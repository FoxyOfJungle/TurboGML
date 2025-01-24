
/// Feather ignore all

#region SHAPES

/// @desc Draws a primitive circle, with width.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} inner The circle inner.
/// @param {real} outer The circle outer.
/// @param {real} segments Amout of segments.
/// @param {real} segStart Initial segment
function draw_circle_width(_x, _y, _inner, _outer, _segments, _segStart=0) {
    draw_primitive_begin(pr_trianglestrip);
    var i = _segStart, _dir, _dx, _dy;
    repeat(_segments + 1) {
        _dir = (i / _segments) * Tau;
        _dx = cos(_dir);
        _dy = sin(_dir);
        draw_vertex(_x + _dx * _inner, _y - _dy * _inner);
        draw_vertex(_x + _dx * _outer, _y - _dy * _outer);
        i++;
    }
    draw_primitive_end();
}

/// @desc Draws a line with direction. Useful for debugging.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} angle The line angle.
/// @param {real} distance The line distance.
function draw_line_vector(_x1, _y1, _angle, _distance) {
	var _a = degtorad(_angle);
	draw_line(_x1, _y1, _x1+cos(_a)*_distance, _y1-sin(_a)*_distance);
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
/// @param {bool} middleLine Enable middle line drawing.
function draw_line_quad(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, _middleLine=false) {
	// p1--p2
	// |    |
	// p4--p3
	draw_line(_x1, _y1, _x2, _y2);
	draw_line(_x1, _y1, _x4, _y4);
	draw_line(_x4, _y4, _x3, _y3);
	draw_line(_x2, _y2, _x3, _y3);
	if (_middleLine) draw_line(_x1, _y1, _x3, _y3);
}

/// @desc Draws a cone with field of view.
/// @param {real} x The x position.
/// @param {real} y The y position.
/// @param {real} angle The cone angle.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
function draw_cone(_x, _y, angle, dist, fov) {
	var _lenX1 = dcos(angle - fov / 2) * dist,
		_lenY1 = dsin(angle - fov / 2) * dist,
		_lenX2 = dcos(angle + fov / 2) * dist,
		_lenY2 = dsin(angle + fov / 2) * dist;
	draw_line(_x, _y, _x + _lenX1, _y - _lenY1);
	draw_line(_x, _y, _x + _lenX2, _y - _lenY2);
	draw_line(_x + _lenX1, _y - _lenY1, _x + _lenX2, _y - _lenY2);
}

#endregion

#region 2D GRAPHICS (Nine Slices, Sprites, Surfaces)

/// @desc Draws a sprite with nineslice turned on, but with custom size and the pivot point is considered.
/// @param {asset.gmsprite} sprite The sprite to draw.
/// @param {real} subimg The sprite frame.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
/// @param {real} width The width. The nine slice will be stretched to this exact amount.
/// @param {real} height The height. The nine slice will be stretched to this exact amount.
/// @param {real} xscale Relative nineslice xscale.
/// @param {real} yscale Relative nineslice yscale.
/// @param {real} rot Sprite angle.
/// @param {real} col Blend color.
/// @param {real} alpha Sprite alpha.
function draw_nineslice_stretched_ext(_sprite, _subimg, _x, _y, _width, _height, _xscale, _yscale, _rot, _col, _alpha) {
	draw_sprite_ext(_sprite, _subimg, _x, _y, (_width / sprite_get_width(_sprite)) * _xscale, (_height / sprite_get_height(_sprite)) * _yscale, _rot, _col, _alpha);
}

/// @desc Useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw centered.
/// @param {asset.gmsprite} sprite The sprite to draw.
/// @param {real} subimg The sprite frame.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
function draw_sprite_centered(_sprite, _subimg, _x, _y) {
	draw_sprite(_sprite, _subimg, _x - sprite_get_width(_sprite) / 2, _y - sprite_get_height(_sprite) / 2);
}

/// @desc Useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw the sprite centered and scaled.
/// @param {asset.gmsprite} sprite The sprite to draw.
/// @param {real} subimg The sprite frame.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
/// @param {real} xscale The sprite xscale.
/// @param {real} yscale The sprite yscale.
/// @param {real} rot The sprite angle.
/// @param {real} col The sprite blend color.
/// @param {real} alpha The sprite alpha.
function draw_sprite_centered_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _color, _alpha) {
	draw_sprite_ext(_sprite, _subimg, _x - (sprite_get_width(_sprite) / 2) * _xscale, _y - (sprite_get_height(_sprite) / 2) * _yscale, _xscale, _yscale, _rot, _color, _alpha);
}

