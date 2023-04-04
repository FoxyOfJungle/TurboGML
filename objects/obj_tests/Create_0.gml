
gpu_set_tex_filter(true);
show_debug_overlay(true);

//
angle = 90;
angle_slow = 0;
angle2 = 180;
angle3 = 0;
angle4 = 0;
dist = 100;
test = 0;

scale_x = 1;
scale_y = 1;
tests = 0;

pseudo_action_list = [];



//show_message(aspect_ratio_gcd(1280, 1280));

/*
array = array_create_3d(8, 8, 2);

//show_debug_message(json_beautify(json_stringify(array)));
show_debug_message(array);

*/



//var files = new DirectoryScanner("F:/TestFolder", "*.*", true, true, true, DIRSCAN_DATA_TYPE.FULL_INFO, false);
//show_debug_message( json_beautify(json_stringify(files.GetContents())) );

//clipboard_set_text(string(files.GetContents()));




//audio = audio_create_stream_wav("music_s16_pcm_48000.wav");
//audio_play_sound(audio, 0, false);



/*struct = {
	name : "Fox",
	test : 10,
	count : 956,
	array : [32, 6456, "grdfg"],
}
array = [
	10, 20, 30,
]
var aa = struct_get_variable(struct, "array", 2);
show_debug_message(aa);*/


//days = undefined;
//day = 10;
//day = days ?? day;

//show_debug_message(day);



var _list = ds_list_create();
ds_list_add(_list, 4);
ds_list_add(_list, 8);
ds_list_add(_list, "Test");

var _list2 = ds_list_create();
ds_list_add(_list2, [120, 320, 64]);
ds_list_add(_list2, [32, 64]);


var _map1 = ds_map_create();
_map1[? "Test"] = 32;
_map1[? "Test3"] = 64;

var _map2 = ds_map_create();
_map2[? "Test"] = 1000;
_map2[? "Test3"] = 2000;


var _grid = ds_grid_create(4, 4);
ds_grid_add(_grid, 0, 0, 8);
ds_grid_add(_grid, 3, 2, 5);


show_debug_message(ds_debug_print(1, ds_type_map));




















