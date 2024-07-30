
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

/// @desc Get resolutions that match the aspect ratio of a base resolution. Useful to make sure the game image will not distort with wrong aspect ratios.
/// @param {Real} width The resolution width to check.
/// @param {Real} height The resolution height to check.
/// @param {Real} aspect_ratio The resolution height to check.
function display_get_true_resolutions(_width, _height, _aspectRatio) {
	var displayWidth = _width;
	var displayHeight = _height;
	var aspect = displayWidth / displayHeight;
	var resolutions = [];
	// loop through possible resolutions to find matches
	for(var width = displayWidth, height = 0; width > 0; width -= 1) {
		height = floor(width / aspect);
			if (height > 0 && (width / height == _aspectRatio) && (width % 8 == 0) && (height % 8 == 0) && is_even(width) && is_even(height)) {
			array_push(resolutions, [width, height]);
		}
	}
	return resolutions;
}

/// @desc Returns the aspect ratio proportion. Example: 16/9
/// @param {real} width The width. Example: display_get_width().
/// @param {real} height The width. Example: display_get_height().
/// @returns {string} Description
function aspect_ratio_gcd(_width, _height) {
	var _gcd = gcd(_width, _height),
	    _wAspect = floor(_width / _gcd),
	    _hAspect = floor(_height / _gcd); 
    return $"{_wAspect} / {_hAspect}";
}

#endregion

#region SURFACES

/// @desc Saves a HDR (High Dynamic Range) surface to a image file.
/// @param {Id.Surface} surfaceId The surface id.
/// @param {string} fname The name of the saved image file.
function surface_save_hdr(_surfaceId, _fname) {
	var _surf = surface_create(surface_get_width(_surfaceId), surface_get_height(_surfaceId), surface_rgba8unorm);
	surface_copy(_surf, 0, 0, _surfaceId);
	surface_save(_surf, _fname);
	surface_free(_surf);
}

/// @desc This function copies one surface to another, applying a shader to it.
/// @param {Id.Surface} source Description
/// @param {Id.Surface} dest Description
/// @param {Function} pass_func The shader function.
/// @param {Struct} pass_json_data The shader parameters.
/// @param {Real} alpha Surface clear alpha.
function surface_blit(_source, _dest, _passFunc=undefined, _passJsonData=undefined, _alpha=0) {
	gml_pragma("forceinline");
	surface_set_target(_dest);
	if (_alpha > -1) draw_clear_alpha(c_black, _alpha);
	if (_passFunc != undefined) _passFunc(_passJsonData);
	draw_surface_stretched(_source, 0, 0, surface_get_width(_dest), surface_get_height(_dest));
	shader_reset();
	surface_reset_target();
}

#endregion

#region TEXTURE GROUPS

// If you need better texture groups management, check Managix:
// https://foxyofjungle.itch.io/managix

/// @desc Unload all texture groups from the array, except one.
/// @param {String} group Texture group name.
/// @param {array} groups_array Description
function texturegroup_unload_except(_group, _groupsArray) {
	var i = 0, isize = array_length(_groupsArray);
	repeat(isize) {
		var _g = _groupsArray[i];
		if (_g != _group) continue;
		texturegroup_unload(_g);
		++i;
	}
}

#endregion
