
gpu_set_tex_filter(true);
show_debug_overlay(true);


// tests...
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


/*
// Search for stuff in directories
files = [];
directory_get_contents("F:/TestFolder", files, "*.*", true, true, true, DIRSCAN_DATA_TYPE.NAME_ONLY);
show_debug_message(json_stringify(files, true));
*/

/*
// Load .wav
sound_struct = audio_load_wav("explosion3.wav");
audio_play_sound(sound_struct.audio, 0, false);
*/


/*
struct = {
	name : "Fox",
	test : 10,
	count : 956,
	array : [32, 6456, "grdfg"],
};
array = [
	10, 20, 30,
];
var aa = struct_get_variable(struct, "array", 2);
show_debug_message(aa);*/



/*var _list = ds_list_create();
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


var _queue = ds_queue_create();
ds_queue_enqueue(_queue, 32, 64, 82, 100);


show_debug_message(ds_debug_print(_queue, ds_type_queue));*/

