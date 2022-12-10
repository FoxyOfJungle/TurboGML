
/*----------------------------------------------------------------------------------
	TurboGML. Library by FoxyOfJungle (Mozart Junior). (C) 2022, MIT License.
	
	https://foxyofjungle.itch.io/
	https://twitter.com/foxyofjungle
	
	Special Thanks, contributions:
	YellowAfterLife, Cecil, TheSnidr, Shaun Spalding
----------------------------------------------------------------------------------*/


#region MATH & OTHERS

/// @desc Return the equivalent of v on an old range of [x0, x1], on a new range of [y0, y1].
function relerp(oldmin, oldmax, value, newmin, newmax) {
	return (value-oldmin) / (oldmax-oldmin) * (newmax-newmin) + newmin;
}

/// @desc Return the interpolating value t such that lerp(minv, maxv, t) would give v. (inverse_lerp).
function linearstep(minv, maxv, value) {
	return (value - minv) / (maxv - minv);
}

function smoothstep(minv, maxv, value) {
	var t = clamp((value - minv) / (maxv - minv), 0, 1);
	return t * t * (3 - 2 * t);
}

function speed_to_reach(dist, fric) {
	return sqrt(2 * dist * fric);
}

function clamp_loop(val, vmin, vmax) {
	if (val > vmax) val = vmin; else if (val < vmin) val = vmax;
	return val;
}

function lerp_angle(val1, val2, amount) {
	var _a = val1 + angle_difference(val2, val1);
	return lerp(val1, _a, amount);
}

//function lerp_angle(_from, _to, _amount) {
//    return _from - (angle_difference(_from, _to) * _amount);
//}

function in_range(value, val1, val2) {
	return (value >= val1 && value <= val2);
}

// returns the difference/distance between two values
function distance(val1, val2) {
	return abs(val1 - val2);
}

function approach(val1, val2, amount) {
	if (val1 < val2) {
		return min(val1 + amount, val2);
	} else {
		return max(val1 - amount, val2);
	}
}

function angle_get_subimg(angle, frames_amount) {
	var _angle_seg = 360 / frames_amount;
	return ((angle + (_angle_seg / 2)) % 360) div _angle_seg;
}

function angle_towards(angle, dir, rate) {
	return median(-rate, rate, angle_difference(-dir, -angle));
}

//function angle_towards(angle1, angle2, spd) {
//	var _dir = angle_difference(angle1, angle2);
//	return min(abs(_dir), spd) * sign(_dir);
//}

// Based on: https://www.reddit.com/r/gamemaker/comments/b0zelv/need_a_help_about_the_prediction_shot/
function angle_predict_intercession(x1, y1, x2, y2, target_speed, target_angle, bullet_speed) {
	var _angle = point_direction(x1, y1, x2, y2);
	var _beta = sin(degtorad(target_angle - _angle)) * (target_speed/bullet_speed);
	return (abs(_beta) < 1) ? _angle+radtodeg(arcsin(_beta)) : -1;
}


/*function angle_predict_interception(origin, target, target_speed, target_direction, bullet_speed) {
	
	//(p)osition of the target relative to shooter
	var _px = target.x - origin.x;
	var _py = target.y - origin.y;
	
	//(v)elocity of the target
	//note: if shooter velocity is added to projectile, then subtract shooter velocity from this
	var _vx = target.hspeed;
	var _vy = target.vspeed;

	var _A = _vx*_vx + _vy*_vy - bullet_speed*bullet_speed;
	var _B = 2 * (_px*_vx + _py*_vy);
	var _C = _px*_px + _py*_py;
	var _delta = _B*_B - 4*_A*_C;
	
	if (_delta < 0) return -1;
	
	//var _time = ((_A < 0 ? -1 : 1) * sqrt(_delta) - _B) / (2 * _A);
	
	
	var _ix = _px + _vx;
	var _iy = _py + _vy;
	
	var _dir = point_direction(0, 0, _ix, _iy);
	show_debug_message(_dir);
	
	return _dir;
}*/

function motion_predict_intercession(x1, y1, x2, y2, target_speed, target_angle, bullet_speed) {
	
}










function point_direction_radians(x1, y1, x2, y2) {
	var dir = arctan2(y2-y1, x2-x1);
	return Vector2(cos(dir), sin(dir));
}

function point_in_cone(px, py, x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist;
	var _len_y1 = dsin(angle - fov/2) * dist;
	var _len_x2 = dcos(angle + fov/2) * dist;
	var _len_y2 = dsin(angle + fov/2) * dist;
    return point_in_triangle(px, py, x, y, x+_len_x1, y-_len_y1, x+_len_x2, y-_len_y2);
}

function non_zero(value) {
	return value != 0 ? value : 1;
}

function is_fractional(number) {
	return (frac(number) > 0);
}

function pow2_next(val) {
	return 1 << ceil(log2(val));
}

function pow2_previous(val) {
	return 1 << floor(log2(val));
}

function bezier(position, points, straight) {
	var _len = array_length(points);
	if (_len == 0) return 0;
	var _pos = max(0, min(1, position)) * _len;
	var _ind = min(floor(_pos), _len - 1);
	_pos -= _ind;
	var _c = points[_ind];
	var _n = points[min(_len - 1, _ind + 1)];
	
	if (straight) {
		return lerp(_c, _n, _pos);
	} else {
		var _p = points[max(_ind - 1, 0)];
		return 0.5 * (((_p - 2 * _c + _n) * _pos + 2 * (_c - _p)) * _pos + _p + _c);
	}
}

function wave_normalized(spd=1) {
	return 0.5 + sin(current_time*0.0025*spd) * 0.5;
}

function irandom_weighted(val) { // WIP
	// credits: Xor
	return floor(sqr(random(sqrt(val))));
}




#endregion


#region VECTORS

// Shorthand for writing Vector2(0, 1).
#macro Vector2_Up Vector2(0, 1)

// Shorthand for writing Vector2(0, -1).
#macro Vector2_Down Vector2(0, -1)

// Shorthand for writing Vector2(-1, 0).
#macro Vector2_Left Vector2(-1, 0)

// Shorthand for writing Vector2(1, 0).
#macro Vector2_Right Vector2(1, 0)


