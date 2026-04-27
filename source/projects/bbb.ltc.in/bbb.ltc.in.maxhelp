{
	"patcher" : {
		"fileversion" : 1,
		"appversion" : {
			"major" : 8,
			"minor" : 6,
			"revision" : 4
		},
		"classnamespace" : "box",
		"rect" : [ 100.0, 100.0, 800.0, 700.0 ],
		"bglocked" : 1,
		"openrect" : [ 0.0, 0.0, 0.0, 0.0 ],
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 2,
		"gridsize" : [ 15.0, 15.0 ],
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
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [ {
			"box" : {
				"id" : "obj-1",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 20.0, 100.0, 20.0 ],
				"text" : "bbb.ltc.in"
			}
		}, {
			"box" : {
				"id" : "obj-2",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 44.0, 360.0, 20.0 ],
				"text" : "Decode LTC audio signal to SMPTE timecode"
			}
		}, {
			"box" : {
				"id" : "obj-3",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 82.0, 180.0, 20.0 ],
				"text" : "(signal) LTC audio input"
			}
		}, {
			"box" : {
				"id" : "obj-4",
				"maxclass" : "newobj",
				"numinlets" : 1,
				"numoutlets" : 3,
				"outlettype" : [ "", "int", "signal" ],
				"patching_rect" : [ 280.0, 82.0, 100.0, 22.0 ],
				"text" : "bbb.ltc.in"
			}
		}, {
			"box" : {
				"id" : "obj-5",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 430.0, 67.0, 310.0, 20.0 ],
				"text" : "(list) hours mins secs frames dfbit"
			}
		}, {
			"box" : {
				"id" : "obj-6",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 430.0, 89.0, 310.0, 20.0 ],
				"text" : "(int) lock status 1=locked 0=lost"
			}
		}, {
			"box" : {
				"id" : "obj-7",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 430.0, 111.0, 310.0, 20.0 ],
				"text" : "(signal) passthrough (always 0.0)"
			}
		}, {
			"box" : {
				"id" : "obj-8",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 158.0, 250.0, 20.0 ],
				"text" : "Example 1 : Decode from ADC"
			}
		}, {
			"box" : {
				"id" : "obj-9",
				"maxclass" : "newobj",
				"numinlets" : 0,
				"numoutlets" : 1,
				"outlettype" : [ "signal" ],
				"patching_rect" : [ 50.0, 198.0, 55.0, 22.0 ],
				"text" : "adc~ 1"
			}
		}, {
			"box" : {
				"id" : "obj-10",
				"maxclass" : "newobj",
				"numinlets" : 2,
				"numoutlets" : 1,
				"outlettype" : [ "signal" ],
				"patching_rect" : [ 50.0, 243.0, 55.0, 22.0 ],
				"text" : "*~ 2.0"
			}
		}, {
			"box" : {
				"id" : "obj-11",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 115.0, 248.0, 80.0, 20.0 ],
				"text" : "gain boost"
			}
		}, {
			"box" : {
				"id" : "obj-12",
				"maxclass" : "newobj",
				"numinlets" : 1,
				"numoutlets" : 3,
				"outlettype" : [ "", "int", "signal" ],
				"patching_rect" : [ 50.0, 288.0, 145.0, 22.0 ],
				"text" : "bbb.ltc.in @fps 1"
			}
		}, {
			"box" : {
				"id" : "obj-13",
				"maxclass" : "newobj",
				"numinlets" : 1,
				"numoutlets" : 0,
				"outlettype" : [ ],
				"patching_rect" : [ 250.0, 288.0, 105.0, 22.0 ],
				"text" : "print timecode"
			}
		}, {
			"box" : {
				"id" : "obj-14",
				"maxclass" : "toggle",
				"numinlets" : 1,
				"numoutlets" : 1,
				"outlettype" : [ "int" ],
				"patching_rect" : [ 250.0, 318.0, 20.0, 20.0 ]
			}
		}, {
			"box" : {
				"id" : "obj-15",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 280.0, 323.0, 80.0, 20.0 ],
				"text" : "lock status"
			}
		}, {
			"box" : {
				"id" : "obj-16",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 373.0, 280.0, 20.0 ],
				"text" : "Example 2 : Test with oscillator"
			}
		}, {
			"box" : {
				"id" : "obj-17",
				"maxclass" : "newobj",
				"numinlets" : 2,
				"numoutlets" : 1,
				"outlettype" : [ "signal" ],
				"patching_rect" : [ 50.0, 413.0, 85.0, 22.0 ],
				"text" : "cycle~ 1000"
			}
		}, {
			"box" : {
				"id" : "obj-18",
				"maxclass" : "newobj",
				"numinlets" : 1,
				"numoutlets" : 3,
				"outlettype" : [ "", "int", "signal" ],
				"patching_rect" : [ 50.0, 458.0, 145.0, 22.0 ],
				"text" : "bbb.ltc.in @fps 0"
			}
		}, {
			"box" : {
				"id" : "obj-19",
				"maxclass" : "newobj",
				"numinlets" : 1,
				"numoutlets" : 0,
				"outlettype" : [ ],
				"patching_rect" : [ 250.0, 458.0, 100.0, 22.0 ],
				"text" : "print tc_test"
			}
		}, {
			"box" : {
				"id" : "obj-20",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 513.0, 80.0, 20.0 ],
				"text" : "Attributes"
			}
		}, {
			"box" : {
				"id" : "obj-21",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 538.0, 390.0, 20.0 ],
				"text" : "@fps — enum: 0=24 1=25 2=29.97 3=30 (default: 1)"
			}
		}, {
			"box" : {
				"id" : "obj-22",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 561.0, 270.0, 20.0 ],
				"text" : "@sample_rate — int (default: 44100)"
			}
		}, {
			"box" : {
				"id" : "obj-23",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 584.0, 300.0, 20.0 ],
				"text" : "@lock_timeout — float seconds (default: 0.5)"
			}
		}, {
			"box" : {
				"id" : "obj-24",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 618.0, 80.0, 20.0 ],
				"text" : "Messages"
			}
		}, {
			"box" : {
				"id" : "obj-25",
				"maxclass" : "comment",
				"numinlets" : 1,
				"numoutlets" : 0,
				"patching_rect" : [ 50.0, 643.0, 300.0, 20.0 ],
				"text" : "bang — output last decoded timecode"
			}
		} ],
		"lines" : [ {
			"patchline" : {
				"source" : [ "obj-9", 0 ],
				"destination" : [ "obj-10", 0 ]
			}
		}, {
			"patchline" : {
				"source" : [ "obj-10", 0 ],
				"destination" : [ "obj-12", 0 ]
			}
		}, {
			"patchline" : {
				"source" : [ "obj-12", 0 ],
				"destination" : [ "obj-13", 0 ]
			}
		}, {
			"patchline" : {
				"source" : [ "obj-12", 1 ],
				"destination" : [ "obj-14", 0 ]
			}
		}, {
			"patchline" : {
				"source" : [ "obj-17", 0 ],
				"destination" : [ "obj-18", 0 ]
			}
		}, {
			"patchline" : {
				"source" : [ "obj-18", 0 ],
				"destination" : [ "obj-19", 0 ]
			}
		} ]
	}
}
