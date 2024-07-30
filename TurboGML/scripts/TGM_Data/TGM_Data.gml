
/// Feather ignore all

/// @desc Make a new buffer, based on parts from an existing buffer.
/// @param {Id.Buffer} buffer The buffer to slice.
/// @param {Real} start Where to start slicing. Default 0.
/// @param {Real} size Where to end the slice, default at the very end of the buffer (-1).
function buffer_slice(_buffer, _start=0, _size=-1) {
	var _alignment = buffer_get_alignment(_buffer);
	if (_size == -1) {
		_size = buffer_get_size(_buffer);
	} else {
		_size *= _alignment;
	}
	var _newBuffer = buffer_create(_size, buffer_get_type(_buffer), _alignment);
	var _offset = _start * _alignment;
	buffer_copy(_buffer, _offset, _size, _newBuffer, 0);
	return _newBuffer;
}

/// @desc The function implements the RC4 cryptography algorithm to encrypt or decrypt data in the given buffer using the provided key, offset, and length.
/// @param {id.buffer} buffer The buffer to encrypt/decrypt.
/// @param {string} key The unique key to encrypt/decrypt. You need to keep it secret.
/// @param {real} offset The buffer offset. Example: 0.
/// @param {real} length The buffer length.
function rc4_cryptography(_buffer, _key, _offset, _length) {
	var i, j, s, _temp, _keyLength, _pos;
	s = array_create(256);
	_keyLength = string_byte_length(_key);
	for(i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for(i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(_key, i % _keyLength)) % 256;
		_temp = s[i];
		s[i] = s[j];
		s[j] = _temp;
	}
	i = 0;
	j = 0;
	_pos = 0;
	buffer_seek(_buffer, buffer_seek_start, _offset);
	repeat(_length) {
		i = (i+1) % 256;
		j = (j+s[i]) % 256;
		_temp = s[i];
		s[i] = s[j];
		s[j] = _temp;
		var cur_byte = buffer_peek(_buffer, _pos++, buffer_u8);
		buffer_write(_buffer, buffer_u8, s[(s[i]+s[j]) % 256] ^ cur_byte);
	}
}

// EXPERIMENTAL
// https://www.sohamkamani.com/uuid-versions-explained/
// https://www.uuidtools.com/uuid-versions-explained
function uuid_v5_generate(_hyphen=false) {
	// non-random, sha1
	var _configData = os_get_info();
	var _uuid = sha1_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+
	_configData[? "udid"]+string(_configData[? "video_adapter_subsysid"]));
	ds_map_destroy(_configData);
	if (_hyphen) {
		for(var i = 1; i < 32; ++i) {
			if (i == 9 || i == 14 || i == 19 || i == 24) {
				_uuid = string_insert("-", _uuid, i);
			}
		}
	}
	return _uuid;
}

/// @desc Generates an UUID v3 string.
/// @returns {string} 
function uuid_v3_generate() {
	// non-random, md5
	var _configData = os_get_info();
	var _uuid = md5_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+_configData[? "udid"]+
	string(_configData[? "video_adapter_subsysid"]));
	ds_map_destroy(_configData);
	return _uuid;
}

/// @desc Generates an UUID v4 string.
/// @param {bool} hyphen Defines whether hyphens will be added to the string
/// warning: this function is not repeat safe... wip
function uuid_v4_generate(_hyphen=false) {
	// randomness
	// by YellowAfterLife
	var _uuid = "";
	for(var i = 0; i < 32; i++) {
		if (_hyphen) {
			if (i == 8 || i == 12 || i == 16 || i == 20) _uuid += "-";
		}
		_uuid += choose("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	}
	return _uuid;
}
