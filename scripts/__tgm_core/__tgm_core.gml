
/*--------------------------------------------------------------------------------------------
	TurboGML. A complete library with must-have functionality.
	- Library by FoxyOfJungle (Mozart Junior). (C) 2023, MIT License.
	
	It would mean a lot to me to have my name in your project/game credits! :D
	Don't remove this notice, please :)
	
	https://foxyofjungle.itch.io/
	https://twitter.com/foxyofjungle
	
	..............................
	Special Thanks, contributions:
	YellowAfterLife, Cecil, TheSnidr, Xot, Shaun Spalding, gnysek, icuurd12b42, DragoniteSpam,
	Grisgram.
	(authors' names written in comment inside the functions used)
	
	Supporters:
	RookTKO
---------------------------------------------------------------------------------------------*/

/*
	MIT License
	
	Copyright (c) 2022 Mozart Junior (FoxyOfJungle)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/
// Feather ignore all

#region MATH and RELATED

// pi = The ratio of the circumference of a circle to its diameter.
// Tau = The ratio of the circumference of a circle to its radius, equal to 2π.
// Phi = Golden Ratio.

#macro Tau (2 * pi)
#macro HalfPi (pi / 2)
#macro Phi 1.6180339887
#macro GoldenAngle 2.3999632297
#macro EulerNumber 2.7182818280


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
/// @returns {Real}
function smoothstep(minv, maxv, value) {
	var t = clamp((value - minv) / (maxv - minv), 0, 1);
	return t * t * (3 - 2 * t);
}

/// @desc 0 is returned if value < edge, and 1 is returned otherwise.
/// @param {Real} edge The location of the edge of the step function.
/// @param {Real} value The value to be used to generate the step function.
/// @returns {real}
function step(edge, value) {
	return (value < edge) ? 0 : 1;
}

/// @desc Returns the cosine, but with a normalized range of 0 to 1
/// @param {real} radians_angle Angle in radians.
/// @returns {real}
function cos01(radians_angle) {
	gml_pragma("forceinline");
	return (cos(radians_angle) * 0.5 + 0.5);
}

/// @desc Returns the sine, but with a normalized range of 0 to 1
/// @param {real} radians_angle Angle in radians.
/// @returns {real}
function sin01(radians_angle) {
	gml_pragma("forceinline");
	return (sin(radians_angle) * 0.5 + 0.5);
}

/// @desc Returns the tangent, but with a normalized range of 0 to 1
/// @param {real} radians_angle Angle in radians.
/// @returns {real}
function tan01(radians_angle) {
	gml_pragma("forceinline");
	return (tan(radians_angle) * 0.5 + 0.5);
}

/// @desc Returns the reciprocal of the square root of "val".
/// @param {Real} Value
function inverse_sqrt(val) {
	return 1 / sqrt(abs(val));
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
function distance_1d(a, b) {
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
	// Original author: Xot
	var _angle = point_direction(x1, y1, x2, y2),
	_beta = sin(degtorad(target_angle - _angle)) * (target_speed/bullet_speed);
	return (abs(_beta) < 1) ? _angle+radtodeg(arcsin(_beta)) : -1;
}

// failed attempts [help is appreciated :')]
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

/// @desc This function prevents it from returning 0, returning another value instead, if this happen.
/// @param {Real} value The value.
/// @param {Real} zero_value Value to return.
/// @returns {real} 
function non_zero(value, zero_value=1) {
	return value != 0 ? value : zero_value;
}

function is_fractional(number) {
	return (frac(number) > 0);
}

function is_even_number(number) {
	return (number & 1 == 0);
	//return (number % 2 == 0);
}

function is_odd_number(number) {
	return (number & 1 == 1);
	//return (number % 2 == 1);
}

function is_prime_number(number) {
	if (number < 2) return false;
	for(var i = 2; i < number; i++) {
		if (number % i == 0) {
			return false;
		}
	}
	return true;
}

/// @desc Returns the next power of two number, based on the value.
/// @param {real} value The value to check.
/// @returns {real}
function pow2_next(value) {
	return 1 << ceil(log2(value));
}

/// @desc Returns the previous power of two number, based on the value.
/// @param {real} value The value to check.
/// @returns {real}
function pow2_previous(value) {
	return 1 << floor(log2(value));
}

function fibonacci(n) {
	var _numbers = [0, 1];
	for(var i = 2; i <= n; i++) {
		_numbers[i] = _numbers[i - 1] + _numbers[i - 2];
	}
	return _numbers[n];
}

function factorial(n) {
	var _number = 1;
	for(var i = 1; i <= n; ++i) {
		_number *= i;
	}
	return _number;
}

/// @desc Greatest common divisor.
function gcd(a, b) {
	if (b == 0) {
		return a;
	} else {
		return gcd(b, a % b);
	}
}

function fraction_reduce(a, b) {
	var _gcd = gcd(a, b);
	return new Vector2(a/_gcd, b/_gcd);
}

function wave_normalized(spd=1) {
	return sin(current_time*0.0025*spd) * 0.5 + 0.5;
}

#endregion


#region VECTORS & RAYCASTING

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


function raycast_hit_point_2d(origin_x, origin_y, object, angle, distance, precise=true, notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/
	// edited by FoxyPfJungle
	var _dir = degtorad(angle),
	_x1 = origin_x,
	_y1 = origin_y,
	_x2 = origin_x + cos(_dir)*distance,
	_y2 = origin_y - sin(_dir)*distance,
	
	_col = collision_line(_x1, _y1, _x2, _y2, object, precise, notme),
	_col2 = noone,
	
	_xo = _x1,
	_yo = _y1;
	
	if (_col != noone) {
		var _p0 = 0,
		_p1 = 1,
		_np = 0,
		_px = 0,
		_py = 0,
		_nx = 0,
		_ny = 0,
		_len = ceil(log2(point_distance(_x1, _y1, _x2, _y2))) + 1;
		repeat(_len) {
			_np = _p0 + (_p1 - _p0) * 0.5;
			_nx = _x1 + (_x2 - _x1) * _np;
			_ny = _y1 + (_y2 - _y1) * _np;
			_px = _x1 + (_x2 - _x1) * _p0;
			_py = _y1 + (_y2 - _y1) * _p0;
			_col2 = collision_line(_px, _py, _nx, _ny, object, precise, notme);
			if (_col2 != noone) {
				_col = _col2;
				_xo = _nx;
				_yo = _ny;
				_p1 = _np;
			} else _p0 = _np;
		}
	}
	return new Vector3(_xo, _yo, _col);
}

// old (unused)
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


function raycast_tag_hit_point_2d(origin_x, origin_y, tags, include_children, angle, distance, precise=true, notme=true) {
	// original by: YellowAfterLife, https://yal.cc/gamemaker-collision-line-point/ | edited by FoxyPfJungle
	// search for tag objects
	var _object_ids_array = tag_get_asset_ids(tags, asset_object),
	i = 0, isize = array_length(_object_ids_array), _col;
	repeat(isize) {
		// raycast
		_col = raycast_hit_point_2d(origin_x, origin_y, _object_ids_array[i], angle, distance, precise, notme);
		if (_col.z != noone) return _col;
		++i;
	}
	return new Vector3(origin_x, origin_y, noone);
}

#endregion


#region GENERAL

#macro fps_average ___fps_average()
/// @ignore
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


#region DATA

function ds_debug_print(data_structure, type) {
	var _separator = string_repeat("-", 32);
	show_debug_message(_separator);
	
	if (!is_real(data_structure) || !ds_exists(data_structure, type)) {
		show_debug_message("Data structure does not exist.");
		exit;
	}
	
	switch(type) {
		case ds_type_list:
			var _txt = "DS_LIST:\n";
			var i = 0, isize = ds_list_size(data_structure);
			repeat(isize) {
				_txt += "\n" + string(data_structure[| i]);
				++i;
			}
			show_debug_message(_txt);
			break;
		
		case ds_type_map:
			var _txt = "DS_MAP:\n";
			var _keys_aray = ds_map_keys_to_array(data_structure);
			var _values_array = ds_map_values_to_array(data_structure);
			var isize = array_length(_keys_aray), i = isize-1;
			_txt += "\n>> SIZE: " + string(isize);
			repeat(isize) {
				_txt += "\n" + string(_keys_aray[i] + " : " + string(_values_array[i]));
				--i;
			}
			show_debug_message(_txt);
			break;
			
		case ds_type_priority:
			var _txt = "DS_PRIORITY:\n";
			var _temp_ds_pri = ds_priority_create();
			ds_priority_copy(_temp_ds_pri, data_structure);
			var i = 0, isize = ds_priority_size(_temp_ds_pri);
			_txt += "\n>> SIZE: " + string(isize) + "| Min priority: " + string(ds_priority_find_min(_temp_ds_pri)) + " | Max priority: " + string(ds_priority_find_max(_temp_ds_pri));
			repeat(isize) {
				var _val = ds_priority_find_min(_temp_ds_pri);
				_txt += "\n" + string(ds_priority_find_priority(_temp_ds_pri, _val)) + " : " + string(_val);
				ds_priority_delete_min(_temp_ds_pri);
				++i;
			}
			
			ds_priority_destroy(_temp_ds_pri);
			show_debug_message(_txt);
			break;
			
		case ds_type_grid:
			var _txt = "DS_GRID:\n";
			var _ww = ds_grid_width(data_structure);
			var _hh = ds_grid_height(data_structure);
			_txt += "\n>> SIZE: " + string(_ww) + "x" + string(_hh);
			var i = 0, j = 0, _space = "";
			repeat(_ww) {
				j = 0;
				repeat(_hh) {
					_space = "";
					if (j % _ww == 0) _space = "\n";
					_txt += _space + string(ds_grid_get(data_structure, i, j)) + "\t";
					++j;
				}
				++i;
			}
			show_debug_message(_txt);
			break;
			
		case ds_type_queue:
			var _txt = "DS_QUEUE:\n";
			var _temp_ds_queue = ds_queue_create();
			ds_queue_copy(_temp_ds_queue, data_structure);
			var i = 0, isize = ds_queue_size(_temp_ds_queue);
			_txt += "\n>> SIZE: " + string(isize) + "| Head: " + string(ds_queue_head(_temp_ds_queue)) + " | Tail: " + string(ds_queue_tail(_temp_ds_queue));
			repeat(isize) {
				_txt += "\n" + string(ds_queue_dequeue(_temp_ds_queue));
				++i;
			}
			ds_queue_destroy(_temp_ds_queue);
			show_debug_message(_txt);
			break;
			
		case ds_type_stack:
			var _txt = "DS_STACK:\n";
			var _temp_ds_stack = ds_stack_create();
			ds_stack_copy(_temp_ds_stack, data_structure);
			var i = 0, isize = ds_stack_size(data_structure);
			_txt += "\n>> SIZE: " + string(isize) + "| Top: " + string(ds_stack_top(_temp_ds_stack));
			repeat(isize) {
				_txt += "\n" + string(ds_stack_pop(_temp_ds_stack));
				++i;
			}
			ds_stack_destroy(_temp_ds_stack);
			show_debug_message(_txt);
			break;
		
		default:
			show_debug_message("Select the type of data structure to debug.");
			break;
	}
	show_debug_message(_separator);
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
	// by YellowAfterLife
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


#region ARRAYS

#macro SORT_ASCENDING function(a, b) {return a - b}
#macro SORT_DESCENDING function(a, b) {return b - a}

function array_create_2d(x_size, y_size, value=0) {
	var _grid = array_create(x_size, value);
	for (var i = 0; i < x_size; i++) {
		_grid[i] = array_create(y_size, value);
	}
	return _grid;
}


function array_create_2d_ext(x_size, y_size, func=undefined) {
	var _grid = array_create(x_size);
	for (var i = x_size; i >= 0; i--) {
		_grid[i] = array_create_ext(y_size, func);
	}
	return _grid;
}


function array_create_3d(x_size, y_size, z_size, value=0) {
	var _grid = array_create(x_size, value);
	for (var i = x_size; i >= 0; i--) {
		_grid[i] = array_create(y_size, value);
		for(var j = y_size; j >= 0; j--) {
			_grid[i][j] = array_create(z_size, value);
		}
	}
	return _grid;
}


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
		var _val = array[i];
		if (is_array(_val)) {
			_struct[$ i] = array_to_struct(_val);
		} else {
			_struct[$ i] = _val;
		}
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


function array_contains_value(array, value) {
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

/// @desc Recursively copy a struct.
/// @param {Struct} struct The struct id.
/// @returns {Struct}
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
	var _struct = {},
	_keys = variable_instance_get_names(inst_id),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = variable_instance_get(inst_id, _key);
		_struct[$ _key] = _value;
		++i;
	}
	return _struct;
}


function struct_to_ds_map(struct) {
	var _ds_map = ds_map_create(),
	_keys = variable_struct_get_names(struct),
	i = 0, isize = array_length(_keys);
	repeat(isize) {
		var _key = _keys[i];
		var _value = struct[$ _key];
		ds_map_add(_ds_map, _key, _value);
		++i;
	}
	return _ds_map;
}


function ds_map_to_struct(map) {
    var _struct = {},
    _key = ds_map_find_first(map),
	i = 0, isize = ds_map_size(map);
	repeat(isize) {
		if (ds_map_is_map(map, _key)) {
			_struct[$ _key] = ds_map_to_struct(map[? _key]);
		} else if (ds_map_is_list(map, _key)) {
			_struct[$ _key] = ds_list_to_array(map[? _key]);
		} else {
			_struct[$ _key] = map[? _key];
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
	var _str = "", _char = "",
	i = 1, isize = string_length(str), _ww = 0;
	repeat(isize) {
		_char = string_char_at(str, i);
		_ww += string_width(_char);
		if (_ww < width) _str += _char;
		++i;
	}
	return _str + "...";
}


function string_split_each_char(str) {
	var _array = [],
	i = 1, _size = string_length(str);
	repeat(_size) {
		array_push(_array, string_char_at(str, i));
		++i;
	}
	return _array;
}


function string_random_letter_case(str, first_is_upper=true, sequence=1) {
	var _str_final = "", _f1 = undefined, _f2 = undefined;
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
	var _string = string_lower(str),
	_str_final = "",
	i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		_str_final += (i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _str_final;
}


function string_word_first_letter_upper_case(str) {
	var _string = string_lower(str),
	_str_final = "",
	i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		var _pchar = string_char_at(_string, i-1);
		_str_final += (_pchar == " " || i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _str_final;
}


function string_case_reverse(str) {
	var _str_final = "",
	i = 1, isize = string_length(str);
	repeat(isize) {
		var _char = string_char_at(str, i),
		_char_upper = string_upper(_char),
		_char_lower = string_lower(_char);
		_str_final += (_char == _char_upper) ? _char_lower : _char_upper;
		++i;
	}
	return _str_final;
}


function string_reverse(str) {
	var _str_final = "",
	isize = string_length(str), i = isize;
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


/// @desc Transforms a 2D coordinate (in window space) to a 3D vector (x, y, z). Z is the camera's near plane.
/// 
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
	return new Vector3(_xx, _yy, camera_get_near_plane(proj_mat));
}


/// Returns a ray whose origin is the camera position (ray origin) Vector3(x, y, z). It also returns the direction of the vector Vector3(x, y, z).
///
/// Works for both orthographic and perspective projections.
function screen_to_ray(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr / DragoniteSpam / FoxyOfJungle
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
	return {
		origin : new Vector3(_matrix[3], _matrix[4], _matrix[5]),
		direction : new Vector3(_matrix[0], _matrix[1], _matrix[2]),
	}
}


/// @desc Transforms a 3D coordinate to a 2D coordinate. Returns a Vector2(x, y).
/// Returns Vector2(-1, -1) if the 3D point is behind the camera.
///
/// Works for both orthographic and perspective projections.
function world_to_screen_dimension(view_mat, proj_mat, xx, yy, zz, normalized=false) {
	// credits: TheSnidr / FoxyOfJungle
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
		return new Vector2((_cx*0.5+0.5), (0.5+0.5*_cy));
	} else {
		return new Vector2((_cx*0.5+0.5) * window_get_width(), (_cy*0.5+0.5) * window_get_height());
	}
}

#endregion


#region INSTANCES and OBJECTS

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


#region LAYERS

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

#endregion


#region PATHS

function distance_to_path(xx, yy, path) {
	// calculates the shortest distance to the given path
	var x0 = xx, y0 = yy, i, points, segments, length, pos, pmin, pmax, x1, y1, x2, y2, dx, dy, t, ix, iy, dist, min_dist;

	if (path_get_kind(path) == 0) {
		// straight path
		// get the number of control points and line segments on the path
		segments = points;
		if (!path_get_closed(path)) segments -= 1;

		// first, find the nearest control point.
		min_dist = infinity;
		for(i = 0; i < points; i++) {
			x1 = path_get_point_x(path, i);
			y1 = path_get_point_y(path, i);
			dist = point_distance(x0, y0, x1, y1);
			if (dist < min_dist) min_dist = dist;
		}
    
		// second, calculate the distance to each line segment and find the nearest one.
		x1 = path_get_point_x(path, 0);
		y1 = path_get_point_y(path, 0);
		for(i = 0; i < segments; i++) {
			x2 = path_get_point_x(path, (i+1) % points);
			y2 = path_get_point_y(path, (i+1) % points);

			dx = x2 - x1;
			dy = y2 - y1;
			if (dx != 0 || dy != 0) {
				// see if there is an intersection between the line segment
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
		// smooth path
		// first, split the path into a few segments and find the nearest one.
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
		
		// now, accurately find the nearest point on the segment.
		// at this point, pmin has the position of the provisional nearest point,
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


function path_get_nearest_point(xx, yy, path) {
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


function path_get_nearest_point_position(xx, yy, path) {
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


function path_get_nearest_position(xx, yy, path, pixel_precision=4) {
	// original by: gnysek
	var _raycast = infinity, _pos = 0, _dst,
	_precision = (1 / path_get_length(path)) * clamp(pixel_precision, 1, 100);
	for(var i = 0; i < 1; i += _precision;) {
		_dst = point_distance(xx, yy, path_get_x(0, i), path_get_y(0, i));
		if (_dst < _raycast) {
			_pos = i;
			_raycast = _dst;
		}
	}
	return _pos;
}


function path_get_direction(path, pos) {
	var _reciprocal = (1 / path_get_length(path)),
	_pos_1 = pos - _reciprocal,
	_pos_2 = pos + _reciprocal,
	_x1 = path_get_x(path, _pos_1),
	_y1 = path_get_y(path, _pos_1),
	_x2 = path_get_x(path, _pos_2),
	_y2 = path_get_y(path, _pos_2),
	_dir = point_direction(_x1, _y1, _x2, _y2);
	return _dir;
}

#endregion


#region DRAWING

function draw_line_quad(x1, y1, x2, y2, x3, y3, x4, y4, middle_line=false) {
	draw_line(x1, y1, x2, y2);
	draw_line(x1, y1, x4, y4);
	draw_line(x4, y4, x3, y3);
	draw_line(x2, y2, x3, y3);
	if (middle_line) draw_line(x1, y1, x3, y3);
}


function draw_line_vector(x1, y1, angle, distance) {
	var _a = degtorad(angle);
	draw_line(x1, y1, x1+cos(_a)*distance, y1-sin(_a)*distance);
}


function draw_texture_quad(texture_id, x1, y1, x2, y2, x3, y3, x4, y4, precision=50) {
	/*p1--p2
	  |    |
	  p4--p3*/
	// original by: icuurd12b42
	var w1xs = (x1-x2) / precision,
	w1ys = (y1-y2) / precision,
	w2xs = (x4-x3) / precision,
	w2ys = (y4-y3) / precision,
	w1xat = x1,
	w1yat = y1,
	w2xat = x4,
	w2yat = y4,
	us = 1 / precision,
	uat = 1;
	draw_primitive_begin_texture(pr_trianglestrip, texture_id);
	repeat(precision+1) {
	    draw_vertex_texture(w1xat, w1yat, uat, 0);
	    draw_vertex_texture(w2xat, w2yat, uat, 1);
	    uat -= us;
	    w1xat -= w1xs;
	    w1yat -= w1ys;
	    w2xat -= w2xs;
	    w2yat -= w2ys;
	}
	draw_primitive_end();
}


