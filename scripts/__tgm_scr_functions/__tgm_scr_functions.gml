
/*----------------------------------------------------------------------------------
	TurboGML. Library by FoxyOfJungle (Mozart Junior). (C) 2022, MIT License.
	Don't remove this notice, please. Credit is really appreciate! :D
	
	https://foxyofjungle.itch.io/
	https://twitter.com/foxyofjungle
	
	Special Thanks, contributions:
	YellowAfterLife, Cecil, TheSnidr, Shaun Spalding
----------------------------------------------------------------------------------*/


#region MATH & OTHERS

// pi = The ratio of the circumference of a circle to its diameter.
// Tau = The ratio of the circumference of a circle to its radius, equal to 2π.
// Phi = Golden Ratio

#macro Tau (2 * pi)
#macro HalfPi (pi / 2)
#macro Phi 1.6180339887
#macro GoldenAngle 2.3999632297
#macro EulerNumber 2.7182818280

function fibonacci(n) {
	var fib_numbers = [0, 1];
	for(var i = 2; i <= n; i++) {
		fib_numbers[i] = fib_numbers[i - 1] + fib_numbers[i - 2];
	}
	return fib_numbers[n];
}

/// @desc Return the equivalent of v on an old range of [x0, x1], on a new range of [y0, y1].
function relerp(in_min, in_max, value, out_min, out_max) {
	return (value-in_min) / (in_max-in_min) * (out_max-out_min) + out_min;
	//return lerp(out_min, out_max, linearstep(in_min, in_max, value));
}

/// @desc This is the inverse lerp. lerp() returns a blend between a and b, based on a fraction t. Inverse lerp returns a fraction t, based on a value between a and b.
/// @param {Real} minv The value of the lower edge
/// @param {Real} maxv The value of the upper edge
/// @param {Real} value he source value for interpolation.
function linearstep(minv, maxv, value) {
	return (value - minv) / (maxv - minv);
}

/// @desc Performs smooth Hermite interpolation between 0 and 1.
/// @param {Real} minv The value of the lower edge of the Hermite function.
/// @param {Real} maxv The value of the upper edge of the Hermite function.
/// @param {Real} value The source value for interpolation.
/// @returns {Real} Description
function smoothstep(minv, maxv, value) {
	var t = clamp((value - minv) / (maxv - minv), 0, 1);
	return t * t * (3 - 2 * t);
}

/// @desc Calculates the distance traveled by an object in free fall under the influence of friction
/// @param {Real} dist The distance an object falls
/// @param {Real} fric Coefficient of friction acting on the object.
/// @returns {Real}
function speed_to_reach(dist, fric) {
	return sqrt(2 * dist * fric);
}

/// @desc This function works like clamp(), but if the value is greater than max, it becomes min, and vice versa.
/// @param {Real} val The value to check.
/// @param {Real} minn The min value.
/// @param {Real} maxx The max value.
function clamp_wrap(val, minn, maxx) {
	if (val > maxx) val = minn; else if (val < minn) val = maxx;
	return val;
}

/// @desc Works like a lerp() but for angles, no rotation limits.
/// @param {Real} a The first angle to check.
/// @param {Real} b The second angle to check.
/// @param {Real} amount The amount to interpolate.
/// @returns {Real} 
function lerp_angle(a, b, amount) {
	var _a = a + angle_difference(b, a);
	return lerp(a, _a, amount);
	//return a - (angle_difference(a, b) * _amount);
}

/// @desc Verify if a value is in a range and returns a boolean.
/// @param {Real} value Value to check.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Bool} 
function in_range(value, a, b) {
	return (value >= a && value <= b);
}

// 
/// @desc Returns the difference/distance between two values
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Real} 
function distance(a, b) {
	return abs(a - b);
}

/// @desc Move linearly value 1 to value 2 in the specified amount.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @param {Real} amount Amount to move.
/// @returns {Real} 
function approach(a, b, amount) {
	//return a - clamp(a-b, -amount, amount);
	if (a < b) {
		return min(a + amount, b);
	} else {
		return max(a - amount, b);
	}
}

/// @desc This function moves linearly one angle to another by the specified amount.
/// @param {Real} angle Current angle.
/// @param {Real} dir Facing point direction.
/// @param {Real} amount The amount to move.
/// @returns {real} Description
function angle_towards(angle, dir, amount) {
	return median(-amount, amount, angle_difference(-dir, -angle));
}
//function angle_towards(angle1, angle2, spd) {
//	var _dir = angle_difference(angle1, angle2);
//	return min(abs(_dir), spd) * sign(_dir);
//}

