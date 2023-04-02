//
draw_self();
/*
var _dir = point_direction(x, y, mouse_x, mouse_y);
var _dist = 300;


draw_line_vector(x, y, _dir, _dist);

var _col = raycast_hit_point_2d(x, y, all, _dir, _dist);
//var _col = raycast_tag_hit_point_2d(x, y, "raycast", true, _dir, _dist);
if (_col.z != noone) {
	draw_circle(_col.x, _col.y, 4, true);
	draw_circle(_col.z.x, _col.z.y, 4, true);
}




var x1 = 50;
var y1 = 50;
var x2 = mouse_x;
var y2 = mouse_y;
var ww = x2 - x1;
var hh = y2 - y1;

draw_rectangle(x1, y1, x2, y2, true);
var size = aspect_ratio_maintain(ww, hh, 480, 270);

draw_sprite_stretched(Sprite9, 0, x1, y1, size.x, size.y);



//show_debug_message(size);
