
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