/// @desc This function returns the frame index to be used on a sprite, relative to the angle it is pointing at.
/// @param {real} angle Description
/// @param {real} frames_amount Description
/// @returns {real} Description
function angle_get_subimg(angle, frames_amount) {
	var _angle_seg = 360 / frames_amount;
	return ((angle + (_angle_seg / 2)) % 360) div _angle_seg;
}

// Based on: https://www.reddit.com/r/gamemaker/comments/b0zelv/need_a_help_about_the_prediction_shot/
/// @desc This function predicts the angle that must be aimed until the bullet hits exactly on the target.
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @param {Real} target_speed Target moving speed.
/// @param {Real} target_angle Target moving angle/direction.
/// @param {Real} bullet_speed Bullet moving speed.
/// @returns {Real} 
function angle_predict_intersection(x1, y1, x2, y2, target_speed, target_angle, bullet_speed) {
	var _angle = point_direction(x1, y1, x2, y2),
	_beta = sin(degtorad(target_angle - _angle)) * (target_speed/bullet_speed);
	return (abs(_beta) < 1) ? _angle+radtodeg(arcsin(_beta)) : -1;
}

// failed attempts
function motion_predict_intersection(x1, y1, x2, y2, target_speed, target_angle, bullet_speed) { // doesn't works as expected!!
	var _bullet_dir = point_direction(x1, y1, x2, y2);
	var alpha = target_speed / bullet_speed;
	var phi = degtorad(target_angle - _bullet_dir);
    var beta = alpha * sin(phi);
	var _distance_to_intercept = point_distance(x1, y1, x2, y2) * sin(phi) / sin(phi - arcsin(beta));
	var _intercept_x = x1 + dcos(_bullet_dir) * _distance_to_intercept;
	var _intercept_y = y1 - dsin(_bullet_dir) * _distance_to_intercept;
	return new Vector2(_intercept_x, _intercept_y);
}

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


/// @desc This function returns the direction between two points, in radians (pi).
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @returns {real} 
function point_direction_radians(x1, y1, x2, y2) {
	return arctan2(y2-y1, x2-x1);
}

/// @desc This function returns the normalized direction between two points. Expected results: -1 to 1, both horizontal and vertical
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @returns {Struct} 
function point_direction_normalized(x1, y1, x2, y2) {
	//var dir = degtorad(-point_direction(x1, y1, x2, y2));
	var dir = arctan2(y2-y1, x2-x1);
	return new Vector2(cos(dir), sin(dir));
}

function point_in_cone(px, py, x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist,
	_len_y1 = dsin(angle - fov/2) * dist,
	_len_x2 = dcos(angle + fov/2) * dist,
	_len_y2 = dsin(angle + fov/2) * dist;
    return point_in_triangle(px, py, x, y, x+_len_x1, y-_len_y1, x+_len_x2, y-_len_y2);
}

function point_in_arc(px, py, x, y, angle, dist, fov) {
	return (point_distance(px, py, x, y) < dist && abs(angle_difference(angle, point_direction(x, y, px, py))) < fov/2);
}

function non_zero(value, zero_value=1) {
	return value != 0 ? value : zero_value;
}

function is_fractional(number) {
	return (frac(number) > 0);
}

function is_number_even(number) {
	return (number % 2 == 0);
}

function is_number_odd(number) {
	return (number % 2 == 1);
}

function is_number_prime(number) {
	if (number < 2) return false;
	for(var i = 2; i < number; i++) {
		if (number % i == 0) {
			return false;
		}
	}
	return true;
}

function pow2_next(val) {
	return 1 << ceil(log2(val));
}

function pow2_previous(val) {
	return 1 << floor(log2(val));
}

function wave_normalized(spd=1) {
	return sin(current_time*0.0025*spd) * 0.5 + 0.5;
}

