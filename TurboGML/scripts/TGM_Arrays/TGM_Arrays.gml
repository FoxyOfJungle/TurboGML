
/// Feather ignore all

/// @desc Calculates the sum of all members contained in the array. Works with both string and real. Returns undefined if array is empty;
/// @param {Array} array Array to sum numbers.
/// @returns {real}
function array_sum(_array) {
	var i = 1, isize = array_length(_array);
	if (isize == 0) return undefined;
	var _sum = _array[0];
	repeat(isize-1) {
		_sum += _array[i];
		++i;
	}
	return _sum;
}

/// @desc Returns true if the array is empty, false otherwise.
/// @param {Array} array The array to check.
/// @returns {bool} 
function array_is_empty(_array) {
	return (array_length(_array) == 0);
}

/// @desc Returns the max value from an array.
/// @param {Array} array The array to check.
/// @returns {real} 
function array_max(_array) {
	var i = 0, isize = array_length(_array);
	if (isize == 0) return 0;
	var _val = -infinity;
	repeat(isize) {
		if (_array[i] > _val) _val = _array[i];
		++i;	
	}
	return _val;
}

/// @desc Returns the min value from an array. If array is empty, it will returns 0.
/// @param {Array} array The array to check.
/// @returns {real} 
function array_min(_array) {
	var i = 0, isize = array_length(_array);
	if (isize == 0) return 0;
	var _val = infinity;
	repeat(isize) {
		if (_array[i] < _val) _val = _array[i];
		++i;	
	}
	return _val;
}

/// @desc Calculates the mean of an array.
/// @param {Array} array The array to check.
/// @returns {real}
function array_mean(_array) {
	var i = 0, isize = array_length(_array);
	if (isize == 0) return 0;
	var _sum = 0;
	repeat(isize) {
		_sum += _array[i];
		++i;
	}
	return _sum / isize;
}

/// @desc Calculates the median of an array.
/// @param {Array} array The array to check.
/// @returns {real}
function array_median(_array) {
	var size = array_length(_array);
	if (size == 0) return 0;
	// sort the array in ascending order
	array_sort(_array, true);
	// calculate the median
	if (size % 2 == 1) {
		// odd number of elements, so return the middle element
		return _array[size div 2];
	} else {
		// even number of elements, so return the average of the two middle elements
		var mid1 = _array[(size div 2) - 1];
		var mid2 = _array[size div 2];
		return (mid1 + mid2) / 2;
	}
}

/// @desc Convert array entries to struct.
/// @param {Array} array The array to convert from.
/// @returns {struct} 
function array_to_struct(_array) {
	var _struct = {};
	var i = 0, isize = array_length(_array);
	repeat(isize) {
		var _val = _array[i];
		if (is_array(_val)) {
			_struct[$ i] = array_to_struct(_val);
		} else {
			_struct[$ i] = _val;
		}
		++i;
	}
	return _struct;
}

/// @desc Checks whether the array contains a value, returning true or false depending. Alternative: array_contains (built-in function)
/// @param {Array} array The array to check
/// @param {any} value The value to check inside the array.
/// @returns {bool} Description
function array_contains_value(_array, _value) {
	var i = 0, isize = array_length(_array);
	repeat(isize) {
		if (_array[i++] == _value) return true;
	}
	return false;
}

/// @desc Copies all array entries to a new array.
/// @param {Array} from The source array to copy from.
/// @param {Array} to The destination array to copy to.
function array_copy_all(_from, _to) {
	array_copy(_to, 0, _from, 0, array_length(_from));
}

/// @desc Move all elements of an array in the given way.
/// @param {Array} array The array to shift.
/// @param {Array} times How many times to shift array values.
/// @param {bool} reverse Reverse order?
function array_shift_indexes(_array, times, _reverse=false) {
	if (_reverse) {
		repeat(times) {
			var _old = _array[array_length(_array)-1];
			array_pop(_array);
			array_insert(_array, 0, _old);
		}
	} else {
		repeat(times) {
			var _old = _array[0];
			array_delete(_array, 0, 1);
			array_push(_array, _old);
		}
	}
}

/// @desc Swap a single index of an array.
/// @param {Array} array The array to be used.
/// @param {real} index The array position to swap to another position.
/// @param {real} offset The offset to swap the element. 0 will have no effect, 1 will swap with the next element. -1 will swap with the previous element and so on. You can use other numbers.
function array_swap_index(_array, _index, _offset) {
	var _len = array_length(_array)-1;
	if (_index+_offset < 0 || _index > _len-_offset) exit;
	var _current = _array[_index];
	var _next = _array[_index + _offset];
	_array[_index + _offset] = _current;
	_array[_index] = _next;
}

