
/// Feather ignore all

#region SHAPES

/// @desc Draws a primitive circle, with width.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} inner The circle inner.
/// @param {real} outer The circle outer.
/// @param {real} segments Amout of segments.
/// @param {real} seg_start Initial segment
function draw_circle_width(x, y, inner, outer, segments, seg_start=0) {
	draw_primitive_begin(pr_trianglestrip);
	var i = seg_start, dir, dx, dy;
	repeat(segments + 1) {
		dir = (i / segments) * Tau;
		dx = cos(dir);
		dy = sin(dir);
		draw_vertex(x + dx*inner, y - dy*inner);
		draw_vertex(x + dx*outer, y - dy*outer);
		i++;
	}
	draw_primitive_end();
}

/// @desc Draws a line with direction. Useful for debugging.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} angle The line angle.
/// @param {real} distance The line distance.
function draw_line_vector(x1, y1, angle, distance) {
	var _a = degtorad(angle);
	draw_line(x1, y1, x1+cos(_a)*distance, y1-sin(_a)*distance);
}

/// @desc Draws a quad of lines. Useful for debugging.
/// @param {real} x1 The first point x position.
/// @param {real} y1 The first point y position.
/// @param {real} x2 The second point x position.
/// @param {real} y2 The second point y position.
/// @param {real} x3 The third point x position.
/// @param {real} y3 The third point y position.
/// @param {real} x4 The fourth point x position.
/// @param {real} y4 The fourth point y position.
/// @param {bool} middle_line Enable middle line drawing.
function draw_line_quad(x1, y1, x2, y2, x3, y3, x4, y4, middle_line=false) {
	// p1--p2
	// |    |
	// p4--p3
	draw_line(x1, y1, x2, y2);
	draw_line(x1, y1, x4, y4);
	draw_line(x4, y4, x3, y3);
	draw_line(x2, y2, x3, y3);
	if (middle_line) draw_line(x1, y1, x3, y3);
}

/// @desc Draws a cone with field of view.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} angle The cone angle.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
function draw_cone(x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist,
		_len_y1 = dsin(angle - fov/2) * dist,
		_len_x2 = dcos(angle + fov/2) * dist,
		_len_y2 = dsin(angle + fov/2) * dist;
	draw_line(x, y, x+_len_x1, y-_len_y1);
	draw_line(x, y, x+_len_x2, y-_len_y2);
	draw_line(x+_len_x1, y-_len_y1, x+_len_x2, y-_len_y2);
}

#endregion

#region 2D GRAPHICS (Nine Slices, Sprites, Surfaces)

function draw_nineslice_stretched_ext(sprite, subimg, x, y, width, height, xscale, yscale, rot, col, alpha) {
	draw_sprite_ext(sprite, subimg, x, y, (width/sprite_get_width(sprite))*xscale, (height/sprite_get_height(sprite))*yscale, rot, col, alpha);
}


// useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw centered.
function draw_sprite_centered(sprite, subimg, x, y) {
	draw_sprite(sprite, subimg, x-sprite_get_width(sprite)/2, y-sprite_get_height(sprite)/2);
}


// useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw centered and scaled.
function draw_sprite_centered_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha) {
	draw_sprite_ext(sprite, subimg, x-(sprite_get_width(sprite)/2)*xscale, y-(sprite_get_height(sprite)/2)*yscale, xscale, yscale, rot, col, alpha);
}


function draw_surface_centered(surface_id, x, y) {
	draw_surface(surface_id, x-(surface_get_width(surface_id)/2), y-(surface_get_height(surface_id)/2));
}


function draw_surface_centered_ext(surface_id, x, y, xscale, yscale, rot, col, alpha) {
	//draw_surface_ext(surface_id, x-(surface_get_width(surface_id)/2)*xscale, y-(surface_get_height(surface_id)/2)*yscale, xscale, yscale, rot, col, alpha);
	var _col = draw_get_color(),
	_alpha = draw_get_alpha(),
	_mat = matrix_get(matrix_world);
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, rot, xscale, yscale, 1));
	draw_set_color(col);
	draw_set_alpha(alpha);
	draw_surface(surface_id, -surface_get_width(surface_id)/2, -surface_get_height(surface_id)/2);
	draw_set_color(_col);
	draw_set_alpha(_alpha);
	matrix_set(matrix_world, _mat);
}