/// @desc Returns a random value depending on its weight.
/// @param {Array} items Total array of items to be returned. It can be any data type: numbers, strings, arrays, structs, data structures, etc.
/// @param {Array<Real>} weights Weight of items in order. Higher values have a higher probability of returning the item.
/// You can use any range of numbers, either 0 to 1 or 0 to 9999 or inf.
/// It is possible to use equal weights, having the same probability of being returned.
function choose_weighted(items, weights) {
	var isize = array_length(items);
	var wsize = array_length(weights);
	if (isize != wsize) show_error("Both arrays must be the same size.", true);
	// sum weights
	var _weights_sum = 0;
	var i = 0;
	repeat(wsize) {
		_weights_sum += abs(weights[i]);
		++i;
	}
	// randomize
	var _val = random(_weights_sum);
	i = 0;
	repeat(isize) {
		_val -= abs(weights[i]);
		if (_val < 0) return items[i];
		++i;
	}
	return items[0];
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
		return point_direction(x, y, vector2.x, vector2.y);
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
			clamp(z, min_vector.z, max_vector.z)
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
	
	/// @desc Returns the angle in degrees of this vector.
	static angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
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
	
	/// @desc Returns the angle (z rotation) in degrees to the given vector.
	static yawTo = function(vector3) {
		gml_pragma("forceinline");
		return point_direction(x, y, vector3.x, vector3.y); // I was too lazy to write the math behind it for now
	}
	
	/// @desc Returns the pitch angle (x rotation) in degrees to the given vector.
	static pitchTo = function(vector3) {
		return radtodeg(arctan2(vector3.z-z, point_distance(x, y, vector3.x, vector3.y)));
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static maxV = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			max(x, vector3.x),
			max(y, vector3.y),
			max(z, vector3.z)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static minV = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			min(x, vector3.x),
			min(y, vector3.y),
			min(z, vector3.z)
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


function Vector4(x, y=x, z=x, w=x) constructor {
	self.x = x;
	self.y = y;
	self.z = z;
	self.w = w;
}

#endregion


#region CAMERA

function camera_get_fov(proj_mat) {
	return radtodeg(arctan(1.0/proj_mat[5]) * 2.0);
}

function camera_get_aspect(proj_mat) {
	return proj_mat[5] / proj_mat[0];
}

function camera_get_far_plane(proj_mat) {
	return -proj_mat[14] / (proj_mat[10]-1);
}

function camera_get_near_plane(proj_mat) {
	return -2 * proj_mat[14] / (proj_mat[10]+1);
}

function camera_get_area_2d(view_mat, proj_mat) {
	var _cam_x = -view_mat[12];
	var _cam_y = -view_mat[13];
	var _cam_w = round(abs(2/proj_mat[0]));
	var _cam_h = round(abs(2/proj_mat[5]));
	return new Vector4(_cam_x-_cam_w/2, _cam_y-_cam_h/2, _cam_w, _cam_h);
}



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

#macro DEBUG_SPEED_INIT var ___time = get_timer()
#macro DEBUG_SPEED_GET show_debug_message(string((get_timer()-___time)/1000) + "ms")

function game_in_IDE() {
	//if (debug_mode) return true;
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

function invoke(callback, args, time, repetitions=1) {
	var _ts = time_source_create(time_source_game, time, time_source_units_frames, callback, args, repetitions);
	time_source_start(_ts);
	return _ts;
}

#endregion


#region PROCEDURAL GENERATION	

function pattern_read_sprite(sprite, wspace=1, hspace=1) {
	var _width = sprite_get_width(sprite),
	_height = sprite_get_height(sprite),
	
	_surf = surface_create(_width, _height);
	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_sprite(sprite, 0, 0, 0);
	surface_reset_target();
	
	var _buff = buffer_create(_width * _height * 4, buffer_fixed, 1);
	buffer_get_surface(_buff, _surf, 0);
	
	// data structure with info
	var data = {
		blocks : [],
		width : 0,
		height : 0,
	};
	
	// read every sprite pixel
	var _r, _g, _b, _a, _pixel, _col;
	var i = 0, j = 0, _total = 0;
	repeat(_width) {
		j = 0;
		repeat(_height) {
			_pixel = buffer_peek(_buff, 4 * (i + j * _width), buffer_u32); // get abgr
			_r = _pixel & $ff;
			_g = (_pixel >> 8) & $ff;
			_b = (_pixel >> 16) & $ff;
			_a = (_pixel >> 24) & $ff;
			
			_col = make_color_rgb(_r, _g, _b);
			
			// add pixel position data to array
			var _json = {
				x : i * wspace,
				y : j * hspace,
				p : (_col == c_white ? 1 : 0),
			}
			data.blocks[_total] = _json;
			_total++;
			++j;
		}
		++i;
	}
	data.width = i;
	data.height = j;
	
	surface_free(_surf);
	buffer_delete(_buff);
	return data;
}




#endregion


#region ASSERT

function assert_array_or(condition, values_array) {
	var i = 0, isize = array_length(values_array);
	repeat(isize) {
		if (condition == values_array[i]) return true;
		++i;
	}
	return false;
}

function assert_array_and(condition, values_array) {
	var i = 0, isize = array_length(values_array);
	repeat(isize) {
		if (condition != values_array[i]) return false;
		++i;
	}
	return true;
}

#endregion


#region DELTA TIME & MOUSE

// PLEASE NOTE: THIS IS A BASIC IMPLEMENTATION OF DELTA TIMING
// USE "IOTA" BY JUJU, FOR ROBUST DELTA TIMING

// Delta Time
// base frame rate
#macro FRAME_RATE 60

// delta time, used for multiplying things
#macro DELTA_TIME global.__delta_time_multiplier

// delta time scale, used for slow motion
#macro DELTA_TIME_SCALE global.__delta_time_scale

// delta update smoothness, is the interpolated speed used to smooth out sudden FPS changes (1 = default)
#macro DELTA_UPDATE_LERP 1


// internal
global.__delta_speed = 0;
global.__delta_time_multiplier_base = 1;
global.__delta_time_multiplier = 1;
global.__delta_time_scale = 1;
//global.__frame_count

// Delta Mouse
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

var _tm;
_tm = call_later(1, time_source_units_frames, function() {
	// delta time
	global.__delta_speed = 1/FRAME_RATE;
	global.__delta_time_multiplier_base = (delta_time/1000000)/global.__delta_speed;
	global.__delta_time_multiplier = lerp(global.__delta_time_multiplier, global.__delta_time_multiplier_base, 1) * global.__delta_time_scale;
	
	// delta mouse
	global.__mouse_x_delta = mouse_x - global.__mouse_x_previous;
	global.__mouse_y_delta = mouse_y - global.__mouse_y_previous;
	global.__gui_mouse_x_delta = mouse_x - global.__gui_mouse_x_previous;
	global.__gui_mouse_y_delta = mouse_y - global.__gui_mouse_y_previous;
}, true);

_tm = call_later(2, time_source_units_frames, function() {
	var _tm = call_later(1, time_source_units_frames, function() {
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


function file_write_text(file_path, str) {
	var _buff = buffer_create(1, buffer_grow, 1);
	buffer_write(_buff, buffer_text, str);
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


function file_read_text(file_path) {
	if (!file_exists(file_path)) return undefined;
	var _buffer = buffer_load(file_path);
	var _result = buffer_read(_buffer, buffer_text);
	buffer_delete(_buffer);
	return _result;
}


function bytes_get_size(bytes) {
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
					size : get_size ? bytes_get_size(file_get_size(_path)) : -1,
				} : _fname);
			}
		}
		++i;
	}
	
	return _contents;
}

function DirectoryScanner(path, extension="*.*", search_folders=true, search_files=true, search_subdir=true, full_info=true, get_size=false) constructor {
	__contents = [];
	__loaded = false;
	__path_exists = false;
	
	if (directory_exists(path)) {
		__directory_recursive_search(__contents, path, string(extension), search_folders, search_files, search_subdir, full_info, get_size);
		__loaded = true;
		__path_exists = true;
	} else {
		show_debug_message("Directory Scanner: Error, can't find directory to scan.");
	}
	
	static GetContents = function() {
		return __path_exists ? __contents : undefined;
	}
	
	static GetFilesAmount = function() {
		return array_length(__contents);
	}
	
	static IsLoaded = function() {
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

#macro SORT_ASCENDING function(a, b) {return a - b}
#macro SORT_DESCENDING function(a, b) {return b - a}

function array_choose(array) {
	return array[irandom_range(0, array_length(array)-1)];
}

//function array_shuffle(array) {
//	static _f = function() {
//		return irandom_range(-1, 1);
//	}
//	array_sort(array, _f);
//}

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

/// @desc Calculates the sum of all numbers contained in the array.
/// @param {array} array Array to sum numbers.
/// @returns {real}
function array_sum(array) {
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

function array_contains(array, value) {
	var i = 0, isize = array_length(array);
	repeat(isize) {
		if (array[i] == value) return true;
		++i;
	}
	return false;
}

function array_copy_all(from, to) {
	array_copy(to, 0, from, 0, array_length(from));
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


function struct_empty(struct) {
	return (variable_struct_names_count(struct) == 0);
}


// get value from json only if exists, without returning undefined
function struct_get_variable(struct, name, default_value=0) {
	if (!is_struct(struct)) return default_value;
	return struct[$ name] ?? default_value;
}


// get and remove a variable from a struct
function struct_pop(struct, name) {
	var _value = struct[$ name];
	variable_struct_remove(struct, name);
	return _value;
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
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
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
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
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
	return normalize ? new Vector2(_px/gui_width, _py/gui_height) : new Vector2(_px, _py);
}


/// @desc Transforms a 2D coordinate (in window space) to a 3D vector.
/// Returns an array of the following format:
/// [dx, dy, dz, ox, oy, oz]
/// where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.
/// Works for both orthographic and perspective projections.
function screen_to_world_dimension(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr
	var _mx = 2 * (xx / window_get_width() - 0.5) / proj_mat[0];
	var _my = 2 * (yy / window_get_height() - 0.5) / proj_mat[5];
	var _cam_x = - (view_mat[12] * view_mat[0] + view_mat[13] * view_mat[1] + view_mat[14] * view_mat[2]);
	var _cam_y = - (view_mat[12] * view_mat[4] + view_mat[13] * view_mat[5] + view_mat[14] * view_mat[6]);
	var _cam_z = - (view_mat[12] * view_mat[8] + view_mat[13] * view_mat[9] + view_mat[14] * view_mat[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (proj_mat[15] == 0) {
	// perspective projection
	_matrix = [view_mat[2]  + _mx * view_mat[0] + _my * view_mat[1],
			view_mat[6]  + _mx * view_mat[4] + _my * view_mat[5],
			view_mat[10] + _mx * view_mat[8] + _my * view_mat[9],
			_cam_x,
			_cam_y,
			_cam_z];
	} else {
	// orthographic projection
	_matrix = [view_mat[2],
			view_mat[6],
			view_mat[10],
			_cam_x + _mx * view_mat[0] + _my * view_mat[1],
			_cam_y + _mx * view_mat[4] + _my * view_mat[5],
			_cam_z + _mx * view_mat[8] + _my * view_mat[9]];
	}
	var _xx = _matrix[0] * _matrix[5] / -_matrix[2] + _matrix[3];
	var _yy = _matrix[1] * _matrix[5] / -_matrix[2] + _matrix[4];
	return new Vector2(_xx, _yy);
}


/// @desc Transforms a 3D coordinate to a 2D coordinate. Returns a Vector2 with x and y.
/// Returns [-1, -1] if the 3D point is behind the camera
/// Works for both orthographic and perspective projections.
function world_to_screen_dimension(view_mat, proj_mat, xx, yy, zz, normalized=false) {
	// credits: TheSnidr
	var _w = view_mat[2] * xx + view_mat[6] * yy + view_mat[10] * zz + view_mat[14];
	if (_w <= 0) return new Vector2(-1, -1);
	var _cx, _cy;
	if (proj_mat[15] == 0) {
		// this is a perspective projection
		_cx = proj_mat[8] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]) / _w;
		_cy = proj_mat[9] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]) / _w;
	} else {
		// this is an ortho projection
		_cx = proj_mat[12] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]);
		_cy = proj_mat[13] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]);
	}
	
	if (normalized) {
		return new Vector2((0.5+0.5*_cx), (0.5+0.5*_cy));
	} else {
		return new Vector2((0.5+0.5*_cx) * window_get_width(), (0.5+0.5*_cy) * window_get_height());
	}
}

#endregion


#region LAYERS

// get the top instance of any layer/depth
function instance_top_position(px, py, object) {
	var _top_instance = noone;
	var _list = ds_list_create();
	var _num = collision_point_list(px, py, object, false, true, _list, false);
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

#endregion


#region PATHS

function distance_to_path(x, y, path) {
	// calculates the shortest distance to the given path
	var x0, y0;
	x0 = x;
	y0 = y;

	var i, points, segments, length, pos, pmin, pmax, x1, y1, x2, y2, dx, dy, t, ix, iy, dist, min_dist;

	if (path_get_kind(path) == 0) {
		// Straight path
		// Get the number of control points and line segments on the path
		segments = points;
		if (!path_get_closed(path)) segments -= 1;

		// First, find the nearest control point.
		min_dist = infinity;
		for(i = 0; i < points; i++) {
			x1 = path_get_point_x(path, i);
			y1 = path_get_point_y(path, i);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < min_dist) min_dist = dist;
		}
    
		// Second, calculate the distance to each line segment and find the nearest one.
		x1 = path_get_point_x(path, 0);
		y1 = path_get_point_y(path, 0);
		for(i = 0; i < segments; i++) {
			x2 = path_get_point_x(path, (i+1) mod points);
			y2 = path_get_point_y(path, (i+1) mod points);

			dx = x2 - x1;
			dy = y2 - y1;
			if (dx != 0 || dy != 0) {
				// See if there is an intersection between the line segment
				// and the perpendicular line to it.
				t = -(dx * (x1 - x0) + dy * (y1 - y0)) / (sqr(dx) + sqr(dy));
				if (t >= 0 && t < 1) {
					// Calculate the distance to the intersection point.
					ix = x1 + dx * t;
					iy = y1 + dy * t;
					dist = point_distance(x0, y0, ix, iy);
					if (dist < min_dist)
					min_dist = dist;
				}
			}
			x1 = x2;
			y1 = y2;
		}
	} else {
		// Smooth path
		// First, split the path into a few segments and find the nearest one.
		length = path_get_length(path);
		segments = max(4, length / 32); // Hope this is enough
		min_dist = infinity;
		pmin = 0;
		for(i = 0; i <= segments; i += 1) {
			pos = i/segments;
			x1 = path_get_x(path, pos);
			y1 = path_get_y(path, pos);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < min_dist) {
				min_dist = dist;
				pmin = pos;
			}
		}
		
		// Now, accurately find the nearest point on the segment.
		// At this point, pmin has the position of the provisional nearest point,
		// and the following two lines are to get two end points adjacent to it.
		pmax = min(pmin + 1/segments, 1);
		pos = max(0, pmin - 1/segments);
		do {
			x1 = path_get_x(path, pos);
			y1 = path_get_y(path, pos);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < min_dist) min_dist = dist;
			pos += 1/length;
		}
		until (pos >= pmax);
	}
	return min_dist;
}


