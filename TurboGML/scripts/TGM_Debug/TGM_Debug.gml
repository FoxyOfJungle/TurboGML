
/// Feather ignore all

#macro DEBUG_SPEED_INIT ___time = get_timer()
#macro DEBUG_SPEED_GET show_debug_message($"{(get_timer()-___time)/1000}ms")

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

#macro trace __tgmTrace(_GMFILE_, _GMFUNCTION_, _GMLINE_)
/// @desc This function creates a trace method for debugging and displaying location-specific debug messages.
function __tgmTrace(_file, _func, _line) {
	// credits: "Red", "JuJu Adams"
	static __struct = {};
	__struct.__location = $"{_file} / {_func} : {_line}: ";;
	return method(__struct, function(_str) {
		show_debug_message(__location + ": " + string(_str));
	});
}

/// @desc This function freezes the application for a few milliseconds. It is NOT recommended to use this function. Only for debug purposes.
/// @param {real} [milliseconds]=1000 Description
function sleep(_milliseconds=1000, _callback=undefined) {
	var _time = current_time + _milliseconds;
	while(current_time < _time) {
		// idle
		if (_callback != undefined) _callback();
	}
}

/// @desc This function reads a data structure and returns a debug message with all the contents.
/// @param {Any} data_structure The data structure index.
/// @param {Constant.DSType} dsType The data structure type. Example: ds_type_list.
function ds_debug_print(_dataStructure, _dsType) {
	var _separator = string_repeat("-", 32);
	show_debug_message(_separator);
    
	if (!ds_exists(_dataStructure, _dsType)) {
		show_debug_message("Data structure does not exist.");
		exit;
	}
    
	switch(_dsType) {
		case ds_type_list:
			var _txt = "DS_LIST:\n";
			var i = 0, _isize = ds_list_size(_dataStructure);
			repeat(_isize) {
				_txt += "\n" + string(_dataStructure[| i]);
				++i;
			}
			show_debug_message(_txt);
			break;
        
		case ds_type_map:
			var _txt = "DS_MAP:\n";
			var _keysArray = ds_map_keys_to_array(_dataStructure);
			var _valuesArray = ds_map_values_to_array(_dataStructure);
			var _isize = array_length(_keysArray), i = _isize - 1;
			_txt += "\n>> SIZE: " + string(_isize);
			repeat(_isize) {
				_txt += "\n" + string(_keysArray[i] + " : " + string(_valuesArray[i]));
				--i;
			}
			show_debug_message(_txt);
			break;
        
		case ds_type_priority:
			var _txt = "DS_PRIORITY:\n";
			var _tempDsPri = ds_priority_create();
			ds_priority_copy(_tempDsPri, _dataStructure);
			var i = 0, _isize = ds_priority_size(_tempDsPri);
			_txt += "\n>> SIZE: " + string(_isize) + "| Min priority: " + string(ds_priority_find_min(_tempDsPri)) + " | Max priority: " + string(ds_priority_find_max(_tempDsPri));
			repeat(_isize) {
				var _val = ds_priority_find_min(_tempDsPri);
				_txt += "\n" + string(ds_priority_find_priority(_tempDsPri, _val)) + " : " + string(_val);
				ds_priority_delete_min(_tempDsPri);
				++i;
			}
            
			ds_priority_destroy(_tempDsPri);
			show_debug_message(_txt);
			break;
        
		case ds_type_grid:
			var _txt = "DS_GRID:\n";
			var _ww = ds_grid_width(_dataStructure);
			var _hh = ds_grid_height(_dataStructure);
			_txt += "\n>> SIZE: " + string(_ww) + "x" + string(_hh);
			var i = 0, j = 0, _space = "";
			repeat(_ww) {
				j = 0;
				repeat(_hh) {
				_space = "";
				if (j % _ww == 0) _space = "\n";
					_txt += _space + string(ds_grid_get(_dataStructure, i, j)) + "\t";
					++j;
				}
				++i;
			}
			show_debug_message(_txt);
			break;
        
		case ds_type_queue:
			var _txt = "DS_QUEUE:\n";
			var _tempDsQueue = ds_queue_create();
			ds_queue_copy(_tempDsQueue, _dataStructure);
			var i = 0, _isize = ds_queue_size(_tempDsQueue);
				_txt += "\n>> SIZE: " + string(_isize) + "| Head: " + string(ds_queue_head(_tempDsQueue)) + " | Tail: " + string(ds_queue_tail(_tempDsQueue));
			repeat(_isize) {
				_txt += "\n" + string(ds_queue_dequeue(_tempDsQueue));
				++i;
			}
			ds_queue_destroy(_tempDsQueue);
			show_debug_message(_txt);
			break;
        
		case ds_type_stack:
			var _txt = "DS_STACK:\n";
			var _tempDsStack = ds_stack_create();
			ds_stack_copy(_tempDsStack, _dataStructure);
			var i = 0, _isize = ds_stack_size(_dataStructure);
				_txt += "\n>> SIZE: " + string(_isize) + "| Top: " + string(ds_stack_top(_tempDsStack));
			repeat(_isize) {
				_txt += "\n" + string(ds_stack_pop(_tempDsStack));
				++i;
			}
			ds_stack_destroy(_tempDsStack);
			show_debug_message(_txt);
			break;
        
		default:
			show_debug_message("Select the type of data structure to debug.");
			break;
	}
	show_debug_message(_separator);
}

