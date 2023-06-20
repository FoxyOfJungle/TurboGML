
/// Feather ignore all

// failed attempts [help is appreciated :')]
//function motion_predict_intersection(x1, y1, x2, y2, target_speed, target_angle, bullet_speed) { // doesn't works as expected!!
//	var _bullet_dir = point_direction(x1, y1, x2, y2);
//	var alpha = target_speed / bullet_speed;
//	var phi = degtorad(target_angle - _bullet_dir);
//    var beta = alpha * sin(phi);
//	var _distance_to_intercept = point_distance(x1, y1, x2, y2) * sin(phi) / sin(phi - arcsin(beta));
//	var _intercept_x = x1 + dcos(_bullet_dir) * _distance_to_intercept;
//	var _intercept_y = y1 - dsin(_bullet_dir) * _distance_to_intercept;
//	return new Vector2(_intercept_x, _intercept_y);
//}

//function motion_predict_intersection(x1, y1, x2, y2, target_hspeed, target_vspeed) {
//	var _bullet_dir = point_direction(x1, y1, x2, y2),
//	_nx = dsin(_bullet_dir),
//	_ny = dcos(_bullet_dir),
//	time = ((x1 - x2)*_nx + (y1 - y2)*_ny) / (target_hspeed*_nx + target_vspeed*_ny);
//	return new Vector2(x2+target_hspeed*time, y2+target_vspeed*time);
//}

//function motion_predict_intersection(x1, y1, x2, y2) {
//	var _bullet_dir = point_direction(x1, y1, x2, y2);
//	var _bullet_dist = point_distance(x1, y1, x2, y2);
//	var _dist = speed_to_reach(_bullet_dist, 0.2);
//	return new Vector2(
//		x1 + lengthdir_x(_dist, _bullet_dir),
//		y1 + lengthdir_y(_dist, _bullet_dir)
//	);
//}

//function point_in_parallelogram(px, py, parallelogram) {
//	// in first
//	if point_in_triangle(px, py, parallelogram[0], parallelogram[1], parallelogram[2], parallelogram[3], parallelogram[6], parallelogram[7]) return true;
//	// in second
//	if point_in_triangle(px, py, parallelogram[4], parallelogram[5], parallelogram[2], parallelogram[3], parallelogram[6], parallelogram[7]) return true;
//	return false;
//}

//function raycast_hit_point_2d(origin_x, origin_y, object, angle, distance, precise=false, ray_precision=4) {
//	var _xo = origin_x,
//	_yo = origin_y,
//	_dir = degtorad(angle),
//	_segments = distance / ray_precision,
//	_normalized = distance / _segments,
//	_col;
//	repeat(_segments) {
//		_xo += cos(_dir) * _normalized;
//		_yo -= sin(_dir) * _normalized;
//		_col = collision_point(_xo, _yo, object, precise, true);
//		//draw_circle(_xo, _yo, 3, true);
//		if (_col != noone) return new Vector3(_xo, _yo, _col);
//	}
//	return noone;
//}

//function debug_method_once(func=undefined, reset_key=vk_control) {
//	static can_test = true;
//	if (can_test) {
//		if (!is_undefined(func)) {
//			var _txt = string_repeat("∎", 20);
//			show_debug_message(_txt);
//			func();
//			show_debug_message(_txt);
//			can_test = false;
//		}
//	} else {
//		if keyboard_check_pressed(reset_key) can_test = true;
//	}
//}

//function print_format(msg, values_array) {
//	var _final_string = "", _vapos = 0;
//	var i = 1, isize = string_length(msg);
//	repeat(isize) {
//		var _char = string_char_at(msg, i);
//		if (_char == "$") {
//			_final_string += string(values_array[_vapos]);
//			_vapos++;
//			i++;
//		} else {
//			_final_string += _char;
//		}
//		++i;
//	}
//	show_debug_message(_final_string);
//}

//function array_shuffle(array) {
//	static _f = function() {
//		return irandom_range(-1, 1);
//	}
//	array_sort(array, _f);
//}

//function draw_surface_centered_ext(surface_id, x, y, xscale, yscale, rot, col, alpha) {
//	//draw_surface_ext(surface_id, x-(surface_get_width(surface_id)/2)*xscale, y-(surface_get_height(surface_id)/2)*yscale, xscale, yscale, rot, col, alpha);
//	var _col = draw_get_color(),
//	_alpha = draw_get_alpha();
	
//	var _mat = matrix_build(x, y, 0, 0, 0, rot, xscale, yscale, 1);
	
//	matrix_stack_push(_mat);
//	matrix_set(matrix_world, matrix_stack_top());
	
//	draw_set_color(col);
//	draw_set_alpha(alpha);
//	draw_surface(surface_id, -surface_get_width(surface_id)/2, -surface_get_height(surface_id)/2);
//	draw_set_color(_col);
//	draw_set_alpha(_alpha);
	
//	matrix_stack_pop();
//	matrix_set(matrix_world, matrix_stack_top());
//}

/// @ignore
//function __folder_recursive_create(folder, struct_content) {	
//	// arquivos
//	if (is_array(struct_content)) {
//		var i = 0, isize = array_length(struct_content);
//		repeat(isize) {
//			var _item = struct_content[i];
//			var _name = _item.name;
//			var _type = _item.type;
//			var _root_folder = _item.root_folder;
//			print("ARRAY", _name);
			
//			// folder
//			if (_type == 0) {
//				folder[$ _name] = [];
//			}
			
//			++i;
//		}
		
//	} else
	
//	if (is_struct(struct_content)) {
		
//	}
//}

//function folder_content_generate(struct_content) {
//	var _folder = {};
//	__folder_recursive_create(_folder, struct_content);
//	return _folder;
//}

