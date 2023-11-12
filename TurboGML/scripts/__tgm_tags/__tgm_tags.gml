
/// Feather ignore all

/// @desc Returns the id of the tag object instances.
/// @param {String,Array} tags Tags string or array
/// @param {Bool} include_children Description
/// @returns {array} 
function tag_get_instance_ids(tags, include_children) {
	var _array = [], _count = 0,
	_asset_ids = tag_get_asset_ids(tags, asset_object), _object = noone,
	i = 0, isize = array_length(_asset_ids);
	repeat(isize) {
		_object = _asset_ids[i];
		with(_object) {
			if (!include_children && object_index != _object) continue;
			_array[_count] = id;
			++_count;
		}
		++i;
	}
	return _array;
}
