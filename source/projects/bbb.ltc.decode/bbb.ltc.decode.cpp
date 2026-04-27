#include "c74_min.h"
#include <cstdio>
#include <string>

class bbb_ltc_decode : public c74::min::object<bbb_ltc_decode> {
public:
	MIN_DESCRIPTION{"Decode timecode to formatted string, frame count, and seconds"};
	MIN_TAGS{"timecode, ltc, smpte, decode"};
	MIN_AUTHOR{"2bit"};

	c74::min::inlet<> input{this, "(list h m s f) or (int) frame count"};
	c74::min::outlet<> m_string_out{this, "(symbol) formatted timecode"};
	c74::min::outlet<> m_frames_out{this, "(int) total frame count"};
	c74::min::outlet<> m_seconds_out{this, "(float) seconds"};

	c74::min::attribute<int> fps{this, "fps", 1,
		c74::min::description{"Frame rate: 0=24, 1=25, 2=29.97, 3=30."},
		c74::min::enum_map{"24", "25", "29.97", "30"}
	};

	c74::min::attribute<int> sample_rate{this, "sample_rate", 44100,
		c74::min::description{"Audio sample rate for samples conversion."}
	};

	c74::min::message<> list_msg{this, "list", "Decode timecode from list (h m s f)",
		MIN_FUNCTION {
			if (args.size() >= 4) {
				int h = static_cast<int>(args[0]);
				int m = static_cast<int>(args[1]);
				int s = static_cast<int>(args[2]);
				int f = static_cast<int>(args[3]);

				if (h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59 || f < 0) {
					cerr << "bbb.ltc.decode: invalid timecode values" << c74::min::endl;
					return {};
				}

				int max_f = get_max_frame();
				if (f > max_f) {
					cerr << "bbb.ltc.decode: frame " << f << " exceeds max " << max_f
					     << " for current fps" << c74::min::endl;
					return {};
				}

				output_timecode(h, m, s, f);
			}
			return {};
		}
	};

	c74::min::message<> int_msg{this, "int", "Decode frame count to timecode",
		MIN_FUNCTION {
			if (args.size() >= 1) {
				long total = static_cast<long>(args[0]);
				if (total < 0) total = 0;

				int h, m, s, f;
				frames_to_timecode(total, h, m, s, f);
				output_timecode(h, m, s, f);
			}
			return {};
		}
	};

private:
	double get_fps_value() const {
		static const double values[] = {24.0, 25.0, 29.97, 30.0};
		int idx = fps;
		if (idx < 0 || idx > 3) idx = 1;
		return values[idx];
	}

	int get_max_frame() const {
		static const int maxf[] = {23, 24, 29, 29};
		int idx = fps;
		if (idx < 0 || idx > 3) idx = 1;
		return maxf[idx];
	}

	bool is_drop_frame() const {
		return fps == 2;
	}

	// SMPTE drop-frame: nominal 30fps, skip frame numbers 0,1 at each minute start
	// except every 10th minute. 108 drops/hour (18 per 10min group).
	long timecode_to_frames(int h, int m, int s, int f) const {
		if (is_drop_frame()) {
			long nominal = static_cast<long>(h) * 108000L + m * 1800L + s * 30 + f;
			long drops  = static_cast<long>(h) * 108L + (m / 10) * 18 + (m % 10) * 2;
			return nominal - drops;
		}
		double fv = get_fps_value();
		return static_cast<long>(h * 3600 * fv + m * 60 * fv + s * fv + f);
	}

	void frames_to_timecode(long total, int& h, int& m, int& s, int& f) const {
		if (is_drop_frame()) {
			static const long kFramesPerHour  = 107892;  // 30*3600 - 6*18
			static const long kFramesPer10Min = 17982;   // 30*600  - 18

			h = static_cast<int>(total / kFramesPerHour);
			long rem = total % kFramesPerHour;

			int ten = static_cast<int>(rem / kFramesPer10Min);
			rem = rem % kFramesPer10Min;
			m = ten * 10;

		// non-10th minutes: sec0 has frames 2-29 (28), sec1-59 have 30 each = 1798
		if (rem >= 1800) {
			rem -= 1800;
			m += 1;

			int extra = static_cast<int>(rem / 1798);
			rem = rem % 1798;
			m += extra;

			if (rem < 28) {
				s = 0;
				f = static_cast<int>(rem) + 2;
			} else {
				rem -= 28;
				s = static_cast<int>(rem / 30) + 1;
				f = static_cast<int>(rem % 30);
			}
		} else {
			s = static_cast<int>(rem / 30);
			f = static_cast<int>(rem % 30);
		}
		} else {
			double fv = get_fps_value();
			h = static_cast<int>(total / (3600 * fv));
			long rem = total - static_cast<long>(h) * static_cast<long>(3600 * fv);
			m = static_cast<int>(rem / (60 * fv));
			rem = rem - static_cast<long>(m) * static_cast<long>(60 * fv);
			s = static_cast<int>(rem / fv);
			f = static_cast<int>(rem - static_cast<long>(s) * static_cast<long>(fv));
		}
	}

	double frames_to_seconds(long total) const {
		return static_cast<double>(total) / get_fps_value();
	}

	// SMPTE uses ';' for drop-frame, ':' for non-drop
	std::string format_timecode(int h, int m, int s, int f) const {
		char buf[16];
		if (is_drop_frame())
			snprintf(buf, sizeof(buf), "%02d:%02d:%02d;%02d", h, m, s, f);
		else
			snprintf(buf, sizeof(buf), "%02d:%02d:%02d:%02d", h, m, s, f);
		return std::string(buf);
	}

	void output_timecode(int h, int m, int s, int f) {
		long total = timecode_to_frames(h, m, s, f);
		double secs = frames_to_seconds(total);
		std::string tc = format_timecode(h, m, s, f);

		m_string_out.send(c74::min::symbol(tc));
		m_frames_out.send(static_cast<int>(total));
		m_seconds_out.send(secs);
	}
};

MIN_EXTERNAL(bbb_ltc_decode);
