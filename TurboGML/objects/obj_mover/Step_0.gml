
//
if (mouse_check_button(mb_left)) {
	if position_meeting(mouse_x, mouse_y, id) {
		moving = true;
	}
} else {
	moving = false;
}

if (moving) {
	x += mouse_x_delta;
	y += mouse_y_delta;
}