function draw_cone(x, y, angle, dist, fov) {
	var _len_x1 = dcos(angle - fov/2) * dist,
		_len_y1 = dsin(angle - fov/2) * dist,
		_len_x2 = dcos(angle + fov/2) * dist,
		_len_y2 = dsin(angle + fov/2) * dist;
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


function draw_surface_centered(surface_id, x, y) {
	draw_surface(surface_id, x-(surface_get_width(surface_id)/2), y-(surface_get_height(surface_id)/2));
}


function draw_surface_centered_ext(surface_id, x, y, xscale, yscale, rot, col, alpha) {
	//draw_surface_ext(surface_id, x-(surface_get_width(surface_id)/2)*xscale, y-(surface_get_height(surface_id)/2)*yscale, xscale, yscale, rot, col, alpha);
	var _col = draw_get_color(),
	_alpha = draw_get_alpha(),
	_mat = matrix_get(matrix_world);
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, rot, xscale, yscale, 1));
	draw_set_color(col);
	draw_set_alpha(alpha);
	draw_surface(surface_id, -surface_get_width(surface_id)/2, -surface_get_height(surface_id)/2);
	draw_set_color(_col);
	draw_set_alpha(_alpha);
	matrix_set(matrix_world, _mat);
}


// useful for grass wave effects
function draw_sprite_pos_ext(sprite, subimg, x, y, width, height, xoffset, yoffset, xscale, yscale, skew_x, skew_y, angle, alpha) {
	var _current_matrix = matrix_get(matrix_world);
	matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, angle, xscale, yscale, 1));
	var xo = -xoffset, yo = -yoffset;
	draw_sprite_pos(sprite_index, subimg, xo+skew_x, yo+skew_y, width+xo+skew_x, yo+skew_y, width+xo, height+yo, xo, height+yo, alpha);
	matrix_set(matrix_world, _current_matrix);
}