function Vector2(x, y=x) constructor {
	self.x = x;
	self.y = y;
	
	/// @desc Set vector components.
	static set = function(_x=0, _y=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static equals = function(vector2) {
		gml_pragma("forceinline");
		return (
			x == vector2.x &&
			y == vector2.y
		);
	}
		
	/// @desc Returns the length of this vector (Read Only).
	static magnitude = function() {
		gml_pragma("forceinline");
		return sqrt(x * x + y * y);
	};
	
	/// @desc Returns the squared length of this vector (Read Only).
	static sqrMagnitude = function() {
		gml_pragma("forceinline");
		return (x * x + y * y);
	}
	
	/// @desc Returns this vector with a magnitude of 1 (Read Only).
	static normalized = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y);
		return new Vector2(
			x * _normalized,
			y * _normalized
		);
	}
	
	/// @desc Returns the vector rotated by the amount supplied in degrees.
	static rotated = function(new_angle) {
		gml_pragma("forceinline");
		var _sin = dsin(new_angle), _cos = dcos(new_angle);
		return new Vector2(
			x*_cos - y*_sin,
			x*_sin + y*_cos
		);
	}
	
	/// @desc Returns the vector snapped in a grid
	static snapped = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			floor(x/vector2.x+0.5)*vector2.x,
			floor(y/vector2.y+0.5)*vector2.y
		);
	}
	
	/// @desc Clamps each component of the vector.
	static clamped = function(min_vector, max_vector) {
		gml_pragma("forceinline");
		return new Vector2(
			clamp(x, min_vector.x, max_vector.x),
			clamp(y, min_vector.y, max_vector.y)
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static clampedMagnitude = function(max_magnitude) {
		gml_pragma("forceinline");
		var _len = magnitude();
		var _vector = self;
		if (_len > 0 && max_magnitude < _len) {
			_vector.x /= _len;
			_vector.y /= _len;
			_vector.x *= max_magnitude;
			_vector.y *= max_magnitude;
		}
		return _vector;
	}
	
	/// @desc Returns the angle in degrees of this vector.
	static angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Adds two vectors.
	static add = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x+vector2.x, y+vector2.y);
	}
	
	/// @desc Subtract two vectors.
	static subtract = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x-vector2.x, y-vector2.y);
	}
	
	/// @desc Multiply two vectors.
	static multiply = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x*vector2.x, y*vector2.y);
	}
	
	/// @desc Divide with another vector.
	static divide = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x/vector2.x, y/vector2.y);
	}
	
	/// @desc Negates the vector.
	static negate = function() {
		gml_pragma("forceinline");
		return new Vector2(-x, -y);
	}
	
	/// @desc Scales the vector.
	static scale = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x*vector2.x, y*vector2.y);
	}
	
	/// @desc Normalise (magnitude set to 1) all the components of this
	static normalize = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y);
		x = x * _normalized;
		y = y * _normalized;
	}
	
	/// @desc Get the dot product of two vectors.
	static dot = function(vector2) {
		gml_pragma("forceinline");
		return (x*vector2.x + y*vector2.y);
	}
	
	/// @desc Returns the cross product.
	static cross = function(vector2) {
		gml_pragma("forceinline");
		return (x*vector2.x - y*vector2.y);
	}
	
	/// @desc Returns the vector with all components rounded down.
	static floorV = function() {
		gml_pragma("forceinline");
		return new Vector2(floor(x), floor(y));
	}
	
	/// @desc Returns the vector with all components rounded up.
	static ceilV = function() {
		gml_pragma("forceinline");
		return new Vector2(ceil(x), ceil(y));
	}
	
	/// @desc Returns the vector with all components rounded.
	static roundV = function() {
		gml_pragma("forceinline");
		return new Vector2(round(x), round(y));
	}
	
	/// @desc Returns positive, negative, or zero depending on the value of the components.
	static signV = function() {
		gml_pragma("forceinline");
		return new Vector2(sign(x), sign(y));
	}
	
	/// @desc Returns a new vector with absolute values.
	static absV = function() {
		gml_pragma("forceinline");
		return new Vector2(abs(x), abs(y));
	}
	
	/// @desc Returns a new vector with fractional values.
	static fracV = function() {
		gml_pragma("forceinline");
		return new Vector2(frac(x), frac(y));
	}
	
	/// @desc Check if the vector is normalized.
	static isNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(sqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	/// @desc Clamps each component of the vector.
	static lerpTo = function(vector2, amount) {
		gml_pragma("forceinline");
		return new Vector2(
			lerp(x, vector2.x, amount),
			lerp(y, vector2.y, amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static distanceTo = function(vector2) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-vector2.x) + sqr(y-vector2.y));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static sqrDistanceTo = function(vector2) {
		gml_pragma("forceinline");
		return (sqr(x-vector2.x) + sqr(y-vector2.y));
	}
	
	/// @desc Returns the angle to the given vector.
	static angleTo = function(vector2) {
		gml_pragma("forceinline");
		return darctan2(cross(vector2), dot(vector2));
	}
	
	/// @desc Returns the angle between the line connecting the two points.
	static angleToPoint = function(vector2) {
		gml_pragma("forceinline");
		return -darctan2(y-vector2.y, x-vector2.x)+180;
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static maxV = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			max(x, vector2.x),
			max(y, vector2.y)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static minV = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			min(x, vector2.x),
			min(y, vector2.y)
		);
	};
	
	/// @desc Returns the highest value of the vector.
	static maxComponent = function(vector2) {
		gml_pragma("forceinline");
		return max(x, y);
	};
	
	/// @desc Returns the lowest value of the vector.
	static minComponent = function(vector2) {
		gml_pragma("forceinline");
		return min(x, y);
	};
	
}


// Shorthand for writing Vector3(0, 0, 1)
#macro Vector3_Up Vector3(0, 0, 1)

// Shorthand for writing Vector3(1, 0, 0)
#macro Vector3_Forward Vector3(1, 0, 0)

// Shorthand for writing Vector3(0, 1, 0)
#macro Vector3_Right Vector3(0, 1, 0)


