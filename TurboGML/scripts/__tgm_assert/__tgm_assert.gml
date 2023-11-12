
/// Feather ignore all

/// @desc The function checks if a given condition is true for at least one element in an array.
/// @param {any} condition Description
/// @param {array} values_array Description
/// @returns {bool} Description
function assert_array_or(condition, values_array) {
	var i = 0, isize = array_length(values_array);
	repeat(isize) {
		if (condition == values_array[i]) return true;
		++i;
	}
	return false;
}

/// @desc The function checks if a given condition is true for all elements in an array.
/// @param {any} condition Description
/// @param {array} values_array Description
/// @returns {bool} Description
function assert_array_and(condition, values_array) {
	var i = 0, isize = array_length(values_array);
	repeat(isize) {
		if (condition != values_array[i]) return false;
		++i;
	}
	return true;
}
