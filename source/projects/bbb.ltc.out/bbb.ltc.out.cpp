#include "c74_min.h"

#pragma push_macro("NIL")
#undef NIL
#include <ltc.h>
#pragma pop_macro("NIL")

#include <vector>


class bbb_ltc_out : public c74::min::object<bbb_ltc_out>,
                    public c74::min::sample_operator<1, 1> {

public:
    MIN_DESCRIPTION{"LTC audio signal encoder/generator"};
    MIN_TAGS{"timecode, ltc, smpte, audio"};
    MIN_AUTHOR{"2bit"};

    // --- Outlets ---
    // outlet 0: signal (automatic from sample_operator return)
    // outlet 1: status
    c74::min::outlet<> m_status_out{this, "(list) current timecode h m s f"};

    // --- Attributes ---

    c74::min::attribute<int> fps{this, "fps", 1,
        c74::min::description{"Frame rate: 24 / 25 / 29.97 / 30."},
        c74::min::enum_map{"24", "25", "29.97", "30"},
        c74::min::setter{[this](const c74::min::atoms& args, int) -> c74::min::atoms {
            reinit_encoder();
            return args;
        }}
    };

    c74::min::attribute<int> sample_rate{this, "sample_rate", 44100,
        c74::min::description{"Audio sample rate for LTC generation."},
        c74::min::setter{[this](const c74::min::atoms& args, int) -> c74::min::atoms {
            reinit_encoder();
            return args;
        }}
    };

    c74::min::attribute<double> volume{this, "volume", -3.0,
        c74::min::description{"Output volume in dBFS."},
        c74::min::setter{[this](const c74::min::atoms& args, int) -> c74::min::atoms {
            if (m_encoder) {
                ltc_encoder_set_volume(m_encoder, static_cast<double>(volume));
                reencode_current_frame();
            }
            return args;
        }}
    };

    // --- Messages ---

    c74::min::message<> list_msg{this, "list", "set timecode (h m s f)",
        MIN_FUNCTION {
            if (args.size() >= 4) {
                set_timecode(
                    static_cast<int>(args[0]),
                    static_cast<int>(args[1]),
                    static_cast<int>(args[2]),
                    static_cast<int>(args[3])
                );
            }
            return {};
        }
    };

    c74::min::message<> int_msg{this, "int", "set timecode from total frame count",
        MIN_FUNCTION {
            if (args.size() >= 1) {
                set_timecode_from_frames(static_cast<int>(args[0]));
            }
            return {};
        }
    };

    c74::min::message<> bang_msg{this, "bang", "output current timecode",
        MIN_FUNCTION {
            output_current_timecode();
            return {};
        }
    };

    // --- Constructor / Destructor ---

    bbb_ltc_out() {
        // Attributes are not yet set at this point.
        // Use deferred timer to initialize after attributes are applied.
        m_init_timer.delay(0);
    }

    ~bbb_ltc_out() {
        if (m_encoder) {
            ltc_encoder_free(m_encoder);
            m_encoder = nullptr;
        }
    }

    // --- Signal perform (audio thread) ---

    double operator()(double /*input*/) {
        if (!m_encoder) {
            return 0.0;
        }

        if (m_buffer_pos >= m_buffer_size) {
            ltc_encoder_inc_timecode(m_encoder);
            ltc_encoder_encode_frame(m_encoder);
            m_buffer_size = static_cast<size_t>(
                ltc_encoder_copy_buffer(m_encoder, m_ltc_buffer.data())
            );
            m_buffer_pos = 0;
        }

        double sample = (static_cast<double>(m_ltc_buffer[m_buffer_pos]) - 128.0) / 128.0;
        ++m_buffer_pos;
        return sample;
    }

private:
    // --- State ---
    LTCEncoder* m_encoder{nullptr};
    std::vector<ltcsnd_sample_t> m_ltc_buffer;
    size_t m_buffer_size{0};
    size_t m_buffer_pos{0};

    // --- Deferred init timer ---
    c74::min::timer<c74::min::timer_options::defer_delivery> m_init_timer{this,
        MIN_FUNCTION {
            init_encoder();
            return {};
        }
    };

    // --- Helpers ---

    double fps_value() const {
        switch (static_cast<int>(fps)) {
            case 0:  return 24.0;
            case 1:  return 25.0;
            case 2:  return 29.97;
            case 3:  return 30.0;
            default: return 25.0;
        }
    }

    LTC_TV_STANDARD tv_standard() const {
        switch (static_cast<int>(fps)) {
            case 0:  return LTC_TV_FILM_24;
            case 1:  return LTC_TV_625_50;
            case 2:  return LTC_TV_525_60;
            case 3:  return LTC_TV_525_60;
            default: return LTC_TV_625_50;
        }
    }

    /// Create encoder, allocate buffer, encode initial frame (00:00:00:00).
    void init_encoder() {
        if (m_encoder) {
            ltc_encoder_free(m_encoder);
            m_encoder = nullptr;
        }

        const double sr = static_cast<double>(sample_rate);
        const double fv = fps_value();
        const LTC_TV_STANDARD tvs = tv_standard();

        m_encoder = ltc_encoder_create(sr, fv, tvs, 0);
        if (!m_encoder) {
            cerr << "bbb.ltc.out: failed to create LTC encoder" << c74::min::endl;
            return;
        }

        ltc_encoder_set_volume(m_encoder, static_cast<double>(volume));

        // Pre-allocate our buffer to the larger of current buffersize
        // or a generous upper bound (48kHz / 24fps ≈ 2001 bytes).
        size_t buf_size = ltc_encoder_get_buffersize(m_encoder);
        const size_t min_size = static_cast<size_t>(sr / 24.0) + 4;
        if (buf_size < min_size) {
            buf_size = min_size;
        }
        m_ltc_buffer.resize(buf_size);

        encode_current_frame();
    }

    /// Reinitialize encoder (fps or sample_rate changed).
    void reinit_encoder() {
        if (!m_encoder) {
            return;
        }

        const double sr = static_cast<double>(sample_rate);
        const double fv = fps_value();
        const LTC_TV_STANDARD tvs = tv_standard();

        // Ensure internal buffer is large enough for the new rate.
        ltc_encoder_set_buffersize(m_encoder, sr, fv);

        if (ltc_encoder_reinit(m_encoder, sr, fv, tvs, 0) != 0) {
            cerr << "bbb.ltc.out: failed to reinit encoder" << c74::min::endl;
            return;
        }

        ltc_encoder_set_volume(m_encoder, static_cast<double>(volume));

        // Resize our mirror buffer.
        m_ltc_buffer.resize(ltc_encoder_get_buffersize(m_encoder));

        encode_current_frame();
    }

    /// Encode one LTC frame into m_ltc_buffer.
    void encode_current_frame() {
        if (!m_encoder) {
            return;
        }
        ltc_encoder_encode_frame(m_encoder);
        m_buffer_size = static_cast<size_t>(
            ltc_encoder_copy_buffer(m_encoder, m_ltc_buffer.data())
        );
        m_buffer_pos = 0;
    }

    /// Re-encode current frame (volume changed, timecode set, etc.).
    void reencode_current_frame() {
        if (!m_encoder) {
            return;
        }
        // Internal buffer was flushed by copy_buffer, safe to re-encode.
        ltc_encoder_encode_frame(m_encoder);
        m_buffer_size = static_cast<size_t>(
            ltc_encoder_copy_buffer(m_encoder, m_ltc_buffer.data())
        );
        m_buffer_pos = 0;
    }

    void set_timecode(int h, int m, int s, int f) {
        if (!m_encoder) {
            return;
        }
        SMPTETimecode tc = {};
        tc.hours = static_cast<unsigned char>(h);
        tc.mins  = static_cast<unsigned char>(m);
        tc.secs  = static_cast<unsigned char>(s);
        tc.frame = static_cast<unsigned char>(f);
        ltc_encoder_set_timecode(m_encoder, &tc);
        reencode_current_frame();
    }

    void set_timecode_from_frames(int total_frames) {
        if (!m_encoder) {
            return;
        }
        if (total_frames < 0) {
            total_frames = 0;
        }

        // Simple NDF conversion. Drop-frame (29.97DF) needs
        // dedicated logic — see AGENTS.md "libltc 固有の注意".
        const double fv = fps_value();
        const int fps_int = (fv > 29.0) ? 30 : static_cast<int>(fv);

        const int h  = total_frames / (fps_int * 3600);
        total_frames %= (fps_int * 3600);
        const int mi = total_frames / (fps_int * 60);
        total_frames %= (fps_int * 60);
        const int s  = total_frames / fps_int;
        const int f  = total_frames % fps_int;

        set_timecode(h, mi, s, f);
    }

    void output_current_timecode() {
        if (!m_encoder) {
            return;
        }
        SMPTETimecode tc;
        ltc_encoder_get_timecode(m_encoder, &tc);

        m_status_out.send({
            c74::min::symbol("list"),
            static_cast<int>(tc.hours),
            static_cast<int>(tc.mins),
            static_cast<int>(tc.secs),
            static_cast<int>(tc.frame)
        });
    }
};


MIN_EXTERNAL(bbb_ltc_out);
