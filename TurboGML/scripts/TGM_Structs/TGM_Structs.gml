
/// Feather ignore all

/// @desc Recursively copy a struct. Alternative to variable_clone().
/// @param {Struct} struct The struct id.
/// @returns {Struct}
function struct_copy(_struct) {
	if (is_array(_struct)) {
		var _array = [];
		var i = 0, _isize = array_length(_struct);
		repeat(_isize) {
			_array[i] = struct_copy(_struct[i]);
			++i;
		}
		return _array;
	} else if (is_struct(_struct)) {
		var _newStruct = {};
		var _names = variable_struct_get_names(_struct);
		var i = 0, _isize = array_length(_names);
		repeat(_isize) {
		var _name = _names[i];
			_newStruct[$ _name] = struct_copy(_struct[$ _name]);
			++i;
		}
		return _newStruct;
	}
	return _struct;
}

/// @desc Remove all struct entries, without deleting it.
/// @param {any} struct Struct index.
function struct_clear(_struct) {
	if (is_struct(_struct)) {
		var _names = variable_struct_get_names(_struct);
		var i = 0, _isize = array_length(_names);
		repeat(_isize) {
			variable_struct_remove(_struct, _names[i]);
			++i;
		}
	}
}

/// @desc Returns a boolean (true or false) indicating whether the struct is empty or not.
/// @param {any} struct Struct to check.
/// @returns {bool} 
function struct_is_empty(_struct) {
	return (variable_struct_names_count(_struct) == 0);
}

/// @desc Get value from json only if exists, without returning undefined. Useful for loading game data.
/// @param {any} struct Struct to get the variable.
/// @param {string} name Variable name.
/// @param {real} defaultValue This value will be used if the variable is not found in the struct.
function struct_get_variable(_struct, _name, _defaultValue=0) {
	if (!is_struct(_struct)) return _defaultValue;
	return _struct[$ _name] ?? _defaultValue;
}

/// @desc Get and remove a variable from a struct.
/// @param {any} struct Struct to get the variable.
/// @param {string} name Variable name.
function struct_pop(_struct, _name) {
	var _value = _struct[$ _name];
	variable_struct_remove(_struct, _name);
	return _value;
}

/// @desc Gets variables from an instance and transforms it into a struct.
/// @param {any} inst_id Instance id.
/// @returns {struct} 
function struct_from_instance_variables(_instanceId) {
	var _struct = {},
	_keys = variable_instance_get_names(_instanceId),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = variable_instance_get(_instanceId, _key);
		_struct[$ _key] = _value;
		++i;
	}
	return _struct;
}

/// @desc Converts a struct to ds_map.
/// @param {struct} struct Struct to convert from.
/// @returns {id} 
function struct_to_ds_map(_struct) {
	var _ds_map = ds_map_create(),
	_keys = variable_struct_get_names(_struct),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = _struct[$ _key];
		ds_map_add(_ds_map, _key, _value);
		++i;
	}
	return _ds_map;
}

/// @desc Converts a ds_map to a struct.
/// @param {id.dsmap} map ds_map index.
/// @returns {struct} 
function ds_map_to_struct(_map) {
	var _struct = {},
		_key = ds_map_find_first(_map),
		i = 0, isize = ds_map_size(_map);
	repeat(isize) {
		if (ds_map_is_map(_map, _key)) {
			_struct[$ _key] = ds_map_to_struct(_map[? _key]);
		} else if (ds_map_is_list(_map, _key)) {
			_struct[$ _key] = ds_list_to_array(_map[? _key]);
		} else {
			_struct[$ _key] = _map[? _key];
		}
		_key = ds_map_find_next(_map, _key);
		++i;
	}
	return _struct;
}