function Vector3(x, y=x, z=x) constructor {
	self.x = x;
	self.y = y;
	self.z = z;
	
	/// @desc Set vector components.
	static set = function(_x=0, _y=_x, _z=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		z = _z;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static equals = function(vector3) {
		gml_pragma("forceinline");
		return (
			x == vector3.x &&
			y == vector3.y &&
			z == vector3.z
		);
	}
		
	/// @desc Returns the length of this vector (Read Only).
	static magnitude = function() {
		gml_pragma("forceinline");
		return sqrt(x * x + y * y + z * z);
	};
	
	/// @desc Returns the squared length of this vector (Read Only).
	static sqrMagnitude = function() {
		gml_pragma("forceinline");
		return (x * x + y * y + z * z);
	}
	
	/// @desc Returns this vector with a magnitude of 1 (Read Only).
	static normalized = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y + z * z);
		return new Vector3(
			x * _normalized,
			y * _normalized,
			z * _normalized
		);
	}
	
	/// @desc Returns the vector snapped in a grid
	static snapped = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			floor(x/vector3.x+0.5)*vector3.x,
			floor(y/vector3.y+0.5)*vector3.y,
			floor(z/vector3.z+0.5)*vector3.z
		);
	}
	
	/// @desc Clamps each component of the vector.
	static clamped = function(min_vector, max_vector) {
		gml_pragma("forceinline");
		return new Vector3(
			clamp(x, min_vector.x, max_vector.x),
			clamp(y, min_vector.y, max_vector.y),
			clamp(z, min_vector.z, max_vector.z),
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static clampedMagnitude = function(max_magnitude) {
		gml_pragma("forceinline");
		var _len = magnitude();
		var _vector = self;
		if (_len > 0 && max_magnitude < _len) {
			_vector.x /= _len;
			_vector.y /= _len;
			_vector.z /= _len;
			_vector.x *= max_magnitude;
			_vector.y *= max_magnitude;
			_vector.z *= max_magnitude;
		}
		return _vector;
	}
	
	/// @desc Returns the yaw angle (z rotation) in degrees of this vector.
	static yaw = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Returns the pitch angle (x rotation) in degrees of this vector.
	static pitch = function(vector3) {
		gml_pragma("forceinline");
		var _magnitude = point_distance_3d(x, y, z, vector3.x, vector3.y, vector3.z);
		var _normal_z = (vector3.z - z) / _magnitude;
		return darcsin(_normal_z);
	}
	
	/// @desc Adds two vectors.
	static add = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x+vector3.x, y+vector3.y, z+vector3.z);
	}
	
	/// @desc Subtract two vectors.
	static subtract = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x-vector3.x, y-vector3.y, z-vector3.z);
	}
	
	/// @desc Multiply two vectors.
	static multiply = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x*vector3.x, y*vector3.y, z*vector3.z);
	}
	
	/// @desc Divide with another vector.
	static divide = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x/vector3.x, y/vector3.y, z/vector3.z);
	}
	
	/// @desc Negates the vector.
	static negate = function() {
		gml_pragma("forceinline");
		return new Vector3(-x, -y, -z);
	}
	
	/// @desc Scales the vector.
	static scale = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x*vector3.x, y*vector3.y, z*vector3.z);
	}
	
	/// @desc Normalise (magnitude set to 1) all the components of this
	static normalize = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y + z * z);
		x = x * _normalized;
		y = y * _normalized;
		z = z * _normalized;
	}
	
	/// @desc Get the dot product of two vectors.
	static dot = function(vector3) {
		gml_pragma("forceinline");
		return (x*vector3.x + y*vector3.y + z*vector3.z);
	}
	
	/// @desc Returns the cross product.
	static cross = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			y*vector3.z - z*vector3.y,
			z*vector3.x - x*vector3.z,
			x*vector3.y - y*vector3.x
		);
	}
	
	/// @desc Returns the vector with all components rounded down.
	static floorV = function() {
		gml_pragma("forceinline");
		return new Vector3(floor(x), floor(y), floor(z));
	}
	
	/// @desc Returns the vector with all components rounded up.
	static ceilV = function() {
		gml_pragma("forceinline");
		return new Vector3(ceil(x), ceil(y), ceil(z));
	}
	
	/// @desc Returns the vector with all components rounded.
	static roundV = function() {
		gml_pragma("forceinline");
		return new Vector3(round(x), round(y), round(z));
	}
	
	/// @desc Returns positive, negative, or zero depending on the value of the components.
	static signV = function() {
		gml_pragma("forceinline");
		return new Vector3(sign(x), sign(y), sign(z));
	}
	
	/// @desc Returns a new vector with absolute values.
	static absV = function() {
		gml_pragma("forceinline");
		return new Vector3(abs(x), abs(y), abs(z));
	}
	
	/// @desc Returns a new vector with fractional values.
	static fracV = function() {
		gml_pragma("forceinline");
		return new Vector3(frac(x), frac(y), frac(z));
	}
	
	/// @desc Check if the vector is normalized.
	static isNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(sqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	/// @desc Clamps each component of the vector.
	static lerpTo = function(vector3, amount) {
		gml_pragma("forceinline");
		return new Vector3(
			lerp(x, vector3.x, amount),
			lerp(y, vector3.y, amount),
			lerp(z, vector3.z, amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static distanceTo = function(vector3) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-vector3.x) + sqr(y-vector3.y) + sqr(z-vector3.z));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static sqrDistanceTo = function(vector3) {
		gml_pragma("forceinline");
		return (sqr(x-vector3.x) + sqr(y-vector3.y) + sqr(z-vector3.z));
	}
	
	/// @desc Returns the angle to the given vector.
	static angleTo = function(vector3) {
		gml_pragma("forceinline");
		return darctan2(cross(vector3), dot(vector3));
	}
	
	/// @desc Returns the angle between the line connecting the two points.
	static angleToPoint = function(vector3) {
		gml_pragma("forceinline");
		return -darctan2(y-vector3.y, x-vector3.x)+180;
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static maxV = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			max(x, vector3.x),
			max(y, vector3.y),
			max(z, vector3.z),
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static minV = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			min(x, vector3.x),
			min(y, vector3.y),
			min(z, vector3.z),
		);
	};
	
	/// @desc Returns the highest value of the vector.
	static maxComponent = function(vector3) {
		gml_pragma("forceinline");
		return max(x, y, z);
	};
	
	/// @desc Returns the lowest value of the vector.
	static minComponent = function(vector3) {
		gml_pragma("forceinline");
		return min(x, y, z);
	};
	
}


/*function Vector4(x, y=undefined, z=undefined, w=undefined) constructor {
	self.x = x;
	self.y = y ?? x;
	self.z = z ?? x;
	self.w = w ?? x;
}*/

#endregion


#region GENERAL

#macro fps_average ___fps_average()
function ___fps_average() {
	static frames = 0;
	static total_fps = 1;
	static total_smooth = 0;
	frames++;
	if (frames > 250) {
		frames = 1;
		total_fps = 1;
	}
	total_fps += fps_real;
	var _fps_avg = total_fps / frames;
	total_smooth = lerp(total_smooth, _fps_avg, 0.2);
	return floor(total_smooth);
}

#macro DEBUG_SPEED_INIT var ___time = get_timer();
#macro DEBUG_SPEED_GET show_debug_message(string((get_timer()-___time)/1000) + "ms");

function game_is_IDE() {
	if (debug_mode) return true;
	if (code_is_compiled()) return false;
	if (parameter_count() == 3 && parameter_string(1) == "-game") return true;
	return false;
}

function generate_code(chars, size) {
	var _len = string_length(chars), _str_final = "", _str_chars = [];
	var i = 0;
	repeat(size) {
		_str_chars[i] = string_char_at(chars, irandom(_len));
		_str_final += _str_chars[i];
		i++;
	}
	return string(_str_final);
}

