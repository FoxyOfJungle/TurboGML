
randomize();

//gpu_set_tex_filter(true);
//show_debug_overlay(true);

angle1 = 0;
angle2 = 0;
angle3 = 0;
angle4 = 0;
angle5 = 0;
angle6 = 0;


tankAngle = 0;
turretAngle = 0;

time = 0;
yup = 0;


//var buffer = buffer_create(1, buffer_grow, 4);
//buffer_write(buffer, buffer_f32, 1.8);
//buffer_write(buffer, buffer_f32, 2.3);
//buffer_write(buffer, buffer_f32, 3.2);
//buffer_write(buffer, buffer_f32, 401.0789);
//buffer_debug(buffer, buffer_f32, 0,, true);

//var newBuffer = buffer_slice(buffer, 1, 1); // 2.3 (position 1, amount 1)
//buffer_debug(newBuffer, buffer_f32, 0,, true);


//buffer_debug(newBuffer, buffer_f32, false);


//matrix = matrix_build(10, 12, 14, 5, 6, 7, 1, 1, 1);
//show_message(matrix_get_position(matrix));
//show_message(matrix_get_scale(matrix));


//var value1 = 255;
//var value2 = 255;
//var value3 = 255;
//var encoded_value = (value1 << 16) | (value2 << 8) | value3;

//var decoded_value1 = (encoded_value >> 16) & 0xFF;
//var decoded_value2 = (encoded_value >> 8) & 0xFF;
//var decoded_value3 = encoded_value & 0xFF;

//print(decoded_value1, decoded_value2, decoded_value3);



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


// Load .wav
//sound_struct = audio_load_wav("explosion3.wav");
//audio_play_sound(sound_struct.audio, 0, false);


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

