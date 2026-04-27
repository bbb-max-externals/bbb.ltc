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
    "description" : "LTC audio signal encoder/generator",
    "digest" : "bbb.ltc.out - LTC audio signal encoder/generator",
    "tags" : "timecode, ltc, smpte, audio, encoder",
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
          "patching_rect" : [50.0, 30.0, 400.0, 20.0],
          "text" : "bbb.ltc.out"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 55.0, 600.0, 20.0],
          "text" : "LTC audio signal encoder/generator"
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
          "patching_rect" : [50.0, 125.0, 550.0, 20.0],
          "text" : "inlet 0 (signal): messages — list (h m s f), int (total frame count), bang (output current TC)"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 170.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 195.0, 400.0, 20.0],
          "text" : "outlet 0 (left): (list) current timecode h m s f"
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 220.0, 400.0, 20.0],
          "text" : "outlet 1 (right): (signal) LTC audio signal"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 270.0, 350.0, 20.0],
          "text" : "--- Example 1: Basic LTC output ---"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 295.0, 200.0, 20.0],
          "text" : "set timecode (1h 0m 0s 0f)"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 320.0, 80.0, 22.0],
          "text" : "1 0 0 0"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", "signal"],
          "patching_rect" : [50.0, 370.0, 170.0, 22.0],
          "text" : "bbb.ltc.out @fps 1"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "newobj",
          "numinlets" : 2,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 420.0, 52.0, 36.0],
          "text" : "ezdac~"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [270.0, 370.0, 50.0, 22.0],
          "text" : "print"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [110.0, 425.0, 200.0, 20.0],
          "text" : "(signal) LTC audio → DAC"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [270.0, 350.0, 200.0, 20.0],
          "text" : "(list) timecode status"
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 480.0, 350.0, 20.0],
          "text" : "--- Example 2: Query current timecode ---"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 505.0, 200.0, 20.0],
          "text" : "set timecode"
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 530.0, 80.0, 22.0],
          "text" : "0 0 0 0"
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", "signal"],
          "patching_rect" : [50.0, 580.0, 110.0, 22.0],
          "text" : "bbb.ltc.out"
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [200.0, 555.0, 200.0, 20.0],
          "text" : "query current TC"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "button",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [200.0, 580.0, 24.0, 24.0]
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 630.0, 50.0, 22.0],
          "text" : "print"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 680.0, 200.0, 20.0],
          "text" : "--- Attributes ---"
        }
      },
      {
        "box" : {
          "id" : "obj-24",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 705.0, 400.0, 20.0],
          "text" : "@fps: enum 24/25/29.97/30 (default: 25)"
        }
      },
      {
        "box" : {
          "id" : "obj-25",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 730.0, 400.0, 20.0],
          "text" : "@sample_rate: int (default: 44100)"
        }
      },
      {
        "box" : {
          "id" : "obj-26",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 755.0, 400.0, 20.0],
          "text" : "@volume: float dBFS (default: -3.0)"
        }
      },
      {
        "box" : {
          "id" : "obj-27",
          "maxclass" : "preset",
          "numinlets" : 1,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 790.0, 100.0, 40.0]
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
          "destination" : ["obj-12", 0]
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
          "source" : ["obj-21", 0],
          "destination" : ["obj-19", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-19", 0],
          "destination" : ["obj-22", 0]
        }
      }
    ]
  }
}