function print() {
	if (argument_count > 0) {
		var _log = "", i = 0;
		repeat(argument_count) {
			_log += string(argument[i]);
			if (argument_count > 1) _log += " | ";
			++i;
		}
		show_debug_message(_log);
	}
}

function print_format(msg, values_array) {
	var _final_string = "", _vapos = 0;
	var i = 1, isize = string_length(msg);
	repeat(isize) {
		var _char = string_char_at(msg, i);
		if (_char == "$") {
			_final_string += string(values_array[_vapos]);
			_vapos++;
			i++;
		} else {
			_final_string += _char;
		}
		++i;
	}
	show_debug_message(_final_string);
}

function show_once(func=undefined, reset_key=vk_control) {
	static can_test = true;
	if (can_test) {
		if (!is_undefined(func)) {
			var _txt = string_repeat("∎", 20);
			show_debug_message(_txt);
			func();
			show_debug_message(_txt);
			can_test = false;
		}
	} else {
		if keyboard_check_pressed(reset_key) can_test = true;
	}
}

function sleep(milliseconds=1000) {
	var _time = current_time + milliseconds;
	while(current_time < _time) {
		// idle
	}
}

#endregion


#region DELTA TIME & MOUSE

// PLEASE NOTE: THIS IS A VERY BASIC IMPLEMENTATION OF DELTA TIMING
// USE "IOTA" BY JUJU, FOR ROBUST DELTA TIMING


// frames
//global.__frame_count = 0;
//#macro FRAME_COUNT global.__frame_count

// delta time
global.__delta_speed = 0;
global.__delta_time_multiplier_base = 1;
global.__delta_time_multiplier = 1;
#macro FRAME_RATE 60
#macro DELTA_TIME global.__delta_time_multiplier

// delta mouse
global.__mouse_x_delta = 0;
global.__mouse_y_delta = 0;
global.__mouse_x_previous = 0;
global.__mouse_y_previous = 0;
global.__gui_mouse_x_delta = 0;
global.__gui_mouse_y_delta = 0;
global.__gui_mouse_x_previous = 0;
global.__gui_mouse_y_previous = 0;
#macro mouse_x_delta global.__mouse_x_delta
#macro mouse_y_delta global.__mouse_y_delta
#macro gui_mouse_x_delta global.__gui_mouse_x_delta
#macro gui_mouse_y_delta global.__gui_mouse_y_delta


call_later(1, time_source_units_frames, function() {
	// delta time
	global.__delta_speed = 1/FRAME_RATE;
	global.__delta_time_multiplier_base = (delta_time/1000000)/global.__delta_speed;
	global.__delta_time_multiplier = lerp(global.__delta_time_multiplier, global.__delta_time_multiplier_base, 0.2); // smooth delta
	
	// delta mouse
	global.__mouse_x_delta = mouse_x - global.__mouse_x_previous;
	global.__mouse_y_delta = mouse_y - global.__mouse_y_previous;
	global.__gui_mouse_x_delta = mouse_x - global.__gui_mouse_x_previous;
	global.__gui_mouse_y_delta = mouse_y - global.__gui_mouse_y_previous;
}, true);

call_later(2, time_source_units_frames, function() {
	call_later(1, time_source_units_frames, function() {
		// delta mouse
		global.__mouse_x_previous = mouse_x;
		global.__mouse_y_previous = mouse_y;
		global.__gui_mouse_x_previous = device_mouse_x_to_gui(0);
		global.__gui_mouse_y_previous = device_mouse_y_to_gui(0);
		
		// frame count
		//global.__frame_count += game_get_speed(gamespeed_fps);
	}, true);
}, false);



#endregion


#region WINDOW & INPUT

#macro gui_mouse_x device_mouse_x_to_gui(0)
#macro gui_mouse_y device_mouse_y_to_gui(0)
#macro gui_mouse_x_normalized (device_mouse_x_to_gui(0)/display_get_gui_width())
#macro gui_mouse_y_normalized (device_mouse_y_to_gui(0)/display_get_gui_height())

// this is useful for some libraries by Samuel
function io_clear_both() {
	keyboard_clear(keyboard_lastkey);
	mouse_clear(mouse_lastbutton);
}

// return the position of the mouse without it being stuck in the window
function window_mouse_x() {
    return display_mouse_get_x() - window_get_x();
}

function window_mouse_y() {
    return display_mouse_get_y() - window_get_y();
}

#endregion


#region DATA

function hex_to_dec(decimal) {
	var count = string_length(decimal);
	var final = 0;
	static __sillies = {
		a: 10, b: 11, c: 12, d: 13, e: 14, f: 15
	}
	for (var i = 1; i < string_length(decimal) + 1; i += 1) {
		count--;
		var digit = __sillies[$ string_lower(string_char_at(decimal, i))] ?? real(string_char_at(decimal, i));
		var base = power(16, count);
		final += digit * base;
	}
	return final;
}

function string_to_hex(str) {
	return int64(ptr(str));
}

// https://www.sohamkamani.com/uuid-versions-explained/
// https://www.uuidtools.com/uuid-versions-explained
function uuid_v5_generate(hifen=false) {
	// non-random, sha1
	var _config_data = os_get_info();
	var _uuid = sha1_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+
	_config_data[? "udid"]+string(_config_data[? "video_adapter_subsysid"]));
	ds_map_destroy(_config_data);
	if (hifen) {
		for(var i = 1; i < 32; ++i) {
			if (i == 9 || i == 14 || i == 19 || i == 24) {
				_uuid = string_insert("-", _uuid, i);
			}
		}
	}
	return _uuid;
}

function uuid_v3_generate() {
	// non-random, md5
	var _config_data = os_get_info();
	var _uuid = md5_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+_config_data[? "udid"]+
	string(_config_data[? "video_adapter_subsysid"]));
	ds_map_destroy(_config_data);
	return _uuid;
}

