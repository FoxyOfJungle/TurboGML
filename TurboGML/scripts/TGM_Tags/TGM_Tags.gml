
/// Feather ignore all

/// @desc Returns the id of the tag object instances.
/// @param {String,Array} tags Tags string or array
/// @param {Bool} includeChildren If true, will include children instances.
/// @returns {array} 
function tag_get_instance_ids(_tags, _includeChildren) {
	var _array = [], _count = 0;
	var _assetIds = tag_get_asset_ids(_tags, asset_object);
	var _object = noone;
	var i = 0, _isize = array_length(_assetIds);
	repeat(_isize) {
		_object = _assetIds[i];
		with(_object) {
			if (!_includeChildren && object_index != _object) continue;
			_array[_count] = id;
			++_count;
		}
		++i;
	}
	return _array;
}
