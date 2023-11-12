
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
/// @desc This function creates a trace method for debugging and displaying location-specific debug messages.
function __trace(_location) {
	// credits: "Red", "JuJu Adams"
	static __struct = {};
	__struct.__location = _location;
	return method(__struct, function(_str) {
		show_debug_message(__location + ": " + string(_str));
	});
}

/// @desc This function freezes the application for a few milliseconds. It is not recommended to use this function. Only for debug purposes.
/// @param {real} [milliseconds]=1000 Description
function sleep(milliseconds=1000, callback=undefined) {
	var _time = current_time + milliseconds;
	while(current_time < _time) {
		// idle
		if (callback != undefined) callback();
	}
}

/// @desc This function reads a data structure and returns a debug message with all the contents.
/// @param {Any} data_structure The data structure index.
/// @param {Constant.DSType} type The data structure type. Example: ds_type_list.
function ds_debug_print(data_structure, type) {
	var _separator = string_repeat("-", 32);
	show_debug_message(_separator);
	
	if (!ds_exists(data_structure, type)) {
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



/// @desc This function draws the resolutions on the screen, for debugging purposes.
/// @param {real} x The x position to draw the text.
/// @param {real} y The y position to draw the text.
/// @param {string} extra_str Additional text to be concatenated.
/// @param {string} show_invisible If enabled, invisible views will be displayed (with their cameras).
function draw_debug_resolutions(x, y, extra_str="", show_invisible=false) {
	var _text = "";
	_text += $"Display Size: {display_get_width()} x {display_get_height()} ({display_get_width()/display_get_height()})\n";
	_text += $"Window Size: {window_get_width()} x {window_get_height()} ({window_get_width()/window_get_height()})\n";
	_text += $"Browser Size: {browser_width} x {browser_height} ({browser_width/browser_height})\n";
	_text += $"application_surface Rect: {application_get_position()} ({(application_get_position()[2]-application_get_position()[0])/(application_get_position()[3]-application_get_position()[1])})\n";
	_text += $"application_surface Size: {surface_get_width(application_surface)} x {surface_get_height(application_surface)} ({surface_get_width(application_surface)/surface_get_height(application_surface)})\n";
	_text += $"Room Size: {room_width} x {room_height} ({room_width/room_height})\n";
	var _ci = 0;
	repeat(8) {
		if (view_get_visible(_ci) || show_invisible) {
			var _view_camera = view_get_camera(_ci);
			_text += $"Camera[{_ci}]: Pos: {camera_get_view_x(_view_camera)}, {camera_get_view_y(_view_camera)} |  Size: {camera_get_view_width(_view_camera)} x {camera_get_view_height(_view_camera)} ({camera_get_view_width(_view_camera)/camera_get_view_height(_view_camera)})\n";
		}
		++_ci;
	}
	var _vi = 0;
	repeat(8) {
		if (view_get_visible(_vi) || show_invisible) {
			_text += $"ViewPort[{_vi}]: Pos: {view_xport[_vi]}, {view_yport[_vi]} |  Size: {view_wport[_vi]} x {view_hport[_vi]} ({view_wport[_vi]/view_hport[_vi]})\n";
		}
		++_vi;
	}
	_text += $"GUI Size: {display_get_gui_width()} x {display_get_gui_height()} ({display_get_gui_width()/display_get_gui_height()})\n";
	draw_text(x, y, _text);
}