/// @desc Draws a centered surface.
/// @param {id.surface} surfaceId The surface id to draw.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
function draw_surface_centered(_surfaceId, _x, _y) {
	draw_surface(_surfaceId, _x - (surface_get_width(_surfaceId) / 2), _y - (surface_get_height(_surfaceId) / 2));
}

/// @desc Draws a centered surface, with scale, angle, color and alpha.
/// @param {Id.surface} surfaceId The surface id to draw.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
/// @param {real} xscale The surface xscale.
/// @param {real} yscale The surface yscale.
/// @param {real} rot The surface angle.
/// @param {real} col The surface blend color.
/// @param {real} alpha The surface alpha.
function draw_surface_centered_ext(_surfaceId, _x, _y, _xscale, _yscale, _rot, _color, _alpha) {
	//draw_surface_ext(_surfaceId, x-(surface_get_width(_surfaceId)/2)*xscale, y-(surface_get_height(_surfaceId)/2)*yscale, xscale, yscale, rot, col, alpha);
	var _oldColor = draw_get_color(),
		_oldAlpha = draw_get_alpha(),
		_oldMat = matrix_get(matrix_world);
	matrix_set(matrix_world, matrix_build(_x, _y, 0, 0, 0, _rot, _xscale, _yscale, 1));
	draw_set_color(_color);
	draw_set_alpha(_alpha);
	draw_surface(_surfaceId, -surface_get_width(_surfaceId)/2, -surface_get_height(_surfaceId)/2);
	draw_set_color(_oldColor);
	draw_set_alpha(_oldAlpha);
	matrix_set(matrix_world, _oldMat);
}

/// @desc Draw a sprite with skew. Useful for grass wave effects
/// @param {asset.gmsprite} sprite The sprite to draw.
/// @param {real} subimg The sprite frame.
/// @param {real} x The x position to draw.
/// @param {real} y The y position to draw.
/// @param {real} width The width. The nine slice will be stretched to this exact amount.
/// @param {real} height The height. The nine slice will be stretched to this exact amount.
/// @param {real} xoffset Sprite x offset.
/// @param {real} yoffset Sprite y offset.
/// @param {real} xscale Relative nineslice xscale.
/// @param {real} yscale Relative nineslice yscale.
/// @param {real} skew_x The amount to skew horizontally.
/// @param {real} skew_y The amount to skew vertically.
/// @param {real} rot Sprite angle.
/// @param {real} alpha Sprite alpha.
function draw_sprite_pos_ext(_sprite, _subimg, _x, _y, _width, _height, _xoffset, _yoffset, _xscale, _yscale, _skewX, _skewY, _rotation, _alpha) {
    var _oldMatrix = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_build(_x, _y, 0, 0, 0, _rotation, _xscale, _yscale, 1));
    var _xo = -_xoffset, _yo = -_yoffset;
    draw_sprite_pos(sprite_index, _subimg, _xo+_skewX, _yo+_skewY, _width+_xo+_skewX, _yo+_skewY, _width+_xo, _height+_yo, _xo, _height+_yo, _alpha);
    matrix_set(matrix_world, _oldMatrix);
}

/// @desc Draws a texturized quad.
/// @param {real} texture_id The texture id. Example: sprite_get_texture(sprite, 0).
/// @param {real} x1 The first point x position.
/// @param {real} y1 The first point y position.
/// @param {real} x2 The second point x position.
/// @param {real} y2 The second point y position.
/// @param {real} x3 The third point x position.
/// @param {real} y3 The third point y position.
/// @param {real} x4 The fourth point x position.
/// @param {real} y4 The fourth point y position.
/// @param {real} precision] Render precision.
function draw_texture_quad(_textureId, _x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, _precision=50) {
	// p1--p2
	// |    |
	// p4--p3
	// original by: icuurd12b42
	var _w1xs = (_x1 - _x2) / _precision,
		_w1ys = (_y1 - _y2) / _precision,
		_w2xs = (_x4 - _x3) / _precision,
		_w2ys = (_y4 - _y3) / _precision,
		_w1xat = _x1,
		_w1yat = _y1,
		_w2xat = _x4,
		_w2yat = _y4,
		_us = 1 / _precision,
		_uat = 1;
       
	draw_primitive_begin_texture(pr_trianglestrip, _textureId);
	repeat(_precision + 1) {
		draw_vertex_texture(_w1xat, _w1yat, _uat, 0);
		draw_vertex_texture(_w2xat, _w2yat, _uat, 1);
		_uat -= _us;
		_w1xat -= _w1xs;
		_w1yat -= _w1ys;
		_w2xat -= _w2xs;
		_w2yat -= _w2ys;
	}
	draw_primitive_end();
}

