
/// Feather ignore all

/// @desc Get camera's field of view.
/// @param {array} projMat The camera projection matrix.
/// @returns {real}
function camera_get_fov(_projMat) {
	return radtodeg(arctan(1.0/_projMat[5]) * 2.0);
}

/// @desc Get camera's aspect ratio.
/// @param {array} projMat The camera projection matrix.
/// @returns {real}
function camera_get_aspect(_projMat) {
	return _projMat[5] / _projMat[0];
}

/// @desc Get camera's far plane.
/// @param {array} projMat The camera projection matrix.
/// @returns {real}
function camera_get_far_plane(_projMat) {
	return -_projMat[14] / (_projMat[10]-1);
}

/// @desc Get camera's near plane.
/// @param {array} projMat The camera projection matrix.
/// @returns {real}
function camera_get_near_plane(_projMat) {
	return -2 * _projMat[14] / (_projMat[10]+1);
}

/// @desc Get camera's 2D rectangle area. Returns a Vector4(x1, y1, width, height).
/// @param {array} viewMat The camera view matrix.
/// @param {array} projMat The camera projection matrix.
/// @returns {real}
function camera_get_rect(_viewMat, _projMat) {
	var _viewX = -_viewMat[12],
		_viewY = -_viewMat[13],
		_viewW = round(abs(2/_projMat[0])),
		_viewH = round(abs(2/_projMat[5]));
	return new Vector4(_viewX-_viewW/2, _viewY-_viewH/2, _viewW, _viewH);
}