function path_get_closest_point(xx, yy, path) {
	var i = 0, isize = path_get_number(path),
	_px = 0, _py = 0, _dist = 0,
	_pri_x = ds_priority_create(), _pri_y = ds_priority_create();
	repeat(isize) {
		_px = path_get_point_x(path, i);
		_py = path_get_point_y(path, i);
		_dist = point_distance(xx, yy, _px, _py);
		ds_priority_add(_pri_x, i, _dist);
		ds_priority_add(_pri_y, i, _dist);
		++i;
	}
	var _pos = new Vector2(
		ds_priority_find_min(_pri_x),
		ds_priority_find_min(_pri_y)
	);
	ds_priority_destroy(_pri_x);
	ds_priority_destroy(_pri_y);
	return _pos;
}


function path_get_closest_point_position(xx, yy, path) {
	var i = 0, isize = path_get_number(path),
	_px = 0, _py = 0, _dist = 0,
	_pri_x = ds_priority_create(), _pri_y = ds_priority_create();
	repeat(isize) {
		_px = path_get_point_x(path, i);
		_py = path_get_point_y(path, i);
		_dist = point_distance(xx, yy, _px, _py);
		ds_priority_add(_pri_x, _px, _dist);
		ds_priority_add(_pri_y, _py, _dist);
		++i;
	}
	var _pos = new Vector2(
		ds_priority_find_min(_pri_x),
		ds_priority_find_min(_pri_y)
	);
	ds_priority_destroy(_pri_x);
	ds_priority_destroy(_pri_y);
	return _pos;
}


