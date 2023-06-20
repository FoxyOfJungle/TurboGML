



/// Feather ignore all

#region DISPLAY

#macro ANTIALIASING_MAX_AVAILABLE max(display_aa & 2, display_aa & 4, display_aa & 8)


function display_get_inches() {
	return sqrt(sqr(display_get_width()) + sqr(display_get_height())) / mean(display_get_dpi_x(), display_get_dpi_y());
}

/// @desc This function gets returns the display count.
function display_get_display_count() {
	// credit: gnysek
	return array_length(window_get_visible_rects(0, 0, 1, 1)) / 8;
}

/// @desc This function gets returns the current display aspect ratio.
function display_get_aspect_ratio() {
	return display_get_width() / display_get_height();
}




function aspect_ratio_gcd(width, height) {
	var _gcd = gcd(width, height);
    var _w_aspect = width / _gcd;
    var _h_aspect = height / _gcd; 
    return string(_w_aspect) + " / " + string(_h_aspect);
}

//function aspect_ratio_maintain(resolution_x, resolution_y, size_x, size_y) {
//	var _aspect_ratio = resolution_x / resolution_y;
//	return (resolution_x > resolution_y) ? new Vector2(size_x * _aspect_ratio, size_y) : new Vector2(size_x, size_y / _aspect_ratio);
//}

// WIP...
//function aspect_ratio_maintain(width, height, base_width, base_height) {
//	var aspect = base_width / base_height;
//	var _ww = 0, _hh = 0;
//	if (width > height) {
//		// landscape
//		_hh = min(base_height, height);
//		_ww = _hh * aspect;
//	} else {
//		// portrait
//		_ww = min(base_width, width);
//		_hh = _ww / aspect;
//	}
//	return new Vector2(_ww, _hh);
//}

#endregion

#region SURFACES

/// @desc Saves a HDR surface to a image file.
/// @param {Id.Surface} surface_id The surface id.
/// @param {string} fname The name of the saved image file.
function surface_save_hdr(surface_id, fname) {
	var _surf = surface_create(surface_get_width(surface_id), surface_get_height(surface_id), surface_rgba8unorm);
	surface_copy(_surf, 0, 0, surface_id);
	surface_save(_surf, fname);
	surface_free(_surf);
}

/// @desc This function copies one surface to another, applying a shader to it.
/// @param {Id.Surface} source Description
/// @param {Id.Surface} dest Description
/// @param {Function} pass_func The shader function.
/// @param {Struct} pass_json_data The shader parameters.
/// @param {Real} alpha Surface clear alpha.
function surface_blit(source, dest, pass_func=undefined, pass_json_data=undefined, alpha=0) {
	gml_pragma("forceinline");
	surface_set_target(dest);
	if (alpha > -1) draw_clear_alpha(c_black, alpha);
	if (pass_func != undefined) pass_func(pass_json_data);
	draw_surface_stretched(source, 0, 0, surface_get_width(dest), surface_get_height(dest));
	shader_reset();
	surface_reset_target();
}

#endregion

#region TEXTURE GROUPS

function texturegroup_unload_except(group, groups_array) {
	var i = 0, isize = array_length(groups_array);
	repeat(isize) {
		var _group = groups_array[i];
		if (_group != group) continue;
		texturegroup_unload(_group);
		++i;
	}
}

function texturegroup_debug_draw_sprites(group, scale) {
	var _tex_array = texturegroup_get_sprites(group);
	
	var i = 0, isize = array_length(_tex_array), yy = 20;
	repeat(isize) {
		var _reciprocal = i / isize;
		var _spr = _tex_array[i];
		var _ww = sprite_get_width(_spr) * scale;
		var _hh = sprite_get_height(_spr) * scale;
		draw_sprite_stretched(_spr, 0, 20, yy, _ww, _hh);
		yy += _hh + 10;
		++i;
	}
}

#endregion