#endregion

#region BLENDING

/// @desc Test all possible blendmodes.
/// @param {real} index The blendmode number index to test.
/// @param {bool} _debugInfo Enable console debug messages.
/// @returns {string} 
function gpu_set_blendmode_test(index, _debugInfo=false) {
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
		// multiply blendmode (with alpha)
		gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha);
		_type = "Multiply (w alpha)";
		_current = 3;
	} else
	if (index == 4) {
		// multiply blendmode
		gpu_set_blendmode_ext(bm_dest_color, bm_zero);
		_type = "Multiply";
		_current = 4;
	} else
	if (index == 5) {
		// subtract blendmode
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_color); // or bm_zero in B
		_type = "Subtract";
		_current = 5;
	} else
	if (index == 6) {
		// invert blendmode
		gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_color); // the alpha also is affected: RGBA
		_type = "Invert";
		_current = 6;
	} else
	if (index >= 7 && index <= 10) {
		var _ind = index-7;
		gpu_set_blendmode(_ind); // bm_normal, bm_add, bm_max, bm_subtract
		_type = __type0(_ind);
		_current = _ind;
		_max = 3;
	} else
	if (index >= 11) {
		// all blendmodes
		var _ind = index;
		_current = index-11;
		_max = 14641;
		
		var p = 11;
		_bm1 = 1 + (_ind % p);
		_bm2 = 1 + ((_ind div p) % p);
		_bm3 = 1 + ((_ind div (p*p)) % p);
		_bm4 = 1 + ((_ind div (p*p*p)) % p);
		
		_type = string_join_ext(", ", [__type1(_bm1), __type1(_bm2), __type1(_bm3), __type1(_bm4)]);
		gpu_set_blendmode_ext_sepalpha(_bm1, _bm2, _bm3, _bm4);
	}
	
	var _info = $"{index} | {_current} / {_max} ({_type})";
	if (_debugInfo) show_debug_message(_info);
	return _info;
}

#endregion

#region COLORS

/// @desc Smoothly merge between array colors. Returns the final GM color.
/// @param {array} colors_array Array of colors.
/// @param {real} progress The array progress, from 0 to 1.
/// @returns {constant} 
function color_gradient(_colorsArray, _progress) {
	var _len = array_length(_colorsArray) - 1;
	var _prog = clamp(_progress, 0, 1) * _len;
	return merge_color(_colorsArray[floor(_prog)], _colorsArray[ceil(_prog)], frac(_prog));
}

/// @desc Generates a RGB color to be used in a shader. Supports decimal and hex colors.
/// @param {constant.color} color The color. Supports decimal and hex colors.
/// @returns {array} 
function make_color_shader(_color) {
	return [color_get_red(_color)/255, color_get_green(_color)/255, color_get_blue(_color)/255];
}

/// @desc Function Description
/// @param {constant.color} color The color. Supports decimal and hex colors.
/// @param {real} alpha Alpha channel, 0 - 255.
/// @returns {array} 
function make_color_shader_rgba(_color, alpha) {
	return [color_get_red(_color)/255, color_get_green(_color)/255, color_get_blue(_color)/255, alpha];
}

#endregion

#region TEXT

function draw_text_shadow(_x, _y, _str, _shadowColor=c_black, _shadowAlpha=1, _shadowDistX=1, _shadowDistY=1) {
	var _oldColor = draw_get_color();
	var _oldAlpha = draw_get_alpha();
	draw_set_color(_shadowColor);
	draw_set_alpha(_shadowAlpha);
	draw_text(_x + _shadowDistX, _y + _shadowDistY, _str);
	draw_set_color(_oldColor);
	draw_set_alpha(_oldAlpha);
	draw_text(_x, _y, _str);
}

function draw_text_ext_shadow(_x, _y, _str, _sep, _width, _shadowColor=c_black, _shadowAlpha=1, _shadowDistX=1, _shadowDistY=1) {
	var _oldColor = draw_get_color();
	var _oldAlpha = draw_get_alpha();
	draw_set_color(_shadowColor);
	draw_set_alpha(_shadowAlpha);
	draw_text_ext(_x + _shadowDistX, _y + _shadowDistY, _str, _sep, _width);
	draw_set_color(_oldColor);
	draw_set_alpha(_oldAlpha);
	draw_text_ext(_x, _y, _str, _sep, _width);
}

