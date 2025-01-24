
/// Feather ignore all

/// @desc This function converts the coordinates of the room to the GUI dimension. Returns a Vector2(x, y) struct.
/// @param {real} x The x position to convert from.
/// @param {real} y The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} guiWidth The GUI width.
/// @param {real} guiHeight The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on
/// @returns {struct} 
function room_to_gui_dimension(_x, _y, _camera, _guiWidth, _guiHeight, normalize) {
	var _px = (_x - camera_get_view_x(_camera)) * (_guiWidth / camera_get_view_width(_camera)),
		_py = (_y - camera_get_view_y(_camera)) * (_guiHeight / camera_get_view_height(_camera));
	return normalize ? new Vector2(_px / _guiWidth, _py / _guiHeight) : new Vector2(_px, _py);
}

/// @desc This function converts the coordinates of the GUI to the room dimension. Returns a Vector2(x, y) struct.
/// @param {real} x The x position to convert from.
/// @param {real} y The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} angle The camera angle.
/// @param {real} guiWidth The GUI width.
/// @param {real} guiHeight The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on
/// @returns {struct} 
function room_to_gui_dimension_ext(_x, _y, _camera, angle, _guiWidth, _guiHeight, normalize) {
	var _cw = camera_get_view_width(_camera),
		_ch = camera_get_view_height(_camera),
		_vcenterX = camera_get_view_x(_camera) + (_cw / 2),
		_vcenterY = camera_get_view_y(_camera) + (_ch / 2),
		_zoom = _guiWidth / _cw,
		_wcenterDis = point_distance(_vcenterX, _vcenterY, _x, _y) * _zoom,
		_wcenterDir = point_direction(_vcenterX, _vcenterY, _x, _y) + angle,
		_px = (_guiWidth / 2) + dcos(_wcenterDir) * _wcenterDis,
		_py = (_guiHeight / 2) - dsin(_wcenterDir) * _wcenterDis;
	return normalize ? new Vector2(_px / _guiWidth, _py / _guiHeight) : new Vector2(_px, _py);
}

/// @desc This function converts the coordinates of the GUI to the room dimension, with additional angle parameter. Returns a Vector2(x, y) struct.
/// @param {real} x The x position to convert from.
/// @param {real} y The y position to convert from.
/// @param {id.camera} camera The current camera in use.
/// @param {real} angle The camera angle.
/// @param {real} guiWidth The GUI width.
/// @param {real} guiHeight The GUI height.
/// @param {bool} normalize If enabled, the value will be returned from 0 to 1 - useful for shaders and so on.
/// @returns {struct} 
function gui_to_room_dimension_ext(_x, _y, _camera, angle, _guiWidth, _guiHeight, normalize) {
	var _cx = camera_get_view_x(_camera),
		_cy = camera_get_view_y(_camera),
		_cw = camera_get_view_width(_camera),
		_ch = camera_get_view_height(_camera),
		_vcenterX = _guiWidth / 2,
		_vcenterY = _guiHeight / 2,
		_zoom = _guiWidth / _cw,
		_wcenterDis = point_distance(_vcenterX, _vcenterY, _x, _y) / _zoom,
		_wcenterDir = point_direction(_vcenterX, _vcenterY, _x, _y) - angle,
		_px = _cx + (_cw / 2) + dcos(_wcenterDir) * _wcenterDis,
		_py = _cy + (_ch / 2) - dsin(_wcenterDir) * _wcenterDis;
	return normalize ? new Vector2(_px / _guiWidth, _py / _guiHeight) : new Vector2(_px, _py);
}

