
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

/// @desc Remove all struct entries, without deleting it.
/// @param {any} struct Struct index.
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

/// @desc Returns a boolean (true or false) indicating whether the struct is empty or not.
/// @param {any} struct Struct to check.
/// @returns {bool} 
function struct_empty(struct) {
	return (variable_struct_names_count(struct) == 0);
}

/// @desc Get value from json only if exists, without returning undefined. Useful for loading game data.
/// @param {any} struct Struct to get the variable.
/// @param {string} name Variable name.
/// @param {real} default_value This value will be used if the variable is not found in the struct.
function struct_get_variable(struct, name, default_value=0) {
	if (!is_struct(struct)) return default_value;
	return struct[$ name] ?? default_value;
}

/// @desc Get and remove a variable from a struct.
/// @param {any} struct Struct to get the variable.
/// @param {string} name Variable name.
function struct_pop(struct, name) {
	var _value = struct[$ name];
	variable_struct_remove(struct, name);
	return _value;
}

/// @desc Gets variables from an instance and transforms it into a struct.
/// @param {any} inst_id Instance id.
/// @returns {struct} 
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

/// @desc Converts a struct to ds_map.
/// @param {struct} struct Struct to convert from.
/// @returns {id} 
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

/// @desc Converts a ds_map to a struct.
/// @param {id.dsmap} map ds_map index.
/// @returns {struct} 
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
