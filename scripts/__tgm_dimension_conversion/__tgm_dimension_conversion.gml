
/// Feather ignore all

/// @desc This function converts the coordinates of the room to the GUI dimension. Returns a Vector2(x, y) struct.
/// @param {real} x1 The x position to convert from.
/// @param {real} y1 The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} gui_width The GUI width.
/// @param {real} gui_height The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on
/// @returns {struct} 
function room_to_gui_dimension(x1, y1, camera, gui_width, gui_height, normalize) {
	var _px = (x1-camera_get_view_x(camera)) * (gui_width/camera_get_view_width(camera)),
	_py = (y1-camera_get_view_y(camera)) * (gui_height/camera_get_view_height(camera));
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
}

/// @desc This function converts the coordinates of the GUI to the room dimension. Returns a Vector2(x, y) struct.
/// @param {real} x1 The x position to convert from.
/// @param {real} y1 The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} angle The camera angle.
/// @param {real} gui_width The GUI width.
/// @param {real} gui_height The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on
/// @returns {struct} 
function room_to_gui_dimension_ext(x1, y1, camera, angle, gui_width, gui_height, normalize) {
	var _cw = camera_get_view_width(camera),
	_ch = camera_get_view_height(camera),
	_vcenter_x = camera_get_view_x(camera) + (_cw / 2),
	_vcenter_y = camera_get_view_y(camera) + (_ch / 2),
	_zoom = gui_width/_cw,
	_wcenter_dis = point_distance(_vcenter_x, _vcenter_y, x1, y1) * _zoom,
	_wcenter_dir = point_direction(_vcenter_x, _vcenter_y, x1, y1) + angle,
	_px = (gui_width/2) + dcos(_wcenter_dir) * _wcenter_dis,
	_py = (gui_height/2) - dsin(_wcenter_dir) * _wcenter_dis;
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
}

/// @desc This function converts the coordinates of the GUI to the room dimension, with additional angle parameter. Returns a Vector2(x, y) struct.
/// @param {real} x1 The x position to convert from.
/// @param {real} y1 The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} angle The camera angle.
/// @param {real} gui_width The GUI width.
/// @param {real} gui_height The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on.
/// @returns {struct} 
function gui_to_room_dimension_ext(x1, y1, camera, angle, gui_width, gui_height, normalize) {
	var _cx = camera_get_view_x(camera),
	_cy = camera_get_view_y(camera),
	_cw = camera_get_view_width(camera),
	_ch = camera_get_view_height(camera),
	_vcenter_x = gui_width / 2,
	_vcenter_y = gui_height / 2,
	zoom = gui_width/_cw,
	_wcenter_dis = point_distance(_vcenter_x, _vcenter_y, x1, y1) / zoom,
	_wcenter_dir = point_direction(_vcenter_x, _vcenter_y, x1, y1) - angle,
	_px = _cx + (_cw/2) + dcos(_wcenter_dir) * _wcenter_dis,
	_py = _cy + (_ch/2) - dsin(_wcenter_dir) * _wcenter_dis;
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
}

/// @desc Transforms a 2D coordinate (in window space) to a Vector3(x, y, z) struct. Z is the camera's near plane.
/// @desc Works for both orthographic and perspective projections.
/// @param {array} view_mat The current camera view matrix.
/// @param {array} proj_mat The current camera projection matrix.
/// @param {real} x Cursor x position in window space. Example: window_mouse_get_x().
/// @param {real} y Cursor y position in window space. Example: window_mouse_get_y().
/// @returns {struct} 
function screen_to_world_dimension(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr
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
	var _xx = _matrix[0] * _matrix[5] / -_matrix[2] + _matrix[3];
	var _yy = _matrix[1] * _matrix[5] / -_matrix[2] + _matrix[4];
	return new Vector3(_xx, _yy, camera_get_near_plane(proj_mat));
}

/// @desc Transforms a 3D coordinate to a 2D coordinate. Returns a Vector2(x, y) struct. Returns Vector2(-1, -1) if the 3D point is behind the camera.
/// @desc Works for both orthographic and perspective projections.
/// @param {array} view_mat The current camera view matrix.
/// @param {array} proj_mat The current camera projection matrix.
/// @param {real} xx The x position, in world dimension.
/// @param {real} yy The y position, in world dimension.
/// @param {real} zz The z position, in world dimension.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on.
/// @returns {struct} 
function world_to_screen_dimension(view_mat, proj_mat, xx, yy, zz, normalized=false) {
	// credits: TheSnidr / FoxyOfJungle
	var _w = view_mat[2] * xx + view_mat[6] * yy + view_mat[10] * zz + view_mat[14];
	if (_w <= 0) return new Vector2(-1, -1);
	var _cx, _cy;
	if (proj_mat[15] == 0) {
		// this is a perspective projection
		_cx = proj_mat[8] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]) / _w;
		_cy = proj_mat[9] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]) / _w;
	} else {
		// this is an ortho projection
		_cx = proj_mat[12] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]);
		_cy = proj_mat[13] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]);
	}
	
	if (normalized) {
		return new Vector2((_cx*0.5+0.5), (0.5+0.5*_cy));
	} else {
		return new Vector2((_cx*0.5+0.5) * window_get_width(), (_cy*0.5+0.5) * window_get_height());
	}
}
