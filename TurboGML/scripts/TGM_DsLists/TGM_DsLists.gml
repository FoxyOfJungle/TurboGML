
/// Feather ignore all
/// @desc This function returns the value of a random index of an list.
/// @param {Id.DsList} list The list.
function ds_list_get_random(_list) {
	return _list[| irandom(ds_list_size(_list)-1)];
}

/// @desc Calculates the sum of all members contained in the list. Works with both string and real. Returns undefined if list is empty;
/// @param {Id.DsList} list Array to sum numbers.
/// @returns {real, undefined}
function ds_list_sum(_list) {
	var i = 1, isize = ds_list_size(_list);
	if (isize == 0) return undefined;
	var _sum = _list[| 0];
	repeat(isize-1) {
		_sum += _list[| i];
		++i;
	}
	return _sum;
}

/// @desc Returns true if the list is empty, false otherwise.
/// @param {Id.DsList} list The list to check.
/// @returns {bool} 
function ds_list_is_empty(_list) {
	return (ds_list_size(_list) == 0);
}

/// @desc Returns the max value from an list.
/// @param {Id.DsList} list The list to check.
/// @returns {real} 
function ds_list_max(_list) {
	var i = 0, isize = ds_list_size(_list);
	if (isize == 0) return 0;
	var _val = -infinity;
	repeat(isize) {
		if (_list[| i] > _val) _val = _list[| i];
		++i;	
	}
	return _val;
}

/// @desc Returns the min value from an list. If list is empty, it will returns 0.
/// @param {Id.DsList} list The list to check.
/// @returns {real} 
function ds_list_min(_list) {
	var i = 0, isize = ds_list_size(_list);
	if (isize == 0) return 0;
	var _val = infinity;
	repeat(isize) {
		if (_list[| i] < _val) _val = _list[| i];
		++i;	
	}
	return _val;
}

/// @desc Calculates the mean of an ds_list.
/// @param {Id.DsList} list The list to check.
/// @returns {real}
function ds_list_mean(_list) {
	var i = 0, isize = ds_list_size(_list);
	if (isize == 0) return 0;
	var _sum = 0;
	repeat(isize) {
		_sum += _list[| i];
		++i;
	}
	return _sum / isize;
}

/// @desc Calculates the median of an list.
/// @param {Id.DsList} list The list to check.
/// @returns {real}
function ds_list_median(_list) {
	var size = ds_list_size(_list);
	if (size == 0) return 0;
	// sort the list in ascending order
	ds_list_sort(_list, true);
	// calculate the median
	if (size % 2 == 1) {
		// odd number of elements, so return the middle element
		return _list[| size div 2];
	} else {
		// even number of elements, so return the average of the two middle elements
		var mid1 = _list[| (size div 2) - 1];
		var mid2 = _list[| size div 2];
		return (mid1 + mid2) / 2;
	}
}

/// @desc Checks whether the list contains a value, returning true or false depending.
/// @param {Id.DsList} list The list to check.
/// @param {any} value The value to check inside the list.
/// @returns {bool} Description
function ds_list_contains_value(_list, _value) {
	var i = 0, isize = ds_list_size(_list);
	repeat(isize) {
		if (_list[| i++] == _value) return true;
	}
	return false;
}

/// @desc With this function, you can sort a ds_list using a function. NOTE: array_sort() is much faster...
/// @param {Id.DsList} list The list to sort.
/// @param {Function} sortFunc The sort function. It should return -1 (a < b), 0 (equal) or 1 (a > b).
function ds_list_sort_ext(_list, _sortFunc=SORT_ASCENDING) {
	// do a sort using the Bubble Sort algorigthm
	var i, j, n = ds_list_size(_list);
	for (i = 0; i < n; i++) {
	    for (j = 0; j < n-1-i; j++) {
	        //if (_list[| j].order > _list[| j+1].order) {
			if (_sortFunc(_list[| j], _list[| j+1]) > 0) {
	            var temp = _list[| j];
	            _list[| j] = _list[| j+1];
	            _list[| j+1] = temp;
	        }
	    }
	}
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
