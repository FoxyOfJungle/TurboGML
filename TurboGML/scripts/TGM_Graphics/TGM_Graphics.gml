
/// Feather ignore all

#region DISPLAY

#macro ANTIALIASING_MAX_AVAILABLE max(display_aa & 2, display_aa & 4, display_aa & 8)


/// @desc Get display inches.
/// @returns {real} 
function display_get_inches() {
	return sqrt(sqr(display_get_width()) + sqr(display_get_height())) / max(display_get_dpi_x(), display_get_dpi_y());
}

/// @desc Returns the display count.
/// Please note, this function is slow.
function display_get_display_count() {
	// credit: gnysek
	return array_length(window_get_visible_rects(0, 0, 1, 1)) / 8;
}

/// @desc This function gets returns the current display aspect ratio.
function display_get_aspect_ratio() {
	return display_get_width() / display_get_height();
}

/// @desc Returns the aspect ratio proportion. Example: 16/9
/// @param {real} width The width. Example: display_get_width().
/// @param {real} height The width. Example: display_get_height().
/// @returns {string} Description
function aspect_ratio_gcd(width, height) {
	var _gcd = gcd(width, height),
    _w_aspect = floor(width / _gcd),
    _h_aspect = floor(height / _gcd); 
    return $"{_w_aspect} / {_h_aspect}";
}

#endregion

#region SURFACES

/// @desc Saves a HDR (High Dynamic Range) surface to a image file.
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

/// @desc Unload all texture groups from the array, except one.
/// @param {String} group Texture group name.
/// @param {array} groups_array Description
function texturegroup_unload_except(group, groups_array) {
	var i = 0, isize = array_length(groups_array);
	repeat(isize) {
		var _group = groups_array[i];
		if (_group != group) continue;
		texturegroup_unload(_group);
		++i;
	}
}

/// @desc Draw sprites from texture group. For debug purposes only.
/// @param {string} group Texture group name.
/// @param {real} scale Image scale.
function texturegroup_debug_draw_sprites(group, scale) {
	var _tex_array = texturegroup_get_sprites(group);
	var i = 0, isize = array_length(_tex_array), yy = 20;
	repeat(isize) {
		var _reciprocal = i / isize,
		_spr = _tex_array[i],
		_ww = sprite_get_width(_spr) * scale,
		_hh = sprite_get_height(_spr) * scale;
		draw_sprite_stretched(_spr, 0, 20, yy, _ww, _hh);
		yy += _hh + 10;
		++i;
	}
}

#endregion