/// @desc Read the contents of a buffer and print each value to the console. This function has limitations and is only a stopgap for in-game debugging. Use debug mode to get better information.
/// @param {Id.Buffer} buffer The buffer to slice.
/// @param {Constant.BufferDataType} dataType The data type to read each value.
/// @param {Real} bytesOffset Buffer read start position (in bytes).
/// @param {Real} bytesLimit Maximum amount allowed to show (in bytes).
/// @param {Bool} peekRead Read with buffer_peek instead of buffer_read.
function buffer_debug(_buffer, _dataType=buffer_f32, _bytesOffset=0, _bytesLimit=512, _peekRead=true) {
	var _size = buffer_get_size(_buffer); // size in bytes
	var _type = buffer_get_type(_buffer);
	switch(_type) {
		case buffer_fixed: _type = "buffer_fixed" break;
		case buffer_grow: _type = "buffer_grow" break;
		case buffer_wrap: _type = "buffer_wrap" break;
		case buffer_fast: _type = "buffer_fast" break;
	}
	var _alignment = buffer_get_alignment(_buffer); // bytes alignment
	var _tell = buffer_tell(_buffer);
	show_debug_message($"Debugging buffer: {_buffer}, {_type}, Size: {bytes_get_size(_size)} ({_size} bytes), Alignment: {_alignment}, Tell: {_tell}");
	if (_size > _bytesLimit) show_debug_message($"Warning: bytes limit reached: {_bytesLimit}");
	var _bytesNumberLength = string_length(string(_bytesLimit));
	buffer_seek(_buffer, buffer_seek_start, 0);
	try {
		if (_peekRead) {
			for (var i = _bytesOffset; i < min(_size, _bytesLimit); i+=_alignment) {
				show_debug_message($"[{string_format(i, _bytesNumberLength, 0)}] {buffer_peek(_buffer, i, _dataType)}");
			}
		} else {
			for (var i = _bytesOffset; i < min(_size, _bytesLimit); i+=_alignment) {
				show_debug_message($"[{string_format(i, _bytesNumberLength, 0)}] {buffer_read(_buffer, _dataType)}");
			}
		}
	} catch(_error) {
		show_debug_message(_error.message);
	}
}

/// @desc This function draws the resolutions on the screen, for debugging purposes.
/// @param {real} x The x position to draw the text.
/// @param {real} y The y position to draw the text.
/// @param {string} extraString Additional text to be concatenated.
/// @param {string} _showInvisible If enabled, invisible views will be displayed (with their cameras).
function draw_debug_resolutions(_x, _y, _showInvisible=false, _extraString="") {
	var _text = "";
	_text += $"Display Size: {display_get_width()} x {display_get_height()} ({display_get_width()/display_get_height()})\n";
	_text += $"Window Size: {window_get_width()} x {window_get_height()} ({window_get_width()/window_get_height()})\n";
	_text += $"Browser Size: {browser_width} x {browser_height} ({browser_width/browser_height})\n";
	_text += $"application_surface Rect: {application_get_position()} ({(application_get_position()[2]-application_get_position()[0])/(application_get_position()[3]-application_get_position()[1])})\n";
	_text += $"application_surface Size: {surface_get_width(application_surface)} x {surface_get_height(application_surface)} ({surface_get_width(application_surface)/surface_get_height(application_surface)})\n";
	_text += $"Room Size: {room_width} x {room_height} ({room_width/room_height})\n";
	var _vi = 0;
	repeat(8) {
		if (view_get_visible(_vi) || _showInvisible) {
			_text += $"ViewPort[{_vi}]: Pos: {view_xport[_vi]}, {view_yport[_vi]} |  Size: {view_wport[_vi]} x {view_hport[_vi]} ({view_wport[_vi]/view_hport[_vi]})\n";
		}
		++_vi;
	}
	var _ci = 0;
	repeat(8) {
		if (view_get_visible(_ci) || _showInvisible) {
			var _view_camera = view_get_camera(_ci);
			_text += $"Camera[{_ci}]: Pos: {camera_get_view_x(_view_camera)}, {camera_get_view_y(_view_camera)} |  Size: {camera_get_view_width(_view_camera)} x {camera_get_view_height(_view_camera)} ({camera_get_view_width(_view_camera)/camera_get_view_height(_view_camera)})\n";
		}
		++_ci;
	}
	_text += $"GUI Size: {display_get_gui_width()} x {display_get_gui_height()} ({display_get_gui_width()/display_get_gui_height()})\n" + _extraString;
	gpu_push_state();
	gpu_set_blendmode(bm_max);
	draw_text(_x, _y, _text);
	gpu_pop_state();
}

