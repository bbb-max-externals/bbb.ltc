#include "c74_min.h"
#include <cstdio>
#include <cstring>
#include <string>

extern "C" {
#include "ltc.h"
}

class bbb_ltc_encode : public c74::min::object<bbb_ltc_encode> {
public:
	MIN_DESCRIPTION{"Encode timecode values to LTC frame data"};
	MIN_TAGS{"timecode", "ltc", "smpte", "encode"};
	MIN_AUTHOR{"2bit"};

	c74::min::inlet<> input{this, "(list h m s f) or (text) HH:MM:SS:FF or bang"};
	c74::min::outlet<> m_tc_out{this, "(list) timecode h m s f"};
	c74::min::outlet<> m_frames_out{this, "(int) total frame count"};
	c74::min::outlet<> m_raw_out{this, "(list) raw LTC frame 10 bytes"};

	c74::min::attribute<int> fps{this, "fps", 1,
		c74::min::description{"Frame rate: 0=24, 1=25, 2=29.97, 3=30."},
		c74::min::enum_map{"24", "25", "29.97", "30"}
	};

	c74::min::attribute<int> hours{this, "hours", 0,
		c74::min::description{"Hours (0-23)."},
		c74::min::range{0, 23}
	};

	c74::min::attribute<int> minutes{this, "minutes", 0,
		c74::min::description{"Minutes (0-59)."},
		c74::min::range{0, 59}
	};

	c74::min::attribute<int> seconds_attr{this, "seconds", 0,
		c74::min::description{"Seconds (0-59)."},
		c74::min::range{0, 59}
	};

	c74::min::attribute<int> frames_attr{this, "frames", 0,
		c74::min::description{"Frames (0-29)."},
		c74::min::range{0, 29}
	};

	c74::min::message<> list_msg{this, "list", "Set timecode from list and output",
		MIN_FUNCTION {
			if (args.size() >= 4) {
				hours = static_cast<int>(args[0]);
				minutes = static_cast<int>(args[1]);
				seconds_attr = static_cast<int>(args[2]);
				frames_attr = static_cast<int>(args[3]);
				output_current();
			}
			return {};
		}
	};

	c74::min::message<> text_msg{this, "text", "Parse formatted timecode string",
		MIN_FUNCTION {
			if (args.size() >= 1 && args[0].type() == c74::min::data_type::symbol) {
				c74::min::symbol sym = args[0];
				std::string str(sym);
				int h, m, s, f;
				if (parse_timecode_string(str, h, m, s, f)) {
					hours = h;
					minutes = m;
					seconds_attr = s;
					frames_attr = f;
					output_current();
				} else {
					cerr << "bbb.ltc.encode: invalid timecode format '"
					     << str << "'" << c74::min::endl;
				}
			}
			return {};
		}
	};

	c74::min::message<> bang_msg{this, "bang", "Output current timecode",
		MIN_FUNCTION {
			output_current();
			return {};
		}
	};

	c74::min::message<> set_msg{this, "set", "Set timecode silently",
		MIN_FUNCTION {
			if (args.size() >= 4) {
				hours = static_cast<int>(args[0]);
				minutes = static_cast<int>(args[1]);
				seconds_attr = static_cast<int>(args[2]);
				frames_attr = static_cast<int>(args[3]);
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

	bool is_drop_frame() const {
		return fps == 2;
	}

	enum LTC_TV_STANDARD get_ltc_standard() const {
		switch (fps.get()) {
			case 0:  return LTC_TV_FILM_24;
			case 1:  return LTC_TV_625_50;
			case 2:  return LTC_TV_525_60;
			case 3:  return LTC_TV_525_60;
			default: return LTC_TV_625_50;
		}
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

	// SMPTE uses ';' for drop-frame, ':' for non-drop
	bool parse_timecode_string(const std::string& str, int& h, int& m, int& s, int& f) const {
		if (str.size() != 11) return false;
		if (str[2] != ':' || str[5] != ':') return false;
		if (str[8] != ':' && str[8] != ';') return false;

		h = std::stoi(str.substr(0, 2));
		m = std::stoi(str.substr(3, 2));
		s = std::stoi(str.substr(6, 2));
		f = std::stoi(str.substr(9, 2));

		return (h >= 0 && h <= 23 && m >= 0 && m <= 59 && s >= 0 && s <= 59 && f >= 0 && f <= 29);
	}

	void output_current() {
		int h = hours;
		int m = minutes;
		int s = seconds_attr;
		int f = frames_attr;

		c74::min::atoms tc_atoms = {h, m, s, f};
		m_tc_out.send(tc_atoms);

		long total = timecode_to_frames(h, m, s, f);
		m_frames_out.send(static_cast<int>(total));

		SMPTETimecode stc;
		std::memset(&stc, 0, sizeof(stc));
		stc.hours = static_cast<unsigned char>(h);
		stc.mins  = static_cast<unsigned char>(m);
		stc.secs  = static_cast<unsigned char>(s);
		stc.frame = static_cast<unsigned char>(f);

		LTCFrame ltc_frame;
		std::memset(&ltc_frame, 0, sizeof(ltc_frame));
		ltc_time_to_frame(&ltc_frame, &stc, get_ltc_standard(), 0);

		unsigned char* raw = reinterpret_cast<unsigned char*>(&ltc_frame);
		c74::min::atoms raw_atoms;
		for (int i = 0; i < 10; ++i) {
			raw_atoms.push_back(static_cast<int>(raw[i]));
		}
		m_raw_out.send(raw_atoms);
	}
};

MIN_EXTERNAL(bbb_ltc_encode);
