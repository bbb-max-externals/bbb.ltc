{
  "patcher" : {
    "fileversion" : 1,
    "appversion" : {
      "major" : 8,
      "minor" : 6,
      "revision" : 4
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
    "description" : "Decode timecode to formatted string, frame count, and seconds",
    "digest" : "bbb.ltc.decode - LTC timecode decoder",
    "tags" : "ltc, timecode, smpte, decode",
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
          "text" : "bbb.ltc.decode"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 55.0, 600.0, 20.0],
          "text" : "Decode timecode to formatted string, frame count, and seconds"
        }
      },
      {
        "box" : {
          "id" : "obj-3",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 100.0, 150.0, 20.0],
          "text" : "--- Inlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-4",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 120.0, 550.0, 20.0],
          "text" : "inlet 0: (list h m s f) timecode as 4 ints, or (int) frame count"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 165.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 185.0, 500.0, 20.0],
          "text" : "outlet 0 (left): (symbol) formatted timecode string e.g. \"01:00:30:15\""
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 205.0, 400.0, 20.0],
          "text" : "outlet 1 (middle): (int) total frame count"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 225.0, 350.0, 20.0],
          "text" : "outlet 2 (right): (float) total seconds"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 275.0, 400.0, 20.0],
          "text" : "--- Example 1: List Input (h m s f) @ 25fps ---"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 310.0, 100.0, 22.0],
          "text" : "1 0 30 15"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 3,
          "outlettype" : ["", "int", "float"],
          "patching_rect" : [220.0, 310.0, 200.0, 22.0],
          "text" : "bbb.ltc.decode @fps 1"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 295.0, 130.0, 20.0],
          "text" : "formatted timecode"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 310.0, 50.0, 22.0],
          "text" : "print"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 340.0, 90.0, 20.0],
          "text" : "frame count"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "number",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["int"],
          "patching_rect" : [470.0, 355.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 385.0, 60.0, 20.0],
          "text" : "seconds"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "flonum",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["float"],
          "patching_rect" : [470.0, 400.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 460.0, 450.0, 20.0],
          "text" : "--- Example 2: Frame Count Input @ 29.97fps (Drop-Frame) ---"
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "number",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["int"],
          "patching_rect" : [50.0, 495.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 3,
          "outlettype" : ["", "int", "float"],
          "patching_rect" : [220.0, 495.0, 200.0, 22.0],
          "text" : "bbb.ltc.decode @fps 2"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 480.0, 130.0, 20.0],
          "text" : "formatted timecode"
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 495.0, 80.0, 22.0],
          "text" : "print df_tc"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 525.0, 90.0, 20.0],
          "text" : "frame count"
        }
      },
      {
        "box" : {
          "id" : "obj-24",
          "maxclass" : "number",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["int"],
          "patching_rect" : [470.0, 540.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-25",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [470.0, 570.0, 60.0, 20.0],
          "text" : "seconds"
        }
      },
      {
        "box" : {
          "id" : "obj-26",
          "maxclass" : "flonum",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : ["float"],
          "patching_rect" : [470.0, 585.0, 50.0, 20.0]
        }
      },
      {
        "box" : {
          "id" : "obj-27",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 640.0, 150.0, 20.0],
          "text" : "--- Attributes ---"
        }
      },
      {
        "box" : {
          "id" : "obj-28",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 660.0, 550.0, 20.0],
          "text" : "@fps — frame rate enum: 0=24, 1=25, 2=29.97, 3=30 (default: 1 = 25fps)"
        }
      },
      {
        "box" : {
          "id" : "obj-29",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 680.0, 500.0, 20.0],
          "text" : "@sample_rate — audio sample rate for seconds conversion (default: 44100)"
        }
      },
      {
        "box" : {
          "id" : "obj-30",
          "maxclass" : "preset",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 720.0, 100.0, 40.0]
        }
      }
    ],
    "lines" : [
      {
        "patchline" : {
          "source" : ["obj-10", 0],
          "destination" : ["obj-11", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-11", 0],
          "destination" : ["obj-13", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-11", 1],
          "destination" : ["obj-15", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-11", 2],
          "destination" : ["obj-17", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-19", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 0],
          "destination" : ["obj-22", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 1],
          "destination" : ["obj-24", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 2],
          "destination" : ["obj-26", 0]
        }
      }
    ]
  }
}