function path_get_direction(pth, pos) {
	var _reciprocal = (1 / path_get_length(pth)),
	_pos_1 = pos - _reciprocal,
	_pos_2 = pos + _reciprocal,
	_x1 = path_get_x(pth, _pos_1),
	_y1 = path_get_y(pth, _pos_1),
	_x2 = path_get_x(pth, _pos_2),
	_y2 = path_get_y(pth, _pos_2),
	_dir = point_direction(_x1, _y1, _x2, _y2);
	return _dir;
}


/*function path_get_position(path, xx, yy) {
	// Return a path_position corresponding to the point (x, y) on the given path.
	// If no path_position corresponds with this point, then return undefined.
	// This script assumes that the given path is not smooth, but exists of a finite amount of line segments only.
	var n = path_get_length(path);

	// "px" is the x coordinate of the previous path point
	// "py" is the y coordinate of the previous path point
	// "nx" is the x coordinate of the current path point
	// "ny" is the y coordinate of the current path point
	// "result" conatins the distance in pixels of the path up to the point (px, py)
	var px, py,
	nx = path_get_point_x(path, 0),
	ny = path_get_point_y(path, 0),
	result = 0;
	
	// If (x, y) corresponds to the start of the path, return 0
	if xx == nx && yy == ny
	return 0;
	
	// Loop through every path point
	for(var i = 1; i < n; i++) {
		px = nx;
		py = ny;
		nx = path_get_point_x(path, i);
		ny = path_get_point_y(path, i);
		// Calculate the cross product of the vector from (px, py, 0) to (nx, ny, 0)
		// and from (px, py, 0) to (x, y, 0)
		// This product is 0 if and only if the two vectors share the same line
		// If they don't share the same line, then the line through (px, py) ad (nx, ny) can't contain (x, y)
		if (nx - px) * (yy - py) == (xx - px) * (ny - py) {
			// If so, calculate the dot product p * d of these two vectors
			// The point (x, y) is contained by the line segment from (px, py) to (nx, ny)
			// if and only if 0 <= p <= d
			var d = point_distance(px, py, xx, yy);
			var p = (nx - px) * (xx - px) + (ny - py) * (yy - py);
			if p >= 0 && p <= d * point_distance(px, py, nx, ny)
			// The line segment contains the point, so add the remaining distance from (px, py) to (x, y)
			// and normalize the path position to a number between 0 and 1
			// by dividing result by the total path length
			return (result + d) / path_get_length(path);
		}
		// If the line segment didn't contain the point, update the result and continue the loop
		result += point_distance(px, py, nx, ny);
	}
	
	// If no line segment containing (x, y) is found, return undefined
	return undefined;
}
*/

