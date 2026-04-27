#include "c74_min.h"

#include "ltc.h"

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cmath>
#include <vector>

class bbb_ltc_in
    : public c74::min::object<bbb_ltc_in>,
      public c74::min::sample_operator<bbb_ltc_in, 1> {
public:
    MIN_DESCRIPTION{"Decode LTC audio signal to SMPTE timecode"};
    MIN_TAGS{"ltc", "timecode", "smpte", "audio"};
    MIN_AUTHOR{"2bit"};

    c74::min::outlet<> m_timecode_out{
        this, "(list) hours mins secs frames dfbit"};
    c74::min::outlet<> m_status_out{
        this, "(int) lock status 1=locked 0=lost"};

    c74::min::attribute<int> fps{this, "fps", 1,
        c74::min::description{"Nominal frame rate for decoder initialisation."},
        c74::min::enum_map{"24", "25", "29.97", "30"},
        c74::min::setter{MIN_FUNCTION {
            recreate_decoder();
            return args;
        }}
    };

    c74::min::attribute<int> sample_rate{this, "sample_rate", 44100,
        c74::min::description{"Audio sample rate of the incoming signal."},
        c74::min::setter{MIN_FUNCTION {
            recreate_decoder();
            return args;
        }}
    };

    c74::min::attribute<double> lock_timeout{this, "lock_timeout", 0.5,
        c74::min::description{
            "Seconds without a new decoded frame before reporting lost lock."}
    };

    c74::min::message<> bang_msg{this, "bang", "Output last decoded timecode",
        MIN_FUNCTION {
            if (m_locked) {
                m_timecode_out.send(m_last_timecode_atoms);
            }
            return {};
        }
    };

    bbb_ltc_in() {
        m_sample_buffer.resize(BUFFER_SIZE, 0.0f);
        m_init_timer.delay(0);
    }

    ~bbb_ltc_in() {
        m_lock_timer.stop();
        if (m_decoder) {
            ltc_decoder_free(m_decoder);
            m_decoder = nullptr;
        }
    }

    // audio thread — do NOT call outlet.send() here
    double operator()(double input) {
        if (!m_decoder || m_recreating.load(std::memory_order_acquire)) {
            return 0.0;
        }

        m_sample_buffer[m_buffer_write_pos] = static_cast<float>(input);
        ++m_buffer_write_pos;

        if (m_buffer_write_pos >= BUFFER_SIZE) {
            ltc_decoder_write_float(
                m_decoder,
                m_sample_buffer.data(),
                BUFFER_SIZE,
                m_sample_position);

            m_sample_position += BUFFER_SIZE;

            LTCFrameExt frame;
            while (ltc_decoder_read(m_decoder, &frame)) {
                SMPTETimecode tc;
                ltc_frame_to_time(&tc, &frame.ltc, 0);

                m_pending.hours = tc.hours;
                m_pending.mins = tc.mins;
                m_pending.secs = tc.secs;
                m_pending.frame = tc.frame;
                m_pending.dfbit = frame.ltc.dfbit;

                m_pending_valid.store(true, std::memory_order_release);
                m_output_queue.set();
            }

            m_buffer_write_pos = 0;
        }

        return 0.0;
    }

private:
    static constexpr size_t BUFFER_SIZE = 256;
    static constexpr int DECODER_QUEUE_SIZE = 8;

    struct decoded_tc {
        unsigned char hours;
        unsigned char mins;
        unsigned char secs;
        unsigned char frame;
        unsigned int dfbit;
    };

    LTCDecoder *m_decoder{nullptr};
    std::atomic<bool> m_recreating{false};
    std::vector<float> m_sample_buffer;
    size_t m_buffer_write_pos{0};
    ltc_off_t m_sample_position{0};

    // audio thread writes, main thread reads via queue<>
    decoded_tc m_pending{};
    std::atomic<bool> m_pending_valid{false};

    c74::min::queue<> m_output_queue{this, MIN_FUNCTION {
        if (m_pending_valid.exchange(false)) {
            m_last_timecode_atoms.clear();
            m_last_timecode_atoms.push_back(
                static_cast<int>(m_pending.hours));
            m_last_timecode_atoms.push_back(
                static_cast<int>(m_pending.mins));
            m_last_timecode_atoms.push_back(
                static_cast<int>(m_pending.secs));
            m_last_timecode_atoms.push_back(
                static_cast<int>(m_pending.frame));
            m_last_timecode_atoms.push_back(
                static_cast<int>(m_pending.dfbit));

            m_timecode_out.send(m_last_timecode_atoms);

            if (!m_locked) {
                m_locked = true;
                m_status_out.send(1);
            }

            m_last_decode_time = std::chrono::steady_clock::now();
        }
        return {};
    }};

    bool m_locked{false};
    c74::min::atoms m_last_timecode_atoms;
    std::chrono::steady_clock::time_point m_last_decode_time{};

    c74::min::timer<c74::min::timer_options::defer_delivery> m_lock_timer{
        this, MIN_FUNCTION {
            if (m_locked) {
                auto now = std::chrono::steady_clock::now();
                auto elapsed = std::chrono::duration<double>(
                    now - m_last_decode_time).count();
                if (elapsed > static_cast<double>(lock_timeout)) {
                    m_locked = false;
                    m_status_out.send(0);
                }
            }
            m_lock_timer.delay(100);
            return {};
        }
    };

    // delayed init — attributes are not yet set in the constructor body
    c74::min::timer<c74::min::timer_options::defer_delivery> m_init_timer{
        this, MIN_FUNCTION {
            recreate_decoder();
            m_lock_timer.delay(100);
            return {};
        }
    };

    double fps_value() const {
        switch (fps) {
            case 0:  return 24.0;
            case 1:  return 25.0;
            case 2:  return 29.97;
            case 3:  return 30.0;
            default: return 25.0;
        }
    }

    void recreate_decoder() {
        m_recreating.store(true, std::memory_order_release);

        if (m_decoder) {
            ltc_decoder_free(m_decoder);
            m_decoder = nullptr;
        }

        double nominal_fps = fps_value();
        int sr = sample_rate;
        int apv = static_cast<int>(std::round(
            static_cast<double>(sr) / nominal_fps));
        if (apv < 1) {
            apv = 1;
        }

        m_decoder = ltc_decoder_create(apv, DECODER_QUEUE_SIZE);
        if (!m_decoder) {
            cerr << "bbb.ltc.in: failed to create LTC decoder (apv="
                 << apv << ")" << c74::min::endl;
        }

        m_buffer_write_pos = 0;
        m_sample_position = 0;
        m_pending_valid.store(false, std::memory_order_release);

        m_recreating.store(false, std::memory_order_release);
    }
};

MIN_EXTERNAL(bbb_ltc_in);