// useful for grass wave effects
function draw_sprite_pos_ext(sprite, subimg, x, y, width, height, xoffset, yoffset, xscale, yscale, skew_x, skew_y, angle, alpha) {
	matrix_stack_push(matrix_world);
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, angle, xscale, yscale, 1));
	var xo = -xoffset, yo = -yoffset;
	draw_sprite_pos(sprite_index, subimg, xo+skew_x, yo+skew_y, width+xo+skew_x, yo+skew_y, width+xo, height+yo, xo, height+yo, alpha);
	matrix_stack_pop();
}

function draw_texture_quad(texture_id, x1, y1, x2, y2, x3, y3, x4, y4, precision=50) {
	// p1--p2
	// |    |
	// p4--p3
	// original by: icuurd12b42
	var w1xs = (x1-x2) / precision,
	w1ys = (y1-y2) / precision,
	w2xs = (x4-x3) / precision,
	w2ys = (y4-y3) / precision,
	w1xat = x1,
	w1yat = y1,
	w2xat = x4,
	w2yat = y4,
	us = 1 / precision,
	uat = 1;
	draw_primitive_begin_texture(pr_trianglestrip, texture_id);
	repeat(precision+1) {
	    draw_vertex_texture(w1xat, w1yat, uat, 0);
	    draw_vertex_texture(w2xat, w2yat, uat, 1);
	    uat -= us;
	    w1xat -= w1xs;
	    w1yat -= w1ys;
	    w2xat -= w2xs;
	    w2yat -= w2ys;
	}
	draw_primitive_end();
}

#endregion

#region TEXT

function draw_text_shadow(x, y, str, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text(x+shadow_dist_x, y+shadow_dist_y, str);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text(x, y, str);
}


function draw_text_ext_shadow(x, y, str, sep, width, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text_ext(x+shadow_dist_x, y+shadow_dist_y, str, sep, width);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text_ext(x, y, str, sep, width);
}


function draw_text_outline(x, y, str, outline_color=c_black, outline_alpha=1, outline_size=1, fidelity=4) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(outline_color);
	draw_set_alpha(outline_alpha);
	var _fid = Tau / fidelity,
	for(var i = 0; i < Tau; i += _fid) {
		draw_text(x+cos(i)*outline_size, y-sin(i)*outline_size, str);
	}
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text(x, y, str);
}


function draw_text_outline_gradient(x, y, str, outline_color1=c_black, outline_color2=c_black, outline_color3=c_black, outline_color4=c_black, outline_alpha=1, outline_size=1, fidelity=4) {
	var _fid = Tau / fidelity,
	for(var i = 0; i < Tau; i += _fid) {
		draw_text_color(x+cos(i)*outline_size, y-sin(i)*outline_size, str, outline_color1, outline_color2, outline_color3, outline_color4, outline_alpha);
	}
	draw_text(x, y, str);
}


function draw_text_transformed_shadow(x, y, str, xscale, yscale, angle, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text_transformed(x+(shadow_dist_x*xscale), y+(shadow_dist_y*xscale), str, xscale, yscale, angle);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text_transformed(x, y, str, xscale, yscale, angle);
}


function draw_text_wave(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}


