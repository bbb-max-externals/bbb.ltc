# bbb.ltc

LTC / SMPTE timecode external objects for Max/MSP.

## Objects

| Object | Description |
|---|---|
| bbb.ltc.in | Extract timecode from LTC audio signal |
| bbb.ltc.out | Generate LTC audio signal from timecode |
| bbb.ltc.mtc | Convert between LTC and MTC (MIDI Timecode) |
| bbb.ltc.decode | Decode raw LTC data to SMPTE timecode string |
| bbb.ltc.encode | Encode SMPTE timecode string to raw LTC data |

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/bbb-max-externals/bbb.ltc/releases)
2. Extract the archive
3. Move the `bbb.ltc` folder to your Max Packages directory:
   - macOS: `~/Documents/Max 8/Packages/`
   - Windows: `%USERPROFILE%\Documents\Max 8\Packages\`

Restart Max to load the package.

## Building from Source

### Prerequisites

- CMake 3.15+
- C++17 compatible compiler
- [libltc](https://github.com/x42/libltc) (included as git submodule)
- [MTCParser](https://github.com/hideakitai/MTCParser) (optional, header-only)

### Build Commands

macOS (Universal Binary):

```bash
mkdir -p build && cd build
cmake ..
cmake --build .
```

Windows (Visual Studio 2022):

```bash
cmake -B build -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release
```

Build outputs are placed in `externals/` as `.mxo` (macOS) or `.mxe64` (Windows).

## Dependencies

- [libltc](https://github.com/x42/libltc) (v1.3.2) — LTC encode/decode (LGPL-3.0)
- [MTCParser](https://github.com/hideakitai/MTCParser) — MTC quarter-frame parse (MIT)

## License

See [LICENSE](LICENSE) for details.

## Author

2bit
