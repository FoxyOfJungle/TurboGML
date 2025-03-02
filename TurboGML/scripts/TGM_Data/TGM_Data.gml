
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

/// @func    buffer_create_from_surface
/// @desc    Creates a fixed-size buffer containing the pixel data from the given surface. The buffer size is determined
///          by the surface's dimensions and format. The buffer is populated with the surface's pixel data starting at byte offset 0.
/// @param   {Id.Surface} _surf - The source surface from which to read pixel data.
/// @returns {Id.Buffer} A buffer containing the surface's pixel data.
function buffer_create_from_surface(_surf) {
	// Get surface properties
	var _width = surface_get_width(_surf);
	var _height = surface_get_height(_surf);
	var _format = surface_get_format(_surf);
	
	// Determine bytes per pixel based on format
	var _bytes_per_pixel;
	switch (_format) {
		case surface_rgba4unorm:  _bytes_per_pixel = 2;  break;
		case surface_rgba8unorm:  _bytes_per_pixel = 4;  break;
		case surface_rgba16float: _bytes_per_pixel = 8;  break;
		case surface_rgba32float: _bytes_per_pixel = 16; break;
		case surface_r8unorm:     _bytes_per_pixel = 1;  break;
		case surface_r16float:    _bytes_per_pixel = 2;  break;
		case surface_r32float:    _bytes_per_pixel = 16; break;
		case surface_rg8unorm:    _bytes_per_pixel = 2;  break;
		default: throw "Unsupported format"
	}
	
	// Create a buffer large enough to store the surface data
	var _buff_size = _width * _height * _bytes_per_pixel;
	var _buff = buffer_create(_buff_size, buffer_fixed, 1);
	
	// Write surface data into buffer
	buffer_get_surface(_buff, _surf, 0);
	buffer_seek(_buff, buffer_seek_start, 0);
	
	return _buff;
}

/// @func    surface_create_from_buffer
/// @desc    Creates a new surface with the specified width, height, and format, and populates it with pixel data
///          read from the provided buffer. The buffer data is written to the surface starting at byte offset 0.
/// @param   {Id.Buffer} _buff - The buffer containing the pixel data to write to the surface.
/// @param   {Real} _width - The width of the new surface.
/// @param   {Real} _height - The height of the new surface.
/// @param   {Constant.SurfaceFormatConstant} _format - The format to use for the new surface.
/// @returns {Id.Surface} The newly created surface containing the pixel data from the buffer.
function surface_create_from_buffer(_buff, _width, _height, _format=surface_rgba8unorm) {
    // Create a new surface with the specified width, height, and format.
    var _surf = surface_create(_width, _height, _format);
    
	// Determine bytes per pixel based on format
	var _bytes_per_pixel;
	switch (_format) {
		case surface_rgba4unorm:  _bytes_per_pixel = 2;  break;
		case surface_rgba8unorm:  _bytes_per_pixel = 4;  break;
		case surface_rgba16float: _bytes_per_pixel = 8;  break;
		case surface_rgba32float: _bytes_per_pixel = 16; break;
		case surface_r8unorm:     _bytes_per_pixel = 1;  break;
		case surface_r16float:    _bytes_per_pixel = 2;  break;
		case surface_r32float:    _bytes_per_pixel = 16; break;
		case surface_rg8unorm:    _bytes_per_pixel = 2;  break;
		default: throw "Unsupported format"
	}
	
	// Calculate the expected buffer size based on the surface dimensions and bytes per pixel.
	var _expected_size = _width * _height * _bytes_per_pixel;
	var _actual_size = buffer_get_size(_buff);
	
	// Safety check: Ensure the buffer size matches the expected size.
	if (_actual_size != _expected_size) {
		show_error("Buffer size mismatch: expected " + string(_expected_size) + " but got " + string(_actual_size), true);
	}
	
    // Write the pixel data from the buffer into the surface, starting at byte offset 0.
    buffer_set_surface(_buff, _surf, 0);
    
    // Return the newly created surface.
    return _surf;
}

/// @desc The function implements the RC4 cryptography algorithm to encrypt or decrypt data in the given buffer using the provided key, offset, and length.
/// @param {id.buffer} buffer The buffer to encrypt/decrypt.
/// @param {string} key The unique key to encrypt/decrypt. You need to keep it secret.
/// @param {real} offset The buffer offset. Example: 0.
/// @param {real} length The buffer length.
function cryptography_rc4(_buffer, _key, _offset, _length) {
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
		var _currentByte = buffer_peek(_buffer, _pos++, buffer_u8);
		buffer_write(_buffer, buffer_u8, s[(s[i]+s[j]) % 256] ^ _currentByte);
	}
}

/// @desc The function implements the XOR cryptography algorithm to encrypt or decrypt data in the given buffer using the provided key, offset, and length. This is a simple cryptography method and it's not very safe.
/// @param {id.buffer} buffer The buffer to encrypt/decrypt.
/// @param {string} key The unique HEX key to encrypt/decrypt. You need to keep it secret. Example: 0xAA, 0x4F, 0x48
/// @param {real} offset The buffer offset. Example: 0.
/// @param {real} length The buffer length.
function cryptography_xor(_buffer, _key, _offset, _length) {
	for (var i = _offset; i < _length; ++i) {
		buffer_poke(_buffer, i, buffer_u8, _key ^ buffer_peek(_buffer, i, buffer_u8))
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
