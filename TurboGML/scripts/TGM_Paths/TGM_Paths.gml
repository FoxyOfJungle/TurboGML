
/// Feather ignore all

/// @desc Returns the distance between the point and the path.
/// @param {real} x The x position to check from.
/// @param {real} y The y position to check from.
/// @param {asset.gmpath} path The path index.
/// @returns {real} 
function distance_to_path(_x, _y, _path) {
	// calculates the shortest distance to the given path
	var x0 = _x, y0 = _y, i, points, segments, length, pos, pmin, pmax, x1, y1, x2, y2, dx, dy, t, ix, iy, dist, minDist;
	if (path_get_kind(_path) == 0) {
		// straight path
		// get the number of control points and line segments on the path
		segments = points;
		if (!path_get_closed(_path)) segments -= 1;
		// first, find the nearest control point.
		minDist = infinity;
		for (i = 0; i < points; i++) {
			x1 = path_get_point_x(_path, i);
			y1 = path_get_point_y(_path, i);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < minDist) minDist = dist;
		}
		// second, calculate the distance to each line segment and find the nearest one.
		x1 = path_get_point_x(_path, 0);
		y1 = path_get_point_y(_path, 0);
		for(i = 0; i < segments; i++) {
			x2 = path_get_point_x(_path, (i+1) % points);
			y2 = path_get_point_y(_path, (i+1) % points);
			dx = x2 - x1;
			dy = y2 - y1;
			if (dx != 0 || dy != 0) {
				// see if there is an intersection between the line segment
				// and the perpendicular line to it.
				t = -(dx * (x1 - x0) + dy * (y1 - y0)) / (sqr(dx) + sqr(dy));
				if (t >= 0 && t < 1) {
					// Calculate the distance to the intersection point.
					ix = x1 + dx * t;
					iy = y1 + dy * t;
					dist = point_distance(x0, y0, ix, iy);
					if (dist < minDist)
					minDist = dist;
				}
			}
			x1 = x2;
			y1 = y2;
		}
	} else {
		// smooth path
		// first, split the path into a few segments and find the nearest one.
		length = path_get_length(_path);
		segments = max(4, length / 32); // Hope this is enough
		minDist = infinity;
		pmin = 0;
		for(i = 0; i <= segments; i += 1) {
			pos = i/segments;
			x1 = path_get_x(_path, pos);
			y1 = path_get_y(_path, pos);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < minDist) {
				minDist = dist;
				pmin = pos;
			}
		}
		// now, accurately find the nearest point on the segment.
		// at this point, pmin has the position of the provisional nearest point,
		// and the following two lines are to get two end points adjacent to it.
		pmax = min(pmin + 1/segments, 1);
		pos = max(0, pmin - 1/segments);
		do {
			x1 = path_get_x(_path, pos);
			y1 = path_get_y(_path, pos);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < minDist) minDist = dist;
			pos += 1/length;
		}
		until (pos >= pmax);
	}
	return minDist;
}

/// @desc Get the nearest point index (n) from a path, based on the distance.
/// @param {real} x The x position to check from.
/// @param {real} y The y position to check from.
/// @param {asset.gmpath} path The path index.
/// @returns {struct} 
function path_get_nearest_point(_x, _y, _path) {
	var i = 0, isize = path_get_number(_path),
	_px = 0, _py = 0, _dist = 0,
	_pri_x = ds_priority_create(), _pri_y = ds_priority_create();
	repeat(isize) {
		_px = path_get_point_x(_path, i);
		_py = path_get_point_y(_path, i);
		_dist = point_distance(_x, _y, _px, _py);
		ds_priority_add(_pri_x, i, _dist);
		ds_priority_add(_pri_y, i, _dist);
		++i;
	}
	var _pos = new Vector2(
		ds_priority_find_min(_pri_x),
		ds_priority_find_min(_pri_y)
	);
	ds_priority_destroy(_pri_x);
	ds_priority_destroy(_pri_y);
	return _pos;
}

/// @desc Get the nearest point position (x, y).
/// @param {real} x The x position to check from.
/// @param {real} y The y position to check from.
/// @param {asset.gmpath} path The path index.
/// @returns {struct} 
function path_get_nearest_point_position(_x, _y, _path) {
	var i = 0, isize = path_get_number(_path),
	_px = 0, _py = 0, _dist = 0,
	_pri_x = ds_priority_create(), _pri_y = ds_priority_create();
	repeat(isize) {
		_px = path_get_point_x(_path, i);
		_py = path_get_point_y(_path, i);
		_dist = point_distance(_x, _y, _px, _py);
		ds_priority_add(_pri_x, _px, _dist);
		ds_priority_add(_pri_y, _py, _dist);
		++i;
	}
	var _pos = new Vector2(
		ds_priority_find_min(_pri_x),
		ds_priority_find_min(_pri_y)
	);
	ds_priority_destroy(_pri_x);
	ds_priority_destroy(_pri_y);
	return _pos;
}

/// @desc Get the normalized path position (0 - 1), based on the position (x, y).
/// @param {real} x The x position to check from.
/// @param {real} y The y position to check from.
/// @param {asset.gmpath} path The path index.
/// @param {real} pixel_precision The path pixel precision. Default is 4.
/// @returns {real} 
function path_get_nearest_position(_x, _y, _path, _pixelPrecision=4) {
	// original by: gnysek
	var _raycast = infinity, _pos = 0, _dst,
	_precision = (1 / path_get_length(_path)) * clamp(_pixelPrecision, 1, 100);
	for(var i = 0; i < 1; i += _precision;) {
		_dst = point_distance(_x, _y, path_get_x(0, i), path_get_y(0, i));
		if (_dst < _raycast) {
			_pos = i;
			_raycast = _dst;
		}
	}
	return _pos;
}

/// @desc The the current path direction the object is facing.
/// @param {asset.gmpath} path The path index.
/// @param {real} pos The path position. Example: path_position.
/// @returns {real} 
function path_get_direction(_path, _pos) {
	var _reciprocal = (1 / path_get_length(_path)),
	_pos_1 = _pos - _reciprocal,
	_pos_2 = _pos + _reciprocal,
	_x1 = path_get_x(_path, _pos_1),
	_y1 = path_get_y(_path, _pos_1),
	_x2 = path_get_x(_path, _pos_2),
	_y2 = path_get_y(_path, _pos_2),
	_dir = point_direction(_x1, _y1, _x2, _y2);
	return _dir;
}
