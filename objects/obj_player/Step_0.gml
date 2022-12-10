
//

input_h = keyboard_check(vk_right) - keyboard_check(vk_left);
input_v = keyboard_check(vk_down) - keyboard_check(vk_up);
input_dir = point_direction(0, 0, input_h, input_v);

if abs(input_h) {
	x += lengthdir_x(spd*DELTA_TIME, input_dir);
}
if abs(input_v) {
	y += lengthdir_y(spd*DELTA_TIME, input_dir);
}


time += 0.1 * DELTA_TIME;

/*if mouse_check_button_pressed(mb_left) {
	instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
}


if mouse_check_button(mb_right) {
	var _enemy = instance_nearest(x, y, obj_enemy);
	
	var _bullet = instance_create_layer(x, y, "Instances", obj_bullet);
	_bullet.direction = angle_predict_intercession(id.x, id.y, _enemy.x, _enemy.y, _enemy.speed, _enemy.direction, 5);
	_bullet.speed = 5;
}*/

//image_angle += 1;
