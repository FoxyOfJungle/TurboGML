
/// Feather ignore all

/// @desc Recursively copy a struct.
/// @param {Struct} struct The struct id.
/// @returns {Struct}
function struct_copy(struct) {
	if (is_array(struct)) {
		var _array = [];
		var i = 0, isize = array_length(struct);
		repeat(isize) {
			_array[i] = struct_copy(struct[i]);
			++i;
		}
		return _array;
	} else if (is_struct(struct)) {
		var _struct = {};
		var _names = variable_struct_get_names(struct);
		var i = 0, isize = array_length(_names);
		repeat(isize) {
			var _name = _names[i];
			_struct[$ _name] = struct_copy(struct[$ _name]);
			++i
		}
		return _struct;
	}
	return struct;
}


// clear the struct without deleting it
function struct_clear(struct) {
	if (is_struct(struct)) {
		var _names = variable_struct_get_names(struct);
		var i = 0, isize = array_length(_names);
		repeat(isize) {
			variable_struct_remove(struct, _names[i]);
			++i;
		}
	}
}


function struct_empty(struct) {
	return (variable_struct_names_count(struct) == 0);
}


// get value from json only if exists, without returning undefined
function struct_get_variable(struct, name, default_value=0) {
	if (!is_struct(struct)) return default_value;
	return struct[$ name] ?? default_value;
}


// get and remove a variable from a struct
function struct_pop(struct, name) {
	var _value = struct[$ name];
	variable_struct_remove(struct, name);
	return _value;
}


function struct_from_instance_variables(inst_id) {
	var _struct = {},
	_keys = variable_instance_get_names(inst_id),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = variable_instance_get(inst_id, _key);
		_struct[$ _key] = _value;
		++i;
	}
	return _struct;
}


function struct_to_ds_map(struct) {
	var _ds_map = ds_map_create(),
	_keys = variable_struct_get_names(struct),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = struct[$ _key];
		ds_map_add(_ds_map, _key, _value);
		++i;
	}
	return _ds_map;
}


function ds_map_to_struct(map) {
    var _struct = {},
    _key = ds_map_find_first(map),
	i = 0, isize = ds_map_size(map);
	repeat(isize) {
		if (ds_map_is_map(map, _key)) {
			_struct[$ _key] = ds_map_to_struct(map[? _key]);
		} else if (ds_map_is_list(map, _key)) {
			_struct[$ _key] = ds_list_to_array(map[? _key]);
		} else {
			_struct[$ _key] = map[? _key];
		}
		_key = ds_map_find_next(map, _key);
		++i;
	}
	return _struct;
}
