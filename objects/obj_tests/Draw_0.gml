
//
#region TESTS
var mx = mouse_x/room_width;

angle2 += 2;
angle2 = clamp_loop(angle2, 0, 360);
draw_text(10, 10, angle2);


var _x1 = 300;
var _y1 = 300;
var _x2 = mouse_x;
var _y2 = mouse_y;
draw_line(_x1, _y1, _x2, _y2);
var _rot = point_direction(_x1, _y1, _x2, _y2);
draw_sprite(spr_penguin, angle_get_subimg(_rot, 15), 200, 200);

// smooth rot
angle_slow = lerp(angle_slow, angle_towards(angle, _rot, 5), 0.2);
angle -= angle_slow;



draw_sprite_ext(spr_penguin, 0, 300, 200, 1, 1, angle, c_white, 1);




angle3 = lerp_angle(angle3, _rot, 0.2);
draw_sprite_ext(spr_penguin, 0, 350, 200, 1, 1, angle3, c_white, 1);


draw_text(10, 80, distance(30, 50));

draw_text(10, 120, string_zeros(125, 10));



//draw_sprite_centered(Sprite2, 0, room_width/2, room_height/2);
//draw_sprite_centered_ext(Sprite2, 0, room_width/2, room_height/2, mx, mx, 0, c_white, 1);

#endregion

draw_text(400, 20, gui_mouse_x_delta);
draw_text(400, 40, gui_mouse_y_delta);
draw_text(400, 60, DELTA_TIME);


angle4 += 0.1;
draw_cone(room_width/2, room_height/2, angle4, 100, 35);
draw_text(10, 150, point_in_cone(mouse_x, mouse_y, room_width/2, room_height/2, angle4, 100, 35));


draw_sprite_pos_persp(Sprite7, 0, obj_b1.x, obj_b1.y, obj_b2.x, obj_b2.y, obj_b3.x, obj_b3.y, obj_b4.x, obj_b4.y, 1);



transform = new Vector2(mouse_x, mouse_y);

//transform = transform.multiply(new Vector2_Down.negate());
transform = transform.snapped(new Vector2(16, 16)).clampedMagnitude(300);

draw_line(0, 0, transform.x, transform.y);

draw_text(10, 300, transform);


