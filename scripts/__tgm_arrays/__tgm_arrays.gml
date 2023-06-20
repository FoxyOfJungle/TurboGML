
/// Feather ignore all

#macro SORT_ASCENDING function(a, b) {return a - b}
#macro SORT_DESCENDING function(a, b) {return b - a}

/// @desc This function returns creates a 2D array.
/// @param {real} x_size Number of columns.
/// @param {real} y_size Number of lines.
/// @param {real} value Initial value for each array index.
/// @returns {array} 
function array_create_2d(x_size, y_size, value=0) {
	var _grid = array_create(x_size, value);
	for (var i = 0; i < x_size; i++) {
		_grid[i] = array_create(y_size, value);
	}
	return _grid;
}

/// @desc This function returns creates a 2D array and executes a callback.
/// @param {real} x_size Number of columns.
/// @param {real} y_size Number of lines.
/// @param {function} func Function to execute for each index.
/// @returns {array} 
function array_create_2d_ext(x_size, y_size, func=undefined) {
	var _grid = array_create(x_size);
	for (var i = x_size; i >= 0; i--) {
		_grid[i] = array_create_ext(y_size, func);
	}
	return _grid;
}

/// @desc This function returns creates a 3D array.
/// @param {real} x_size Number of entries.
/// @param {real} y_size Number of entries.
/// @param {real} z_size Number of entries.
/// @param {real} value Initial value for each array index.
/// @returns {array} 
function array_create_3d(x_size, y_size, z_size, value=0) {
	var _grid = array_create(x_size, value);
	for (var i = x_size; i >= 0; i--) {
		_grid[i] = array_create(y_size, value);
		for(var j = y_size; j >= 0; j--) {
			_grid[i][j] = array_create(z_size, value);
		}
	}
	return _grid;
}

/// @desc This function returns the value of a random index of an array.
/// @param {array} array The array.
function array_choose(array) {
	return array[irandom(array_length(array)-1)];
}

/// @desc Calculates the sum of all numbers contained in the array.
/// @param {array} array Array to sum numbers.
/// @returns {real}
function array_sum(array) {
	var _sum = 0;
	var i = 0, isize = array_length(array);
	repeat(isize) {
		_sum += real(array[i]);
		++i;
	}
	return _sum;
}

/// @desc Returns true if the array is empty, false otherwise.
/// @param {array} array The array to check.
/// @returns {bool} 
function array_empty(array) {
	return (array_length(array) == 0);
}

/// @desc Returns the max value from an array
/// @param {array} array The array to check.
/// @returns {real,undefined} 
function array_max(array) {
	var _len = array_length(array);
	if (_len == 0) return undefined;
	var i = 0, _val = -infinity;
	repeat(_len) {
		if (array[i] > _val) _val = array[i];
		++i;	
	}
	return _val;
}

/// @desc Returns the min value from an array
/// @param {array} array The array to check.
/// @returns {real,undefined} 
function array_min(array) {
	var _len = array_length(array);
	if (_len == 0) return undefined;
	var i = 0, _val = infinity;
	repeat(_len) {
		if (array[i] < _val) _val = array[i];
		++i;	
	}
	return _val;
}

/// @desc Convert array entries to struct.
/// @param {array} array The array to convert from.
/// @returns {struct} 
function array_to_struct(array) {
	var _struct = {};
	var i = 0, isize = array_length(array);
	repeat(isize) {
		var _val = array[i];
		if (is_array(_val)) {
			_struct[$ i] = array_to_struct(_val);
		} else {
			_struct[$ i] = _val;
		}
		++i;
	}
	return _struct;
}

/// @desc Convert ds_list to array.
/// @param {Id.DsList} list The DS List to convert from.
/// @returns {array} 
function ds_list_to_array(list) {
	var _array = [];
	var i = 0, isize = ds_list_size(list);
	repeat(isize) {
		var _val = list[| i ];
		if (ds_list_is_map(list, i)) {
			_array[i] = ds_map_to_struct(_val);
		} else if (ds_list_is_list(list, i)) {
			_array[i] = ds_list_to_array(_val);
		} else {
			_array[i] = _val;
		}
		++i;
	}
	return _array;
}

/// @desc Checks whether the array contains a value, returning true or false depending.
/// @param {array} array The array to check
/// @param {any} value The value to check inside the array.
/// @returns {bool} Description
function array_contains_value(array, value) {
	var i = 0, isize = array_length(array);
	repeat(isize) {
		if (array[i] == value) return true;
		++i;
	}
	return false;
}

/// @desc Copies all array entries to a new array.
/// @param {array} from Description
/// @param {array} to Description
function array_copy_all(from, to) {
	array_copy(to, 0, from, 0, array_length(from));
}

// testing...
function array_shift(array, reverse) {
	if (reverse) {
		var _old = array[array_length(array)-1];
		array_pop(array);
		array_insert(array, 0, _old);
	} else {
		var _old = array[0];
		array_delete(array, 0, 1)
		array_push(array, _old);
	}
}

function array_shift_index(array, index, way) {
	var _len = array_length(array)-1;
	if (index+way < 0 || index > _len-way) exit;
	var _current = array[index];
	var _next = array[index + way];
	array[index + way] = _current;
	array[index] = _next;
}