/// @desc Transforms a 2D coordinate (in window space) to a Vector3(x, y, z) struct. Z is the camera's near plane.
/// @desc Works for both orthographic and perspective projections.
/// @param {array} viewMatrix The current camera view matrix.
/// @param {array} projectionMatrix The current camera projection matrix.
/// @param {real} x The x position. Can be mouse position. Example: window_mouse_get_x() or device_mouse_x_to_gui().
/// @param {real} y The y position. Can be mouse position. Example: window_mouse_get_y() or device_mouse_y_to_gui().
/// @param {real} canvasWidth The canvas width. Can be window or GUI width.
/// @param {real} canvasHeight The canvas height. Can be window or GUI height.
/// @returns {struct} 
function screen_to_world_dimension(_viewMatrix, _projectionMatrix, _x, _y, _canvasWidth, _canvasHeight) {
	// credits: TheSnidr
	var _mx = 2 * (_x / window_get_width() - 0.5) / _projectionMatrix[0];
	var _my = 2 * (_y / window_get_height() - 0.5) / _projectionMatrix[5];
	var _camX = - (_viewMatrix[12] * _viewMatrix[0] + _viewMatrix[13] * _viewMatrix[1] + _viewMatrix[14] * _viewMatrix[2]);
	var _camY = - (_viewMatrix[12] * _viewMatrix[4] + _viewMatrix[13] * _viewMatrix[5] + _viewMatrix[14] * _viewMatrix[6]);
	var _camZ = - (_viewMatrix[12] * _viewMatrix[8] + _viewMatrix[13] * _viewMatrix[9] + _viewMatrix[14] * _viewMatrix[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (_projectionMatrix[15] == 0) {
		// perspective projection
		_matrix = [
			_viewMatrix[2]  + _mx * _viewMatrix[0] + _my * _viewMatrix[1],
			_viewMatrix[6]  + _mx * _viewMatrix[4] + _my * _viewMatrix[5],
			_viewMatrix[10] + _mx * _viewMatrix[8] + _my * _viewMatrix[9],
			_camX,
			_camY,
			_camZ
		];
	} else {
		// orthographic projection
		_matrix = [
			_viewMatrix[2],
			_viewMatrix[6],
			_viewMatrix[10],
			_camX + _mx * _viewMatrix[0] + _my * _viewMatrix[1],
			_camY + _mx * _viewMatrix[4] + _my * _viewMatrix[5],
			_camZ + _mx * _viewMatrix[8] + _my * _viewMatrix[9]
		];
	}
	var _xx = _matrix[0] * _matrix[5] / -_matrix[2] + _matrix[3];
	var _yy = _matrix[1] * _matrix[5] / -_matrix[2] + _matrix[4];
	return new Vector3(_xx, _yy, camera_get_near_plane(_projectionMatrix));
}

/// @desc Transforms a 3D coordinate to a 2D coordinate. Returns a Vector2(x, y) struct, where x and y goes from 0 to 1 - you can multiply it with GUI size. Returns Vector2(-1, -1) if the 3D point is behind the camera.
/// @desc Works for both orthographic and perspective projections.
/// @param {array} viewMatrix The current camera view matrix.
/// @param {array} projectionMatrix The current camera projection matrix.
/// @param {real} x The x position, in world dimension.
/// @param {real} y The y position, in world dimension.
/// @param {real} z The z position, in world dimension.
/// @param {real} canvasWidth The canvas width. Can be GUI or window width.
/// @param {real} canvasHeight The canvas height. Can be GUI or window height.
/// @returns {struct} 
function world_to_screen_dimension(_viewMatrix, _projectionMatrix, _x, _y, _z, _canvasWidth=1, _canvasHeight=1) {
	// credits: TheSnidr / FoxyOfJungle
	var _w = _viewMatrix[2] * _x + _viewMatrix[6] * _y + _viewMatrix[10] * _z + _viewMatrix[14];
	if (_w <= 0) return new Vector2(-1, -1);
	var _cx, _cy;
	if (_projectionMatrix[15] == 0) {
		// this is a perspective projection
		_cx = _projectionMatrix[8] + _projectionMatrix[0] * (_viewMatrix[0] * _x + _viewMatrix[4] * _y + _viewMatrix[8] * _z + _viewMatrix[12]) / _w;
		_cy = _projectionMatrix[9] + _projectionMatrix[5] * (_viewMatrix[1] * _x + _viewMatrix[5] * _y + _viewMatrix[9] * _z + _viewMatrix[13]) / _w;
	} else {
		// this is an ortho projection
		_cx = _projectionMatrix[12] + _projectionMatrix[0] * (_viewMatrix[0] * _x + _viewMatrix[4] * _y + _viewMatrix[8] * _z + _viewMatrix[12]);
		_cy = _projectionMatrix[13] + _projectionMatrix[5] * (_viewMatrix[1] * _x + _viewMatrix[5] * _y + _viewMatrix[9] * _z + _viewMatrix[13]);
	}
	// returns normalized value from 0 to 1
	return new Vector2((_cx * 0.5 + 0.5) * _canvasWidth, (_cy * 0.5 + 0.5) * _canvasHeight);
}
