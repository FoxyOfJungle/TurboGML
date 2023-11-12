
/// Feather ignore all

// Shorthand for writing Vector2(0, 1).
#macro Vector2_Up Vector2(0, 1)

// Shorthand for writing Vector2(0, -1).
#macro Vector2_Down Vector2(0, -1)

// Shorthand for writing Vector2(-1, 0).
#macro Vector2_Left Vector2(-1, 0)

// Shorthand for writing Vector2(1, 0).
#macro Vector2_Right Vector2(1, 0)


/// @desc Returns a struct containing x and y.
/// @param {real} x The value for x.
/// @param {real} y The value for y.
function Vector2(x, y=x) constructor {
	self.x = x;
	self.y = y;
	
	/// @desc Set vector components.
	static Set = function(_x=0, _y=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static Equals = function(vector2) {
		gml_pragma("forceinline");
		return (
			x == vector2.x &&
			y == vector2.y
		);
	}
		
	/// @desc Returns the length of this vector (Read Only).
	static Magnitude = function() {
		gml_pragma("forceinline");
		return sqrt(x * x + y * y);
	};
	
	/// @desc Returns the squared length of this vector (Read Only).
	static SqrMagnitude = function() {
		gml_pragma("forceinline");
		return (x * x + y * y);
	}
	
	/// @desc Returns this vector with a magnitude of 1 (Read Only).
	static Normalized = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y);
		return new Vector2(
			x * _normalized,
			y * _normalized
		);
	}
	
	/// @desc Returns the vector rotated by the amount supplied in degrees.
	static Rotated = function(new_angle) {
		gml_pragma("forceinline");
		var _sin = dsin(new_angle), _cos = dcos(new_angle);
		return new Vector2(
			x*_cos - y*_sin,
			x*_sin + y*_cos
		);
	}
	
	/// @desc Returns the vector snapped in a grid
	static Snapped = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			floor(x/vector2.x+0.5)*vector2.x,
			floor(y/vector2.y+0.5)*vector2.y
		);
	}
	
	/// @desc Clamps each component of the vector.
	static Clamped = function(min_vector, max_vector) {
		gml_pragma("forceinline");
		return new Vector2(
			clamp(x, min_vector.x, max_vector.x),
			clamp(y, min_vector.y, max_vector.y)
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(max_magnitude) {
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
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Adds two vectors.
	static Add = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x+vector2.x, y+vector2.y);
	}
	
	/// @desc Subtract two vectors.
	static Subtract = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x-vector2.x, y-vector2.y);
	}
	
	/// @desc Multiply two vectors.
	static Multiply = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x*vector2.x, y*vector2.y);
	}
	
	/// @desc Divide with another vector.
	static Divide = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x/vector2.x, y/vector2.y);
	}
	
	/// @desc Negates the vector.
	static Negate = function() {
		gml_pragma("forceinline");
		return new Vector2(-x, -y);
	}
	
	/// @desc Scales the vector.
	static Scale = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(x*vector2.x, y*vector2.y);
	}
	
	/// @desc Normalise (magnitude set to 1) all the components of this
	static Normalize = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y);
		x = x * _normalized;
		y = y * _normalized;
	}
	
	/// @desc Get the dot product of two vectors.
	static Dot = function(vector2) {
		gml_pragma("forceinline");
		return (x*vector2.x + y*vector2.y);
	}
	
	/// @desc Returns the cross product.
	static Cross = function(vector2) {
		gml_pragma("forceinline");
		return (x*vector2.x - y*vector2.y);
	}
	
	/// @desc Returns the vector with all components rounded down.
	static Floor = function() {
		gml_pragma("forceinline");
		return new Vector2(floor(x), floor(y));
	}
	
	/// @desc Returns the vector with all components rounded up.
	static Ceil = function() {
		gml_pragma("forceinline");
		return new Vector2(ceil(x), ceil(y));
	}
	
	/// @desc Returns the vector with all components rounded.
	static Round = function() {
		gml_pragma("forceinline");
		return new Vector2(round(x), round(y));
	}
	
	/// @desc Returns positive, negative, or zero depending on the value of the components.
	static Sign = function() {
		gml_pragma("forceinline");
		return new Vector2(sign(x), sign(y));
	}
	
	/// @desc Returns a new vector with absolute values.
	static Abs = function() {
		gml_pragma("forceinline");
		return new Vector2(abs(x), abs(y));
	}
	
	/// @desc Returns a new vector with fractional values.
	static Frac = function() {
		gml_pragma("forceinline");
		return new Vector2(frac(x), frac(y));
	}
	
	/// @desc Check if the vector is normalized.
	static IsNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(sqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	/// @desc Clamps each component of the vector.
	static Lerp = function(vector2, amount) {
		gml_pragma("forceinline");
		return new Vector2(
			lerp(x, vector2.x, amount),
			lerp(y, vector2.y, amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static Distance = function(vector2) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-vector2.x) + sqr(y-vector2.y));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static SqrDistance = function(vector2) {
		gml_pragma("forceinline");
		return (sqr(x-vector2.x) + sqr(y-vector2.y));
	}
	
	/// @desc Returns the angle to the given vector.
	static Angle = function(vector2) {
		gml_pragma("forceinline");
		return point_direction(x, y, vector2.x, vector2.y);
	}
	
	/// @desc Returns the angle between the line connecting the two points.
	static AngleTo = function(vector2) {
		gml_pragma("forceinline");
		return -darctan2(y-vector2.y, x-vector2.x)+180;
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static Max = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			max(x, vector2.x),
			max(y, vector2.y)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static Min = function(vector2) {
		gml_pragma("forceinline");
		return new Vector2(
			min(x, vector2.x),
			min(y, vector2.y)
		);
	};
	
	/// @desc Returns the highest value of the vector.
	static MaxComponent = function(vector2) {
		gml_pragma("forceinline");
		return max(x, y);
	};
	
	/// @desc Returns the lowest value of the vector.
	static MinComponent = function(vector2) {
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

/// @desc Returns a struct containing x, y and z.
/// @param {real} x The value for x.
/// @param {real} y The value for y.
/// @param {real} z The value for z.
function Vector3(x, y=x, z=x) constructor {
	self.x = x;
	self.y = y;
	self.z = z;
	
	/// @desc Set vector components.
	static Set = function(_x=0, _y=_x, _z=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		z = _z;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static Equals = function(vector3) {
		gml_pragma("forceinline");
		return (
			x == vector3.x &&
			y == vector3.y &&
			z == vector3.z
		);
	}
		
	/// @desc Returns the length of this vector (Read Only).
	static Magnitude = function() {
		gml_pragma("forceinline");
		return sqrt(x * x + y * y + z * z);
	};
	
	/// @desc Returns the squared length of this vector (Read Only).
	static SqrMagnitude = function() {
		gml_pragma("forceinline");
		return (x * x + y * y + z * z);
	}
	
	/// @desc Returns this vector with a magnitude of 1 (Read Only).
	static Normalized = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y + z * z);
		return new Vector3(
			x * _normalized,
			y * _normalized,
			z * _normalized
		);
	}
	
	/// @desc Returns the vector snapped in a grid
	static Snapped = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			floor(x/vector3.x+0.5)*vector3.x,
			floor(y/vector3.y+0.5)*vector3.y,
			floor(z/vector3.z+0.5)*vector3.z
		);
	}
	
	/// @desc Clamps each component of the vector.
	static Clamped = function(min_vector, max_vector) {
		gml_pragma("forceinline");
		return new Vector3(
			clamp(x, min_vector.x, max_vector.x),
			clamp(y, min_vector.y, max_vector.y),
			clamp(z, min_vector.z, max_vector.z)
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(max_magnitude) {
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
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Adds two vectors.
	static Add = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x+vector3.x, y+vector3.y, z+vector3.z);
	}
	
	/// @desc Subtract two vectors.
	static Subtract = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x-vector3.x, y-vector3.y, z-vector3.z);
	}
	
	/// @desc Multiply two vectors.
	static Multiply = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x*vector3.x, y*vector3.y, z*vector3.z);
	}
	
	/// @desc Divide with another vector.
	static Divide = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x/vector3.x, y/vector3.y, z/vector3.z);
	}
	
	/// @desc Negates the vector.
	static Negate = function() {
		gml_pragma("forceinline");
		return new Vector3(-x, -y, -z);
	}
	
	/// @desc Scales the vector.
	static Scale = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(x*vector3.x, y*vector3.y, z*vector3.z);
	}
	
	/// @desc Normalise (magnitude set to 1) all the components of this
	static Normalize = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y + z * z);
		x = x * _normalized;
		y = y * _normalized;
		z = z * _normalized;
	}
	
	/// @desc Get the dot product of two vectors.
	static Dot = function(vector3) {
		gml_pragma("forceinline");
		return (x*vector3.x + y*vector3.y + z*vector3.z);
	}
	
	/// @desc Returns the cross product.
	static Cross = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			y*vector3.z - z*vector3.y,
			z*vector3.x - x*vector3.z,
			x*vector3.y - y*vector3.x
		);
	}
	
	/// @desc Returns the vector with all components rounded down.
	static Floor = function() {
		gml_pragma("forceinline");
		return new Vector3(floor(x), floor(y), floor(z));
	}
	
	/// @desc Returns the vector with all components rounded up.
	static Ceil = function() {
		gml_pragma("forceinline");
		return new Vector3(ceil(x), ceil(y), ceil(z));
	}
	
	/// @desc Returns the vector with all components rounded.
	static Round = function() {
		gml_pragma("forceinline");
		return new Vector3(round(x), round(y), round(z));
	}
	
	/// @desc Returns positive, negative, or zero depending on the value of the components.
	static Sign = function() {
		gml_pragma("forceinline");
		return new Vector3(sign(x), sign(y), sign(z));
	}
	
	/// @desc Returns a new vector with absolute values.
	static Abs = function() {
		gml_pragma("forceinline");
		return new Vector3(abs(x), abs(y), abs(z));
	}
	
	/// @desc Returns a new vector with fractional values.
	static Frac = function() {
		gml_pragma("forceinline");
		return new Vector3(frac(x), frac(y), frac(z));
	}
	
	/// @desc Check if the vector is normalized.
	static IsNormalized = function() {
		gml_pragma("forceinline");
		var _epsilon = 0.0001;
		var _difference = abs(sqrMagnitude() - 1.0);
		return (_difference < _epsilon);
	}
	
	/// @desc Clamps each component of the vector.
	static Lerp = function(vector3, amount) {
		gml_pragma("forceinline");
		return new Vector3(
			lerp(x, vector3.x, amount),
			lerp(y, vector3.y, amount),
			lerp(z, vector3.z, amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static Distance = function(vector3) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-vector3.x) + sqr(y-vector3.y) + sqr(z-vector3.z));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static SqrDistance = function(vector3) {
		gml_pragma("forceinline");
		return (sqr(x-vector3.x) + sqr(y-vector3.y) + sqr(z-vector3.z));
	}
	
	/// @desc Returns the angle (z rotation) in degrees to the given vector.
	static YawTo = function(vector3) {
		gml_pragma("forceinline");
		return point_direction(x, y, vector3.x, vector3.y); // I was too lazy to write the math behind it for now
	}
	
	/// @desc Returns the pitch angle (x rotation) in degrees to the given vector.
	static PitchTo = function(vector3) {
		return radtodeg(arctan2(vector3.z-z, point_distance(x, y, vector3.x, vector3.y)));
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static Max = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			max(x, vector3.x),
			max(y, vector3.y),
			max(z, vector3.z)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static Min = function(vector3) {
		gml_pragma("forceinline");
		return new Vector3(
			min(x, vector3.x),
			min(y, vector3.y),
			min(z, vector3.z)
		);
	};
	
	/// @desc Returns the highest value of the vector.
	static MaxComponent = function() {
		gml_pragma("forceinline");
		return max(x, y, z);
	};
	
	/// @desc Returns the lowest value of the vector.
	static MinComponent = function() {
		gml_pragma("forceinline");
		return min(x, y, z);
	};
	
}

/// @desc Returns a struct containing x, y, z and w.
/// @param {real} x The value for x.
/// @param {real} y The value for y.
/// @param {real} z The value for z.
function Vector4(x, y=x, z=x, w=x) constructor {
	self.x = x;
	self.y = y;
	self.z = z;
	self.w = w;
}

