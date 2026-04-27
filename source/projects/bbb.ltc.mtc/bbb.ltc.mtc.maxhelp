{
  "patcher" : {
    "fileversion" : 1,
    "appversion" : {
      "major" : 8,
      "minor" : 6,
      "revision" : 4,
      "processor" : "x86",
      "platform" : "macintel"
    },
    "classnamespace" : "box",
    "rect" : [100.0, 100.0, 800.0, 700.0],
    "bglocked" : 1,
    "openrect" : [0.0, 0.0, 0.0, 0.0],
    "openinpresentation" : 0,
    "default_fontsize" : 12.0,
    "default_fontface" : 0,
    "default_fontname" : "Arial",
    "gridonopen" : 2,
    "gridsize" : [15.0, 15.0],
    "gridsnaponopen" : 0,
    "objectsnaponopen" : 1,
    "statusbarvisible" : 2,
    "toolbarvisible" : 2,
    "lefttoolbarpinned" : 0,
    "toptoolbarpinned" : 0,
    "righttoolbarpinned" : 0,
    "bottomtoolbarpinned" : 0,
    "toolbars_unpinned_last_save" : 0,
    "tallnewobj" : 0,
    "boxanimatetime" : 200,
    "enablehscroll" : 1,
    "enablevscroll" : 1,
    "devicewidth" : 0.0,
    "description" : "LTC <-> MTC (MIDI Timecode) converter",
    "digest" : "Convert between SMPTE timecode and MTC quarter-frame / full-frame messages",
    "tags" : "timecode, ltc, mtc, midi",
    "style" : "",
    "subpatcher_template" : "",
    "assistshowspatchername" : 0,
    "boxes" : [
      {
        "box" : {
          "id" : "obj-1",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 30.0, 200.0, 20.0],
          "text" : "bbb.ltc.mtc"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 55.0, 350.0, 20.0],
          "text" : "LTC \u2194 MTC (MIDI Timecode) converter"
        }
      },
      {
        "box" : {
          "id" : "obj-3",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 90.0, 150.0, 20.0],
          "text" : "--- Inlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-4",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 115.0, 480.0, 20.0],
          "text" : "inlet 0: (list) timecode h m s f \u2014 outputs 8 MTC QF bytes from outlet 0"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 135.0, 520.0, 20.0],
          "text" : "inlet 0: (int) MTC QF data byte (0-127) \u2014 accumulates, outputs TC from outlet 1"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 155.0, 460.0, 20.0],
          "text" : "inlet 0: fullframe h m s f \u2014 outputs 10-byte SysEx list from outlet 1"
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 190.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 215.0, 350.0, 20.0],
          "text" : "outlet 0 (left): (int) MTC quarter-frame data byte"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 235.0, 300.0, 20.0],
          "text" : "outlet 1 (right): (list) timecode h m s f"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 270.0, 400.0, 20.0],
          "text" : "--- Example 1: Timecode \u2192 MTC quarter-frames ---"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 290.0, 350.0, 20.0],
          "text" : "01:00:00:00 at 25fps \u2192 8 QF ints from left outlet"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 315.0, 65.0, 22.0],
          "text" : "1 0 0 0"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", ""],
          "patching_rect" : [200.0, 315.0, 155.0, 22.0],
          "text" : "bbb.ltc.mtc @fps 1"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [410.0, 315.0, 100.0, 22.0],
          "text" : "print MTC-QF"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 370.0, 400.0, 20.0],
          "text" : "--- Example 2: MTC quarter-frames \u2192 Timecode ---"
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 390.0, 400.0, 20.0],
          "text" : "8 QF bytes for 01:00:00:00 at 25fps, sent via iter"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 415.0, 220.0, 22.0],
          "text" : "0 16 32 48 64 80 97 114"
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [300.0, 415.0, 40.0, 22.0],
          "text" : "iter"
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", ""],
          "patching_rect" : [370.0, 415.0, 100.0, 22.0],
          "text" : "bbb.ltc.mtc"
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [520.0, 415.0, 100.0, 22.0],
          "text" : "print TC-out"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 470.0, 350.0, 20.0],
          "text" : "--- Example 3: MTC Full Frame SysEx ---"
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 490.0, 400.0, 20.0],
          "text" : "fullframe h m s f \u2192 10-byte SysEx list from right outlet"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 515.0, 145.0, 22.0],
          "text" : "fullframe 1 30 0 0"
        }
      },
      {
        "box" : {
          "id" : "obj-24",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", ""],
          "patching_rect" : [250.0, 515.0, 155.0, 22.0],
          "text" : "bbb.ltc.mtc @fps 1"
        }
      },
      {
        "box" : {
          "id" : "obj-25",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [460.0, 515.0, 120.0, 22.0],
          "text" : "print FullFrame"
        }
      },
      {
        "box" : {
          "id" : "obj-26",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 570.0, 150.0, 20.0],
          "text" : "--- Attributes ---"
        }
      },
      {
        "box" : {
          "id" : "obj-27",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 595.0, 420.0, 20.0],
          "text" : "@fps \u2014 frame rate enum: 24 / 25 / 29.97 / 30 (default: 25)"
        }
      },
      {
        "box" : {
          "id" : "obj-28",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 630.0, 150.0, 20.0],
          "text" : "--- Messages ---"
        }
      },
      {
        "box" : {
          "id" : "obj-29",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 650.0, 400.0, 20.0],
          "text" : "list h m s f \u2014 encode timecode to 8 MTC QF bytes (outlet 0)"
        }
      },
      {
        "box" : {
          "id" : "obj-30",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 670.0, 520.0, 20.0],
          "text" : "int (0-127) \u2014 decode MTC QF byte, output TC when all 8 received (outlet 1)"
        }
      },
      {
        "box" : {
          "id" : "obj-31",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 690.0, 500.0, 20.0],
          "text" : "fullframe h m s f \u2014 output MTC Full Frame SysEx as 10-byte list (outlet 1)"
        }
      },
      {
        "box" : {
          "id" : "obj-32",
          "maxclass" : "preset",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [650.0, 30.0, 100.0, 40.0]
        }
      }
    ],
    "lines" : [
      {
        "patchline" : {
          "source" : ["obj-12", 0],
          "destination" : ["obj-13", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-13", 0],
          "destination" : ["obj-14", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-17", 0],
          "destination" : ["obj-18", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-18", 0],
          "destination" : ["obj-19", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-19", 1],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-23", 0],
          "destination" : ["obj-24", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-24", 1],
          "destination" : ["obj-25", 0]
        }
      }
    ]
  }
}
