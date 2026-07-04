#include <bbb/timecode.h>

#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>

namespace {

int failure_count{0};

void expect_true(bool condition, const char *message) {
    if(condition) {
        return;
    }
    ++failure_count;
    std::cerr << "FAIL: " << message << "\n";
}

void expect_equal_int64(std::int64_t actual, std::int64_t expected, const char *message) {
    if(actual == expected) {
        return;
    }
    ++failure_count;
    std::cerr << "FAIL: " << message
        << " expected " << expected
        << " got " << actual << "\n";
}

void expect_equal_int(int actual, int expected, const char *message) {
    expect_equal_int64(actual, expected, message);
}

void expect_equal_string(const std::string &actual, const std::string &expected, const char *message) {
    if(actual == expected) {
        return;
    }
    ++failure_count;
    std::cerr << "FAIL: " << message
        << " expected " << expected
        << " got " << actual << "\n";
}

void expect_near(double actual, double expected, double tolerance, const char *message) {
    if(std::abs(actual - expected) <= tolerance) {
        return;
    }
    ++failure_count;
    std::cerr << "FAIL: " << message
        << " expected " << expected
        << " got " << actual
        << " tolerance " << tolerance << "\n";
}

void expect_timecode(
    const bbb::ltc::Timecode &timecode,
    int hours,
    int minutes,
    int seconds,
    int frames,
    bool drop_frame,
    const char *message
) {
    expect_equal_int(timecode.hours, hours, message);
    expect_equal_int(timecode.minutes, minutes, message);
    expect_equal_int(timecode.seconds, seconds, message);
    expect_equal_int(timecode.frames, frames, message);
    expect_true(timecode.drop_frame == drop_frame, message);
}

void test_framerate_identity() {
    expect_true(!bbb::ltc::is_drop_frame(bbb::ltc::Framerate::FPS_24), "24 fps is not drop-frame");
    expect_true(!bbb::ltc::is_drop_frame(bbb::ltc::Framerate::FPS_25), "25 fps is not drop-frame");
    expect_true(!bbb::ltc::is_drop_frame(bbb::ltc::Framerate::FPS_30), "30 fps is not drop-frame");
    expect_true(bbb::ltc::is_drop_frame(bbb::ltc::Framerate::FPS_2997), "29.97 fps is drop-frame");

    expect_equal_int(bbb::ltc::nominal_fps(bbb::ltc::Framerate::FPS_24), 24, "24 nominal fps");
    expect_equal_int(bbb::ltc::nominal_fps(bbb::ltc::Framerate::FPS_25), 25, "25 nominal fps");
    expect_equal_int(bbb::ltc::nominal_fps(bbb::ltc::Framerate::FPS_2997), 30, "29.97 nominal fps");
    expect_equal_int(bbb::ltc::nominal_fps(bbb::ltc::Framerate::FPS_30), 30, "30 nominal fps");

    expect_near(bbb::ltc::exact_framerate(bbb::ltc::Framerate::FPS_2997), 30000.0 / 1001.0, 0.000000000001, "29.97 exact fps");
    expect_near(bbb::ltc::exact_framerate(bbb::ltc::Framerate::FPS_30), 30.0, 0.0, "30 exact fps");
}

void test_framerate_from_int() {
    expect_true(bbb::ltc::framerate_from_int(24) == bbb::ltc::Framerate::FPS_24, "framerate_from_int 24");
    expect_true(bbb::ltc::framerate_from_int(25) == bbb::ltc::Framerate::FPS_25, "framerate_from_int 25");
    expect_true(bbb::ltc::framerate_from_int(30, true) == bbb::ltc::Framerate::FPS_2997, "framerate_from_int 29.97 drop-frame");
    expect_true(bbb::ltc::framerate_from_int(30, false) == bbb::ltc::Framerate::FPS_30, "framerate_from_int 30 non-drop");

    bool threw{false};
    try {
        (void)bbb::ltc::framerate_from_int(23);
    } catch(const std::invalid_argument &) {
        threw = true;
    }
    expect_true(threw, "framerate_from_int rejects unsupported fps");
}

void test_timecode_string_roundtrip() {
    const bbb::ltc::Timecode non_drop_frame{1, 2, 3, 4, false};
    const bbb::ltc::Timecode drop_frame{1, 2, 3, 4, true};

    expect_equal_string(non_drop_frame.to_string(false), "01:02:03:04", "non-drop formatted timecode");
    expect_equal_string(drop_frame.to_string(true), "01:02:03;04", "drop-frame formatted timecode");

    const bbb::ltc::Timecode parsed_non_drop_frame{bbb::ltc::Timecode::from_string("01:02:03:04")};
    const bbb::ltc::Timecode parsed_drop_frame{bbb::ltc::Timecode::from_string("01:02:03;04")};

    expect_timecode(parsed_non_drop_frame, 1, 2, 3, 4, false, "parse non-drop formatted timecode");
    expect_timecode(parsed_drop_frame, 1, 2, 3, 4, true, "parse drop-frame formatted timecode");
}

void test_non_drop_frame_conversions() {
    const bbb::ltc::Timecode one_hour{1, 0, 0, 0, false};
    expect_equal_int64(
        bbb::ltc::timecode_to_frames(one_hour, bbb::ltc::Framerate::FPS_24),
        86400,
        "24 fps one hour frame count"
    );
    expect_equal_int64(
        bbb::ltc::timecode_to_frames(one_hour, bbb::ltc::Framerate::FPS_25),
        90000,
        "25 fps one hour frame count"
    );
    expect_equal_int64(
        bbb::ltc::timecode_to_frames(one_hour, bbb::ltc::Framerate::FPS_30),
        108000,
        "30 fps one hour frame count"
    );

    expect_timecode(
        bbb::ltc::frames_to_timecode(108000, bbb::ltc::Framerate::FPS_30),
        1,
        0,
        0,
        0,
        false,
        "30 fps one hour frame-to-timecode"
    );
}

void test_drop_frame_boundaries() {
    expect_equal_int64(
        bbb::ltc::timecode_to_frames({0, 0, 59, 29, true}, bbb::ltc::Framerate::FPS_2997),
        1799,
        "drop-frame last frame before first dropped minute"
    );
    expect_equal_int64(
        bbb::ltc::timecode_to_frames({0, 1, 0, 2, true}, bbb::ltc::Framerate::FPS_2997),
        1800,
        "drop-frame first valid frame after first dropped minute"
    );
    expect_equal_int64(
        bbb::ltc::timecode_to_frames({0, 10, 0, 0, true}, bbb::ltc::Framerate::FPS_2997),
        17982,
        "drop-frame tenth minute has no dropped labels"
    );
    expect_equal_int64(
        bbb::ltc::timecode_to_frames({1, 0, 0, 0, true}, bbb::ltc::Framerate::FPS_2997),
        107892,
        "drop-frame one hour frame count"
    );

    expect_timecode(
        bbb::ltc::frames_to_timecode(1799, bbb::ltc::Framerate::FPS_2997),
        0,
        0,
        59,
        29,
        true,
        "drop-frame frame 1799"
    );
    expect_timecode(
        bbb::ltc::frames_to_timecode(1800, bbb::ltc::Framerate::FPS_2997),
        0,
        1,
        0,
        2,
        true,
        "drop-frame frame 1800 skips labels 00 and 01"
    );
    expect_timecode(
        bbb::ltc::frames_to_timecode(17982, bbb::ltc::Framerate::FPS_2997),
        0,
        10,
        0,
        0,
        true,
        "drop-frame frame 17982 is the ten-minute boundary"
    );
    expect_timecode(
        bbb::ltc::frames_to_timecode(107892, bbb::ltc::Framerate::FPS_2997),
        1,
        0,
        0,
        0,
        true,
        "drop-frame frame 107892 is the one-hour boundary"
    );
}

void test_drop_frame_ndf_mapping_helpers() {
    expect_equal_int64(bbb::ltc::ndf_to_df(1802), 1800, "ndf_to_df first valid dropped-minute label");
    expect_equal_int64(bbb::ltc::df_to_ndf(1800), 1802, "df_to_ndf first valid dropped-minute label");
    expect_equal_int64(bbb::ltc::ndf_to_df(18000), 17982, "ndf_to_df ten-minute boundary");
    expect_equal_int64(bbb::ltc::df_to_ndf(17982), 18000, "df_to_ndf ten-minute boundary");
}

void test_seconds_and_samples() {
    expect_near(
        bbb::ltc::frames_to_seconds(30000, bbb::ltc::Framerate::FPS_2997),
        1001.0,
        0.000000001,
        "30000 frames at 29.97 equals 1001 seconds"
    );
    expect_equal_int64(
        bbb::ltc::seconds_to_frames(1001.0, bbb::ltc::Framerate::FPS_2997),
        30000,
        "1001 seconds at 29.97 equals 30000 frames"
    );
    expect_equal_int64(
        bbb::ltc::frames_to_samples(30000, bbb::ltc::Framerate::FPS_2997, 48000),
        48048000,
        "30000 frames at 29.97 equals 48048000 samples at 48k"
    );
    expect_equal_int64(
        bbb::ltc::samples_to_frames(48048000, bbb::ltc::Framerate::FPS_2997, 48000),
        30000,
        "48048000 samples at 48k equals 30000 frames at 29.97"
    );
}

} // namespace

int main() {
    test_framerate_identity();
    test_framerate_from_int();
    test_timecode_string_roundtrip();
    test_non_drop_frame_conversions();
    test_drop_frame_boundaries();
    test_drop_frame_ndf_mapping_helpers();
    test_seconds_and_samples();

    if(failure_count != 0) {
        std::cerr << failure_count << " bbb.ltc timecode test(s) failed\n";
        return 1;
    }

    std::cout << "bbb.ltc timecode tests passed\n";
    return 0;
}
