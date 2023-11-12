
/// Feather ignore all

/// @desc Get camera's field of view.
/// @param {array} proj_mat The camera projection matrix.
/// @returns {real}
function camera_get_fov(proj_mat) {
	return radtodeg(arctan(1.0/proj_mat[5]) * 2.0);
}

/// @desc Get camera's aspect ratio.
/// @param {array} proj_mat The camera projection matrix.
/// @returns {real}
function camera_get_aspect(proj_mat) {
	return proj_mat[5] / proj_mat[0];
}

/// @desc Get camera's far plane.
/// @param {array} proj_mat The camera projection matrix.
/// @returns {real}
function camera_get_far_plane(proj_mat) {
	return -proj_mat[14] / (proj_mat[10]-1);
}

/// @desc Get camera's near plane.
/// @param {array} proj_mat The camera projection matrix.
/// @returns {real}
function camera_get_near_plane(proj_mat) {
	return -2 * proj_mat[14] / (proj_mat[10]+1);
}

/// @desc Get camera's 2D rect area. Returns a Vector4(x1, y1, width, height).
/// @param {array} proj_mat The camera projection matrix.
/// @returns {real}
function camera_get_area_2d(view_mat, proj_mat) {
	var _cam_x = -view_mat[12],
		_cam_y = -view_mat[13],
		_cam_w = round(abs(2/proj_mat[0])),
		_cam_h = round(abs(2/proj_mat[5]));
	return new Vector4(_cam_x-_cam_w/2, _cam_y-_cam_h/2, _cam_w, _cam_h);
}
