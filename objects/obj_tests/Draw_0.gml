
//var _val = floor(gui_mouse_x_normalized*1000);
//draw_text(10, 50, _val);
//draw_text(10, 80, inverse_sqrt(_val));



/*var _numbber = floor(gui_mouse_x_normalized*100);
draw_text(10, 80, _numbber);
draw_text(10, 100, is_odd_number(_numbber));


draw_debug_button(40, 40, "TEST");

draw_debug_slider(40, 100, 200, "Test", 0.5, -5, 5);*/


//var _a = smoothstep(0, 255, gui_mouse_x_normalized*255); // returns 0 - 1
//var _b = linearstep(0, 255, gui_mouse_x_normalized*255); // returns 0 - 1
//var _c = lerp(0, 255, gui_mouse_x_normalized); // returns 0 - 255
//var _d = step(0.5, gui_mouse_x_normalized); // returns 0 or 1
//var _e = relerp(0, 1, gui_mouse_x_normalized, 0, room_width); // returns 0 - 255

//draw_text(10, 200, _a);
//draw_text(10, 220, _b);
//draw_text(10, 240, _c);
//draw_text(10, 260, _d);
//draw_text(10, 280, _e);

//draw_circle(room_width*_a, 200+10, 8, true);
//draw_circle(room_width*_b, 220+10, 8, true);
//draw_circle(room_width*(_c/255), 240+10, 8, true);
//draw_circle(room_width*_d, 260+10, 8, true);
//draw_circle(_e, 280+10, 8, true);


/*var _xx = 400;
var _yy = 180;
var _size = 256;
for (var i = 0; i < _size; i+=GoldenAngle) {
	var dist = relerp(0, _size, i, 4, 200*gui_mouse_x_normalized);
	draw_circle(_xx+(cos(i)*dist), _yy-(sin(i)*dist), relerp(0, _size, i, 3, 6), true);
}*/



//draw_set_color(c_white);
//var sc = gui_mouse_x_normalized * 30;
//draw_text_transformed_shadow(100, 100, "TESTTT", sc, sc, 0, c_black, 0.6);

//draw_text_outline(300, 300, "TESTTTT", c_black, 1, gui_mouse_y_normalized*5, floor(gui_mouse_x_normalized*64));
//draw_text_outline_gradient(300, 300, "TESTTTT", c_red, c_yellow, c_lime, c_purple, 1, gui_mouse_y_normalized*5, floor(gui_mouse_x_normalized*64));



/*
draw_path(Path1, 0, 0, true);
var _pos = path_get_nearest_point_position(mouse_x, mouse_y, Path1);
draw_circle(_pos.x, _pos.y, 4, true);


_pos = path_get_nearest_position(mouse_x, mouse_y, Path1);
draw_circle(path_get_x(Path1, _pos), path_get_y(Path1, _pos), 4, true);
*/

// raycasting
/*
draw_set_color(c_yellow);
var _point = raycast_hit_object_2d(mouse_x, mouse_y, all, angle, dist, true, true, 1);
//var _point = raycast_hit_tag_object_2d(mouse_x, mouse_y, "raycast", true, angle, dist, true, 1);

if (_point != noone) {
	draw_circle(_point.x, _point.y, 5, true);
}

draw_set_color(c_white);
draw_line_vector(mouse_x, mouse_y, angle, dist);
*/


/*
for (var xx = 0; xx < array_length(array); ++xx) {
	for (var yy = 0; yy < array_length(array[xx]); ++yy) {
		for (var zz = 0; zz < array_length(array[xx][yy]); ++zz) {
			var _x = 32 + xx*32 + zz*300;
			var _y = 32 + yy*32;
			draw_text(_x, _y, array[xx][yy][zz]);
		}
	}
}*/


/*for (var xx = 0; xx < array_length(array); ++xx) {
	for (var yy = 0; yy < array_length(array[xx]); ++yy) {
		var _x = 32 + xx*32;
		var _y = 32 + yy*32;
		draw_text(_x, _y, array[xx][yy]);
	}
}*/




