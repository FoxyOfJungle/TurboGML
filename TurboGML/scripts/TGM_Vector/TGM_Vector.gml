
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
function Vector2(_x=0, _y=_x) constructor {
	self.x = _x;
	self.y = _y;
	
	/// @desc Set vector components.
	static Set = function(_x=0, _y=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static Equals = function(_vectorB) {
		gml_pragma("forceinline");
		return (x == _vectorB.x && y == _vectorB.y);
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
	static Rotated = function(_angle) {
		gml_pragma("forceinline");
		var _sin = dsin(_angle), _cos = dcos(_angle);
		return new Vector2(
			x*_cos - y*_sin,
			x*_sin + y*_cos
		);
	}
	
	/// @desc Returns the vector snapped in a grid
	static Snapped = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(
			floor(x/_vectorB.x+0.5)*_vectorB.x,
			floor(y/_vectorB.y+0.5)*_vectorB.y
		);
	}
	
	/// @desc Clamps each component of the vector.
	static Clamped = function(_minVector, _maxVector) {
		gml_pragma("forceinline");
		return new Vector2(
			clamp(x, _minVector.x, _maxVector.x),
			clamp(y, _minVector.y, _maxVector.y)
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(_maxMagnitude) {
		gml_pragma("forceinline");
		var _len = Magnitude();
		var _vector = self;
		if (_len > 0 && _maxMagnitude < _len) {
			_vector.x /= _len;
			_vector.y /= _len;
			_vector.x *= _maxMagnitude;
			_vector.y *= _maxMagnitude;
		}
		return _vector;
	}
	
	/// @desc Returns the angle in degrees of this vector.
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Adds two vectors.
	static Add = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(x+_vectorB.x, y+_vectorB.y);
	}
	
	/// @desc Subtract two vectors.
	static Subtract = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(x-_vectorB.x, y-_vectorB.y);
	}
	
	/// @desc Multiply two vectors.
	static Multiply = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(x*_vectorB.x, y*_vectorB.y);
	}
	
	/// @desc Divide with another vector.
	static Divide = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(x/_vectorB.x, y/_vectorB.y);
	}
	
	/// @desc Negates the vector.
	static Negate = function() {
		gml_pragma("forceinline");
		return new Vector2(-x, -y);
	}
	
	/// @desc Scales the vector.
	static Scale = function(_scale) {
		gml_pragma("forceinline");
		return new Vector2(x*_scale, y*_scale);
	}
	
	/// @desc Normalise (magnitude set to 1) all the components of this
	static Normalize = function() {
		gml_pragma("forceinline");
		var _normalized = 1.0 / sqrt(x * x + y * y);
		x = x * _normalized;
		y = y * _normalized;
	}
	
	/// @desc Get the dot product of two vectors.
	static Dot = function(_vectorB) {
		gml_pragma("forceinline");
		return (x*_vectorB.x + y*_vectorB.y);
	}
	
	/// @desc Returns the cross product.
	static Cross = function(_vectorB) {
		gml_pragma("forceinline");
		return (x*_vectorB.x - y*_vectorB.y);
	}
		
	/// Returns the projection of the vector.
    static Project = function(_origin, _vectorB) {
        gml_pragma("forceinline");
        return _origin.Dot(_vectorB) / _origin.Magnitude();
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
	
	/// @desc Returns a new vector with absolute values (i.e. positive).
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
	static Lerp = function(_vectorB, _amount) {
		gml_pragma("forceinline");
		return new Vector2(
			lerp(x, _vectorB.x, _amount),
			lerp(y, _vectorB.y, _amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static Distance = function(_vectorB) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-_vectorB.x) + sqr(y-_vectorB.y));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static SqrDistance = function(_vectorB) {
		gml_pragma("forceinline");
		return (sqr(x-_vectorB.x) + sqr(y-_vectorB.y));
	}
	
	/// @desc Returns the angle between the line connecting the two points.
	static AngleTo = function(_vectorB) {
		gml_pragma("forceinline");
		return point_direction(x, y, _vectorB.x, _vectorB.y);
		//return -darctan2(y-_vectorB.y, x-_vectorB.x)+180;
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static Max = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(
			max(x, _vectorB.x),
			max(y, _vectorB.y)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static Min = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector2(
			min(x, _vectorB.x),
			min(y, _vectorB.y)
		);
	};
	
	/// @desc Returns the highest value of the vector.
	static MaxComponent = function(_vectorB) {
		gml_pragma("forceinline");
		return max(x, y);
	};
	
	/// @desc Returns the lowest value of the vector.
	static MinComponent = function(_vectorB) {
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
function Vector3(_x=0, _y=_x, _z=_x) constructor {
	self.x = _x;
	self.y = _y;
	self.z = _z;
	
	/// @desc Set vector components.
	static Set = function(_x=0, _y=_x, _z=_x) {
		gml_pragma("forceinline");
		x = _x;
		y = _y;
		z = _z;
		return self;
	};
	
	/// @desc Returns true if the given vector is exactly equal to this vector.
	static Equals = function(_vectorB) {
		gml_pragma("forceinline");
		return (
			x == _vectorB.x &&
			y == _vectorB.y &&
			z == _vectorB.z
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
	static Snapped = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(
			floor(x/_vectorB.x+0.5)*_vectorB.x,
			floor(y/_vectorB.y+0.5)*_vectorB.y,
			floor(z/_vectorB.z+0.5)*_vectorB.z
		);
	}
	
	/// @desc Clamps each component of the vector.
	static Clamped = function(_minVector, _maxVector) {
		gml_pragma("forceinline");
		return new Vector3(
			clamp(x, _minVector.x, _maxVector.x),
			clamp(y, _minVector.y, _maxVector.y),
			clamp(z, _minVector.z, _maxVector.z)
		);
	};
	
	/// @desc Returns a vector with a clamped magnitude
	static ClampedMagnitude = function(_maxMagnitude) {
		gml_pragma("forceinline");
		var _len = Magnitude();
		var _vector = self;
		if (_len > 0 && _maxMagnitude < _len) {
			_vector.x /= _len;
			_vector.y /= _len;
			_vector.z /= _len;
			_vector.x *= _maxMagnitude;
			_vector.y *= _maxMagnitude;
			_vector.z *= _maxMagnitude;
		}
		return _vector;
	}
	
	/// @desc Returns the angle in degrees of this vector.
	static Angle = function() {
		gml_pragma("forceinline");
		return point_direction(0, 0, x, y);
	}
	
	/// @desc Adds two vectors.
	static Add = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(x+_vectorB.x, y+_vectorB.y, z+_vectorB.z);
	}
	
	/// @desc Subtract two vectors.
	static Subtract = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(x-_vectorB.x, y-_vectorB.y, z-_vectorB.z);
	}
	
	/// @desc Multiply two vectors.
	static Multiply = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(x*_vectorB.x, y*_vectorB.y, z*_vectorB.z);
	}
	
	/// @desc Divide with another vector.
	static Divide = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(x/_vectorB.x, y/_vectorB.y, z/_vectorB.z);
	}
	
	/// @desc Negates the vector.
	static Negate = function() {
		gml_pragma("forceinline");
		return new Vector3(-x, -y, -z);
	}
	
	/// @desc Scales the vector.
	static Scale = function(_scale) {
		gml_pragma("forceinline");
		return new Vector3(x*_scale, y*_scale, z*_scale);
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
	static Dot = function(_vectorB) {
		gml_pragma("forceinline");
		return (x*_vectorB.x + y*_vectorB.y + z*_vectorB.z);
	}
	
	/// @desc Returns the cross product.
	static Cross = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(
			y*_vectorB.z - z*_vectorB.y,
			z*_vectorB.x - x*_vectorB.z,
			x*_vectorB.y - y*_vectorB.x
		);
	}
	
	/// Returns the projection of the vector.
    static Project = function(_origin, _vectorB) {
        gml_pragma("forceinline");
        return _origin.Dot(_vectorB) / _origin.Magnitude();
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
	static Lerp = function(_vectorB, _amount) {
		gml_pragma("forceinline");
		return new Vector3(
			lerp(x, _vectorB.x, _amount),
			lerp(y, _vectorB.y, _amount),
			lerp(z, _vectorB.z, _amount)
		);
	};
	
	/// @desc Returns the distance between the two vectors.
	static Distance = function(_vectorB) {
		gml_pragma("forceinline");
		return sqrt(sqr(x-_vectorB.x) + sqr(y-_vectorB.y) + sqr(z-_vectorB.z));
	}
	
	/// @desc Returns the square distance between the two vectors.
	static SqrDistance = function(_vectorB) {
		gml_pragma("forceinline");
		return (sqr(x-_vectorB.x) + sqr(y-_vectorB.y) + sqr(z-_vectorB.z));
	}
	
	/// @desc Returns the angle (z rotation) in degrees to the given vector.
	static YawTo = function(_vectorB) {
		gml_pragma("forceinline");
		return point_direction(x, y, _vectorB.x, _vectorB.y); // I was too lazy to write the math behind it for now
	}
	
	/// @desc Returns the pitch angle (x rotation) in degrees to the given vector.
	static PitchTo = function(_vectorB) {
		return radtodeg(arctan2(_vectorB.z-z, point_distance(x, y, _vectorB.x, _vectorB.y)));
	}
	
	/// @desc Returns a vector that is made from the largest components of two vectors.
	static Max = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(
			max(x, _vectorB.x),
			max(y, _vectorB.y),
			max(z, _vectorB.z)
		);
	};
	
	/// @desc Returns a vector that is made from the smallest components of two vectors.
	static Min = function(_vectorB) {
		gml_pragma("forceinline");
		return new Vector3(
			min(x, _vectorB.x),
			min(y, _vectorB.y),
			min(z, _vectorB.z)
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
function Vector4(_x=0, _y=_x, _z=_x, _w=_x) constructor {
	self.x = _x;
	self.y = _y;
	self.z = _z;
	self.w = _w;
}