// warning: this function is not repeat safe... wip
function uuid_v4_generate(hifen=false) {
	// randomness
	var _uuid = "";
	for (var i = 0; i < 32; i++) {
		if (hifen) {
			if (i == 8 || i == 12 || i == 16 || i == 20) _uuid += "-";
		}
		_uuid += choose("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	}
	return _uuid;
}

#endregion


#region FILE SYSTEM

function filename_dir_name(file) {
	//var _dir_name = filename_name(filename_dir(file));
	var _dir = filename_dir(file), _dir_name = "";
	var isize = string_length(_dir), i = isize;
	repeat(isize) {
		var _char = string_char_at(_dir, i);
		if (_char == "/") {
			_dir_name = string_copy(_dir, i+1, string_length(_dir)-i);
			break;
		}
		--i;
	}
	return _dir_name;
}


function filename_name_noext(path) {
	return filename_name(filename_change_ext(path, ""));
	//var _name = filename_name(path);
	//var _size = string_length(_name);
	//for (var i = 1; i <= _size; ++i) {
	//	var _char = string_char_at(_name, i);
	//	if (_char == ".") {
	//		var _pos = string_pos(".", _name);
	//		var _word = string_copy(_name, _pos+1, string_length(_name)-_pos);
	//		_name = string_delete(_name, _pos, string_length(_word)+1);
	//	}
	//}
	//return _name;
}


function file_write_string(file_path, str) {
	var _buff = buffer_create(1, buffer_grow, 1);
	buffer_write(_buff, buffer_string, str);
	buffer_save(_buff, file_path);
	buffer_delete(_buff);
}


function file_read_string(file_path) {
	if (!file_exists(file_path)) return undefined;
	var _buffer = buffer_load(file_path);
	var _result = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	return _result;
}


function bytes_to_size(bytes) {
	var _sizes = ["B", "KB", "MB", "GB", "TB", "PB"]; // you can add more
	if (bytes == 0) return "0 B";
	var i = floor(log2(bytes) / log2(1024));
	return string(round(bytes / power(1024, i))) + " " + _sizes[i];
}


function file_get_size(file) {
	var _buff = buffer_load(file);
	if (_buff <= 0) return 0;
	var _size = buffer_get_size(_buff);
	buffer_delete(_buff);
	return _size;
}


// based on https://yal.cc/gamemaker-recursive-folder-copying/
/// @ignore
function __directory_recursive_search(contents, source, extension, search_folders, search_files, search_subdir, full_info, get_size) {
	// scan contents (folders and files)
	var _contents = [];
	var _file = file_find_first(source + "/" + extension, fa_directory | fa_archive | fa_readonly);
	var _files_count = 0;
	while(_file != "") {
		if (_file == ".") continue;
		if (_file == "..") continue;
		array_push(_contents, _file);
		_file = file_find_next();
		_files_count++;
	}
	file_find_close();
	
	// process found contents:
	var i = 0;
	repeat(_files_count) {
		var _fname = _contents[i];
		var _path = source + "/" + _fname; // the path of the content (folder or file)
		var _dir_name = filename_dir_name(_path);
		
		var _progress = (i/_files_count); // ready-only
		show_debug_message("Scanning: [" + string(_progress*100) + "%] " + _dir_name + " | " + string(_fname));
		
		if (directory_exists(_path)) {
			// recursively search directories
			if (search_subdir) __directory_recursive_search(contents, _path, extension, search_folders, search_files, search_subdir, full_info, get_size);
			if (search_folders) {
				array_push(contents, full_info ? {
					name : _fname,
					type : 0,
					ext : "",
					path : _path,
					root_folder : _dir_name,
					size : -1,
				} : _fname);
			}
		} else {
			if (search_files) {
				array_push(contents, full_info ? {
					name : filename_name_noext(_fname),
					type : 1,
					ext : filename_ext(_fname),
					path : _path,
					root_folder : _dir_name,
					size : get_size ? bytes_to_size(file_get_size(_path)) : -1,
				} : _fname);
			}
		}
		++i;
	}
	
	return _contents;
}

function directory_scanner(path, extension="*.*", search_folders=true, search_files=true, search_subdir=true, full_info=true, get_size=false) constructor {
	__contents = [];
	__loaded = false;
	__path_exists = false;
	
	if (directory_exists(path)) {
		__directory_recursive_search(__contents, path, string(extension), search_folders, search_files, search_subdir, full_info, get_size);
		__loaded = true;
		__path_exists = true;
	}
	
	static contents = function() {
		return __path_exists ? __contents : undefined;
	}
	
	static amount = function() {
		return array_length(__contents);
	}
	
	static loaded = function() {
		return __loaded;
	}
	
}


/// @ignore
/*function __folder_recursive_create(folder, struct_content) {	
	// arquivos
	if (is_array(struct_content)) {
		var i = 0, isize = array_length(struct_content);
		repeat(isize) {
			var _item = struct_content[i];
			var _name = _item.name;
			var _type = _item.type;
			var _root_folder = _item.root_folder;
			print("ARRAY", _name);
			
			// folder
			if (_type == 0) {
				folder[$ _name] = [];
			}
			
			++i;
		}
		
	} else
	
	if (is_struct(struct_content)) {
		
	}
}

function folder_content_generate(struct_content) {
	var _folder = {};
	__folder_recursive_create(_folder, struct_content);
	return _folder;
}*/

#endregion


#region ARRAYS

function array_choose(array) {
	return array[irandom_range(0, array_length(array)-1)];
}

function array_shuffle(array) {
	static _f = function() {
		return irandom_range(-1, 1);
	}
	array_sort(array, _f);
}

function array_shift(array, reverse) {
	if (reverse) {
		var _old = array[array_length(array)-1];
		array_pop(array);
		array_insert(array, 0, _old);
	} else {
		var _old = array[0];
		array_delete(array, 0, 1)
		array_push(array, _old);
	}
}

function array_shift_index(array, index, way) {
	var _len = array_length(array)-1;
	if (index+way < 0 || index > _len-way) exit;
	var _current = array[index];
	var _next = array[index + way];
	array[index + way] = _current;
	array[index] = _next;
}

function array_sum(array) {
	//return array_reduce(array, function(p, v) {return p+v;});
	var _sum = 0;
	var i = 0, isize = array_length(array);
	repeat(isize) {
		_sum += real(array[i]);
		++i;
	}
	return _sum;	
}

function array_empty(array) {
	return (array_length(array) == 0);
}

/// @desc Returns the max value from an array
function array_max(array) {
	var _len = array_length(array);
	if (_len == 0) return undefined;
	var i = 0, _val = -infinity;
	repeat(_len) {
		if (array[i] > _val) _val = array[i];
		++i;	
	}
	return _val;
}

/// @desc Returns the min value from an array
function array_min(array) {
	var _len = array_length(array);
	if (_len == 0) return undefined;
	var i = 0, _val = infinity;
	repeat(_len) {
		if (array[i] < _val) _val = array[i];
		++i;	
	}
	return _val;
}

function array_to_struct(array) {
	var _struct = {};
	var i = 0, isize = array_length(array);
	repeat(isize) {
		variable_struct_set(_struct, i, array[i]);
		++i;
	}
	return _struct;
}

function ds_list_to_array(list) {
	var _array = [];
	var i = 0, isize = ds_list_size(list);
	repeat(isize) {
		var _val = list[| i ];
		if (ds_list_is_map(list, i)) {
			_array[i] = ds_map_to_struct(_val);
		} else if (ds_list_is_list(list, i)) {
			_array[i] = ds_list_to_array(_val);
		} else {
			_array[i] = _val;
		}
		++i;
	}
	return _array;
}



#endregion


#region STRUCTS

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


function struct_empty(struct) {
	return (variable_struct_names_count(struct) == 0);
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


// get and remove a variable from a struct
function struct_pop(struct, name) {
	var _value = struct[$ name];
	variable_struct_remove(struct, name);
	return _value;
}


// get value from json only if exists, without returning undefined
function struct_get_variable(struct, name, default_value=0) {
	if (!is_struct(struct)) return default_value;
	return struct[$ name] ?? default_value;
}


function struct_from_instance_variables(inst_id) {
	var _struct = {};
	var _keys = variable_instance_get_names(inst_id);
	var i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = variable_instance_get(inst_id, _key);
		variable_struct_set(_struct, _key, _value);
		++i;
	}
	return _struct;
}


function struct_to_ds_map(struct) {
	var _ds_map = ds_map_create();
	var _keys = variable_struct_get_names(struct);
	var i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = variable_struct_get(struct, _key);
		ds_map_add(_ds_map, _key, _value);
		++i;
	}
	return _ds_map;
}


function ds_map_to_struct(map) {
    var _struct = {};
    var _key = ds_map_find_first(map);
	var i = 0, isize = ds_map_size(map);
	repeat(isize) {
		if (ds_map_is_map(map, _key)) {
			variable_struct_set(_struct, _key, ds_map_to_struct(map[? _key]));
		} else if (ds_map_is_list(map, _key)) {
			variable_struct_set(_struct, _key, ds_list_to_array(map[? _key]));
		} else {
			variable_struct_set(_struct, _key, map[? _key]);
		}
		_key = ds_map_find_next(map, _key);
		++i;
	}
	return _struct;
}





#endregion


#region STRINGS

function string_password(str, char="*") {
	return string_repeat(char, string_length(str));
}

function string_zeros(str, zero_amount) {
	return string_replace_all(string_format(str, zero_amount, 0), " ", "0");
}

function string_limit(str, width) {
	var _len = width / string_width("M");
	return string_width(str) < width ? str : string_copy(str, 1, _len) + "...";
}

function string_limit_nonmono(str, width) {
	if (string_width(str) < width) return str;
	var _str = "", _char = "";
	var i = 1, isize = string_length(str), _ww = 0;
	repeat(isize) {
		_char = string_char_at(str, i);
		_ww += string_width(_char);
		if (_ww < width) _str += _char;
		++i;
	}
	return _str + "...";
}

function string_split_each_char(str) {
	var _array = [];
	var i = 1, _size = string_length(str);
	repeat(_size) {
		array_push(_array, string_char_at(str, i));
		++i;
	}
	return _array;
}

function string_random_letter_case(str, first_is_upper=true, sequence=1) {
	var _str_final = "", _f1 = -1, _f2 = -1;
	if (first_is_upper) {
		_f1 = string_lower;
		_f2 = string_upper;
	} else {
		_f1 = string_upper;
		_f2 = string_lower;
	}
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		_str_final += (i % (sequence+1) == 0) ? _f1(_char) : _f2(_char);
		++i;
	}
	return _str_final;
}

