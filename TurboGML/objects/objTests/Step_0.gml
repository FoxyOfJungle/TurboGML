
if (keyboard_check_pressed(vk_escape)) game_end();
if (keyboard_check_pressed(ord("R"))) room_restart();








// Save and Load example, using rc4
/*#macro GAMEDATA_KEY "aK74das#4%sdb574"

// save
if (keyboard_check_pressed(ord("S"))) {
	gameData = {
		scoreAmount : 100,
		livesAmount : 3
	};
	
	// convert struct to json
	var _jsonString = json_stringify(gameData);
	
	// write data to a buffer
	var _buff = buffer_create(0, buffer_grow, 1);
	buffer_write(_buff, buffer_text, _jsonString);
	
	// encrypt buffer (sync)
	cryptography_rc4(_buff, GAMEDATA_KEY, 0, buffer_get_size(_buff));
	//cryptography_xor(_buff, 0x48, 0, buffer_get_size(_buff));
	
	// save
	buffer_save(_buff, "gamedata.dat");
	buffer_delete(_buff);
}

// load
if (keyboard_check_pressed(ord("L"))) {
	// load buffer from file
	var _buff = buffer_load("gamedata.dat");
	try {
		// decrypt buffer (sync)
		cryptography_rc4(_buff, GAMEDATA_KEY, 0, buffer_get_size(_buff));
		//cryptography_xor(_buff, 0x48, 0, buffer_get_size(_buff));
	
		// read buffer
		buffer_seek(_buff, buffer_seek_start, 0); // set read byte to 0
		var _jsonString = buffer_read(_buff, buffer_text);
	
		// read struct
		var _jsonStruct = json_parse(_jsonString);
		show_message(_jsonStruct);
		buffer_delete(_buff);
	} catch(_error) {
		show_debug_message(_error.message);
	}
}
*/

/*if (keyboard_check_pressed(vk_space)) {
	// generate pseudo-random action list
	if (array_is_empty(pseudo_action_list)) {
		pseudo_action_list = array_create_random_sequence_ext(10, function(_val) {
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

