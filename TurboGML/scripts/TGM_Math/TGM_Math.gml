
/// Feather ignore all

// pi = The ratio of the circumference of a circle to its diameter.
// Tau = The ratio of the circumference of a circle to its radius, equal to 2π.
// Phi = Golden Ratio.
// Golden Angle = Vogel disk
// Euler Number = e (Néper number)

#macro Tau (2 * pi)
#macro HalfPi (pi / 2)
#macro Phi 1.6180339887
#macro GoldenAngle 2.3999632297
#macro EulerNumber 2.7182818280


/// @desc Linear interpolation (lerp) remap. Returns the result of a non-clamping linear remapping of a value from source range [_inMin, _inMax] to the destination range [_outMin, _outMax].
/// @param {Real} inMin Input min value.
/// @param {Real} inMax Input max value.
/// @param {Real} value Value to remap.
/// @param {Real} inMin Output min value.
/// @param {Real} inMax Output max value.
function relerp(_inMin, _inMax, _value, _outMin, _outMax) {
	return (_value-_inMin) / (_inMax-_inMin) * (_outMax-_outMin) + _outMin;
	//return lerp(_outMin, _outMax, linearstep(_inMin, _inMax, _value));
}

/// @desc Interpolates between a and b, based on value. With smoothing at the limits (Hermite interpolation). Always returns a value from 0 to 1.
///
/// Example: var prog = smoothstep(20, 40, 22) -> 0.03;
/// @param {Real} a The value of the lower edge of the Hermite function.
/// @param {Real} b The value of the upper edge of the Hermite function.
/// @param {Real} value The source value for interpolation.
/// @returns {Real}
function smoothstep(_a, _b, _value) {
	var _t = clamp((_value - _a) / (_b - _a), 0, 1);
	return _t * _t * (3 - 2 * _t);
}

/// @desc Same as smoothstep() but linear. Inverse linear interpolation (lerp). Interpolates between a and b, based on value. Returns a value between 0 and 1, representing where the "value" parameter falls within the range defined by a and b.
///
/// Example: var prog = linearstep(20, 40, 22) -> 0.10;
/// @param {Real} a The start of the range.
/// @param {Real} b The end of the range.
/// @param {Real} value The point within the range you want to calculate.
/// @returns {Real}
function linearstep(_a, _b, _value) {
	return (_value - _a) / (_b - _a);
}

/// @desc 0 is returned if value < edge, and 1 is returned otherwise.
/// @param {Real} edge The location of the edge of the step function.
/// @param {Real} value The value to be used to generate the step function.
/// @returns {real}
function step(_edge, _value) {
	return (_value < _edge) ? 0 : 1;
}

/// @desc Works exactly the same as lerp(), but with delta time support. By "exact", it is a VERY close approximation, which works well.
/// @param {Real} a The first value.
/// @param {Real} b The second value.
/// @param {Real} amount The amount to interpolate.
/// @param {Real} dt The delta time.
function lerp_dt(_a, _b, _amount, _dt) {
	return _b + (_a - _b) * exp(-_amount * _dt); // Freya Holmér
	//return _a + (_b - _a) * (1 - power(1 - _amount, _dt)); // Mozart Junior
	//return lerp(_a, _b, 1 - power(0.5, _dt * _amount)); // Jonas Tyroller
}

/// @desc Works like a lerp() but for angles, no rotation limits.
/// @param {Real} a The first angle value.
/// @param {Real} b The second angle value.
/// @param {Real} amount The amount to interpolate.
/// @returns {Real} 
function lerp_angle(_a, _b, _amount) {
	return _a - (angle_difference(_a, _b) * _amount);
	//return lerp(_a, _a + angle_difference(_b, _a), _amount);
}

/// @desc Works like a lerp_angle() but works with delta time.
/// @param {Real} a The first angle value.
/// @param {Real} b The second angle value.
/// @param {Real} amount The amount to interpolate.
/// @param {Real} dt The delta time.
/// @returns {Real} 
function lerp_angle_dt(_a, _b, _amount, _dt) {
	return lerp_dt(_a, _a + angle_difference(_b, _a), _amount, _dt);
}

/// @desc Interpolates in log scale (multiplicatively linear). Alternative to lerp().
/// @param {Real} The first value.
/// @param {Real} The second value.
/// @param {Real} The amount to interpolate.
function eerp(_a, _b, _amount) {
	// By Freya Holmér. Source: https://x.com/FreyaHolmer/status/1813629237187817600
	return _a * exp(_amount * log2(_b / _a));
}