function string_first_letter_upper_case(str) {
	var _string = string_lower(str);
	var _str_final = "";
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		_str_final += (i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _str_final;
}

function string_word_first_letter_upper_case(str) {
	var _string = string_lower(str);
	var _str_final = "";
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		var _pchar = string_char_at(_string, i-1);
		_str_final += (_pchar == " " || i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _str_final;
}

function string_case_reverse(str) {
	var _str_final = "";
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _char_upper = string_upper(_char);
		var _char_lower = string_lower(_char);
		_str_final += (_char == _char_upper) ? _char_lower : _char_upper;
		++i;
	}
	return _str_final;
}

function string_reverse(str) {
	var _str_final = "";
	var isize = string_length(str), i = isize;
	repeat(isize) {
		_str_final += string_char_at(str, i);
		--i;
	}
	return _str_final;
}






#endregion


#region DIMENSION CONVERSION

function room_to_gui_dimension(x1, y1, camera, gui_width, gui_height, normalize) {
	var _px = (x1-camera_get_view_x(camera)) * (gui_width/camera_get_view_width(camera)),
	_py = (y1-camera_get_view_y(camera)) * (gui_height/camera_get_view_height(camera));
	return normalize ? Vector2(_px/gui_width, _py/gui_height) : Vector2(_px, _py);
}

function room_to_gui_dimension_ext(x1, y1, camera, angle, gui_width, gui_height, normalize) {
	var _cw = camera_get_view_width(camera),
	_ch = camera_get_view_height(camera),
	_vcenter_x = camera_get_view_x(camera) + (_cw / 2),
	_vcenter_y = camera_get_view_y(camera) + (_ch / 2),
	_zoom = gui_width/_cw,
	_wcenter_dis = point_distance(_vcenter_x, _vcenter_y, x1, y1) * _zoom,
	_wcenter_dir = point_direction(_vcenter_x, _vcenter_y, x1, y1) + angle,
	_px = (gui_width/2) + dcos(_wcenter_dir) * _wcenter_dis,
	_py = (gui_height/2) - dsin(_wcenter_dir) * _wcenter_dis;
	return normalize ? Vector2(_px/gui_width, _py/gui_height) : Vector2(_px, _py);
}

function gui_to_room_dimension_ext(x1, y1, camera, angle, gui_width, gui_height, normalize) {
	var _cx = camera_get_view_x(camera),
	_cy = camera_get_view_y(camera),
	_cw = camera_get_view_width(camera),
	_ch = camera_get_view_height(camera),
	_vcenter_x = gui_width / 2,
	_vcenter_y = gui_height / 2,
	zoom = gui_width/_cw,
	_wcenter_dis = point_distance(_vcenter_x, _vcenter_y, x1, y1) / zoom,
	_wcenter_dir = point_direction(_vcenter_x, _vcenter_y, x1, y1) - angle,
	_px = _cx + (_cw/2) + dcos(_wcenter_dir) * _wcenter_dis,
	_py = _cy + (_ch/2) - dsin(_wcenter_dir) * _wcenter_dis;
	return normalize ? Vector2(_px/gui_width, _py/gui_height) : Vector2(_px, _py);
}

#endregion


#region LAYERS

// get the top instance of any layer/depth
function instance_top_position(px, py, object) {
	var _top_instance = noone;
	var _list = ds_list_create();
	var _num = collision_point_list(px, py, object, false, true, _list, false);
	if (_num > 0) {
		var i = 0,
		repeat(_num) {
			_top_instance = _list[| ds_list_size(_list)-1];
			++i;
		}
	}
	ds_list_destroy(_list);
	return _top_instance;
}

// get the top instance of a layer (without conflicting with other layers)
function layer_instance_top_position(px, py,  layer_id) {
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
			var i = 0,
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

#endregion


#region DRAWING

global.__tgm_sh_uni = {
	sprite_pos_uab : shader_get_uniform(__tgm_sh_quad_persp, "uAB"),
	sprite_pos_ucd : shader_get_uniform(__tgm_sh_quad_persp, "uCD"),
	sprite_pos_uvs : shader_get_uniform(__tgm_sh_quad_persp, "uUVS"),
};

function draw_cone(x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist;
	var _len_y1 = dsin(angle - fov/2) * dist;
	var _len_x2 = dcos(angle + fov/2) * dist;
	var _len_y2 = dsin(angle + fov/2) * dist;
	draw_line(x, y, x+_len_x1, y-_len_y1);
	draw_line(x, y, x+_len_x2, y-_len_y2);
	draw_line(x+_len_x1, y-_len_y1, x+_len_x2, y-_len_y2);
}

function draw_nineslice_stretched_ext(sprite, subimg, x, y, width, height, xscale, yscale, rot, col, alpha) {
	draw_sprite_ext(sprite, subimg, x, y, (width/sprite_get_width(sprite))*xscale, (height/sprite_get_height(sprite))*yscale, rot, col, alpha);
}

// useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw centered.
function draw_sprite_centered(sprite, subimg, x, y) {
	draw_sprite(sprite, subimg, x-sprite_get_width(sprite)/2, y-sprite_get_height(sprite)/2);
}

// useful when applying a shader to a sprite that is offset at 0, 0, but still wants to draw centered and scaled.
function draw_sprite_centered_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha) {
	draw_sprite_ext(sprite, subimg, x-(sprite_get_width(sprite)/2)*xscale, y-(sprite_get_height(sprite)/2)*yscale, xscale, yscale, rot, col, alpha);
}

// useful for grass wave effects
function draw_sprite_pos_ext(sprite, subimg, x, y, width, height, xoffset, yoffset, xscale, yscale, skew_x, skew_y, angle, alpha) {
	var _current_matrix = matrix_get(matrix_world);
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, angle, xscale, yscale, 1));
	var xo = -xoffset, yo = -yoffset;
	draw_sprite_pos(sprite_index, subimg, xo+skew_x, yo+skew_y, width+xo+skew_x, yo+skew_y, width+xo, height+yo, xo, height+yo, alpha);
	matrix_set(matrix_world, _current_matrix);
}

