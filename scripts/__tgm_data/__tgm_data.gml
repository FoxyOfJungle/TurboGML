
/// Feather ignore all

/// @desc The function implements the RC4 cryptography algorithm to encrypt or decrypt data in the given buffer using the provided key, offset, and length.
/// @param {id.buffer} buffer The buffer to encrypt/decrypt.
/// @param {string} key The unique key to encrypt/decrypt. You need to keep it secret.
/// @param {real} offset The buffer offset. Example: 0.
/// @param {real} length The buffer length.
function rc4_cryptography(buffer, key, offset, length) {
	var i, j, s, temp, key_length, pos;
	s = array_create(256);
	key_length = string_byte_length(key);
	for(i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for(i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(key, i % key_length)) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
	}
	i = 0;
	j = 0;
	pos = 0;
	buffer_seek(buffer, buffer_seek_start, offset);
	repeat(length) {
		i = (i+1) % 256;
		j = (j+s[i]) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		var cur_byte = buffer_peek(buffer, pos++, buffer_u8);
		buffer_write(buffer, buffer_u8, s[(s[i]+s[j]) % 256] ^ cur_byte);
	}
}

// EXPERIMENTAL
// https://www.sohamkamani.com/uuid-versions-explained/
// https://www.uuidtools.com/uuid-versions-explained
function uuid_v5_generate(hyphen=false) {
	// non-random, sha1
	var _config_data = os_get_info();
	var _uuid = sha1_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+
	_config_data[? "udid"]+string(_config_data[? "video_adapter_subsysid"]));
	ds_map_destroy(_config_data);
	if (hyphen) {
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
	var _config_data = os_get_info();
	var _uuid = md5_string_unicode(string(get_timer()*current_second*current_minute*current_hour*current_day*current_month)+_config_data[? "udid"]+
	string(_config_data[? "video_adapter_subsysid"]));
	ds_map_destroy(_config_data);
	return _uuid;
}

/// @desc Generates an UUID v4 string.
/// @param {bool} hyphen Defines whether hyphens will be added to the string
/// warning: this function is not repeat safe... wip
function uuid_v4_generate(hyphen=false) {
	// randomness
	// by YellowAfterLife
	var _uuid = "";
	for(var i = 0; i < 32; i++) {
		if (hyphen) {
			if (i == 8 || i == 12 || i == 16 || i == 20) _uuid += "-";
		}
		_uuid += choose("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	}
	return _uuid;
}
