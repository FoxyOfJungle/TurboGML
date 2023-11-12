//

//if (can_rotate) image_angle -= spd;

//Spring Scale Animation
x_scale_spd = lerp(x_scale_spd, (1 - x_scale) * 0.5, 0.01);
y_scale_spd = lerp(y_scale_spd, (1 - y_scale) * 0.5, 0.01);

//Apply Spring Animation
x_scale += x_scale_spd * DELTA_TIME;
y_scale += y_scale_spd * DELTA_TIME;

