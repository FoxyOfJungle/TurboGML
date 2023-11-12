
/// Feather ignore all

// pi = The ratio of the circumference of a circle to its diameter.
// Tau = The ratio of the circumference of a circle to its radius, equal to 2π.
// Phi = Golden Ratio.

#macro Tau (2 * pi)
#macro HalfPi (pi / 2)
#macro Phi 1.6180339887
#macro GoldenAngle 2.3999632297
#macro EulerNumber 2.7182818280


/// @desc Returns the result of a non-clamping linear remapping of a value from source range [in_min, in_max] to the destination range [out_min, out_max].
function relerp(in_min, in_max, value, out_min, out_max) {
	return (value-in_min) / (in_max-in_min) * (out_max-out_min) + out_min;
	//return lerp(out_min, out_max, linearstep(in_min, in_max, value));
}

/// @desc Inverse lerp. Interpolates between a and b, based on value. Returns a value between 0 and 1, representing where the "value" parameter falls within the range defined by a and b.
///
/// Example: var prog = linearstep(20, 40, 22) -> 0.10;
/// @param {Real} a The start of the range.
/// @param {Real} b The end of the range.
/// @param {Real} value The point within the range you want to calculate.
/// @returns {Real}
function linearstep(a, b, value) {
	return (value - a) / (b - a);
}

/// @desc Interpolates between a and b, base on value. With smoothing at the limits (Hermite interpolation). Always returns a value from 0 to 1.
///
/// Example: var prog = smoothstep(20, 40, 22) -> 0.03;
/// @param {Real} a The value of the lower edge of the Hermite function.
/// @param {Real} b The value of the upper edge of the Hermite function.
/// @param {Real} value The source value for interpolation.
/// @returns {Real}
function smoothstep(a, b, value) {
	var t = clamp((value - a) / (b - a), 0, 1);
	return t * t * (3 - 2 * t);
}

/// @desc 0 is returned if value < edge, and 1 is returned otherwise.
/// @param {Real} edge The location of the edge of the step function.
/// @param {Real} value The value to be used to generate the step function.
/// @returns {real}
function step(edge, value) {
	return (value < edge) ? 0 : 1;
}

/// @desc Returns a random value depending on its weight. Useful for probability of returning an item.
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

/// @desc Returns the reciprocal of the square root of "val".
/// @param {Real} Value
function inverse_sqrt(val) {
	return 1 / sqrt(abs(val));
}

/// @desc This function works like clamp(), but if the value is greater than max, it becomes min, and vice versa.
/// @param {Real} val The value to check.
/// @param {Real} min The min value.
/// @param {Real} max The max value.
function clamp_wrap(val, minn, maxx) {
	if (val > maxx) val = minn; else if (val < minn) val = maxx;
	return val;
}

/// @desc Returns a boolean, indicating whether the number is a fraction.
/// @param {real} number The number to check
/// @returns {bool} 
function is_fractional(number) {
	return (abs(frac(number)) > 0);
}

/// @desc Returns a boolean, indicating whether the number is even.
/// @param {real} number The number to check
/// @returns {bool} 
function is_even(number) {
	return (number & 1 == 0);
	//return (number % 2 == 0);
}

/// @desc Returns a boolean, indicating whether the number is odd.
/// @param {real} number The number to check
/// @returns {bool} 
function is_odd(number) {
	return (number & 1 == 1);
	//return (number % 2 == 1);
}