/// @desc Show game resources usage (including memory) in a Debug View.
/// @param {Real} updateTime Number of frames until information is updated.
/// @param {Real} uiX The debug UI x position.
/// @param {Real} uiY The debug UI y position.
function debug_resources(_updateTime=10, _uiX=16, _uiY=35) {
	// Based on: https://gist.github.com/glebtsereteli/04578cf8d3f9c9cd1954599c9b480b5a (by glebtsereteli)
	// Adjustments by Mozart Junior (@foxyofjungle)
	static _dbgView = undefined;
	static _resourcesParams = [
		undefined, "Resources",
		"DS Lists", "listCount",
		"DS Maps", "mapCount",
		"DS Queues", "queueCount",
		"DS Grids", "gridCount",
		"DS Priority Queues", "priorityCount",
		"DS Stacks", "stackCount",
		"MP Grids", "mpGridCount",
		"Buffers", "bufferCount",
		"Surfaces", "surfaceCount",
		"Audio Emitters", "audioEmitterCount",
		"Particle Systems", "partSystemCount",
		"Particle Emitters", "partEmitterCount",
		"Particle Types", "partTypeCount",
		"Time Sources", "timeSourceCount",
		undefined, "Assets",
		"Sprites", "spriteCount",
		"Paths", "pathCount",
		"Fonts", "fontCount",
		"Rooms", "roomCount",
		"Timelines", "timelineCount",
		undefined, "Instances",
		"Instances", "instanceCount"
	];
	static _memoryParams = [
		"Used", "totalUsed",
		"Free","free",
		"Max Usage", "peakUsage"
	];
	static _resourcesParamsSize = array_length(_resourcesParams);
	static _memoryParamsSize = array_length(_memoryParams);
	static _resourcesVars = {};
	static _memoryVars = {};
	static _time = 0;
	
	// update variables every time
	if (_time++ % _updateTime == 0) {
		// ResourcesCount
		var _resourcesStruct = debug_event("ResourceCounts", true);
		for (var i = 0; i < _resourcesParamsSize; i+=2) {
			_resourcesVars[$ _resourcesParams[i]] = _resourcesStruct[$ _resourcesParams[i+1]];
		}
		// DumpMemory
		var _memoryStruct = debug_event("DumpMemory", true);
		for (var i = 0; i < _memoryParamsSize; i+=2) {
			_memoryVars[$ _memoryParams[i]] = bytes_get_size(_memoryStruct[$ _memoryParams[i+1]]);
		}
	}
	
	// create UI using variables
	if (_dbgView == undefined || !dbg_view_exists(_dbgView)) {
		_dbgView = dbg_view("Game Resources Debug", true, _uiX, _uiY, 320, 545);
		dbg_section("Resources");
		for (var i = 0; i < _resourcesParamsSize; i += 2) {
			var _name = _resourcesParams[i];
			if (_name == undefined) {
				dbg_text_separator(_resourcesParams[i+1]);
			} else {
				dbg_watch(ref_create(_resourcesVars, _name));
			}
		}
		dbg_section("Memory");
		for (var i = 0; i < _memoryParamsSize; i += 2) {
			var _name = _memoryParams[i];
			if (_name == undefined) {
				dbg_text_separator(_memoryParams[i+1]);
			} else {
				dbg_watch(ref_create(_memoryVars, _name));
			}
		}
	}
}