function draw_text_wave(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_wave_colorful(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv(current_time*color_speed % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_wave_rainbow(x, y, str, str_width, wave_amplitude=3, wave_speed=0.01, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv((current_time * color_speed + i*10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy + sin(i + current_time * wave_speed) * wave_amplitude, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_rainbow(x, y, str, str_width, color_speed=0.1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_set_color(make_color_hsv((current_time * color_speed + i*10) % 255, 255, 255));
		draw_text(_xx - _wf, _yy, _char);
		_xx += _ww;
		i++;
	}
}

function draw_text_shake(x, y, str, str_width, dist=1) {
	var _xx = x, _yy = y;
	var i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i);
		var _ww = string_width(_char);
		var _wf = (str_width == 0) ? 0 : str_width/2;
		draw_text(_xx-_wf + random_range(-dist, dist), _yy + random_range(-dist, dist), _char);
		_xx += _ww;
		i++;
	}
}

function draw_sprite_pos_persp(sprite, subimg, x1, y1, x2, y2, x3, y3, x4, y4, alpha) {
	/*p1--p2
	  |    |
	  p4--p3*/
	shader_set(__tgm_sh_quad_persp);
	var _uvs = sprite_get_uvs(sprite, subimg);
	shader_set_uniform_f_array(global.__tgm_sh_uni.sprite_pos_uab, [x1, y1, x2, y2]);
	shader_set_uniform_f_array(global.__tgm_sh_uni.sprite_pos_ucd, [x3, y3, x4, y4]);
	shader_set_uniform_f_array(global.__tgm_sh_uni.sprite_pos_uvs, _uvs);
	draw_sprite_pos(sprite, subimg, x1, y1, x2, y2, x3, y3, x4, y4, alpha);
	shader_reset();
}


#endregion


#region BLENDING

function gpu_set_blendmode_test(index, debug_info=false) {
	// final_pixel_colour =  (Rs,Gs,Bs,As) * source_blend_factor + (Rd,Gd,Bd,Ad) * destination_blend_factor
	// s = source | d = destination
	// there is 14641 possible extended blendmode combinations
	/*
	[0] bm_normal
	[1] bm_add
	[2] bm_max
	[3] bm_subtract
	
	[1] bm_zero
	[2] bm_one
	[3] bm_src_color
	[4] bm_inv_src_color
	[5] bm_src_alpha
	[6] bm_inv_src_alpha
	[7] bm_dest_alpha
	[8] bm_inv_dest_alpha
	[9] bm_dest_color
	[10] bm_inv_dest_color
	[11] bm_src_alpha_sat
	*/
	static __type0 = function(val) {
		switch(val) {
			case 0: return "bm_normal" break;
			case 1: return "bm_add" break;
			case 2: return "bm_max" break;
			case 3: return "bm_subtract" break;
			default: return "N/A" break;
		}
		return val;
	}
	static __type1 = function(val) {
		switch(val) {
			case 1: return "bm_zero" break;
			case 2: return "bm_one" break;
			case 3: return "bm_src_color" break;
			case 4: return "bm_inv_src_color" break;
			case 5: return "bm_src_alpha" break;
			case 6: return "bm_inv_src_alpha" break;
			case 7: return "bm_dest_alpha" break;
			case 8: return "bm_inv_dest_alpha" break;
			case 9: return "bm_dest_color" break;
			case 10: return "bm_inv_dest_color" break;
			case 11: return "bm_src_alpha_sat" break;
			default: return "N/A" break;
		}
		return val;
	}
	var _type = "";
	var _current = 0;
	var _max = 5;
	
	// default blendmode
	var _bm1 = bm_src_alpha;
	var _bm2 = bm_inv_src_alpha;
	var _bm3 = bm_src_alpha;
	var _bm4 = bm_one;
	
	// no blendmode
	if (index < 0) {
		gpu_set_blendenable(false);
		_type = "DISABLED BLENDING";
		_current = -1;
		_max = -1;
		_bm1 = -1;
		_bm2 = -1;
		_bm3 = -1;
		_bm4 = -1;
	}
	
	// most used blendmodes
	if (index == 0) {
		// default blendmode
		gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
		_type = "Default";
		_current = 0;
	} else
	if (index == 1) {
		// premultiply alpha (needs a shader)
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		_type = "Premultiply Alpha";
		_current = 1;
	} else
	if (index == 2) {
		// add blendmode
		gpu_set_blendmode_ext(bm_src_alpha, bm_one);
		_type = "Add";
		_current = 2;
	} else
	if (index == 3) {
		// multiply blendmode
		gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha); // or bm_zero in B
		_type = "Multiply";
		_current = 3;
	} else
	if (index == 4) {
		// subtract blendmode
		gpu_set_blendmode_ext(bm_zero, bm_inv_src_color); // or bm_zero in B
		_type = "Subtract";
		_current = 4;
	} else
	if (index == 5) {
		// invert blendmode
		gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_color); // the alpha also is affected: RGBA
		_type = "Invert";
		_current = 5;
	} else
	if (index >= 6 && index <= 9) {
		var _ind = index-6;
		gpu_set_blendmode(_ind); // bm_normal, bm_add, bm_max, bm_subtract
		_type = __type0(_ind);
		_current = _ind;
		_max = 3;
	} else
	if (index >= 10) {
		// all blendmodes
		var _ind = index;
		_current = index-10;
		_max = 14641;
		
		var p = 11;
		_bm1 = 1 + (_ind % p);
		_bm2 = 1 + ((_ind div p) % p);
		_bm3 = 1 + ((_ind div (p*p)) % p);
		_bm4 = 1 + ((_ind div (p*p*p)) % p);
		
		_type = string_join_ext(", ", [__type1(_bm1), __type1(_bm2), __type1(_bm3), __type1(_bm4)]);
		var _blends = [_bm1, _bm2, _bm3, _bm4];
		gpu_set_blendmode_ext_sepalpha(_blends);
	}
	
	var _info = string(index) + " | " + string(_current) + " / " + string(_max) + " (" + _type + ");";
	if (debug_info) show_debug_message(_info);
	return _info;
}

#endregion


#region COLOR

function color_gradient(colors_array, progress) {
	var _len = array_length(colors_array)-1;
	var _prog = clamp(progress, 0, 1) * _len;
	return merge_color(colors_array[floor(_prog)], colors_array[ceil(_prog)], frac(_prog));
}


#endregion


#region UI

#macro gui_w display_get_gui_width()
#macro gui_h display_get_gui_height()

function draw_button_test(x, y, text, callback=undefined) {
	var _pressed = false, _color_bg = c_dkgray, _color_text = c_white;
	var _ww = string_width(text)+8, _hh = string_height(text)+8;
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+_ww, y+_hh) {
		_color_bg = c_white;
		_color_text = c_dkgray;
		if mouse_check_button(mb_left) {
			_color_text = c_lime;
			_color_bg = c_gray;
		}
		if mouse_check_button_released(mb_left) {
			if !is_undefined(callback) callback();
			_pressed = true;
		}
	}
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(_color_bg);
	draw_rectangle(x, y, x+_ww, y+_hh, false);
	draw_set_color(_color_text);
	draw_text(x+_ww/2, y+_hh/2, text);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	return _pressed;
}