function draw_text_outline(_x, _y, _str, _outlineColor=c_black, _outlineAlpha=1, _outlineSize=1, _fidelity=4) {
	var _oldColor = draw_get_color();
	var _oldAlpha = draw_get_alpha();
	draw_set_color(_outlineColor);
	draw_set_alpha(_outlineAlpha);
	var _fidelityIncrement = Tau / _fidelity;
	for (var i = 0; i < Tau; i += _fidelityIncrement) {
	    draw_text(_x + cos(i) * _outlineSize, _y - sin(i) * _outlineSize, _str);
	}
	draw_set_color(_oldColor);
	draw_set_alpha(_oldAlpha);
	draw_text(_x, _y, _str);
}

function draw_text_outline_gradient(_x, _y, _str, _outlineColor1=c_black, _outlineColor2=c_black, _outlineColor3=c_black, _outlineColor4=c_black, _outlineAlpha=1, _outlineSize=1, _fidelity=4) {
	var _fidelityIncrement = Tau / _fidelity;
	for (var i = 0; i < Tau; i += _fidelityIncrement) {
		draw_text_color(_x+cos(i)*_outlineSize, _y-sin(i)*_outlineSize, _str, _outlineColor1, _outlineColor2, _outlineColor3, _outlineColor4, _outlineAlpha);
	}
	draw_text(_x, _y, _str);
}

function draw_text_transformed_shadow(_x, _y, _str, _xscale, _yscale, _angle, _shadowColor=c_black, _shadowAlpha=1, _shadowDistX=1, _shadowDistY=1) {
	var _oldColor = draw_get_color();
	var _oldAlpha = draw_get_alpha();
	draw_set_color(_shadowColor);
	draw_set_alpha(_shadowAlpha);
	draw_text_transformed(_x + (_shadowDistX * _xscale), _y + (_shadowDistY * _yscale), _str, _xscale, _yscale, _angle);
	draw_set_color(_oldColor);
	draw_set_alpha(_oldAlpha);
	draw_text_transformed(_x, _y, _str, _xscale, _yscale, _angle);
}

function draw_text_wave(_x, _y, _str, _strWidth, _waveAmplitude=3, _waveSpeed=0.01) {
	var _xx = _x, _yy = _y;
	var i = 1, _isize = string_length(_str);
	repeat(_isize) {
		var _char = string_char_at(_str, i);
		var _ww = string_width(_char);
		var _wf = (_strWidth == 0) ? 0 : _strWidth / 2;
		draw_text(_xx - _wf, _yy + sin(i + current_time * _waveSpeed) * _waveAmplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_wave_colorful(_x, _y, _str, _strWidth, _waveAmplitude=3, _waveSpeed=0.01, _colorSpeed=0.1) {
	var _xx = _x, _yy = _y;
	var i = 1, _isize = string_length(_str);
	repeat(_isize) {
		var _char = string_char_at(_str, i);
		var _ww = string_width(_char);
		var _wf = (_strWidth == 0) ? 0 : _strWidth / 2;
		draw_set_color(make_color_hsv(current_time * _colorSpeed % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * _waveSpeed) * _waveAmplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_wave_rainbow(_x, _y, _str, _strWidth, _waveAmplitude=3, _waveSpeed=0.01, _colorSpeed=0.1) {
	var _xx = _x, _yy = _y;
	var i = 1, _isize = string_length(_str);
	repeat(_isize) {
		var _char = string_char_at(_str, i);
		var _ww = string_width(_char);
		var _wf = (_strWidth == 0) ? 0 : _strWidth / 2;
		draw_set_color(make_color_hsv((current_time * _colorSpeed + i * 10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * _waveSpeed) * _waveAmplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_rainbow(_x, _y, _str, _strWidth, _colorSpeed=0.1) {
	var _xx = _x, _yy = _y;
	var i = 1, _isize = string_length(_str);
	repeat(_isize) {
		var _char = string_char_at(_str, i);
		var _ww = string_width(_char);
		var _wf = (_strWidth == 0) ? 0 : _strWidth / 2;
		draw_set_color(make_color_hsv((current_time * _colorSpeed + i * 10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_shake(_x, _y, _str, _strWidth, _dist=1) {
	var _xx = _x, _yy = _y;
	var i = 1, _isize = string_length(_str);
	repeat(_isize) {
		var _char = string_char_at(_str, i);
		var _ww = string_width(_char);
		var _wf = (_strWidth == 0) ? 0 : _strWidth / 2;
		draw_text(_xx - _wf + random_range(-_dist, _dist), _yy + random_range(-_dist, _dist), _char);
		_xx += _ww;
		i++;
	}
}

#endregion