#endregion


#region DRAWING

global.__tgm_sh_uni = {
	sprite_pos_uab : shader_get_uniform(__tgm_sh_quad_persp, "uAB"),
	sprite_pos_ucd : shader_get_uniform(__tgm_sh_quad_persp, "uCD"),
	sprite_pos_uvs : shader_get_uniform(__tgm_sh_quad_persp, "uUVS"),
};


function draw_quad_lines(x1, y1, x2, y2, x3, y3, x4, y4, middle_line=false) {
	draw_line(x1, y1, x2, y2);
	draw_line(x1, y1, x4, y4);
	draw_line(x4, y4, x3, y3);
	draw_line(x2, y2, x3, y3);
	if (middle_line) draw_line(x1, y1, x3, y3);
}


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
		gpu_set_blendmode_ext_sepalpha(_bm1, _bm2, _bm3, _bm4);
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

function make_color_shader(color) {
	return [color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255];
}

#endregion


#region GRAPHICS PIPELINE

#macro ANTIALIASING_MAX_AVAILABLE max(display_aa & 2, display_aa & 4, display_aa & 8)


#endregion


#region UI

#macro gui_w display_get_gui_width()
#macro gui_h display_get_gui_height()

function draw_button_test(x, y, text, callback=undefined) {
	var _old_font = draw_get_font(),
	old_halign = draw_get_halign(),
	old_valign = draw_get_valign(),
	old_color = draw_get_color(),
	var _pressed = false, _color_bg = c_dkgray, _color_text = c_white;
	var _ww = string_width(text)+8, _hh = string_height(text)+8;
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+_ww, y+_hh) {
		_color_bg = c_white;
		_color_text = c_dkgray;
		if mouse_check_button(mb_left) {
			_color_text = c_lime;
			_color_bg = c_black;
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
	draw_set_font(-1);
	draw_text(x+_ww/2, y+_hh/2, text);
	draw_set_font(_old_font);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);
	draw_set_color(old_color);
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
		var _file_buff = buffer_load(file_audio),
		_file_size = buffer_get_size(_file_buff),
		_audio_file_buff = buffer_create(_file_size, buffer_fixed, 1),
		_audio_buff_length = buffer_get_size(_audio_file_buff);
		buffer_copy(_file_buff, 0, _file_size, _audio_file_buff, 0);
		buffer_delete(_file_buff);
		
		// read header
		with(audio_data) {
			for(var i = 0; i <= _header_length; i++) {
				if (i >= _ho_chunk_id && i < _ho_chunk_size)
					chunk_id += chr(buffer_peek(_audio_file_buff, i, buffer_u8));
				if (i >= _ho_audio_format && i < _ho_channels_num)
					audio_format += buffer_peek(_audio_file_buff, i, buffer_u8);
				if (i >= _ho_channels_num && i < _ho_sample_rate)
					channels_num += buffer_peek(_audio_file_buff, i, buffer_u8);
				if (i == _ho_sample_rate)
					sample_rate += buffer_peek(_audio_file_buff, i, buffer_u32);
				if (i >= _ho_bps && i < _ho_subchunk_id2)
					bps += buffer_peek(_audio_file_buff, i, buffer_u8);
			}
			if (string_lower(chunk_id) != "riff" || audio_format != 1) return -3;
			var _format = (bps == 8) ? buffer_u8 : buffer_s16,
			_channels = (channels_num == 2) ? audio_stereo : ((channels_num == 1) ? audio_mono : audio_3d);
			return audio_create_buffer_sound(_audio_file_buff, _format, sample_rate, _ho_data, _audio_buff_length-_ho_data, _channels);
		}
	} else {
		return -1;
	}
	return undefined;
}


