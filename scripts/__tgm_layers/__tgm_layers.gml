
/// Feather ignore all

// get the top instance of a layer (without conflicting with other layers)
function layer_instance_top_position(px, py, layer_id) {
	var _top_instance = noone;
	if (layer_exists(layer_id) && layer_get_visible(layer_id)) {
		var _list = ds_list_create();
		var _elements = layer_get_all_elements(layer_id);
		var isize = array_length(_elements), i = isize-1;
		repeat(isize) {
			if (layer_get_element_type(_elements[i]) == layerelementtype_instance) {
			    var _inst = layer_instance_get_instance(_elements[i]);
				if instance_exists(_inst) {
					if position_meeting(px, py, _inst) ds_list_add(_list, _inst);
				}
			}
			--i;
		}
		var _num = ds_list_size(_list);
		if (_num > 0) {
			i = 0;
			repeat(_num) {
				_top_instance = _list[| ds_list_size(_list)-1];
				++i;
			}
		}
		ds_list_destroy(_list);
	}
	return _top_instance;
}


function layer_instance_count(layer_id) {
	return layer_exists(layer_id) ? array_length(layer_get_all_elements(layer_id)) : 0;
}
