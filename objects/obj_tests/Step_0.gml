
if keyboard_check_pressed(vk_escape) game_end();

//if keyboard_check(ord("U")) DELTA_TIME_SCALE -= 0.02;
//if keyboard_check(ord("I")) DELTA_TIME_SCALE += 0.02;

//if keyboard_check_pressed(ord("J")) test -= 1;
//if keyboard_check_pressed(ord("K")) test += 1;



/*if keyboard_check_pressed(ord("V")) {
	audio = audio_load_wav("Musiccc.wav");
	show_debug_message(audio);
	audio_play_sound(audio.audio, 100, false);
}

if keyboard_check_pressed(ord("B")) {
	audio = audio_load_wav("explosion3.wav");
	show_debug_message(audio);
	audio_play_sound(audio.audio, 100, false);
}

if keyboard_check_pressed(ord("N")) {
	audio = audio_load_raw("music_u8_pcm_44100.raw", 44100, 8, 2);
	show_debug_message(audio);
	audio_play_sound(audio.audio, 100, false);
}

if keyboard_check_pressed(ord("M")) {
	audio_stream_destroy(audio);
}*/



/*var x1, y1, x2, y2;
x1 = lengthdir_x(1, image_angle);
y1 = lengthdir_y(1, image_angle);
x2 = o_Player.x - x;
y2 = o_Player.y - y;
if dot_product(x1, y1, x2, y2) > 0 seen=true else seen=false;
*/


/*if keyboard_check_pressed(vk_space) {
	// generate pseudo-random action list
	if array_empty(pseudo_action_list) {
		pseudo_action_list = random_pseudo_array_ext(10, function(_val) {
			var _chance = choose_weighted([0, 1, 2], [10, 100, 30]);
			return _chance; //_val
		});
		
		show_debug_message("----- new shuffle -----");
	}
	
	show_debug_message(pseudo_action_list);
	
	
	var _value = array_pop(pseudo_action_list);
	show_debug_message(_value);
	
}
*/


//if mouse_check_button_pressed(mb_right) {
//	var _inst = instance_top_position(mouse_x, mouse_y, all);
//	instance_destroy(_inst);
//}


//if mouse_check_button_pressed(mb_left) {
//	var _inst = instance_create_layer(mouse_x, mouse_y, "Instances", all);
//	_inst.depth = instt.depth - 1;
//	instt = _inst;
//}

