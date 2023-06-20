
/// Feather ignore all

/// @desc This function returns a boolean (true or false) depending on whether the position is inside a triangle.
/// @param {real} px The x position, example: mouse_x.
/// @param {real} py The y position, example: mouse_y.
/// @param {real} x The x origin of the cone
/// @param {real} y The y origin of the cone
/// @param {real} angle The cone angle/direction.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
/// @returns {bool}
function point_in_cone(px, py, x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist,
	_len_y1 = dsin(angle - fov/2) * dist,
	_len_x2 = dcos(angle + fov/2) * dist,
	_len_y2 = dsin(angle + fov/2) * dist;
    return point_in_triangle(px, py, x, y, x+_len_x1, y-_len_y1, x+_len_x2, y-_len_y2);
}

/// @desc This function returns a boolean (true or false) depending on whether the position is inside a arc.
/// @param {real} px The x position, example: mouse_x.
/// @param {real} py The y position, example: mouse_y.
/// @param {real} x The x origin of the cone
/// @param {real} y The y origin of the cone
/// @param {real} angle The cone angle/direction.
/// @param {real} dist The cone distance.
/// @param {real} fov The cone field of view.
/// @returns {bool} Description
function point_in_arc(px, py, x, y, angle, dist, fov) {
	return (point_distance(px, py, x, y) < dist && abs(angle_difference(angle, point_direction(x, y, px, py))) < fov/2);
}

/// @desc This function is used to check collisions without slope support.
/// @param {real} hspd The horizontal vector speed.
/// @param {real} vspd The vertical vector speed.
/// @param {any} object Object to check collision with.
/// @returns {struct} 
function move_and_collide_simple(hspd, vspd, object) {
	var vx = sign(hspd),
	vy = sign(vspd),
	_col = noone,
	_hor_colliding = false,
	_ver_colliding = false,
	_collision_id = noone;
	
	_col = instance_place(x+hspd, y, object);
	if (_col != noone) {
		repeat(abs(hspd) + 1) {
			if (place_meeting(x + vx, y, object)) break;
			x += vx;
		}
		hspd = 0;
		_hor_colliding = true;
		_collision_id = _col;
	}
	x += hspd;
	
	_col = instance_place(x, y+vspd, object);
	if (_col != noone) {
		repeat(abs(vspd) + 1) {
			if (place_meeting(x, y + vy, object)) break;
			y += vy;
		}
		vspd = 0;
		_ver_colliding = true;
		_collision_id = _col;
	}
	y += vspd;
	
	return new Vector3(_hor_colliding, _ver_colliding, _collision_id);
}


/// @desc This function is used to check collisions based on tags, without slope support.
/// @param {real} hspd The horizontal vector speed.
/// @param {real} vspd The vertical vector speed.
/// @param {String, Array<String>} tags Tags string or array
/// @returns {struct} 
function move_and_collide_simple_tag(hspd, vspd, tags) {
	var _pri = ds_priority_create();
	// search for tag objects
	var _object_ids_array = tag_get_asset_ids(tags, asset_object),
	i = 0, isize = array_length(_object_ids_array);
	repeat(isize) {
		var _object = _object_ids_array[i];
		ds_priority_add(_pri, _object, distance_to_object(_object));
		++i;
	}
	var _obj = ds_priority_find_min(_pri);
	ds_priority_destroy(_pri);
	return move_and_collide_simple(hspd, vspd, _obj);
}


// get the top instance of any layer/depth
function instance_top_position(px, py, object) {
	var _top_instance = noone,
	_list = ds_list_create(),
	_num = collision_point_list(px, py, object, false, true, _list, false);
	if (_num > 0) {
		var i = 0;
		repeat(_num) {
			_top_instance = _list[| ds_list_size(_list)-1];
			++i;
		}
	}
	ds_list_destroy(_list);
	return _top_instance;
}


function instance_number_object(object) {
	var _number = 0;
	with(object) {
		if (object_index == object) _number++;
	}
	return _number;
}


/// @desc Gets the nearest instance of an object, based on x and y position.
/// @param {Real} x The x position to check from.
/// @param {Real} y The y position to check from.
/// @param {Id.GMObject} object Object asset index.
/// @param {Real} number The position number.
/// @returns {id} 
function instance_nearest_nth(x, y, object, number) {
	//if (!instance_exists(object)) return noone;
	var _px = x,
	_py = y,
	_inst = noone,
	_pri = ds_priority_create(),
	i = 0;
	with(object) {
		if (self == object) continue;
		ds_priority_add(_pri, id, distance_to_point(_px, _py));
		++i;
	}
	var _numb = min(i, max(1, number));
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
function instance_farthest_nth(x, y, object, number) {
	//if (!instance_exists(object)) return noone;
	var _px = x,
	_py = y,
	_inst = noone,
	_pri = ds_priority_create(),
	i = 0;
	with(object) {
		if (self == object) continue;
		ds_priority_add(_pri, id, distance_to_point(_px, _py));
		++i;
	}
	var _numb = min(i, max(1, number));
	repeat(_numb) {
		_inst = ds_priority_delete_max(_pri);
	}
	ds_priority_destroy(_pri);
	return _inst;
}
