#ifndef BBB_LTC_TIMECODE_H
#define BBB_LTC_TIMECODE_H

#include <cstdint>
#include <cmath>
#include <stdexcept>
#include <string>

namespace bbb {
namespace ltc {

enum class Framerate {
    FPS_24  = 24,
    FPS_25  = 25,
    // two enum values share int=30; is_drop_frame() distinguishes them
    FPS_2997 = 30,
    FPS_30   = 30
};

constexpr bool is_drop_frame(Framerate fps) {
    return fps == Framerate::FPS_2997;
}

constexpr double exact_framerate(Framerate fps) {
    switch(fps) {
        case Framerate::FPS_24:   return 24.0;
        case Framerate::FPS_25:   return 25.0;
        case Framerate::FPS_2997: return 30000.0 / 1001.0;
        case Framerate::FPS_30:   return 30.0;
    }
    return 0.0;
}

constexpr int nominal_fps(Framerate fps) {
    return static_cast<int>(fps);
}

inline Framerate framerate_from_int(int fps_val, bool drop_frame = false) {
    switch(fps_val) {
        case 24: return Framerate::FPS_24;
        case 25: return Framerate::FPS_25;
        case 30: return drop_frame ? Framerate::FPS_2997 : Framerate::FPS_30;
        default: break;
    }
    throw std::invalid_argument{"unsupported framerate: " + std::to_string(fps_val)};
}

struct Timecode {
    int hours{0};
    int minutes{0};
    int seconds{0};
    int frames{0};
    bool drop_frame{false};

    std::string to_string(bool df) const {
        const char sep = df ? ';' : ':';
        const auto pad2 = [](int v) -> std::string {
            if(v < 10) {
                return {'0', static_cast<char>('0' + v)};
            }
            return std::to_string(v);
        };
        return pad2(hours) + ':' + pad2(minutes) + ':' + pad2(seconds) + sep + pad2(frames);
    }

    static Timecode from_string(const std::string &s) {
        Timecode tc;

        const auto pos1 = s.find(':');
        if(pos1 == std::string::npos) {
            throw std::invalid_argument{"invalid timecode format"};
        }
        const auto pos2 = s.find(':', pos1 + 1);
        if(pos2 == std::string::npos) {
            throw std::invalid_argument{"invalid timecode format"};
        }
        const auto pos3 = s.find_first_of(":;", pos2 + 1);
        if(pos3 == std::string::npos) {
            throw std::invalid_argument{"invalid timecode format"};
        }

        tc.hours   = std::stoi(s.substr(0, pos1));
        tc.minutes = std::stoi(s.substr(pos1 + 1, pos2 - pos1 - 1));
        tc.seconds = std::stoi(s.substr(pos2 + 1, pos3 - pos2 - 1));
        tc.frames  = std::stoi(s.substr(pos3 + 1));
        tc.drop_frame = (s[pos3] == ';');

        return tc;
    }
};

// Drop-frame (29.97 fps): frames 0,1 dropped at the start of every minute
// except every 10th minute.  9 drops/min × 2 frames = 18 frames per 10-min cycle.
//   frames per 10-min cycle = 10×60×30 − 18 = 17982
//   frames per drop-minute  = 60×30 − 2   = 1798
//   frames per non-drop-min = 60×30       = 1800
//
// timecode_to_frames:
//   total = h×3600×n + m×60×n + s×n + f − drop_count
//   drop_count = 2 × (total_minutes − total_minutes / 10)
//
// frames_to_timecode:
//   decompose by 10-min cycles (17982) then individual minutes (1798 or 1800).

inline int64_t timecode_to_frames(const Timecode &tc, Framerate fps) {
    const int n = nominal_fps(fps);
    int64_t total = static_cast<int64_t>(tc.hours) * 3600 * n
                  + static_cast<int64_t>(tc.minutes) * 60 * n
                  + static_cast<int64_t>(tc.seconds) * n
                  + tc.frames;

    if(is_drop_frame(fps)) {
        const int64_t total_minutes = static_cast<int64_t>(tc.hours) * 60 + tc.minutes;
        const int64_t drop_count = 2 * (total_minutes - total_minutes / 10);
        total -= drop_count;
    }

    return total;
}

inline Timecode frames_to_timecode(int64_t total_frames, Framerate fps) {
    Timecode tc;
    tc.drop_frame = is_drop_frame(fps);
    const int n = nominal_fps(fps);

    if(total_frames < 0) {
        total_frames = 0;
    }

    if(!is_drop_frame(fps)) {
        tc.hours   = static_cast<int>(total_frames / (3600 * n));
        total_frames %= 3600 * n;
        tc.minutes = static_cast<int>(total_frames / (60 * n));
        total_frames %= 60 * n;
        tc.seconds = static_cast<int>(total_frames / n);
        tc.frames  = static_cast<int>(total_frames % n);
    } else {
        constexpr int64_t frames_per_10min = 10 * 60 * 30 - 18;  // 17982
        constexpr int64_t frames_per_min   = 60 * 30 - 2;        // 1798
        constexpr int64_t frames_min0      = 60 * 30;             // 1800

        int64_t ten_min = total_frames / frames_per_10min;
        int64_t rem = total_frames % frames_per_10min;

        int64_t min;
        if(rem < frames_min0) {
            min = 0;
        } else {
            rem -= frames_min0;
            min = 1 + rem / frames_per_min;
            rem = rem % frames_per_min + 2;
        }

        tc.seconds = static_cast<int>(rem / 30);
        tc.frames  = static_cast<int>(rem % 30);

        const int64_t total_min = ten_min * 10 + min;
        tc.hours   = static_cast<int>(total_min / 60);
        tc.minutes = static_cast<int>(total_min % 60);
    }

    return tc;
}

// NDF <-> DF frame-number conversions (30 fps nominal only).

inline int64_t ndf_to_df(int64_t ndf_frame) {
    const int64_t total_minutes = ndf_frame / (30 * 60);
    const int64_t drop_count = 2 * (total_minutes - total_minutes / 10);
    return ndf_frame - drop_count;
}

inline int64_t df_to_ndf(int64_t df_frame) {
    constexpr int64_t frames_per_10min = 17982;
    constexpr int64_t frames_per_min   = 1798;
    constexpr int64_t frames_min0      = 1800;

    const int64_t ten_min = df_frame / frames_per_10min;
    const int64_t rem = df_frame % frames_per_10min;

    int64_t drop_minutes;
    if(rem < frames_min0) {
        drop_minutes = 0;
    } else {
        drop_minutes = 1 + (rem - frames_min0) / frames_per_min;
        if(drop_minutes > 9) {
            drop_minutes = 9;
        }
    }

    const int64_t drops = ten_min * 18 + drop_minutes * 2;
    return df_frame + drops;
}

inline double frames_to_seconds(int64_t total_frames, Framerate fps) {
    return static_cast<double>(total_frames) / exact_framerate(fps);
}

inline int64_t seconds_to_frames(double seconds, Framerate fps) {
    return static_cast<int64_t>(std::round(seconds * exact_framerate(fps)));
}

inline int64_t frames_to_samples(int64_t total_frames, Framerate fps, int sample_rate) {
    return static_cast<int64_t>(
        std::round(frames_to_seconds(total_frames, fps) * sample_rate));
}

inline int64_t samples_to_frames(int64_t samples, Framerate fps, int sample_rate) {
    return seconds_to_frames(static_cast<double>(samples) / sample_rate, fps);
}

} // namespace ltc
} // namespace bbb

#endif