/// @desc Move linearly value A to value B in the specified amount.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @param {Real} amount Amount to move.
/// @returns {Real}
function approach(_a, _b, _amount) {
	//return a - clamp(a-b, -amount, amount);
	if (_a < _b) {
		return min(_a + _amount, _b);
	} else {
		return max(_a - _amount, _b);
	}
}

/// @desc Move linearly angle A to angle B in the specified amount.
/// @param {Real} a First angle.
/// @param {Real} b Second angle.
/// @param {Real} amount Amount to move.
/// @returns {Real}
function approach_angle(_a, _b, _amount) {
	var diff = angle_difference(_b, _a);
	if (abs(diff) < _amount) {
		return _b;
	}
	if (diff > 0) {
		return (_a + _amount) % 360;
	} else {
		return (_a - _amount + 360) % 360;
	}
}

/// @desc This function moves linearly one angle to another by the specified amount.
/// @param {Real} angle Current angle.
/// @param {Real} targetAngle The target direction.
/// @param {Real} amount The amount to move.
/// @returns {real} Description
function angle_towards(_angle, _targetAngle, _amount) {
	return median(-_amount, _amount, angle_difference(-_targetAngle, -_angle));
	//var _dir = angle_difference(angle1, angle2);
	//return min(abs(_dir), spd) * sign(_dir);
}

// by Mozart Junior (@foxyofjungle)
/// @desc With this function, you can limit the rotation angle based on the target angle. This can be useful to limit the rotation of a tank's turret.
/// @param {Real} angle The angle to clamp.
/// @param {Real} destAngle The destination angle to clamp from, based on FOV.
/// @param {Real} fov The field of view. A value from 0 to 180.
function clamp_angle_fov(_angle, _destAngle, _fov) {
	var _diff = angle_difference(_angle, _destAngle);
	var _halfFov = _fov * 0.5;
	if (abs(_diff) < _halfFov) {
		return _angle;
	} else {
		if (_diff > 0) {
			return _destAngle + _halfFov;
		} else {
			return _destAngle - _halfFov;
		}
	}
}

// Original source: https://stackoverflow.com/questions/43566019/how-to-choose-a-weighted-random-array-element-in-javascript
/// @desc Returns a random value depending on its weight. Useful for probability of returning an item. Both arrays must be the same size to work correctly.
/// @param {Array} items Total array of items to be returned. It can be any data type: numbers, strings, arrays, structs, data structures, etc.
/// @param {Array<Real>} weights Weight of items in order. Higher values have a higher probability of returning the item.
/// You can use any range of numbers, either 0 to 1 or 0 to 9999 or inf.
/// It is possible to use equal weights, having the same probability of being returned.
function choose_weighted(_items, _weights) {
	var isize = array_length(_items);
	var wsize = array_length(_weights);
	// sum weights
	var _weights_sum = 0;
	var i = 0;
	repeat(wsize) {
		_weights_sum += abs(_weights[i]);
		++i;
	}
	// randomize
	var _val = random(_weights_sum);
	i = 0;
	repeat(isize) {
		_val -= abs(_weights[i]);
		if (_val < 0) return _items[i];
		++i;
	}
	return _items[0];
}

/// @desc Returns the cosine, but with a normalized range of 0 to 1
/// @param {real} radiansAngle Angle in radians.
/// @returns {real}
function cos01(_radiansAngle) {
	gml_pragma("forceinline");
	return (cos(_radiansAngle) * 0.5 + 0.5);
}

/// @desc Returns the sine, but with a normalized range of 0 to 1
/// @param {real} radiansAngle Angle in radians.
/// @returns {real}
function sin01(_radiansAngle) {
	gml_pragma("forceinline");
	return (sin(_radiansAngle) * 0.5 + 0.5);
}

/// @desc Returns the reciprocal of the square root of "val".
/// @param {Real} value The value.
function inverse_sqrt(_value) {
	return 1 / sqrt(abs(_value));
}

/// @desc This function works like clamp(), but if the value is greater than max, it becomes min, and vice versa.
/// 
/// You may also be interested: wrap().
/// @param {Real} value The value to check.
/// @param {Real} min The min value.
/// @param {Real} max The max value.
function clamp_wrap(_value, _min, _max) {
	if (_value > _max) _value = _min; else if (_value < _min) _value = _max;
	return _value;
}

/// @desc Returns the value wrapped. If it's above or below the threshold it will wrap around.
/// @param {Real} value The value to check.
/// @param {Real} min The min value.
/// @param {Real} max The max value.
function wrap(_value, _min, _max) {
	var _mod = (_value - _min) mod (_max - _min);
	return (_mod < 0) ? _mod + _max : _mod + _min;
}

