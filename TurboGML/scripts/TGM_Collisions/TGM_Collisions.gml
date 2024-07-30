
/// Feather ignore all

/// @desc This function returns a boolean (true or false) depending on whether the position is inside a triangle.
/// @param {real} px The x position, example: mouse_x.
/// @param {real} py The y position, example: mouse_y.
/// @param {real} x The x origin of the cone.
/// @param {real} y The y origin of the cone.
/// @param {real} angle The cone angle/direction.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
/// @returns {bool}
function point_in_cone(_px, _py, _x, _y, _angle, _dist, _fov) {
	var _lenX1 = dcos(_angle - _fov / 2) * _dist,
		_lenY1 = dsin(_angle - _fov / 2) * _dist,
		_lenX2 = dcos(_angle + _fov / 2) * _dist,
		_lenY2 = dsin(_angle + _fov / 2) * _dist;
	return point_in_triangle(_px, _py, _x, _y, _x + _lenX1, _y - _lenY1, _x + _lenX2, _y - _lenY2);
}

/// @desc This function returns a boolean (true or false) depending on whether the position is inside a arc.
/// @param {real} px The x position, example: mouse_x.
/// @param {real} py The y position, example: mouse_y.
/// @param {real} x The x origin of the cone.
/// @param {real} y The y origin of the cone.
/// @param {real} angle The cone angle/direction.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
/// @returns {bool} Description
function point_in_arc(_px, _py, _x, _y, _angle, _dist, _fov) {
	return (point_distance(_px, _py, _x, _y) < _dist && abs(angle_difference(_angle, point_direction(_x, _y, _px, _py))) < _fov/2);
}

/// @desc Checks if a point is inside a parallelogram.
/// @param {real} x The x position to check.
/// @param {real} y The y position to check.
/// @param {array} parallelogram Parallelogram points.
/// @returns {bool} 
function point_in_parallelogram(_px, _py, _parallelogram) {
	// in first
	if (point_in_triangle(_px, _py, _parallelogram[0], _parallelogram[1], _parallelogram[2], _parallelogram[3], _parallelogram[6], _parallelogram[7])) return true;
	// in second
	if (point_in_triangle(_px, _py, _parallelogram[4], _parallelogram[5], _parallelogram[2], _parallelogram[3], _parallelogram[6], _parallelogram[7])) return true;
	return false;
}

/// @desc This function is used to check collisions without slope support.
/// @param {real} hspd The horizontal vector speed.
/// @param {real} vspd The vertical vector speed.
/// @param {any} object Object to check collision with.
/// @returns {struct} 
function move_and_collide_simple(_hspd, _vspd, _object) {
    var _vx = sign(_hspd),
        _vy = sign(_vspd),
        _col = noone,
        _horColliding = false,
        _verColliding = false,
        _collisionId = noone;
    
    _col = instance_place(x + _hspd, y, _object);
    if (_col != noone) {
        repeat(abs(_hspd) + 1) {
            if (place_meeting(x + _vx, y, _object)) break;
            x += _vx;
        }
        _hspd = 0;
        _horColliding = true;
        _collisionId = _col;
    }
    x += _hspd;
    
    _col = instance_place(x, y + _vspd, _object);
    if (_col != noone) {
        repeat(abs(_vspd) + 1) {
            if (place_meeting(x, y + _vy, _object)) break;
            y += _vy;
        }
        _vspd = 0;
        _verColliding = true;
        _collisionId = _col;
    }
    y += _vspd;
    
    return new Vector3(_horColliding, _verColliding, _collisionId);
}

/// @desc This function is used to check collisions based on tags, without slope support.
/// @param {real} hspd The horizontal vector speed.
/// @param {real} vspd The vertical vector speed.
/// @param {String, Array<String>} tags Tags string or array
/// @returns {struct} 
function move_and_collide_simple_tag(_hspd, _vspd, _tags) {
	var _pri = ds_priority_create();
	// search for tag objects
	var _objectIdsArray = tag_get_asset_ids(_tags, asset_object),
		_i = 0, 
		_isize = array_length(_objectIdsArray);
	repeat(_isize) {
		var _object = _objectIdsArray[_i];
		ds_priority_add(_pri, _object, distance_to_object(_object));
		++_i;
	}
	var _obj = ds_priority_find_min(_pri);
	ds_priority_destroy(_pri);
	return move_and_collide_simple(_hspd, _vspd, _obj);
}

/// @desc Gets the instance with the highest depth, regardless of the layer
/// @param {real} px The x position to check.
/// @param {real} py The y position to check.
/// @param {any*} object The object to check.
/// @returns {id} 
function instance_top_position(_px, _py, _object) {
    var _topInstance = noone,
        _list = ds_list_create(),
        _num = collision_point_list(_px, _py, _object, false, true, _list, false);
    if (_num > 0) {
        var i = 0;
        repeat(_num) {
            _topInstance = _list[| ds_list_size(_list) - 1];
            ++i;
        }
    }
    ds_list_destroy(_list);
    return _topInstance;
}

/// @desc Get the number of instances of a specific object.
/// @param {asset.gmobject} object The object asset.
/// @returns {real} 
function instance_number_object(_object) {
	var _number = 0;
	with(_object) {
		if (object_index == _object) _number++;
	}
	return _number;
}

/// @desc Gets the nearest instance of an object, based on x and y position.
/// @param {Real} x The x position to check from.
/// @param {Real} y The y position to check from.
/// @param {Id.GMObject} object Object asset index.
/// @param {Real} number The position number.
/// @returns {id} 
function instance_nearest_nth(_x, _y, _object, _number) {
	//if (!instance_exists(_object)) return noone;
	var _px = _x,
		_py = _y,
		_inst = noone,
		_pri = ds_priority_create(),
		_i = 0;
	with(_object) {
		if (self == _object) continue;
		ds_priority_add(_pri, id, distance_to_point(_px, _py));
		++_i;
	}
	var _numb = min(_i, max(1, _number));
		repeat(_numb) {
		_inst = ds_priority_delete_min(_pri);
	}
	ds_priority_destroy(_pri);
	return _inst;
}

/// @desc Gets the farthest instance of an object, based on x and y position.
/// @param {Real} x The x position to check from.
/// @param {Real} y The y position to check from.
/// @param {Id.GMObject} object Object asset index.
/// @param {Real} number The position number.
/// @returns {id} 
function instance_farthest_nth(_x, _y, _object, _number) {
	//if (!instance_exists(_object)) return noone;
	var _px = _x,
		_py = _y,
		_inst = noone,
		_pri = ds_priority_create(),
		_i = 0;
	with(_object) {
		if (self == _object) continue;
		ds_priority_add(_pri, id, distance_to_point(_px, _py));
		++_i;
	}
	var _numb = min(_i, max(1, _number));
		repeat(_numb) {
		_inst = ds_priority_delete_max(_pri);
	}
	ds_priority_destroy(_pri);
	return _inst;
}
