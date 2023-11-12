
/// Feather ignore all

#macro gui_w display_get_gui_width()
#macro gui_h display_get_gui_height()
#macro gui_mouse_x device_mouse_x_to_gui(0)
#macro gui_mouse_y device_mouse_y_to_gui(0)
#macro gui_mouse_x_normalized (device_mouse_x_to_gui(0)/display_get_gui_width())
#macro gui_mouse_y_normalized (device_mouse_y_to_gui(0)/display_get_gui_height())

// this is useful for some libraries by Samuel
function io_clear_both() {
	keyboard_clear(keyboard_lastkey);
	mouse_clear(mouse_lastbutton);
}

/// @desc Returns the x position of the mouse without it being stuck in the window.
/// @returns {real} 
function window_mouse_x() {
    return display_mouse_get_x() - window_get_x();
}

/// @desc Returns the y position of the mouse without it being stuck in the window.
/// @returns {real} 
function window_mouse_y() {
    return display_mouse_get_y() - window_get_y();
}

/// @desc This function returns a boolean if you double-click the mouse.
/// @param {constant.mousebutton} button Description
/// @returns {bool} Description
function mouse_check_doubleclick_pressed(button) {
	static _time = 500; //ms
	static _once = false;
	static _delta = 0;
	var _pressed = false;
	if mouse_check_button_pressed(button) {
		if (!_once) {
			_delta = current_time;
			_once = true;
		} else {
			if (current_time - _delta < _time) {
				_pressed = true;
			}
			_once = false;
			_delta = 0;
		}
	}
	return _pressed;
}


#region 3D

// vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
global.__tgm_vbf_3d_format = vertex_format_end();

/// @func vertex_add_point(vbuff, xx, yy, zz, nx, ny, nz, u, v, color, alpha)
function vertex_add_point(vbuff, xx, yy, zz, nx, ny, nz, u, v, color, alpha) {
	gml_pragma("forceinline");
	vertex_position_3d(vbuff, xx, yy, zz);
	vertex_normal(vbuff, nx, ny, nz);
	vertex_texcoord(vbuff, u, v);
	vertex_color(vbuff, color, alpha);
}


function model_build_plane(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, color=c_white, alpha=1) {
	var _vbuff = vertex_create_buffer();
	
	vertex_begin(_vbuff, global.__tgm_vbf_3d_format);
	vertex_add_point(_vbuff, x1, y1, z1, 0, 0, 1, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	vertex_end(_vbuff);
	
	vertex_freeze(_vbuff);
	return _vbuff;
}


function model_build_cube(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, color=c_white, alpha=1) {
	var _vbuff = vertex_create_buffer();
	
	vertex_begin(_vbuff, global.__tgm_vbf_3d_format);
	
	// top
	vertex_add_point(_vbuff, x1, y1, z2, 0, 0, 1, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	// bottom
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, 0, 0, -1, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	
	// front
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, 0, 1, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	
	// back
	vertex_add_point(_vbuff, x1, y1, z1, 0, -1, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, -1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	// right
	vertex_add_point(_vbuff, x2, y1, z1, 1, 0, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	// left
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, -1, 0, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	
	// finalize VBO
	vertex_end(_vbuff);
	vertex_freeze(_vbuff);
	return _vbuff;
}

//function model_build_ellipsoid(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, steps, color=c_white, alpha=1) {
//	steps = clamp(steps, 3, 128);
	
//	var _vbuff = vertex_create_buffer();
//	var _cc;
//	var _ss;
//	_cc[steps] = 0;
//	_ss[steps] = 0;
	
//	var i;
//	for(i = 0; i <= steps; i++) {
//		var __rad = (i * 2.0 * pi) / steps;
//		_cc[i] = cos(__rad);
//		_ss[i] = sin(__rad);
//	}
	
//	var _mx = (x2 + x1) / 2,
//	_my = (y2 + y1) / 2,
//	_mz = (z2 + z1) / 2,
//	_rx = (x2 - x1) / 2,
//	_ry = (y2 - y1) / 2,
//	_rz = (z2 - z1) / 2,
//	_rows = (steps+1)/2, j;
	
//	for(j = 0; j <= (_rows - 1); j++) {
//		var __row1rad = (j*pi)/_rows;
//		var __row2rad = ((j+1)*pi)/_rows;
//		var __rh1 = cos(__row1rad);
//		var __rd1 = sin(__row1rad);
//		var __rh2 = cos(__row2rad);
//		var __rd2 = sin(__row2rad);
	
//		vertex_begin(_vbuff, global.vf_default);
//		for(i = 0; i <= steps; i++) {
//			vertex_add_point(_vbuff, _mx+_rx*__rd1*_cc[i], _my+_ry*__rd1*_ss[i], _mz+_rz*__rh1,__rd1*_cc[i], __rd1*_ss[i], __rh1, hrepeat*i/steps, j*vrepeat/_rows, color, alpha);
//			vertex_add_point(_vbuff, _mx+_rx*__rd2*_cc[i], _my+_ry*__rd2*_ss[i], _mz+_rz*__rh2,__rd2*_cc[i], __rd2*_ss[i], __rh2, hrepeat*i/steps, (j+1)*vrepeat/_rows, color, alpha);
//		}
//		vertex_end(_vbuff);
//	}
//	return _vbuff;
//}

//global.__vbf_debug = vertex_create_buffer();

//vertex_format_begin();
//vertex_format_add_position_3d();
//vertex_format_add_color();
//global.vbf_default_format = vertex_format_end();


//function draw_line_3d(x1, y1, z1, x2, y2, z2) {
//	var _vbf_line = global.__vbf_debug;
//	vertex_begin(_vbf_line, global.vbf_default_format);
	
//	vertex_position_3d(_vbf_line, x1, y1, z1);
//	vertex_color(_vbf_line, c_white, 1);
	
//	vertex_position_3d(_vbf_line, x2, y2, z2);
//	vertex_color(_vbf_line, c_white, 1);
	
//	vertex_end(_vbf_line);
//}

#endregion
