# bbb.ltc

Max/MSP external オブジェクト群 — LTC (Linear Timecode) / SMPTE タイムコードの受信・送信・MTC変換。

## プロジェクト概要

C++17 + min-api (C74_MIN) + CMake でビルドする external パッケージ。
命名規則は `bbb.xxx.yyy`（ディレクトリ・ファイル名 = ドット区切り、C++ クラス名 = アンダースコア区切り）。

## 外部依存

| ライブラリ | 用途 | ライセンス | 備考 |
|---|---|---|---|
| [libltc](https://github.com/x42/libltc) (v1.3.2) | LTC encode/decode | LGPL-3.0 | autotools、CMakeLists.txt なし |
| [MTCParser](https://github.com/hideakitai/MTCParser) (MIT) | MTC quarter-frame parse | MIT | header-only、または自前実装でも可 |

### libltc の統合方法

libltc には CMakeLists.txt がないため、git submodule として `deps/libltc/` に配置し、ソースを直接コンパイルする:

```cmake
# deps/libltc/ は git submodule
target_sources(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc/src/decoder.c
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc/src/encoder.c
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc/src/ltc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc/src/timecode.c
)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/deps/libltc/src)
```

LGPL-3.0 のため、Max external (.mxo) は動的リンク扱いで配布可能。静的リンクする場合はライセンス義務に注意。

## external オブジェクト一覧（予定）

| オブジェクト | 役割 | 入力 | 出力 | 備考 |
|---|---|---|---|---|
| `bbb.ltc.in` | LTC音声信号→タイムコード抽出 | audio signal (inlet~) | timecode list/symbol | libltc decoder 使用 |
| `bbb.ltc.out` | タイムコード→LTC音声信号生成 | timecode list/int | audio signal (outlet~) | libltc encoder 使用 |
| `bbb.ltc.mtc` | LTC ↔ MTC 変換 | timecode / MTC bytes | MTC bytes / timecode | MTCParser または自前 |
| `bbb.ltc.decode` | LTC生データ→SMPTEタイムコード文字列 | raw LTC data | formatted timecode string | |
| `bbb.ltc.encode` | SMPTEタイムコード文字列→LTC生データ | timecode params | raw LTC data | |

## ビルド

```bash
mkdir -p build && cd build
cmake ..
cmake --build .
```

成果物は `externals/*.mxo` に出力される（Universal Binary: x86_64 + arm64）。

ルート CMakeLists.txt の `SUBDIRLIST` マクロが `source/projects/` を自動スキャンするため、新しい external ディレクトリを追加するだけでビルド対象に含まれる。

## 新規 external 追加手順

1. `source/projects/bbb.ltc.xxx/` ディレクトリ作成
2. `bbb.ltc.xxx.cpp` — `templates/external.cpp` ベース（プレースホルダ置換: `__CLASS_NAME__` → `bbb_ltc_xxx`）
3. `CMakeLists.txt` — `templates/CMakeLists.project.txt` ベース（`bbb_add_external()` のみ）
4. `bbb.ltc.xxx.maxhelp` — ヘルプパッチ（max-patgen skill で生成可能）
5. `package-info.json` の `filelist` に `externals/bbb.ltc.xxx.mxo` を追加
6. ビルドして確認

## min-api トラップ（抜粋）

**必ず `.agents/skills/max-external/docs/pitfalls.md` を参照。** 主要なもの:

- **attribute はコンストラクタ完了後に設定される** — 初期化は `timer.delay(0)` で遅延させる
- **outlet 出力はメインスレッドのみ** — worker thread → `queue<>` → メインスレッドで `output.send()`
- **`enum_map` を使う** — `range + style::enum_index` は "bad number" エラー
- **`cout`/`cerr` はメンバ変数** — `std::cout` ではない
- **`std::filesystem` は使えない** — min-api pretarget が deployment target を 10.11 に固定
- **`m_maxobj` は private** — `maxobj()` メソッド経由でアクセス
- **NIL マクロ衝突** — Max SDK の `#define NIL` と他ライブラリの enum が衝突する場合は `#pragma push_macro("NIL")` / `#undef NIL`

## Skills

| Skill | 用途 |
|---|---|
| `max-external` | external の新規作成・ビルド手順 |
| `max-patgen` | .maxpat / .maxhelp パッチの JSON 生成 |
| `max-external-githubactions` | CI (macOS + Windows) ワークフロー生成 |

## libltc 固有の注意

- libltc は LTC 音声信号の encode/decode のみ。以下は自前で実装が必要:
  - **ドロップフレーム計算**（必須）— 29.97fps DF↔NDF 変換、フレーム番号↔HH:MM:SS:FF 文字列
  - **フレーム番号↔実時間（秒・サンプル数）**の相互変換
  - SMPTE フレームレート定数（24/25/29.97/30 fps）の管理
  - ※ 異フレームレート間の変換（24fps↔25fps 等）はユースケースが限定的なので初期スコープ外
- 最小入力レベル: -36 dB 以下の信号はデコード不能。必要に応じてプリゲインを設定
- `ltc_decoder_read()` は queue 型。`ltc_decoder_decode_audio()` 後に `ltc_decoder_read()` で フレームを取り出す
- エンコーダのサンプルレートは `ltc_encoder_set_sample_rate()` で明示的に設定が必要（デフォルトなし）
