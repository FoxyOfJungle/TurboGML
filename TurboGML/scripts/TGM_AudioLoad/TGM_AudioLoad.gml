
/// Feather ignore all

/// @desc Load an external .ogg audio file. Returns a struct with information.
/// @param {string} file_path The file location.
/// @returns {Struct,Real}
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

/// @desc Load an external .raw audio file. Returns a struct with information. You need to specify sample rate, bps and channels as there is no information about this in the raw file.
/// @param {string} file_path The file location.
/// @param {real} sample_rate The sample rate.
/// @param {real} bits_per_sample Bits per sample.
/// @param {real} channels Channels number.
/// @returns {Struct,Real,undefined}
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


/// @desc Load an external .raw audio file. Returns a struct with information.
/// @param {string} file_path The file location.
/// @returns {Struct,Real,undefined}
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

/// @desc Destroy previously loaded stream. Freeing the memory.
/// @param {any} stream_data Stream data struct.
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

/// @desc Get stream audio format.
/// @param {any} stream_data Stream data struct.
function audio_stream_get_format(stream_data) {
	if (is_struct(stream_data)) return stream_data.audio.format;
	return "";
}