/// Works like "mod" or "%" but works as expected for negative numbers. a % b.
/// @param {Real} a The first value.
/// @param {Real} b The second value.
function mod_wrap(_a, _b) {
    return _a - _b * floor(_a / _b);
}

/// @desc Returns a boolean, indicating whether the number is a fraction.
/// @param {real} value The number to check.
/// @returns {bool} 
function is_fractional(_value) {
	return abs(frac(_value)) > 0;
}

/// @desc Returns a boolean, indicating whether the number is even.
/// @param {real} value The number to check.
/// @returns {bool} 
function is_even(_value) {
	return (_value & 1 == 0);
	//return (_value % 2 == 0);
}

/// @desc Returns a boolean, indicating whether the number is odd.
/// @param {real} value The number to check.
/// @returns {bool} 
function is_odd(_value) {
	return (_value & 1 == 1);
	//return (_value % 2 == 1);
}

/// @desc Returns a boolean, indicating whether the number is prime.
/// @param {real} value The number to check.
/// @returns {bool} 
function is_prime(_value) {
	if (_value < 2) return false;
	for(var i = 2; i * i <= _value; i++) {
		if (_value % i == 0) {
			return false;
		}
	}
	return true;
}

/// @desc Returns the next power of two number, based on the value.
/// @param {real} value The value to check.
/// @returns {real}
function pow2_next(_value) {
	return 1 << ceil(log2(_value));
}

/// @desc Returns the previous power of two number, based on the value.
/// @param {real} value The value to check.
/// @returns {real}
function pow2_previous(_value) {
	return 1 << floor(log2(_value));
}

/// @desc This function calculates and returns the nth Fibonacci number.
/// @param {real} n The number to calculate.
/// @returns {real} 
function fibonacci(_n) {
	var _numbers = [0, 1];
	for(var i = 2; i <= _n; i++) {
		_numbers[i] = _numbers[i - 1] + _numbers[i - 2];
	}
	return _numbers[_n];
}

/// @desc This function calculates the factorial of a given number "n".
/// @param {real} n The number to calculate.
/// @returns {real} 
function factorial(_n) {
	var _number = 1;
	for(var i = 1; i <= _n; ++i) {
		_number *= i;
	}
	return _number;
}

/// @desc This function calculates the greatest common divisor (GCD) of two numbers "a" and "b".
/// @param {real} a The first number.
/// @param {real} b The second number.
/// @returns {real} 
function gcd(_a, _b) {
	if (_b == 0) {
		return _a;
	} else {
		return gcd(_b, _a % _b);
	}
}

/// @desc This function takes two parameters, "a" and "b", representing a fraction, and returns a reduced form of the fraction by dividing both numerator and denominator by their greatest common divisor (GCD).
/// @param {real} a First number.
/// @param {real} b Second number.
/// @returns {struct} 
function fraction_reduce(_a, _b) {
	var _gcd = gcd(_a, _b);
	return new Vector2(_a/_gcd, _b/_gcd);
}

/// @desc Verify if a value is in a range and returns a boolean.
/// @param {Real} value Value to check.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Bool} 
function in_range(_value, _a, _b) {
	return (_value >= _a && _value <= _b);
}

/// @desc Returns the difference/distance between two values.
/// @param {Real} a First value.
/// @param {Real} b Second value.
/// @returns {Real} 
function distance_1d(_a, _b) {
	return abs(_a - _b);
}

/// @desc Returns the distance from a point to a rectangle (Manhattan distance).
/// @param {Real} pointX The x origin.
/// @param {Real} pointY The y origin.
/// @param {Real} x1 The rectangles's top left x position.
/// @param {Real} y1 The rectangles's top left y position.
/// @param {Real} x2 The rectangles's bottom right x position.
/// @param {Real} y2 The rectangles's bottom right y position.
function distance_to_rectangle(_pointX, _pointY, _x1, _y1, _x2, _y2) {
	var _dX = max(_x1 - _pointX, 0, _pointX - _x2);
	var _dY = max(_y1 - _pointY, 0, _pointY - _y2);
	return sqrt(_dX * _dX + _dY * _dY);
}

/// @desc Returns the distance from a point to a cube (Manhattan distance).
/// @param {Real} pointX The x origin.
/// @param {Real} pointY The y origin.
/// @param {Real} pointZ The z origin.
/// @param {Real} x1 The cube's top left x position.
/// @param {Real} y1 The cube's top left y position.
/// @param {Real} yz The cube's top left z position.
/// @param {Real} x2 The cube's bottom right x position.
/// @param {Real} y2 The cube's bottom right y position.
/// @param {Real} yz The cube's bottom right z position.
function distance_to_cube(_pointX, _pointY, _pointZ, _x1, _y1, _z1, _x2, _y2, _z2) {
	var _dX = max(_x1 - _pointX, 0, _pointX - _x2);
	var _dY = max(_y1 - _pointY, 0, _pointY - _y2);
	var _dZ = max(_z1 - _pointZ, 0, _pointZ - _z2);
	return sqrt(_dX * _dX + _dY * _dY + _dZ * _dZ);
}

