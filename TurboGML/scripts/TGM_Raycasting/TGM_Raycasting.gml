
/// Feather ignore all

/// @desc Throws a vector until it hits an object. Returns Vector3(x, y, id) if it hits.
/// @param {real} origin_x The ray x origin.
/// @param {real} origin_y The ray y origin.
/// @param {Id.GMObject} object The object id do check.
/// @param {real} angle Ray angle.
/// @param {real} distance Ray distance.
/// @param {bool} precise Whether the check is based on precise collisions (true, which is slower) or its bounding box in general (false, faster).
/// @param {bool} notme Whether the calling instance, if relevant, should be excluded (true) or not (false).
/// @returns {struct} Description
function raycast_hit_point_2d(_originX, _originY, _object, _angle, _distance, _precise=true, _notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/
	// edited by FoxyOfJungle
	var _dir = degtorad(_angle),
		_x1 = _originX,
		_y1 = _originY,
		_x2 = _originX + cos(_dir) * _distance,
		_y2 = _originY - sin(_dir) * _distance,
		
		_col = collision_line(_x1, _y1, _x2, _y2, _object, _precise, _notme),
		_col2 = noone,
		
		_xo = _x1,
		_yo = _y1;
	
	if (_col != noone) {
		var _p0 = 0,
			_p1 = 1,
			_np = 0,
			_px = 0,
			_py = 0,
			_nx = 0,
			_ny = 0,
			_len = ceil(log2(point_distance(_x1, _y1, _x2, _y2))) + 1;
		repeat(_len) {
			_np = _p0 + (_p1 - _p0) * 0.5;
			_nx = _x1 + (_x2 - _x1) * _np;
			_ny = _y1 + (_y2 - _y1) * _np;
			_px = _x1 + (_x2 - _x1) * _p0;
			_py = _y1 + (_y2 - _y1) * _p0;
			_col2 = collision_line(_px, _py, _nx, _ny, _object, _precise, _notme);
			if (_col2 != noone) {
				_col = _col2;
				_xo = _nx;
				_yo = _ny;
				_p1 = _np;
			} else _p0 = _np;
		}
	}
	return new Vector3(_xo, _yo, _col);
}

/// @desc Throws a vector until it hits an object, based on tags. Returns Vector3(x, y, id) if it hits.
/// @param {real} origin_x The ray x origin.
/// @param {real} origin_y The ray y origin.
/// @param {string,array<string>} tags Tag string or array.
/// @param {bool} include_children Include object children?
/// @param {real} angle Ray angle.
/// @param {real} distance Ray distance.
/// @param {bool} precise Whether the check is based on precise collisions (true, which is slower) or its bounding box in general (false, faster).
/// @param {bool} notme Whether the calling instance, if relevant, should be excluded (true) or not (false).
/// @returns {struct} 
function raycast_tag_hit_point_2d(_originX, _originY, _tags, _includeChildren, _angle, _distance, _precise=true, _notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/ | edited by FoxyPfJungle
	// search for tag objects
	var _objectIdsArray = tag_get_asset_ids(_tags, asset_object),
		_i = 0, 
		_isize = array_length(_objectIdsArray), 
		_col;
	repeat(_isize) {
		// raycast
		_col = raycast_hit_point_2d(_originX, _originY, _objectIdsArray[_i], _angle, _distance, _precise, _notme);
		if (_col.z != noone) return _col;
		++_i;
	}
	return new Vector3(_originX, _originY, noone);
}

/// @desc Returns a ray whose origin is the camera position (ray origin) Vector3(x, y, z). It also returns the direction of the vector Vector3(x, y, z).
/// @desc Works for both orthographic and perspective projections.
/// @param {array} view_mat Camera view matrix.
/// @param {array} proj_mat Camera projection matrix.
/// @param {real} x Cursor x position in window space. Example: window_mouse_get_x().
/// @param {real} y Cursor y position in window space. Example: window_mouse_get_y().
/// @returns {struct} 
function screen_to_ray(_viewMat, _projMat, _xx, _yy) {
	// credits: TheSnidr / DragoniteSpam / FoxyOfJungle
	var _mx = 2 * (_xx / window_get_width() - 0.5) / _projMat[0];
	var _my = 2 * (_yy / window_get_height() - 0.5) / _projMat[5];
	var _camX = - (_viewMat[12] * _viewMat[0] + _viewMat[13] * _viewMat[1] + _viewMat[14] * _viewMat[2]);
	var _camY = - (_viewMat[12] * _viewMat[4] + _viewMat[13] * _viewMat[5] + _viewMat[14] * _viewMat[6]);
	var _camZ = - (_viewMat[12] * _viewMat[8] + _viewMat[13] * _viewMat[9] + _viewMat[14] * _viewMat[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (_projMat[15] == 0) {
		// perspective projection
		_matrix = [
			_viewMat[2]  + _mx * _viewMat[0] + _my * _viewMat[1],
			_viewMat[6]  + _mx * _viewMat[4] + _my * _viewMat[5],
			_viewMat[10] + _mx * _viewMat[8] + _my * _viewMat[9],
			_camX,
			_camY,
			_camZ
		];
	} else {
		// orthographic projection
		_matrix = [
			_viewMat[2],
			_viewMat[6],
			_viewMat[10],
			_camX + _mx * _viewMat[0] + _my * _viewMat[1],
			_camY + _mx * _viewMat[4] + _my * _viewMat[5],
			_camZ + _mx * _viewMat[8] + _my * _viewMat[9]
		];
	}
	return {
		origin: new Vector3(_matrix[3], _matrix[4], _matrix[5]),
		direction: new Vector3(_matrix[0], _matrix[1], _matrix[2]),
	};
}
