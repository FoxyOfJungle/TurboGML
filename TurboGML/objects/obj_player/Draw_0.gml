//
draw_self();

var _dir = point_direction(x, y, mouse_x, mouse_y);
var _dist = 300;


//draw_line_vector(x, y, _dir, _dist);

var _col = raycast_hit_point_2d(x, y, all, _dir, _dist);
//var _col = raycast_tag_hit_point_2d(x, y, "raycast", true, _dir, _dist);
if (_col.z != noone) {
	draw_circle(_col.x, _col.y, 4, true);
	draw_circle(_col.z.x, _col.z.y, 4, true);
}


if keyboard_check_pressed(ord("H")) {
	instance_create_layer(0, 0, "Instances", obj_child);
}