#endregion


#region 3D

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
global.vbf_default_format = vertex_format_end();

/// @func vertex_add_point(vbuff, xx, yy, zz, nx, ny, nz, u, v, color, alpha)
function vertex_add_point(vbuff, xx, yy, zz, nx, ny, nz, u, v, color, alpha) {
	gml_pragma("forceinline");
	vertex_position_3d(vbuff, xx, yy, zz);
	vertex_normal(vbuff, nx, ny, nz);
	vertex_texcoord(vbuff, u, v);
	vertex_color(vbuff, color, alpha);
}


function model_build_plane(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, color=c_white, alpha=1) {
	var _vbuff = vertex_create_buffer();
	
	vertex_begin(_vbuff, global.vf_default);
	vertex_add_point(_vbuff, x1, y1, z1, 0, 0, 1, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	vertex_end(_vbuff);
	
	vertex_freeze(_vbuff);
	return _vbuff;
}


function model_build_cube(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, color=c_white, alpha=1) {
	var _vbuff = vertex_create_buffer();
	
	vertex_begin(_vbuff, global.vf_default);
	
	// top
	vertex_add_point(_vbuff, x1, y1, z2, 0, 0, 1, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	// bottom
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, 0, 0, -1, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	
	// front
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, 0, 1, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	
	// back
	vertex_add_point(_vbuff, x1, y1, z1, 0, -1, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, -1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	// right
	vertex_add_point(_vbuff, x2, y1, z1, 1, 0, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	// left
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, -1, 0, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	
	// finalize VBO
	vertex_end(_vbuff);
	vertex_freeze(_vbuff);
	return _vbuff;
}

//function model_build_ellipsoid(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, steps, color=c_white, alpha=1) {
//	steps = clamp(steps, 3, 128);
	
//	var _vbuff = vertex_create_buffer();
//	var _cc;
//	var _ss;
//	_cc[steps] = 0;
//	_ss[steps] = 0;
	
//	var i;
//	for(i = 0; i <= steps; i++) {
//		var __rad = (i * 2.0 * pi) / steps;
//		_cc[i] = cos(__rad);
//		_ss[i] = sin(__rad);
//	}
	
//	var _mx = (x2 + x1) / 2,
//	_my = (y2 + y1) / 2,
//	_mz = (z2 + z1) / 2,
//	_rx = (x2 - x1) / 2,
//	_ry = (y2 - y1) / 2,
//	_rz = (z2 - z1) / 2,
//	_rows = (steps+1)/2, j;
	
//	for(j = 0; j <= (_rows - 1); j++) {
//		var __row1rad = (j*pi)/_rows;
//		var __row2rad = ((j+1)*pi)/_rows;
//		var __rh1 = cos(__row1rad);
//		var __rd1 = sin(__row1rad);
//		var __rh2 = cos(__row2rad);
//		var __rd2 = sin(__row2rad);
	
//		vertex_begin(_vbuff, global.vf_default);
//		for(i = 0; i <= steps; i++) {
//			vertex_add_point(_vbuff, _mx+_rx*__rd1*_cc[i], _my+_ry*__rd1*_ss[i], _mz+_rz*__rh1,__rd1*_cc[i], __rd1*_ss[i], __rh1, hrepeat*i/steps, j*vrepeat/_rows, color, alpha);
//			vertex_add_point(_vbuff, _mx+_rx*__rd2*_cc[i], _my+_ry*__rd2*_ss[i], _mz+_rz*__rh2,__rd2*_cc[i], __rd2*_ss[i], __rh2, hrepeat*i/steps, (j+1)*vrepeat/_rows, color, alpha);
//		}
//		vertex_end(_vbuff);
//	}
//	return _vbuff;
//}

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

