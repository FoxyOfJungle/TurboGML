
draw_text(100, 170, string_limit("the quick brown fox jumps over the lazy dog", mouse_x));

//draw_cone(150, 150, tankAngle, 32, 90);
//draw_line_vector(150, 150, turretAngle, 64);


time += 1;
yup = wave_period(time, 10*60, 50);

draw_circle(80, 100, 8, true);
draw_circle(80, 100+yup, 32, true);



draw_line(30, 30, 300, 50);

var _dist = distance_to_line(mouse_x, mouse_y, 30, 30, 300, 50);

draw_text(300, 30, _dist);




//var _deltaSpeed = 1 / 60;
//var _dt = (delta_time / 1000000) / _deltaSpeed; //
var _dt = 60 / game_get_speed(gamespeed_fps); // I know this is not the way to do it

draw_circle(room_width/2, room_height/2, 8, true);
var _dir = point_direction(room_width/2, room_height/2, mouse_x, mouse_y);

angle1 = lerp(angle1, _dir, 0.1);
angle2 = lerp_angle(angle2, _dir, 0.1);

//angle2 = lerp_dt(angle2, _dir, 0.1, _dt);
angle3 = lerp_angle(angle3, _dir, 0.1);
angle4 = lerp_angle_dt(angle3, _dir, 0.1, _dt);
angle5 = approach(angle5, _dir, 3 * _dt)
angle6 = approach_angle(angle6, _dir, 3 * _dt);

var _yy = 100;
draw_line_vector(150, _yy, angle1, 32);
_yy += 40;
draw_line_vector(150, _yy, angle2, 32);
_yy += 40;
draw_line_vector(150, _yy, angle3, 32);
_yy += 40;
draw_line_vector(150, _yy, angle4, 32);
_yy += 80;
draw_line_vector(150, _yy, angle5, 32);
_yy += 40;
draw_line_vector(150, _yy, angle6, 32);

draw_sprite_ext(sprPlayer, angle_get_portion(angle2, 16), 200, 300, 1, 1, 0, c_white, 1);


//var test = 4_103_200 * gui_mouse_x_normalized;

//draw_text(10, 100, string_currency_prettify(test));
//draw_text(10, 120, dollars_to_string(test));


/*
var testX = mouse_x/room_width;

//draw_circle_width(mouse_x, mouse_y, 32, 64, 32, floor(testX*12));

var _a = smoothstep(0, 255, testX*255); // returns 0 - 1
var _b = linearstep(0, 255, testX*255); // returns 0 - 1
var _c = lerp(0, 255, testX); // returns 0 - 255
var _d = step(0.5, testX); // returns 0 or 1
var _e = relerp(0, 1, testX, 0, room_width); // returns 0 - 255

draw_text(10, 200, _a);
draw_text(10, 220, _b);
draw_text(10, 240, _c);
draw_text(10, 260, _d);
draw_text(10, 280, _e);

draw_circle(room_width*_a, 200+10, 8, true);
draw_circle(room_width*_b, 220+10, 8, true);
draw_circle(room_width*(_c/255), 240+10, 8, true);
draw_circle(room_width*_d, 260+10, 8, true);
draw_circle(_e, 280+10, 8, true);
*/



//var _x1 = 300;
//var _y1 = 300;
//var _x2 = mouse_x;
//var _y2 = mouse_y;
//draw_line(_x1, _y1, _x2, _y2);
//var _rot = point_direction(_x1, _y1, _x2, _y2);

//angle3 = lerp_angle(angle3, _rot, 0.2);
//draw_sprite_ext(spr_player, 0, 350, 200, 1, 1, angle3, c_white, 1);



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

//var mx = mouse_x/room_width;


//var _x1 = 400;
//var _y1 = 300;
//var _x2 = mouse_x;
//var _y2 = mouse_y;
//draw_line(_x1, _y1, _x2, _y2);
//var _rot = point_direction(_x1, _y1, _x2, _y2);
//draw_sprite(spr_player, angle_get_subimg(_rot, 15), 200, 200);

// smooth rot
//angle_slow = lerp(angle_slow, angle_towards(angle, _rot, 5), 0.3);
//angle -= angle_slow;

// linear angle
//angle -= angle_towards(angle, _rot, 5);

//draw_sprite_ext(spr_player, 0, _x1, _y1, 1, 1, angle, c_white, 1);



//angle4 += 0.1;
//draw_cone(room_width/2, room_height/2, angle4, 100, 45);
//var _dist = point_in_arc(mouse_x, mouse_y, room_width/2, room_height/2, angle4, 100, 45); //point_in_cone(mouse_x, mouse_y, room_width/2, room_height/2, angle4, 100, 35);
//draw_text(10, 150, _dist);
//draw_text(10, 200, point_direction_normalized(room_width/2, room_height/2, mouse_x, mouse_y));



//var transform = new Vector2(mouse_x, mouse_y);

//transform = transform.multiply(new Vector2_Down.negate());
//transform = transform.snapped(new Vector2(16, 16)).clampedMagnitude(300);
//transform = transform.clamped_magnitude(300);
//transform.Set(150, 150);

//draw_line(0, 0, transform.x, transform.y);

//draw_text(10, 300, transform);




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