function draw_text_shadow(x, y, str, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text(x+shadow_dist_x, y+shadow_dist_y, str);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text(x, y, str);
}


function draw_text_ext_shadow(x, y, str, sep, width, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text_ext(x+shadow_dist_x, y+shadow_dist_y, str, sep, width);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text_ext(x, y, str, sep, width);
}


function draw_text_outline(x, y, str, outline_color=c_black, outline_alpha=1, outline_size=1, fidelity=4) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(outline_color);
	draw_set_alpha(outline_alpha);
	var _fid = Tau / fidelity,
	for(var i = 0; i < Tau; i += _fid) {
		draw_text(x+cos(i)*outline_size, y-sin(i)*outline_size, str);
	}
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text(x, y, str);
}


function draw_text_outline_gradient(x, y, str, outline_color1=c_black, outline_color2=c_black, outline_color3=c_black, outline_color4=c_black, outline_alpha=1, outline_size=1, fidelity=4) {
	var _fid = Tau / fidelity,
	for(var i = 0; i < Tau; i += _fid) {
		draw_text_color(x+cos(i)*outline_size, y-sin(i)*outline_size, str, outline_color1, outline_color2, outline_color3, outline_color4, outline_alpha);
	}
	draw_text(x, y, str);
}


function draw_text_transformed_shadow(x, y, str, xscale, yscale, angle, shadow_color=c_black, shadow_alpha=1, shadow_dist_x=1, shadow_dist_y=1) {
	var _old_col = draw_get_color();
	var _old_alpha = draw_get_alpha();
	draw_set_color(shadow_color);
	draw_set_alpha(shadow_alpha);
	draw_text_transformed(x+(shadow_dist_x*xscale), y+(shadow_dist_y*xscale), str, xscale, yscale, angle);
	draw_set_color(_old_col);
	draw_set_alpha(_old_alpha);
	draw_text_transformed(x, y, str, xscale, yscale, angle);
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

#endregion


#region BLENDING

function gpu_set_blendmode_test(index, debug_info=false) {
	// Feather disable GM1044
	// final_pixel_colour =  (Rs,Gs,Bs,As) * source_blend_factor + (Rd,Gd,Bd,Ad) * destination_blend_factor
	// s = source | d = destination
	// there are 14641 possible extended blendmode combinations
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
	var _type = "",
	_current = 0,
	_max = 5,
	
	// default blendmode
	_bm1 = bm_src_alpha,
	_bm2 = bm_inv_src_alpha,
	_bm3 = bm_src_alpha,
	_bm4 = bm_one;
	
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

function make_color_rgba_shader(color, alpha) {
	return [color_get_red(color)/255, color_get_green(color)/255, color_get_blue(color)/255, alpha];
}

#endregion


#region GRAPHICS PIPELINE, TEXTURE GROUPS, SURFACES and DISPLAY

#macro ANTIALIASING_MAX_AVAILABLE max(display_aa & 2, display_aa & 4, display_aa & 8)


function display_get_inches() {
	return sqrt(sqr(display_get_width()) + sqr(display_get_height())) / mean(display_get_dpi_x(), display_get_dpi_y());
}


function display_get_display_count() {
	// credit: gnysek
	return array_length(window_get_visible_rects(0, 0, 1, 1)) / 8;
}


function display_get_aspect_ratio() {
	return display_get_width() / display_get_height();
}


function aspect_ratio_gcd(width, height) {
	var _gcd = gcd(width, height);
    var _w_aspect = width / _gcd;
    var _h_aspect = height / _gcd; 
    return string(_w_aspect) + " / " + string(_h_aspect);
}


function aspect_ratio_maintain(resolution_x, resolution_y, size_x, size_y) {
	var _aspect_ratio = resolution_x / resolution_y;
	return (resolution_x > resolution_y) ? new Vector2(size_x * _aspect_ratio, size_y) : new Vector2(size_x, size_y / _aspect_ratio);
}


// WIP...
//function aspect_ratio_maintain(width, height, base_width, base_height) {
//	var aspect = base_width / base_height;
//	var _ww = 0, _hh = 0;
//	if (width > height) {
//		// landscape
//		_hh = min(base_height, height);
//		_ww = _hh * aspect;
//	} else {
//		// portrait
//		_ww = min(base_width, width);
//		_hh = _ww / aspect;
//	}
//	return new Vector2(_ww, _hh);
//}


/// @desc Saves a HDR surface to a image file.
/// @param {Id.Surface} surface_id The surface id.
/// @param {string} fname The name of the saved image file.
function surface_save_hdr(surface_id, fname) {
	var _surf = surface_create(surface_get_width(surface_id), surface_get_height(surface_id), surface_rgba8unorm);
	surface_copy(_surf, 0, 0, surface_id);
	surface_save(_surf, fname);
	surface_free(_surf);
}

/// @desc This function copies one surface to another, applying a shader to it.
/// @param {Id.Surface} source Description
/// @param {Id.Surface} dest Description
/// @param {Function} pass_func The shader function.
/// @param {Struct} pass_json_data The shader parameters.
/// @param {Real} alpha Surface clear alpha.
function surface_blit(source, dest, pass_func=undefined, pass_json_data=undefined, alpha=0) {
	gml_pragma("forceinline");
	surface_set_target(dest);
	if (alpha > -1) draw_clear_alpha(c_black, alpha);
	if (pass_func != undefined) pass_func(pass_json_data);
	draw_surface_stretched(source, 0, 0, surface_get_width(dest), surface_get_height(dest));
	shader_reset();
	surface_reset_target();
}


function texturegroup_unload_except(group, groups_array) {
	var i = 0, isize = array_length(groups_array);
	repeat(isize) {
		var _group = groups_array[i];
		if (_group != group) continue;
		texturegroup_unload(_group);
		++i;
	}
}


function texturegroup_debug_draw_sprites(group, scale) {
	var _tex_array = texturegroup_get_sprites(group);
	
	var i = 0, isize = array_length(_tex_array), yy = 20;
	repeat(isize) {
		var _reciprocal = i / isize;
		var _spr = _tex_array[i];
		var _ww = sprite_get_width(_spr) * scale;
		var _hh = sprite_get_height(_spr) * scale;
		draw_sprite_stretched(_spr, 0, 20, yy, _ww, _hh);
		yy += _hh + 10;
		++i;
	}
}


#endregion


#region PARTICLES

function particle_create(x, y, layer_id, particle_asset) {
	var _part = part_system_create_layer(layer_id, false, particle_asset);
	part_system_position(_part, x, y);
	return _part;
}

function particle_type_create(x, y, part_system, particle_asset, amount) {
	part_particles_create(part_system, x, y, particle_get_info(particle_asset).emitters[0].parttype.ind, amount);
}

function particle_move(part_system, x, y) {
	part_system_position(part_system, x, y);
}

function particle_set_emission_enabled(part_system, particle_asset, enabled, emitter_index=0) {
	var _part_info = particle_get_info(particle_asset),
	_emitter = _part_info.emitters[emitter_index];
    part_emitter_stream(part_system, _emitter, _emitter.parttype.ind, enabled ? _emitter.number : 0);
}

function particle_set_emission(part_system, particle_asset, amount, emitter_index=0) {
	var _part_info = particle_get_info(particle_asset),
	_emitter = _part_info.emitters[emitter_index];
	part_emitter_stream(part_system, _emitter, _emitter.parttype.ind, amount);
}

function particle_pause(part_system, pause) {
	part_system_automatic_update(part_system, !pause);
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
			_pixel = buffer_peek(_buff, 4 * (i + j * _width), buffer_u32); // get rgba
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


function random_pseudo_array(amount) {
	var _array = [];
	var i = 0;
	repeat(amount) {
		_array[i] = i;
		++i;
	}
	array_shuffle(_array);
	return _array;
}


function random_pseudo_array_ext(amount, func=undefined) {
	var _func = func;
	if (is_undefined(_func)) {
		_func = function(_val) {
			return _val;
		}
	}
	var _array = [], _val;
	var i = 0;
	repeat(amount) {
		_val = _func(i);
		if (!is_undefined(_val)) _array[i] = _val;
		++i;
	}
	array_shuffle(_array);
	return _array;
}


#endregion


#region DELTA TIME and MOUSE

#macro __DELTA_ENABLE true

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

if (__DELTA_ENABLE) {
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
}


#endregion


#region WINDOW and INPUT

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

function mouse_check_doubleclick_pressed(button) {
	static _time = 500; //ms
	static _once = false;
	static _delta = 0;
	var _pressed = false;
	if mouse_check_button_pressed(button) {
		if (!_once) {
			_delta = current_time;
			_once = true;
		} else {
			if (current_time - _delta < _time) {
				_pressed = true;
			}
			_once = false;
			_delta = 0;
		}
	}
	return _pressed;
}

#endregion


#region FILE SYSTEM

enum DIRSCAN_DATA_TYPE {
	FULL_PATH,
	NAME_ONLY,
	FULL_INFO,
}

function DirectoryScanner(path, extension="*.*", search_files=true, search_folders=true, search_subdir=true, data_type=DIRSCAN_DATA_TYPE.NAME_ONLY, get_size=false) constructor {
	__contents = [];
	__loaded = false;
	__path_exists = false;
	
	if (directory_exists(path)) {
		__directory_recursive_search(__contents, path, string(extension), search_files, search_folders, search_subdir, data_type, get_size);
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

// based on https://yal.cc/gamemaker-recursive-folder-copying/
/// @ignore
function __directory_recursive_search(contents, source, extension, search_files, search_folders, search_subdir, data_type, get_size) {
	// Feather disable GM1044
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
		var _data = -1;
		
		var _progress = (i/_files_count); // ready-only
		show_debug_message("Scanning: [" + string(_progress*100) + "%] " + _dir_name + " | " + string(_fname));
		
		if (directory_exists(_path)) {
			// recursively search directories
			if (search_subdir) __directory_recursive_search(contents, _path, extension, search_files, search_folders, search_subdir, data_type, get_size);
			if (search_folders) {
				switch(data_type) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : _fname,
							type : 0,
							ext : "",
							path : _path,
							root_folder : _dir_name,
							size : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY:
						_data = _fname;
						break;
					case DIRSCAN_DATA_TYPE.FULL_PATH:
						_data = _path;
						break;
				}
			}
		} else {
			if (search_files) {
				switch(data_type) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : filename_name_noext(_fname),
							type : 1,
							ext : filename_ext(_fname),
							path : _path,
							root_folder : _dir_name,
							size : get_size ? bytes_get_size(file_get_size(_path)) : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY:
						_data = _fname;
						break;
					case DIRSCAN_DATA_TYPE.FULL_PATH:
						_data = _path;
						break;
				}
			}
		}
		
		array_push(contents, _data);
		++i;
	}
	
	return _contents;
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


#endregion


#region UI

#macro gui_w display_get_gui_width()
#macro gui_h display_get_gui_height()

function draw_debug_button(x, y, text, callback=undefined) {
	var _old_font = draw_get_font(),
	old_halign = draw_get_halign(),
	old_valign = draw_get_valign(),
	old_color = draw_get_color(),
	_pressed = false, _color_bg = c_dkgray, _color_text = c_white,
	_ww = string_width(text)+8, _hh = string_height(text)+8;
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

function draw_debug_slider(x, y, width, title, default_value, min_value, max_value, callback=undefined) {
	var height = 16;
	var _value = default_value;
	if point_in_rectangle(gui_mouse_x, gui_mouse_y, x-16, y-height, x+width+16, y+height) {
		if mouse_check_button(mb_left) {
			_value = median(0, 1, (device_mouse_x_to_gui(0) - x) / width);
		}
	}
	var _output = lerp(min_value, max_value, _value);
	if (callback != undefined)  callback(_output);
	draw_text(x, y, string(_output) + " | " + title);
	draw_line(x, y, x+width, y);
	draw_circle(x+width*_value, y, 5, true);
}

#endregion


#region AUDIO

function audio_load_ogg(file_path) {
	if (file_exists(file_path)) {
		if (string_lower(filename_ext(file_path)) == ".ogg") {
			var audio_data = {
				format : "ogg",
				audio : audio_create_stream(file_path),
			}
			return audio_data;
		} else {
			return -3;
		}
	}
	return -1;
}


function audio_load_raw(file_path, sample_rate, bits_per_sample, channels) {
	if (file_exists(file_path)) {
		// read file bytes
		var file_buff = buffer_load(file_path);
		var _file_size = buffer_get_size(file_buff);
		var _audio_buff = buffer_create(_file_size, buffer_fixed, 1);
		buffer_copy(file_buff, 0, _file_size, _audio_buff, 0);
		buffer_delete(file_buff);
		
		// create buffer sound
		var _format = (bits_per_sample == 8) ? buffer_u8 : buffer_s16;
		var _channels = (channels == 2) ? audio_stereo : ((channels == 1) ? audio_mono : audio_3d);
		var _length = _file_size / (sample_rate * channels * bits_per_sample / 8) / 60;
		
		// return data
		var audio_data = {
			format : "raw",
			channels : channels,
			sample_rate : sample_rate,
			bits_per_sample : bits_per_sample,
			byte_rate : bits_per_sample / 8,
			length : _length,
			kpbs : (sample_rate * bits_per_sample * channels) / 1000,
			audio : audio_create_buffer_sound(_audio_buff, _format, sample_rate, 0, _file_size, _channels),
			buffer : _audio_buff,
		}
		return audio_data;
	} else {
		return -1;
	}
	return undefined;
}


function audio_load_wav(file_path) {
	if (file_exists(file_path)) {
		// read file bytes
		var file_buff = buffer_load(file_path);
		var _file_size = buffer_get_size(file_buff);
		var _audio_buff = buffer_create(_file_size, buffer_fixed, 1);
		buffer_copy(file_buff, 0, _file_size, _audio_buff, 0);
		buffer_delete(file_buff);
		
		// header byte offset
		var _header_length = 44, _ho_chunk_id = 0, _ho_chunk_size = 4, _ho_format = 8, _ho_subchunk_id1 = 12, _ho_subchunk_id1_size = 16,
		_ho_audio_format = 20, _ho_channels_num = 22, _ho_sample_rate = 24, _ho_byte_rate = 28, _ho_block_align = 32, _ho_bps = 34,
		_ho_subchunk_id2 = 36, _ho_subchunk_id2_size = 40, _ho_data = 44;
		
		// read header
		var _chunk_id="", _chunk_size=0, _format="", _subchunk_id1="", _subchunk_id1_size=0, _audio_format=0, _channels_num=0,
		_sample_rate=0, _byte_rate=0, _block_align=0, _bits_per_sample=0, _subchunk_id2="", _subchunk_id2_size=0;
		
		var audio_buff_length = buffer_get_size(_audio_buff);
		for (var i = 0; i <= _header_length; i++) {
			if (i >= _ho_chunk_id && i < _ho_chunk_size)
				_chunk_id += chr(buffer_peek(_audio_buff, i, buffer_u8));
			//if (i == _ho_chunk_size)
				//_chunk_size += buffer_peek(_audio_buff, i, buffer_u32);
			if (i >= _ho_format && i < _ho_subchunk_id1)
				_format += chr(buffer_peek(_audio_buff, i, buffer_u8));
			//if (i >= _ho_subchunk_id1 && i < _ho_subchunk_id1_size)
				//_subchunk_id1 += chr(buffer_peek(_audio_buff, i, buffer_u8)); // < fmt >
			//if (i >= _ho_subchunk_id1_size && i < _ho_audio_format)
				//_subchunk_id1_size += buffer_peek(_audio_buff, i, buffer_u8);
			if (i >= _ho_audio_format && i < _ho_channels_num)
				_audio_format += buffer_peek(_audio_buff, i, buffer_u8); // 1 is PCM
			if (i >= _ho_channels_num && i < _ho_sample_rate)
				_channels_num += buffer_peek(_audio_buff, i, buffer_u8);
			if (i == _ho_sample_rate)
				_sample_rate += buffer_peek(_audio_buff, i, buffer_u32);
			//if (i == _ho_byte_rate)
				//_byte_rate += buffer_peek(_audio_buff, i, buffer_u32);
			//if (i >= _ho_block_align && i < _ho_bps)
				//_block_align += buffer_peek(_audio_buff, i, buffer_u8);
			if (i >= _ho_bps && i < _ho_subchunk_id2)
				_bits_per_sample += buffer_peek(_audio_buff, i, buffer_u8);
			//if (i >= _ho_subchunk_id2 && i < _ho_subchunk_id2_size)
				//_subchunk_id2 += chr(buffer_peek(_audio_buff, i, buffer_u8)); // < DATA >
			//if (i == _ho_subchunk_id2_size)
				//_subchunk_id2_size += buffer_peek(_audio_buff, i, buffer_u32);
		}
		if (string_lower(_chunk_id) != "riff" || _audio_format != 1) return -3;
		
		// create buffer sound
		var _format = (_bits_per_sample == 8) ? buffer_u8 : buffer_s16;
		var _channels = (_channels_num == 2) ? audio_stereo : ((_channels_num == 1) ? audio_mono : audio_3d);
		
		// return data
		var audio_data = {
			format : "wav",
			channels : _channels_num,
			sample_rate : _sample_rate,
			bits_per_sample : _bits_per_sample, // samples per second
			byte_rate : _bits_per_sample / 8, // bytes per second
			length : _file_size / (_sample_rate * _channels_num * _bits_per_sample / 8) / 60, // seconds
			kpbs : (_sample_rate * _bits_per_sample * _channels_num) / 1000,
			audio : audio_create_buffer_sound(_audio_buff, _format, _sample_rate, _ho_data, audio_buff_length-_ho_data, _channels),
			buffer : _audio_buff,
		};
		return audio_data;
	} else {
		return -1;
	}
	return undefined;
}


function audio_stream_destroy(stream_data) {
	if (is_struct(stream_data)) {
		if (stream_data.format == "ogg") {
			audio_destroy_stream(stream_data.audio);
		} else {
			if (buffer_exists(stream_data.buffer)) {
				audio_free_buffer_sound(stream_data.audio);
				buffer_delete(stream_data.buffer);
			}
		}
	}
}


function audio_stream_get_format(stream_data) {
	if (is_struct(stream_data)) return stream_data.audio.format;
	return "";
}


#endregion


#region 3D

// vertex format
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
global.__vbf_3d_format = vertex_format_end();

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
	
	vertex_begin(_vbuff, global.__vbf_3d_format);
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
	
	vertex_begin(_vbuff, global.__vbf_3d_format);
	
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

//global.__vbf_debug = vertex_create_buffer();

//vertex_format_begin();
//vertex_format_add_position_3d();
//vertex_format_add_color();
//global.vbf_default_format = vertex_format_end();


//function draw_line_3d(x1, y1, z1, x2, y2, z2) {
//	var _vbf_line = global.__vbf_debug;
//	vertex_begin(_vbf_line, global.vbf_default_format);
	
//	vertex_position_3d(_vbf_line, x1, y1, z1);
//	vertex_color(_vbf_line, c_white, 1);
	
//	vertex_position_3d(_vbf_line, x2, y2, z2);
//	vertex_color(_vbf_line, c_white, 1);
	
//	vertex_end(_vbf_line);
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


#region TAGS

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

