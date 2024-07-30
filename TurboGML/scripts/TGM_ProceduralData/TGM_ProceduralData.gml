
/// Feather ignore all

/// @desc Read a sprite and returns an array of blocks. Useful for coins patterns.
/// @param {asset.gmsprite} sprite The sprite to read pixels from.
/// @param {real} wspace Padding width.
/// @param {real} hspace Padding height.
/// @returns {struct} 
function pattern_read_sprite(_sprite, _wSpace=1, _hSpace=1) {
	var _width = sprite_get_width(_sprite),
	_height = sprite_get_height(_sprite),
	
	_surf = surface_create(_width, _height);
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_sprite(_sprite, 0, 0, 0);
	surface_reset_target();
	
	var _buff = buffer_create(_width * _height * 4, buffer_fixed, 1);
	buffer_get_surface(_buff, _surf, 0);
	
	// data structure with info
	var data = {
		blocks : [],
		width : 0,
		height : 0,
	};
	
	// read every sprite pixel
	var _r, _g, _b, _a, _pixel, _col;
	var i = 0, j = 0, _total = 0;
	repeat(_width) {
		j = 0;
		repeat(_height) {
			_pixel = buffer_peek(_buff, 4 * (i + j * _width), buffer_u32); // get rgba
			_r = _pixel & $ff;
			_g = (_pixel >> 8) & $ff;
			_b = (_pixel >> 16) & $ff;
			_a = (_pixel >> 24) & $ff;
			
			_col = make_color_rgb(_r, _g, _b);
			
			// add pixel position data to array
			var _json = {
				x : i * _wSpace,
				y : j * _hSpace,
				p : (_col == c_white ? 1 : 0),
			}
			data.blocks[_total] = _json;
			_total++;
			++j;
		}
		++i;
	}
	data.width = i;
	data.height = j;
	
	surface_free(_surf);
	buffer_delete(_buff);
	return data;
}
