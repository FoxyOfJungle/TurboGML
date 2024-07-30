
/// Feather ignore all

/// @desc Get the top instance of a layer (without conflicting with other layers)
/// @param {real} px The x position to check.
/// @param {real} py The y position to check.
/// @param {real} layer_id The layer id.
/// @returns {id} 
function layer_instance_top_position(_px, _py, _layerId) {
	var _topInstance = noone;
	if (layer_exists(_layerId) && layer_get_visible(_layerId)) {
		var _list = ds_list_create();
		var _elements = layer_get_all_elements(_layerId);
		var _isize = array_length(_elements), i = _isize - 1;
		repeat(_isize) {
			if (layer_get_element_type(_elements[i]) == layerelementtype_instance) {
			    var _instance = layer_instance_get_instance(_elements[i]);
				if (instance_exists(_instance)) {
					if (position_meeting(_px, _py, _instance)) ds_list_add(_list, _instance);
				}
			}
			--i;
		}
		var _num = ds_list_size(_list);
		if (_num > 0) {
			i = 0;
			repeat(_num) {
				_topInstance = _list[| ds_list_size(_list) - 1];
				++i;
			}
		}
		ds_list_destroy(_list);
	}
	return _topInstance;
}

/// @desc Get instance count from a specific layer.
/// @param {real} layerId The layer id.
/// @returns {real} 
function layer_instance_count(_layer_id) {
	return layer_exists(_layer_id) ? array_length(layer_get_all_elements(_layer_id)) : 0;
}