//
/*
#region TESTS
var mx = mouse_x/room_width;

angle2 += 2;
angle2 = clamp_wrap(angle2, 0, 360);
draw_text(10, 10, angle2);


var _x1 = 300;
var _y1 = 300;
var _x2 = mouse_x;
var _y2 = mouse_y;
draw_line(_x1, _y1, _x2, _y2);
var _rot = point_direction(_x1, _y1, _x2, _y2);
draw_sprite(spr_player, angle_get_subimg(_rot, 15), 200, 200);

// smooth rot
angle_slow = lerp(angle_slow, angle_towards(angle, _rot, 5), 0.2);
angle -= angle_slow;



draw_sprite_ext(spr_player, 0, 300, 200, 1, 1, angle, c_white, 1);




angle3 = lerp_angle(angle3, _rot, 0.2);
draw_sprite_ext(spr_player, 0, 350, 200, 1, 1, angle3, c_white, 1);


draw_text(10, 80, distance(30, 50));

draw_text(10, 120, string_zeros(125, 10));



//draw_sprite_centered(Sprite2, 0, room_width/2, room_height/2);
//draw_sprite_centered_ext(Sprite2, 0, room_width/2, room_height/2, mx, mx, 0, c_white, 1);

#endregion
*/

/*

angle4 += 0.1;
draw_cone(room_width/2, room_height/2, angle4, 100, 45);
var _dist = point_in_arc(mouse_x, mouse_y, room_width/2, room_height/2, angle4, 100, 45); //point_in_cone(mouse_x, mouse_y, room_width/2, room_height/2, angle4, 100, 35);
draw_text(10, 150, _dist);
draw_text(10, 200, point_direction_normalized(room_width/2, room_height/2, mouse_x, mouse_y));



var transform = new Vector2(mouse_x, mouse_y);

//transform = transform.multiply(new Vector2_Down.negate());
transform = transform.snapped(new Vector2(16, 16)).clampedMagnitude(300);

draw_line(0, 0, transform.x, transform.y);

draw_text(10, 300, transform);



var value = relerp(0, 1, gui_mouse_x_normalized, 50, 100);

draw_text(10, 100, value);

*/


/*var dir = point_direction(150, 150, mouse_x, mouse_y);
var aa = point_direction_radians_vec2(150, 150, mouse_x, mouse_y);
*/

//var a = -point_direction_radians(150, 150, mouse_x, mouse_y);

//var a = degtorad();

//var _matrix = [
////  x  y  z  w     
//	cos(a)*scale_x, -sin(a)*scale_y, 0, 0,
//    sin(a)*scale_x, cos(a)*scale_y, 0, 0,
//	0, 0, 1, 0,
//	150, 150, 0, 1,
//];


//matrix_set(matrix_world, _matrix);

//draw_sprite(Sprite3, 0, 0, 0);

//matrix_set(matrix_world, matrix_build_identity());








//draw_sprite_pos_persp(Sprite7, 0, obj_b1.x, obj_b1.y, obj_b2.x, obj_b2.y, obj_b3.x, obj_b3.y, obj_b4.x, obj_b4.y, 1);


//draw_texture_quad(sprite_get_texture(Sprite7, 0), obj_b1.x, obj_b1.y, obj_b2.x, obj_b2.y, obj_b3.x, obj_b3.y, obj_b4.x, obj_b4.y, 100);


//var x1 = 50;
//var y1 = 50;
//var x2 = mouse_x;
//var y2 = mouse_y;
//var ww = x2 - x1;
//var hh = y2 - y1;

//draw_rectangle(x1, y1, x2, y2, true);
//var size = aspect_ratio_maintain(ww, hh, 480, 270);

//draw_sprite_stretched(Sprite9, 0, x1, y1, size.x, size.y);



