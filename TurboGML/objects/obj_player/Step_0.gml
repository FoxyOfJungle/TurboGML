
input_h = keyboard_check(vk_right) - keyboard_check(vk_left);
input_v = keyboard_check(vk_down) - keyboard_check(vk_up);
input_dir = point_direction(0, 0, input_h, input_v);

if (abs(input_h)) {
	hsp += move_speed_acceleration * input_h;
} else {
	hsp = approach(hsp, 0, move_speed_friction);
}

vsp += grav;

/*if (abs(input_v)) {
	vsp += move_speed_acceleration * input_v;
} else {
	vsp = approach(vsp, 0, move_speed_friction);
}*/

hsp = clamp(hsp, -move_speed, move_speed);
vsp = clamp(vsp, -fall_speed, fall_speed);

if (keyboard_check_pressed(vk_up)) vsp = -14;

var _col = move_and_collide_simple(hsp, vsp, obj_solid); // using objects
//var _col = move_and_collide_simple_tag(hsp, vsp, "ground"); // using object tags
if (_col.z != noone) {
	if (_col.x) hsp = 0;
	if (_col.y) vsp = 0;
}

//show_debug_message(_col);