/// @desc Find the number closest to the reference value in an array.
/// @param {Array} array The array to bse used.
/// @param {Real} value The array to bse used.
function array_find_closest_number(_array, _value) {
	var _closestIndex = -1;
	var _closestDiff = abs(_value - _array[0]);
	for(var i = 1; i < array_length(_array); i++) {
		var _diff = abs(_value - _array[i]);
		if (_diff < _closestDiff) {
			_closestDiff = _diff;
			_closestIndex = i;
		}
	}
	return _array[_closestIndex];
}

/// @desc This function returns a random value from an array.
/// @param {Array} array The array.
function array_get_random(_array) {
	return _array[irandom(array_length(_array)-1)];
}

/// @desc This function returns the value of a random index of an array. But now it is possible to wrap the offset.
/// @param {Array} array The array.
/// @param {Real} offset The position to get the nexts values from. Default is 0. It can be negative as much as it can be greater than the array size.
/// @param {Real} length The amount of items to get, from the offset. Default is the size of the array.
function array_get_random_ext(_array, _offset=0, _length=undefined) {
	var _arrayLen = array_length(_array);
	_length ??= _arrayLen;
	_offset = mod_wrap(_offset, _arrayLen + 1);
	_length = mod_wrap(_length, _arrayLen + 1 - _offset);
	if (_length == 0) return undefined;
	return _array[irandom_range(_offset, _offset + _length - 1)];
}

/// @desc This function returns a random index of an array.
/// @param {Array} array The array.
function array_get_random_index(_array) {
	return irandom(array_length(_array)-1);
}

/// @desc This function returns a random index of an array. But now it is possible to wrap the offset.
/// @param {Real} offset The position to get the nexts values from. Default is 0. It can be negative as much as it can be greater than the array size.
/// @param {Real} length The amount of items to get, from the offset. Default is the size of the array.
function array_get_random_index_ext(_array, _offset=0, _length=undefined) {
	var _arrayLen = array_length(_array);
	_length ??= _arrayLen;
	_offset = mod_wrap(_offset, _arrayLen + 1);
	_length = mod_wrap(_length, _arrayLen + 1 - _offset);
	if (_length == 0) return undefined;
	return irandom_range(_offset, _offset + _length - 1);
}

/// @desc This function returns creates a 2D array.
/// @param {real} xSize Number of columns.
/// @param {real} ySize Number of lines.
/// @param {real} value Initial value for each array index.
/// @returns {Array} 
function array_create_2d(_xSize, _ySize, _value=0) {
	var _grid = array_create(_xSize, _value);
	for (var i = 0; i < _xSize; i++) {
		_grid[i] = array_create(_ySize, _value);
	}
	return _grid;
}

/// @desc This function returns creates a 2D array and executes a callback.
/// @param {real} xSize Number of columns.
/// @param {real} ySize Number of lines.
/// @param {function} func Function to execute for each index.
/// @returns {Array} 
function array_create_2d_ext(_xSize, _ySize, _func=undefined) {
	var _grid = array_create(_xSize);
	for (var i = _xSize; i >= 0; i--) {
		_grid[i] = array_create_ext(_ySize, _func);
	}
	return _grid;
}

/// @desc This function returns creates a 3D array.
/// @param {real} xSize Number of entries.
/// @param {real} ySize Number of entries.
/// @param {real} zSize Number of entries.
/// @param {real} value Initial value for each array index.
/// @returns {Array} 
function array_create_3d(_xSize, _ySize, _zSize, _value=0) {
	var _grid = array_create(_xSize, _value);
	for (var i = _xSize; i >= 0; i--) {
		_grid[i] = array_create(_ySize, _value);
		for(var j = _ySize; j >= 0; j--) {
			_grid[i][j] = array_create(_zSize, _value);
		}
	}
	return _grid;
}

/// @desc Generates an array with random sequencial numbers. Useful for procedural generation or non-repeating music sequence. Should return something like: [7,4,2,1,8,9,6,5,0,3].
/// @param {real} length Array size. Number of values to generate, from 0.
function array_create_random_sequence(_length) {
	var _array = [];
	var i = 0;
	repeat(_length) {
		_array[i] = i;
		++i;
	}
	_array = array_shuffle(_array);
	return _array;
}

/// @desc Works like array_create_random_sequence(), but you can pass a function.
/// @param {real} length Array size.
/// @param {function,method} func The function or method to execute.
/// @returns {Array} 
function array_create_random_sequence_ext(_length, _func=undefined) {
	var _funct = _func;
	if (is_undefined(_funct)) {
		_funct = function(_val) {
			return _val;
		}
	}
	var _array = [], _val;
	var i = 0;
	repeat(_length) {
		_val = _funct(i);
		if (!is_undefined(_val)) _array[i] = _val;
		++i;
	}
	_array = array_shuffle(_array);
	return _array;
}