function draw_text_wave_colorful(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv(current_time*color_speed % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}


function draw_text_wave_rainbow(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv((current_time * color_speed + i*10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}


function draw_text_rainbow(x, y, str, str_width, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv((current_time * color_speed + i*10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy, _char);
		_xx += _ww;
		i++;
	}
}


function draw_text_shake(x, y, str, str_width, dist=1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_text(_xx-_wf + random_range(-dist, dist), _yy + random_range(-dist, dist), _char);
		_xx += _ww;
		i++;
	}
}

#endregion

#region BLENDING

function gpu_set_blendmode_test(index, debug_info=false) {
	// Feather disable GM1044
	// final_pixel_colour =  (Rs,Gs,Bs,As) * source_blend_factor + (Rd,Gd,Bd,Ad) * destination_blend_factor
	// s = source | d = destination
	// there are 14641 possible extended blendmode combinations
	/*
	[0] bm_normal
	[1] bm_add
	[2] bm_max
	[3] bm_subtract
	
	[1] bm_zero
	[2] bm_one
	[3] bm_src_color
	[4] bm_inv_src_color
	[5] bm_src_alpha
	[6] bm_inv_src_alpha
	[7] bm_dest_alpha
	[8] bm_inv_dest_alpha
	[9] bm_dest_color
	[10] bm_inv_dest_color
	[11] bm_src_alpha_sat
	*/
	static __type0 = function(val) {
		switch(val) {
			case 0: return "bm_normal" break;
			case 1: return "bm_add" break;
			case 2: return "bm_max" break;
			case 3: return "bm_subtract" break;
			default: return "N/A" break;
		}
		return val;
	}
	static __type1 = function(val) {
		switch(val) {
			case 1: return "bm_zero" break;
			case 2: return "bm_one" break;
			case 3: return "bm_src_color" break;
			case 4: return "bm_inv_src_color" break;
			case 5: return "bm_src_alpha" break;
			case 6: return "bm_inv_src_alpha" break;
			case 7: return "bm_dest_alpha" break;
			case 8: return "bm_inv_dest_alpha" break;
			case 9: return "bm_dest_color" break;
			case 10: return "bm_inv_dest_color" break;
			case 11: return "bm_src_alpha_sat" break;
			default: return "N/A" break;
		}
		return val;
	}
	var _type = "",
	_current = 0,
	_max = 5,
	
	// default blendmode
	_bm1 = bm_src_alpha,
	_bm2 = bm_inv_src_alpha,
	_bm3 = bm_src_alpha,
	_bm4 = bm_one;
	
	// no blendmode
	if (index < 0) {
		gpu_set_blendenable(false);
		_type = "DISABLED BLENDING";
		_current = -1;
		_max = -1;
		_bm1 = -1;
		_bm2 = -1;
		_bm3 = -1;
		_bm4 = -1;
	}
	
	// most used blendmodes
	if (index == 0) {
		// default blendmode
		gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
		_type = "Default";
		_current = 0;
	} else
	if (index == 1) {
		// premultiply alpha (needs a shader)
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		_type = "Premultiply Alpha";
		_current = 1;
	} else
	if (index == 2) {
		// add blendmode
		gpu_set_blendmode_ext(bm_src_alpha, bm_one);
		_type = "Add";
		_current = 2;
	} else
	if (index == 3) {
		// multiply blendmode
		gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha); // or bm_zero in B
		_type = "Multiply";
		_current = 3;
	} else
	if (index == 4) {
		// subtract blendmode
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_color); // or bm_zero in B
		_type = "Subtract";
		_current = 4;
	} else
	if (index == 5) {
		// invert blendmode
		gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_color); // the alpha also is affected: RGBA
		_type = "Invert";
		_current = 5;
	} else
	if (index >= 6 && index <= 9) {
		var _ind = index-6;
		gpu_set_blendmode(_ind); // bm_normal, bm_add, bm_max, bm_subtract
		_type = __type0(_ind);
		_current = _ind;
		_max = 3;
	} else
	if (index >= 10) {
		// all blendmodes
		var _ind = index;
		_current = index-10;
		_max = 14641;
		
		var p = 11;
		_bm1 = 1 + (_ind % p);
		_bm2 = 1 + ((_ind div p) % p);
		_bm3 = 1 + ((_ind div (p*p)) % p);
		_bm4 = 1 + ((_ind div (p*p*p)) % p);
		
		_type = string_join_ext(", ", [__type1(_bm1), __type1(_bm2), __type1(_bm3), __type1(_bm4)]);
		gpu_set_blendmode_ext_sepalpha(_bm1, _bm2, _bm3, _bm4);
	}
	
	var _info = string(index) + " | " + string(_current) + " / " + string(_max) + " (" + _type + ");";
	if (debug_info) show_debug_message(_info);
	return _info;
}

#endregion

#region COLORS

function color_gradient(colors_array, progress) {
	var _len = array_length(colors_array)-1;
	var _prog = clamp(progress, 0, 1) * _len;
	return merge_color(colors_array[floor(_prog)], colors_array[ceil(_prog)], frac(_prog));
}

function make_color_shader(color) {
	return [color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255];
}

function make_color_rgba_shader(color, alpha) {
	return [color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255, alpha];
}

#endregion
