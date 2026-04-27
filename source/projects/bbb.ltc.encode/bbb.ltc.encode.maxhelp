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
    "description" : "Encode timecode values to LTC frame data",
    "digest" : "bbb.ltc.encode - encode timecode to LTC frame data",
    "tags" : "LTC, timecode, SMPTE, encode",
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
          "patching_rect" : [50.0, 25.0, 200.0, 20.0],
          "text" : "bbb.ltc.encode"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 45.0, 450.0, 20.0],
          "text" : "Encode timecode values to LTC frame data"
        }
      },
      {
        "box" : {
          "id" : "obj-3",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 75.0, 150.0, 20.0],
          "text" : "--- Inlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-4",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 95.0, 500.0, 20.0],
          "text" : "inlet 0: (list) h m s f, (text) HH:MM:SS:FF, bang"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 120.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 140.0, 350.0, 20.0],
          "text" : "0 (left): (list) timecode h m s f"
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 160.0, 300.0, 20.0],
          "text" : "1 (mid): (int) total frame count"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 180.0, 350.0, 20.0],
          "text" : "2 (right): (list) raw LTC frame 10 bytes"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 210.0, 200.0, 20.0],
          "text" : "--- Messages ---"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 230.0, 400.0, 20.0],
          "text" : "list h m s f — set timecode from 4 ints and output"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 250.0, 420.0, 20.0],
          "text" : "text HH:MM:SS:FF — parse formatted timecode string"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 270.0, 350.0, 20.0],
          "text" : "bang — output current timecode"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 290.0, 400.0, 20.0],
          "text" : "set h m s f — set timecode silently (no output)"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 322.0, 350.0, 20.0],
          "text" : "--- Example 1: List Input (25fps) ---"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 350.0, 100.0, 22.0],
          "text" : "1 0 30 15"
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 3,
          "outlettype" : ["", "int", ""],
          "patching_rect" : [50.0, 385.0, 180.0, 22.0],
          "text" : "bbb.ltc.encode @fps 1"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 425.0, 60.0, 22.0],
          "text" : "print tc"
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "number",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["int"],
          "patching_rect" : [170.0, 425.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [290.0, 425.0, 70.0, 22.0],
          "text" : "print raw"
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 460.0, 400.0, 20.0],
          "text" : "--- Example 2: Text Input (default 25fps) ---"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 488.0, 160.0, 22.0],
          "text" : "text 01:02:03:10"
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 3,
          "outlettype" : ["", "int", ""],
          "patching_rect" : [50.0, 523.0, 130.0, 22.0],
          "text" : "bbb.ltc.encode"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 563.0, 60.0, 22.0],
          "text" : "print tc"
        }
      },
      {
        "box" : {
          "id" : "obj-24",
          "maxclass" : "number",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["int"],
          "patching_rect" : [170.0, 563.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-25",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [290.0, 563.0, 70.0, 22.0],
          "text" : "print raw"
        }
      },
      {
        "box" : {
          "id" : "obj-26",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 598.0, 200.0, 20.0],
          "text" : "--- Attributes ---"
        }
      },
      {
        "box" : {
          "id" : "obj-27",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 618.0, 400.0, 20.0],
          "text" : "@fps — enum: 24/25/29.97/30 (default: 25)"
        }
      },
      {
        "box" : {
          "id" : "obj-28",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 638.0, 300.0, 20.0],
          "text" : "@hours — int 0-23 (default: 0)"
        }
      },
      {
        "box" : {
          "id" : "obj-29",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 658.0, 300.0, 20.0],
          "text" : "@minutes — int 0-59 (default: 0)"
        }
      },
      {
        "box" : {
          "id" : "obj-30",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 678.0, 300.0, 20.0],
          "text" : "@seconds — int 0-59 (default: 0)"
        }
      },
      {
        "box" : {
          "id" : "obj-31",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 698.0, 300.0, 20.0],
          "text" : "@frames — int 0-29 (default: 0)"
        }
      }
    ],
    "lines" : [
      {
        "patchline" : {
          "source" : ["obj-15", 0],
          "destination" : ["obj-16", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-16", 0],
          "destination" : ["obj-17", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-16", 1],
          "destination" : ["obj-18", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-16", 2],
          "destination" : ["obj-19", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-21", 0],
          "destination" : ["obj-22", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-22", 0],
          "destination" : ["obj-23", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-22", 1],
          "destination" : ["obj-24", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-22", 2],
          "destination" : ["obj-25", 0]
        }
      }
    ]
  }
}