#endregion


#region AUDIO

function audio_create_stream_wav(file_audio) {
	if (file_exists(file_audio)) {
		// headers offset
		var _header_length = 44,
		_ho_chunk_id = 0,
		_ho_chunk_size = 4,
		_ho_audio_format = 20,
		_ho_channels_num = 22,
		_ho_sample_rate = 24,
		_ho_bps = 34,
		_ho_subchunk_id2 = 36,
		_ho_data = 44;
		
		var audio_data = {
			chunk_id : "", // < RIFF >
			audio_format : 0, // 1 is PCM
			channels_num : 0,
			sample_rate : 0, // samples per second
			bps : 0, // bits per sample (16 or 8)
		};
		
		// read file bytes
		var file_buff = buffer_load(file_audio);
		var file_size = buffer_get_size(file_buff);
		var audio_file_buff = buffer_create(file_size, buffer_fixed, 1);
		buffer_copy(file_buff, 0, file_size, audio_file_buff, 0);
		buffer_delete(file_buff);
		
		// read header
		with(audio_data) {
			var audio_buff_length = buffer_get_size(audio_file_buff);
			for (var i = 0; i <= _header_length; i++) {
				if (i >= _ho_chunk_id && i < _ho_chunk_size)
					chunk_id += chr(buffer_peek(audio_file_buff, i, buffer_u8));
				if (i >= _ho_audio_format && i < _ho_channels_num)
					audio_format += buffer_peek(audio_file_buff, i, buffer_u8);
				if (i >= _ho_channels_num && i < _ho_sample_rate)
					channels_num += buffer_peek(audio_file_buff, i, buffer_u8);
				if (i == _ho_sample_rate)
					sample_rate += buffer_peek(audio_file_buff, i, buffer_u32);
				if (i >= _ho_bps && i < _ho_subchunk_id2)
					bps += buffer_peek(audio_file_buff, i, buffer_u8);
			}
			if (string_lower(chunk_id) != "riff" || audio_format != 1) return -3;
			var _format = (bps == 8) ? buffer_u8 : buffer_s16;
			var _channels = (channels_num == 2) ? audio_stereo : ((channels_num == 1) ? audio_mono : audio_3d);
			return audio_create_buffer_sound(audio_file_buff, _format, sample_rate, _ho_data, audio_buff_length-_ho_data, _channels);;
		}
	} else {
		return -1;
	}
	return undefined;
}


#endregion


#region SHADERS [WIP]

// Wrappers for test purposes

/*function make_color_shader(color) {
	return [color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255];
}

function shader_set_uniform_float(shader, name) {
	if (argument_count > 2) {
		var i = 0;
		repeat(argument_count) {
			shader_set_uniform_f(shader_get_uniform(shader, name), argument[3+i]);
			i++;
		}
	}
}

function shader_set_uniform_float_array(shader, name, array) {
	shader_set_uniform_f_array(shader_get_uniform(shader, name), array);
}

function shader_set_uniform_int(shader, name, value) {
	shader_set_uniform_i(shader_get_uniform(shader, name), value);
}

function shader_set_uniform_int_array(shader, name, array) {
	shader_set_uniform_i_array(shader_get_uniform(shader, name), array);
}

function shader_set_uniform_mat(shader, name) {
	shader_set_uniform_matrix(shader_get_uniform(shader, name));
}

function shader_set_uniform_mat_array(shader, name, array) {
	shader_set_uniform_matrix_array(shader_get_uniform(shader, name), array);
}*/


#endregion

