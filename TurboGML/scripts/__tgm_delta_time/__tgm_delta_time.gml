
/// Feather ignore all

#macro __DELTA_TIME_ENABLE true

// PLEASE NOTE: THIS IS A BASIC IMPLEMENTATION OF DELTA TIMING
// USE "IOTA" BY JUJU, FOR ROBUST DELTA TIMING

// Delta Time
// base frame rate
#macro FRAME_RATE 60

// Delta time, used for multiplying things
#macro DELTA_TIME global.__delta_time_multiplier

// Delta time scale, used for slow motion
#macro DELTA_TIME_SCALE global.__delta_time_scale

// Delta update smoothness, is the interpolated speed used to smooth out sudden FPS changes (1 = default)
#macro DELTA_UPDATE_LERP 1

// The maximum delta time should reach, until reset to 1. 3 is a good value
#macro DELTA_TIME_TOLERANCE 1000

// Current time, based on Delta Time. Useful for animations
#macro TIMER global.__timer


// --- internal ---
global.__delta_speed = 0;
global.__delta_time_multiplier_base = 1;
global.__delta_time_multiplier = 1;
global.__delta_time_scale = 1;
global.__timer = 0;
//global.__frame_count

// Delta Mouse
global.__mouse_x_delta = 0;
global.__mouse_y_delta = 0;
global.__mouse_x_previous = 0;
global.__mouse_y_previous = 0;
global.__gui_mouse_x_delta = 0;
global.__gui_mouse_y_delta = 0;
global.__gui_mouse_x_previous = 0;
global.__gui_mouse_y_previous = 0;
#macro mouse_x_delta global.__mouse_x_delta
#macro mouse_y_delta global.__mouse_y_delta
#macro gui_mouse_x_delta global.__gui_mouse_x_delta
#macro gui_mouse_y_delta global.__gui_mouse_y_delta

if (__DELTA_TIME_ENABLE) {
	var _tm;
	_tm = call_later(1, time_source_units_frames, function() {
		// delta time
		global.__delta_speed = 1/FRAME_RATE;
		global.__delta_time_multiplier_base = (delta_time/1000000)/global.__delta_speed;
		global.__delta_time_multiplier = lerp(global.__delta_time_multiplier, global.__delta_time_multiplier_base, 1) * global.__delta_time_scale;
		if (global.__delta_time_multiplier > DELTA_TIME_TOLERANCE) global.__delta_time_multiplier = 1;
	
		// delta mouse
		global.__mouse_x_delta = mouse_x - global.__mouse_x_previous;
		global.__mouse_y_delta = mouse_y - global.__mouse_y_previous;
		global.__gui_mouse_x_delta = mouse_x - global.__gui_mouse_x_previous;
		global.__gui_mouse_y_delta = mouse_y - global.__gui_mouse_y_previous;
	}, true);

	_tm = call_later(2, time_source_units_frames, function() {
		var _tm = call_later(1, time_source_units_frames, function() {
			// delta mouse
			global.__mouse_x_previous = mouse_x;
			global.__mouse_y_previous = mouse_y;
			global.__gui_mouse_x_previous = device_mouse_x_to_gui(0);
			global.__gui_mouse_y_previous = device_mouse_y_to_gui(0);
			
			// frame count
			//global.__frame_count += game_get_speed(gamespeed_fps);
			
			// thread-dependent timer, based on Delta Time
			global.__timer += DELTA_TIME;
		}, true);
	}, false);
}
