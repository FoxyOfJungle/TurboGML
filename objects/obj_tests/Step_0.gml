
if keyboard_check_pressed(vk_escape) game_end();


if keyboard_check(ord("U")) DELTA_TIME_SCALE -= 0.02;
if keyboard_check(ord("I")) DELTA_TIME_SCALE += 0.02;


/*var x1, y1, x2, y2;
x1 = lengthdir_x(1, image_angle);
y1 = lengthdir_y(1, image_angle);
x2 = o_Player.x - x;
y2 = o_Player.y - y;
if dot_product(x1, y1, x2, y2) > 0 seen=true else seen=false;
*/
