
/// Feather ignore all

#macro DEBUG_SPEED_INIT var ___time = get_timer()
#macro DEBUG_SPEED_GET show_debug_message(string((get_timer()-___time)/1000) + "ms")

/// @desc Similar to show_debug_message(), but with multiple arguments separated by commas.
function print() {
	if (argument_count > 0) {
		var _log = "", i = 0;
		repeat(argument_count) {
			_log += string(argument[i]);
			if (argument_count > 1) _log += " | ";
			++i;
		}
		show_debug_message(_log);
	}
}

#macro trace __trace(_GMFILE_ + "/" + _GMFUNCTION_ + ":" + string(_GMLINE_) + ": ")
function __trace(_location) {
	// credits: "Red", "JuJu Adams"
	static __struct = {};
	__struct.__location = _location;
	return method(__struct, function(_str) {
		show_debug_message(__location + ": " + string(_str));
	});
}

/// @desc This function freezes the window for a few milliseconds. It is not recommended to use this function. Only for debug purposes.
/// @param {real} [milliseconds]=1000 Description
function sleep(milliseconds=1000, callback=undefined) {
	var _time = current_time + milliseconds;
	while(current_time < _time) {
		// idle
		if (callback != undefined) callback();
	}
}

/// @desc This function reads a data structure and returns a debug message.
/// @param {Any} data_structure The data structure index.
/// @param {Constant.DSType} type The data structure type. Example: ds_type_list.
function ds_debug_print(data_structure, type) {
	var _separator = string_repeat("-", 32);
	show_debug_message(_separator);
	
	if (!is_real(data_structure) || !ds_exists(data_structure, type)) {
		show_debug_message("Data structure does not exist.");
		exit;
	}
	
	switch(type) {
		case ds_type_list:
			var _txt = "DS_LIST:\n";
			var i = 0, isize = ds_list_size(data_structure);
			repeat(isize) {
				_txt += "\n" + string(data_structure[| i]);
				++i;
			}
			show_debug_message(_txt);
			break;
		
		case ds_type_map:
			var _txt = "DS_MAP:\n";
			var _keys_aray = ds_map_keys_to_array(data_structure);
			var _values_array = ds_map_values_to_array(data_structure);
			var isize = array_length(_keys_aray), i = isize-1;
			_txt += "\n>> SIZE: " + string(isize);
			repeat(isize) {
				_txt += "\n" + string(_keys_aray[i] + " : " + string(_values_array[i]));
				--i;
			}
			show_debug_message(_txt);
			break;
			
		case ds_type_priority:
			var _txt = "DS_PRIORITY:\n";
			var _temp_ds_pri = ds_priority_create();
			ds_priority_copy(_temp_ds_pri, data_structure);
			var i = 0, isize = ds_priority_size(_temp_ds_pri);
			_txt += "\n>> SIZE: " + string(isize) + "| Min priority: " + string(ds_priority_find_min(_temp_ds_pri)) + " | Max priority: " + string(ds_priority_find_max(_temp_ds_pri));
			repeat(isize) {
				var _val = ds_priority_find_min(_temp_ds_pri);
				_txt += "\n" + string(ds_priority_find_priority(_temp_ds_pri, _val)) + " : " + string(_val);
				ds_priority_delete_min(_temp_ds_pri);
				++i;
			}
			
			ds_priority_destroy(_temp_ds_pri);
			show_debug_message(_txt);
			break;
			
		case ds_type_grid:
			var _txt = "DS_GRID:\n";
			var _ww = ds_grid_width(data_structure);
			var _hh = ds_grid_height(data_structure);
			_txt += "\n>> SIZE: " + string(_ww) + "x" + string(_hh);
			var i = 0, j = 0, _space = "";
			repeat(_ww) {
				j = 0;
				repeat(_hh) {
					_space = "";
					if (j % _ww == 0) _space = "\n";
					_txt += _space + string(ds_grid_get(data_structure, i, j)) + "\t";
					++j;
				}
				++i;
			}
			show_debug_message(_txt);
			break;
			
		case ds_type_queue:
			var _txt = "DS_QUEUE:\n";
			var _temp_ds_queue = ds_queue_create();
			ds_queue_copy(_temp_ds_queue, data_structure);
			var i = 0, isize = ds_queue_size(_temp_ds_queue);
			_txt += "\n>> SIZE: " + string(isize) + "| Head: " + string(ds_queue_head(_temp_ds_queue)) + " | Tail: " + string(ds_queue_tail(_temp_ds_queue));
			repeat(isize) {
				_txt += "\n" + string(ds_queue_dequeue(_temp_ds_queue));
				++i;
			}
			ds_queue_destroy(_temp_ds_queue);
			show_debug_message(_txt);
			break;
			
		case ds_type_stack:
			var _txt = "DS_STACK:\n";
			var _temp_ds_stack = ds_stack_create();
			ds_stack_copy(_temp_ds_stack, data_structure);
			var i = 0, isize = ds_stack_size(data_structure);
			_txt += "\n>> SIZE: " + string(isize) + "| Top: " + string(ds_stack_top(_temp_ds_stack));
			repeat(isize) {
				_txt += "\n" + string(ds_stack_pop(_temp_ds_stack));
				++i;
			}
			ds_stack_destroy(_temp_ds_stack);
			show_debug_message(_txt);
			break;
		
		default:
			show_debug_message("Select the type of data structure to debug.");
			break;
	}
	show_debug_message(_separator);
}

