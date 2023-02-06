

/*#macro mouse_check_button_pressed test_mouse_check_button_pressed
#macro __mouse_check_button_pressed mouse_check_button_pressed

function test_mouse_check_button_pressed(button) {
	var _pressed = __mouse_check_button_pressed(button);
	if (_pressed) show_debug_message("Click");
	return _pressed;
}*/


/*global._time_source = time_source_create(time_source_game, 300, time_source_units_frames, function() {
	show_debug_message("CALLED");
}, [], -1);
time_source_start(global._time_source);


#macro game_restart mod_game_restart
#macro __game_restart game_restart

function mod_game_restart() {
	__game_restart();
	show_debug_message(">> Redefine Everything <<");
	time_source_reset(global._time_source);
	return undefined;
}*/