// Suggested by Delfos, improved by Mozart Junior
/// @desc Returns the distance from a point to a line segment.
/// @param {Real} pointX The x origin.
/// @param {Real} pointX The y origin.
/// @param {Real} x1 The x position of the line start position.
/// @param {Real} y1 The y position of the line start position.
/// @param {Real} x1 The x position of the line end position.
/// @param {Real} y1 The y position of the line end position.
function distance_to_line(_pointX, _pointY, _x1, _y1, _x2, _y2) {
	var _dX = _x2 - _x1,
		_dY = _y2 - _y1,
		_numerator = abs(_dX * (_y1 - _pointY) - (_x1 - _pointX) * _dY),
		_denominator = sqrt(_dX * _dX + _dY * _dY);
    if (_denominator == 0) {
        return point_distance(_pointX, _pointY, _x1, _y1);
    }
    return _numerator / _denominator;
};

/// @desc Calculates the speed required to reach a given distance, considering the friction.
/// @param {Real} distance The distance an object falls
/// @param {Real} friction Coefficient of friction acting on the object.
/// @returns {Real}
function speed_to_reach(_distance, _friction) {
	return sqrt(2 * _distance * _friction);
}

// Original author: Xot
// Based on: https://www.reddit.com/r/gamemaker/comments/b0zelv/need_a_help_about_the_prediction_shot/
/// @desc This function predicts the angle that must be aimed until the bullet hits exactly on the target.
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
/// @param {Real} targetSpeed Target moving speed.
/// @param {Real} targetAngle Target moving angle/direction.
/// @param {Real} bulletSpeed Bullet moving speed.
/// @returns {Real} 
function angle_predict_intersection(_x1, _y1, _x2, _y2, _targetSpeed, _targetAngle, _bulletSpeed) {
	var _angle = point_direction(_x1, _y1, _x2, _y2),
		_beta = sin(degtorad(_targetAngle - _angle)) * (_targetSpeed/_bulletSpeed);
	return (abs(_beta) < 1) ? _angle+radtodeg(arcsin(_beta)) : -1;
}

// by Mozart Junior
/// @desc This function returns the portion of an angle. Useful for use as the image index of a sprite.
/// @param {real} angle The angle.
/// @param {real} segments The amount of segments.
function angle_get_portion(_angle, _segments) {
	_angle = _angle % 360;
	if (_angle < 0) _angle += 360;
	var _angleSeg = 360 / _segments;
	return ((_angle + (_angleSeg / 2)) % 360) div _angleSeg;
}

/// @desc This function returns the direction between two points, in radians (pi).
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
function point_direction_radians(_x1, _y1, _x2, _y2) {
	return degtorad(point_direction(_x1, _y1, _x2, _y2));
	//(arctan2(y2-y1, x2-x1) + pi*2) % pi*2;
}

/// @desc This function returns the normalized direction between two points. Expected results: -1 to 1, both horizontal and vertical
/// @param {Real} x1 Origin X position.
/// @param {Real} y1 Origin Y position.
/// @param {Real} x2 Target X position.
/// @param {Real} y2 Target Y position.
function point_direction_normalized(_x1, _y1, _x2, _y2) {
	//var dir = degtorad(-point_direction(x1, y1, x2, y2));
	var _len = point_distance(_x1, _y1, _x2, _y2);
	if (_len == 0) return new Vector2(0, 0);
	return new Vector2((_x2 - _x1) / _len, (_y2 - _y1) / _len);
}

// by Mozart Junior
/// @desc This function prevents it from returning 0, returning another value instead, if this happen.
/// @param {Real} value The value.
/// @param {Real} zeroValue Value to return.
function non_zero(_value, _zeroValue=1) {
	return _value == 0 ? _zeroValue : _value;
}

// by Mozart Junior
/// This function creates a normalized wave (from 0 to 1) based on the period.
/// @param {Real} time The current time. In frames or in seconds.
/// @param {Real} period The total time period. If time is in frames, this value should be in frames too. So you can do for example: 5 frames * 60 FPS = 5 seconds to go from 0 to 1.
/// @param {Real} amplitude The wave amplitude. Default is 1.
function wave_period(_time, _period, _amplitude) {
	return (sin((_time / _period) * Tau) * 0.5 + 0.5) * _amplitude; // time / period = normalized
}
