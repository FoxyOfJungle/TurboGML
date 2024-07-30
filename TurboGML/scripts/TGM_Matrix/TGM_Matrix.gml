
/// Feather ignore all

/// @desc Returns the position from a matrix.
/// @param {array} matrix The matrix.
/// @returns {struct} Vector3(x, y, z)
function matrix_get_position(_matrix) {
	return new Vector3(_matrix[12], _matrix[13], _matrix[14]);
}

/// @desc Returns the scale from a matrix.
/// @param {array} matrix The matrix.
/// @returns {struct} Vector3(scalex, scaley, scalez)
function matrix_get_scale(_matrix) {
	var xScl = sqrt(_matrix[0] * _matrix[0] + _matrix[1] * _matrix[1] + _matrix[2] * _matrix[2]);
	var yScl = sqrt(_matrix[4] * _matrix[4] + _matrix[5] * _matrix[5] + _matrix[6] * _matrix[6]);
	var zScl = sqrt(_matrix[8] * _matrix[8] + _matrix[9] * _matrix[9] + _matrix[10] * _matrix[10]);
	return new Vector3(xScl, yScl, zScl);
}

/// @desc Returns the x position from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_x(_matrix) {
	gml_pragma("forceinline");
	return _matrix[12];
}
/// @desc Returns the y position from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_y(_matrix) {
	gml_pragma("forceinline");
	return _matrix[13];
}
/// @desc Returns the z position from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_z(_matrix) {
	gml_pragma("forceinline");
	return _matrix[14];
}

/// @desc Returns the x scale from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_xscale(_matrix) {
	gml_pragma("forceinline");
	return sqrt(_matrix[0] * _matrix[0] + _matrix[1] * _matrix[1] + _matrix[2] * _matrix[2]);
}

/// @desc Returns the y scale from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_yscale(_matrix) {
	gml_pragma("forceinline");
	return sqrt(_matrix[0] * _matrix[0] + _matrix[1] * _matrix[1] + _matrix[2] * _matrix[2]);
}

/// @desc Returns the z scale from a matrix.
/// @param {array} matrix The matrix.
/// @returns {Real}
function matrix_get_zscale(_matrix) {
	gml_pragma("forceinline");
	return sqrt(_matrix[0] * _matrix[0] + _matrix[1] * _matrix[1] + _matrix[2] * _matrix[2]);
}
