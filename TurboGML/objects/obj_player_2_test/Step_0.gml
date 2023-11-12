
//

input_h = keyboard_check(vk_right) - keyboard_check(vk_left);
input_v = keyboard_check(vk_down) - keyboard_check(vk_up);
input_dir = point_direction(0, 0, input_h, input_v);
facing_dir = point_direction(x, y, mouse_x, mouse_y);


if (abs(input_v)) {
	move_speed -= move_speed_acceleration * input_v;
} else {
	move_speed = approach(move_speed, 0, move_speed_friction);
}
hsp = lengthdir_x(move_speed, facing_dir);
vsp = lengthdir_y(move_speed, facing_dir);


move_speed = clamp(move_speed, -backward_speed, forward_speed);


x += hsp;
y += vsp;
image_angle = facing_dir;












/*
time += 0.1 * DELTA_TIME;

if mouse_check_button_pressed(mb_left) {
	// create enemy
	instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
	
	
	// create bullet towards enemy direction
	_enemy = instance_nearest(x, y, obj_enemy);
	
	_bullet = instance_create_layer(x, y, "Instances", obj_bullet);
	_bullet.direction = angle_predict_intersection(x, y, _enemy.x, _enemy.y, _enemy.speed, _enemy.direction, 1);
	_bullet.speed = 1;
	
	
	// calculate intersection position
	//var _pos = motion_predict_intersection(x, y, _enemy.x, _enemy.y, _enemy.hspeed, _enemy.vspeed);
	var _pos = motion_predict_intersection(x, y, _enemy.x, _enemy.y, _enemy.speed, _enemy.direction, 1);
	//var _pos = motion_predict_intersection(x, y, _enemy.x, _enemy.y);
	target_x = _pos.x;
	target_y = _pos.y;
}*/

//if keyboard_check_pressed(vk_space) {
//	instance_destroy(obj_enemy);
//}

/*
var uni_test = shader_get_uniform(__tgm_sh_quad_persp, "u_hsv");


DEBUG_SPEED_INIT

var color = [0.22, 0.7, 0.44];

repeat(9999) {
	shader_set_uniform_f_array(uni_test, color);
}


DEBUG_SPEED_GET


// 1.03
// 1.82
// 0.72
*/