/// @desc Returns a boolean, indicating whether the number is prime.
/// @param {real} number The number to check
/// @returns {bool} 
function is_prime(number) {
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

/// @desc This function calculates and returns the nth Fibonacci number.
/// @param {real} n The number to calculate.
/// @returns {real} 
function fibonacci(n) {
	var _numbers = [0, 1];
	for(var i = 2; i <= n; i++) {
		_numbers[i] = _numbers[i - 1] + _numbers[i - 2];
	}
	return _numbers[n];
}

/// @desc This function calculates the factorial of a given number "n".
/// @param {real} n The number to calculate.
/// @returns {real} 
function factorial(n) {
	var _number = 1;
	for(var i = 1; i <= n; ++i) {
		_number *= i;
	}
	return _number;
}

/// @desc This function calculates the greatest common divisor (GCD) of two numbers "a" and "b".
/// @param {real} a The first number.
/// @param {real} b The second number.
/// @returns {real} 
function gcd(a, b) {
	if (b == 0) {
		return a;
	} else {
		return gcd(b, a % b);
	}
}

/// @desc This function takes two parameters, "a" and "b", representing a fraction, and returns a reduced form of the fraction by dividing both numerator and denominator by their greatest common divisor (GCD).
/// @param {real} a First number.
/// @param {real} b Second number.
/// @returns {struct} 
function fraction_reduce(a, b) {
	var _gcd = gcd(a, b);
	return new Vector2(a/_gcd, b/_gcd);
}

/// @desc Works like a lerp() but for angles, no rotation limits.
/// @param {Real} a The first angle to check.
/// @param {Real} b The second angle to check.
/// @param {Real} amount The amount to interpolate.
/// @returns {Real} 
function lerp_angle(a, b, amount) {
	return a - (angle_difference(a, b) * amount);
	//var _a = a + angle_difference(b, a);
	//return lerp(a, _a, amount);
}

/// @desc Verify if a value is in a range and returns a boolean.
/// @param {Real} value Value to check.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Bool} 
function in_range(value, a, b) {
	return (value >= a && value <= b);
}

/// @desc Returns the difference/distance between two values.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Real} 
function distance_1d(a, b) {
	return abs(a - b);
}

/// @desc Calculates the distance traveled by an object in free fall under the influence of friction.
/// @param {Real} dist The distance an object falls
/// @param {Real} fric Coefficient of friction acting on the object.
/// @returns {Real}
function speed_to_reach(dist, fric) {
	return sqrt(2 * dist * fric);
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
/// @param {Real} target_angle The target direction.
/// @param {Real} amount The amount to move.
/// @returns {real} Description
function angle_towards(angle, target_angle, amount) {
	return median(-amount, amount, angle_difference(-target_angle, -angle));
	//var _dir = angle_difference(angle1, angle2);
	//return min(abs(_dir), spd) * sign(_dir);
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

/// @desc This function returns the frame index to be used on a sprite, relative to the angle it is pointing at.
/// @param {real} angle Description
/// @param {real} frames_amount Description
/// @returns {real} Description
function angle_get_subimg(angle, frames_amount) {
	var _angle_seg = 360 / frames_amount;
	return ((angle + (_angle_seg / 2)) % 360) div _angle_seg;
}

/// @desc This function returns the direction between two points, in radians (pi).
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @returns {real} 
function point_direction_radians(x1, y1, x2, y2) {
	return degtorad(point_direction(x1, y1, x2, y2));
	//(arctan2(y2-y1, x2-x1) + pi*2) % pi*2;
}

/// @desc This function returns the normalized direction between two points. Expected results: -1 to 1, both horizontal and vertical
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @returns {Struct} 
function point_direction_normalized(x1, y1, x2, y2) {
	//var dir = degtorad(-point_direction(x1, y1, x2, y2));
	var len = point_distance(x1, y1, x2, y2);
	if (len == 0) return new Vector2(0, 0);
	return new Vector2((x2 - x1) / len, (y2 - y1) / len);
}

/// @desc This function prevents it from returning 0, returning another value instead, if this happen.
/// @param {Real} value The value.
/// @param {Real} zero_value Value to return.
/// @returns {real} 
function non_zero(value, zero_value=1) {
	return value == 0 ? zero_value : value;
}

/// @desc This function returns an animated sine wave.
/// @param {real} spd Movement speed. Example: 1
/// @param {real} amplitude The wave amplitude
/// @returns {real} 
function wave_normalized(spd, amplitude) {
	return amplitude * sin(current_time*0.0025*spd) * 0.5 + 0.5;
}
