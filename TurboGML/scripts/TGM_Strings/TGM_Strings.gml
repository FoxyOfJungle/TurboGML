
/// Feather ignore all

/// @desc Converts all string characters to a character. Useful for passwords.
/// @param {string} str Text string.
/// @param {string} char The character to convert.
/// @returns {string} 
function string_password(_str, _char="*") {
	return string_repeat(_char, string_length(_str));
}

/// @func string_contains(_str, _subStr)
/// @desc Returns a boolean indicating whether the substring was found within the string.
/// @arg {String} str Text string.
/// @arg {String} substr The substring you want to search for within the string.
/// @returns {Bool}
function string_contains(_str, _subStr) {
	return string_pos(_subStr, _str) > 0;
}

/// @desc Adds some zeros to the string.
/// @param {string} str Text string.
/// @param {real} zeroAmount The amount of zeros to be added.
/// @returns {string} 
function string_zeros(_str, _zeroAmount) {
	return string_replace_all(string_format(_str, _zeroAmount, 0), " ", "0");
}

/// @desc Formats a number that represents money in the game, in a beautiful way, adding surfixes like K, M, B, T. Also supports negative numbers.
/// @param {String} prefix The cash prefix. Example: "$".
/// @param {Real} decimals Number of decimals.
/// @param {Bool} remove_zeroes If true, will remove all decimal zeroes.
/// @returns {String}
function string_currency_prettify(_cash, _prefix="$", _decimals=0, _removeZeroes=true) {
	static _suffixes = ["", "K", "M", "B", "T"];
	var _cashAbs = abs(_cash),
		_negativeSymbol = "";
	if (_cash < 0) {
		_negativeSymbol = "-";
	}
	if (_cashAbs < 1000) {
		return _prefix + _negativeSymbol + string_format(_cashAbs, 0, _decimals);
	} else {
		var _pos = floor(log10(_cashAbs) / 3), // number of digits divided by 3
			_dividor = power(10, _pos * 3),
			_value = _cashAbs / _dividor;
		if (_removeZeroes) {
			var _fractional = string_replace(string_replace_all(frac(_value), "0", ""), ".", "");
			_decimals = string_length(_fractional);
		}
		return _prefix + _negativeSymbol + string_format(_value, 0, _decimals) + _suffixes[_pos];
	}
}

/// @desc Calculates the reading time of a string (useful for dialogues). Returns the value in seconds. Multiply by the game's FPS (example: 60) to obtain the value in frames.
/// @param {String} string The string/text to get estimated time.
/// @param {Real} charsPerMinute The average reading speed.
function string_get_read_time(_string, _charsPerMinute=1000) {
	var _minutes = string_length(_string) / _charsPerMinute;
	return ceil(_minutes * 60); // return in seconds
}

/// @desc Add an ellipsis to the string if it is longer than the given width.
/// @param {String} str Text string.
/// @param {Real} width The maximum text width.
/// @param {String} suffix The suffix to add after the string, if the text does not reach the width.
/// @returns {string} 
function string_limit(_str, _width, _suffix="...") {
	var _len = _width / string_width("M");
	return string_width(_str) < _width ? _str : string_copy(_str, 1, _len) + "...";
}

/// @desc Add an ellipsis to the string if it is longer than the given width, for non-monospace fonts.
/// @param {String} str Text string.
/// @param {Real} width The maximum text width.
/// @param {String} suffix The suffix to add after the string, if the text does not reach the width.
/// @returns {string} 
function string_limit_nonmono(_str, _width, _suffix="...") {
	if (string_width(_str) < _width) return _str;
	var _strFinal = "", _char = "",
	i = 1, isize = string_length(_str), _ww = 0;
	repeat(isize) {
		_char = string_char_at(_str, i);
		_ww += string_width(_char);
		if (_ww < _width) _strFinal += _char;
		++i;
	}
	return _strFinal + _suffix;
}

/// @desc Leave each character in the string with random case.
/// @param {string} str Text string.
/// @param {bool} first_is_upper Is the first letter uppercase?
/// @param {real} sequence Sequence in which the letters will be changed.
/// @param {bool} skip_char Define if will skip a character.
/// @param {string} char The character to skip.
/// @returns {string} 
function string_random_letter_case(_str, _firstIsUpper=true, _sequence=1, _skipChar=true, _char=" ") {
	var _strFinal = "", _f1 = undefined, _f2 = undefined;
	if (_firstIsUpper) {
		_f1 = string_lower;
		_f2 = string_upper;
	} else {
		_f1 = string_upper;
		_f2 = string_lower;
	}
	var i = 1, isize = string_length(_str), _index = 1;
	repeat(isize) {
		var _chr = string_char_at(_str, i);
		_strFinal += (_index % (_sequence + 1) == 0) ? _f1(_chr) : _f2(_chr);
		if (!_skipChar || _chr != _char) _index++;
		++i;
	}
	return _strFinal;
}

/// @desc Capitalize the first letter of the string
/// @param {string} str Text string.
/// @returns {string} 
function string_first_letter_upper_case(_str) {
	var _string = string_lower(_str),
	_strFinal = "",
	i = 1, isize = string_length(_str);
	repeat(isize) {
		var _char = string_char_at(_string, i);
		_strFinal += (i == 1) ? string_upper(_char) : _char;
		++i;
	}
	return _strFinal;
}

/// @desc Capitalizes each word in the string.
/// @param {string} str Text string.
/// @returns {string} 
function string_proper_case(_str) {
	var _string = string_lower(_str),
	_strFinal = "",
	i = 1, isize = string_length(_str), _char = "", _pchar = "";
	repeat(isize) {
		_char = string_char_at(_string, i);
		_strFinal += (_pchar == " " || i == 1) ? string_upper(_char) : _char;
		_pchar = _char;
		++i;
	}
	return _strFinal;
}

/// @desc Uppercase letters become lowercase and vice-versa.
/// @param {string} str Text string.
/// @returns {string} 
function string_case_reverse(_str) {
	var _strFinal = "",
	i = 1, isize = string_length(_str), _char = "", _charUpper = "", _charLower = "";
	repeat(isize) {
		_char = string_char_at(_str, i);
		_charUpper = string_upper(_char);
		_charLower = string_lower(_char);
		_strFinal += (_char == _charUpper) ? _charLower : _charUpper;
		++i;
	}
	return _strFinal;
}

/// @desc Put string characters in reverse order.
/// @param {string} str Text string.
/// @returns {string} 
function string_reverse(_str) {
	var _strFinal = "",
	isize = string_length(_str), i = isize;
	repeat(isize) {
		_strFinal += string_char_at(_str, i);
		--i;
	}
	return _strFinal;
}
