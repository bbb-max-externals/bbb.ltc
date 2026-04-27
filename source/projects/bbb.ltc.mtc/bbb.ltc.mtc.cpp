#include "c74_min.h"

class bbb_ltc_mtc : public c74::min::object<bbb_ltc_mtc> {
public:
	MIN_DESCRIPTION{"LTC <-> MTC (MIDI Timecode) converter"};
	MIN_TAGS{"timecode, ltc, mtc, midi"};
	MIN_AUTHOR{"2bit"};

	// --- inlets / outlets ---

	c74::min::inlet<> m_in{this, "(list/int) timecode or MTC byte"};
	c74::min::outlet<> m_mtc_out{this, "(int) MTC quarter-frame data byte"};
	c74::min::outlet<> m_tc_out{this, "(list) timecode h m s f"};

	// --- attributes ---

	c74::min::attribute<int> fps{this, "fps", 25,
		c74::min::description{"Frame rate for timecode encoding."},
		c74::min::enum_map{"24", "25", "29.97", "30"}
	};

	// --- message handlers ---

	c74::min::message<> list_msg{this, "list", "timecode as list h m s f",
		MIN_FUNCTION {
			if (args.size() != 4) {
				cerr << "bbb.ltc.mtc: list needs 4 ints (h m s f)" << c74::min::endl;
				return {};
			}
			try {
				int h = static_cast<int>(args[0]);
				int m = static_cast<int>(args[1]);
				int s = static_cast<int>(args[2]);
				int f = static_cast<int>(args[3]);
				encode_qf(h, m, s, f, fps);
			}
			catch (...) {
				cerr << "bbb.ltc.mtc: invalid timecode values" << c74::min::endl;
			}
			return {};
		}
	};

	c74::min::message<> int_msg{this, "int", "MTC quarter-frame data byte",
		MIN_FUNCTION {
			if (args.empty()) return {};
			try {
				int byte = static_cast<int>(args[0]);
				if (byte < 0 || byte > 127) {
					cerr << "bbb.ltc.mtc: byte must be 0-127" << c74::min::endl;
					return {};
				}
				decode_qf(static_cast<uint8_t>(byte));
			}
			catch (...) {
				cerr << "bbb.ltc.mtc: invalid byte" << c74::min::endl;
			}
			return {};
		}
	};

	c74::min::message<> fullframe_msg{this, "fullframe", "output MTC Full Frame SysEx as list",
		MIN_FUNCTION {
			if (args.size() != 4) {
				cerr << "bbb.ltc.mtc: fullframe needs 4 ints (h m s f)" << c74::min::endl;
				return {};
			}
			try {
				int h = static_cast<int>(args[0]);
				int m = static_cast<int>(args[1]);
				int s = static_cast<int>(args[2]);
				int f = static_cast<int>(args[3]);
				encode_fullframe(h, m, s, f, fps);
			}
			catch (...) {
				cerr << "bbb.ltc.mtc: invalid timecode values" << c74::min::endl;
			}
			return {};
		}
	};

	// --- helpers ---

	int fps_to_type(int fps_val) const {
		if (fps_val == 24) return 0;
		if (fps_val == 25) return 1;
		if (fps_val == 29) return 2;
		return 3;
	}

	void encode_qf(int h, int m, int s, int f, int fps_val) {
		int ft = fps_to_type(fps_val);
		m_mtc_out.send(0x00 | (f & 0x0F));
		m_mtc_out.send(0x10 | ((f >> 4) & 0x01));
		m_mtc_out.send(0x20 | (s & 0x0F));
		m_mtc_out.send(0x30 | ((s >> 4) & 0x03));
		m_mtc_out.send(0x40 | (m & 0x0F));
		m_mtc_out.send(0x50 | ((m >> 4) & 0x03));
		m_mtc_out.send(0x60 | (h & 0x0F));
		m_mtc_out.send(0x70 | ((h >> 4) & 0x01) | (ft << 1));
	}

	void encode_fullframe(int h, int m, int s, int f, int fps_val) {
		int ft = fps_to_type(fps_val);
		// F0 7F 00 01 01 hr mn sc fr F7
		c74::min::atoms sysex;
		sysex.push_back(0xF0);
		sysex.push_back(0x7F);
		sysex.push_back(0x00);  // device ID
		sysex.push_back(0x01);  // MTC sub-ID 1
		sysex.push_back(0x01);  // MTC sub-ID 2: full frame
		sysex.push_back((f & 0x0F) | ((s & 0x0F) << 4));
		sysex.push_back(((s >> 4) & 0x03) | ((m & 0x0F) << 4));
		sysex.push_back(((m >> 4) & 0x03) | ((h & 0x0F) << 4));
		sysex.push_back(((h >> 4) & 0x01) | (ft << 1));
		sysex.push_back(0xF7);
		m_tc_out.send(sysex);
	}

	void decode_qf(uint8_t byte) {
		int type = (byte >> 4) & 0x07;
		int value = byte & 0x0F;

		// QF0 signals start of new frame sequence
		if (type == 0) {
			m_received = 0;
		}

		m_qf[type] = value;
		m_received |= (1 << type);

		// all 8 quarter-frames received
		if (m_received == 0xFF) {
			int f = m_qf[0] | (m_qf[1] << 4);
			int s = m_qf[2] | (m_qf[3] << 4);
			int m = m_qf[4] | (m_qf[5] << 4);
			int h = m_qf[6] | ((m_qf[7] & 0x01) << 4);
			int ft = (m_qf[7] >> 1) & 0x03;

			m_tc_out.send({h, m, s, f});
			m_received = 0;
		}
	}

private:
	int  m_qf[8]     = {};
	uint8_t m_received = 0;
};

MIN_EXTERNAL(bbb_ltc_mtc);
