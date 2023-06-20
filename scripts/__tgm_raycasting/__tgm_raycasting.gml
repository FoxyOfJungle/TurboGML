
/// Feather ignore all

function raycast_hit_point_2d(origin_x, origin_y, object, angle, distance, precise=true, notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/
	// edited by FoxyPfJungle
	var _dir = degtorad(angle),
	_x1 = origin_x,
	_y1 = origin_y,
	_x2 = origin_x + cos(_dir)*distance,
	_y2 = origin_y - sin(_dir)*distance,
	
	_col = collision_line(_x1, _y1, _x2, _y2, object, precise, notme),
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
			_col2 = collision_line(_px, _py, _nx, _ny, object, precise, notme);
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

function raycast_tag_hit_point_2d(origin_x, origin_y, tags, include_children, angle, distance, precise=true, notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/ | edited by FoxyPfJungle
	// search for tag objects
	var _object_ids_array = tag_get_asset_ids(tags, asset_object),
	i = 0, isize = array_length(_object_ids_array), _col;
	repeat(isize) {
		// raycast
		_col = raycast_hit_point_2d(origin_x, origin_y, _object_ids_array[i], angle, distance, precise, notme);
		if (_col.z != noone) return _col;
		++i;
	}
	return new Vector3(origin_x, origin_y, noone);
}

/// Returns a ray whose origin is the camera position (ray origin) Vector3(x, y, z). It also returns the direction of the vector Vector3(x, y, z).
///
/// Works for both orthographic and perspective projections.
function screen_to_ray(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr / DragoniteSpam / FoxyOfJungle
	var _mx = 2 * (xx / window_get_width() - 0.5) / proj_mat[0];
	var _my = 2 * (yy / window_get_height() - 0.5) / proj_mat[5];
	var _cam_x = - (view_mat[12] * view_mat[0] + view_mat[13] * view_mat[1] + view_mat[14] * view_mat[2]);
	var _cam_y = - (view_mat[12] * view_mat[4] + view_mat[13] * view_mat[5] + view_mat[14] * view_mat[6]);
	var _cam_z = - (view_mat[12] * view_mat[8] + view_mat[13] * view_mat[9] + view_mat[14] * view_mat[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (proj_mat[15] == 0) {
	// perspective projection
	_matrix = [view_mat[2]  + _mx * view_mat[0] + _my * view_mat[1],
			view_mat[6]  + _mx * view_mat[4] + _my * view_mat[5],
			view_mat[10] + _mx * view_mat[8] + _my * view_mat[9],
			_cam_x,
			_cam_y,
			_cam_z];
	} else {
	// orthographic projection
	_matrix = [view_mat[2],
			view_mat[6],
			view_mat[10],
			_cam_x + _mx * view_mat[0] + _my * view_mat[1],
			_cam_y + _mx * view_mat[4] + _my * view_mat[5],
			_cam_z + _mx * view_mat[8] + _my * view_mat[9]];
	}
	return {
		origin : new Vector3(_matrix[3], _matrix[4], _matrix[5]),
		direction : new Vector3(_matrix[0], _matrix[1], _matrix[2]),
	}
}