function draw_debug_button(x, y, text, callback=undefined) {
	var _old_font = draw_get_font(),
	old_halign = draw_get_halign(),
	old_valign = draw_get_valign(),
	old_color = draw_get_color(),
	_pressed = false, _color_bg = c_dkgray, _color_text = c_white,
	_ww = string_width(text)+8, _hh = string_height(text)+8;
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+_ww, y+_hh) {
		_color_bg = c_white;
		_color_text = c_dkgray;
		if mouse_check_button(mb_left) {
			_color_text = c_lime;
			_color_bg = c_black;
		}
		if mouse_check_button_released(mb_left) {
			if !is_undefined(callback) callback();
			_pressed = true;
		}
	}
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(_color_bg);
	draw_rectangle(x, y, x+_ww, y+_hh, false);
	draw_set_color(_color_text);
	draw_set_font(-1);
	draw_text(x+_ww/2, y+_hh/2, text);
	draw_set_font(_old_font);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);
	draw_set_color(old_color);
	return _pressed;
}

function draw_debug_slider(x, y, width, title, default_value, min_value, max_value, callback=undefined) {
	var height = 16;
	var _value = default_value;
	if point_in_rectangle(gui_mouse_x, gui_mouse_y, x-16, y-height, x+width+16, y+height) {
		if mouse_check_button(mb_left) {
			_value = median(0, 1, (device_mouse_x_to_gui(0) - x) / width);
		}
	}
	var _output = lerp(min_value, max_value, _value);
	if (callback != undefined)  callback(_output);
	draw_text(x, y, string(_output) + " | " + title);
	draw_line(x, y, x+width, y);
	draw_circle(x+width*_value, y, 5, true);
}

/// @desc This function draws the resolutions on the screen, for debugging purposes.
/// @param {real} x The x position to draw the text.
/// @param {real} x The y position to draw the text.
/// @param {string} extra_str Additional text to be concatenated.
function draw_debug_resolutions(x, y, extra_str="") {
	var _sep = "";//string_repeat("-", 40);
	var _text =
	$"display_get_width: {display_get_width()} \ndisplay_get_height: {display_get_height()} | {display_get_width()/display_get_height()}\n{_sep}\n" +
	$"window_get_width: {window_get_width()} \nwindow_get_height: {window_get_height()} | {window_get_width()/window_get_height()}\n{_sep}\n" +
	$"browser_width: {browser_width} \nbrowser_height: {browser_height} | {browser_width/browser_height}\n{_sep}\n" +
	$"application_get_position(): {application_get_position()} | {(application_get_position()[2]-application_get_position()[0])/(application_get_position()[3]-application_get_position()[1])}\n{_sep}\n" +
	$"display_get_gui_width: {display_get_gui_width()} \ndisplay_get_gui_height: {display_get_gui_height()} | {display_get_gui_width()/display_get_gui_height()}\n{_sep}\n" +
	$"application_surface width: {surface_get_width(application_surface)} \napplication_surface height: {surface_get_height(application_surface)} | {surface_get_width(application_surface)/surface_get_height(application_surface)}\n{_sep}\n" +
	$"view_wport0: {view_wport[0]} \nview_hport0: {view_hport[0]} | {view_wport[0]/view_hport[0]}\n{_sep}\n" +
	$"camera_get_view_width0: {camera_get_view_width(view_camera[0])} \ncamera_get_view_height0: {camera_get_view_height(view_camera[0])} | {camera_get_view_width(view_camera[0])/camera_get_view_height(view_camera[0])}\n{_sep}\n" + string(extra_str);
	draw_text(x, y, _text);
}
