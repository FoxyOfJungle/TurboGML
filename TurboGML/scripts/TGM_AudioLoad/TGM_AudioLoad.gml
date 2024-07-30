
/// Feather ignore all

/// @desc Load an external .ogg audio file. Returns a struct with information.
/// @param {string} filePath The file location.
/// @returns {Struct,Real}
function audio_load_ogg(_filePath) {
	if (file_exists(_filePath)) {
		if (string_lower(filename_ext(_filePath)) == ".ogg") {
			var audio_data = {
				format : "ogg",
				audio : audio_create_stream(_filePath),
			}
			return audio_data;
		} else {
			return -3;
		}
	}
	return -1;
}

/// @desc Load an external .raw audio file. Returns a struct with information. You need to specify sample rate, bps and channels as there is no information about this in the raw file.
/// @param {string} filePath The file location.
/// @param {real} sampleRate The sample rate.
/// @param {real} bitsPerSample Bits per sample.
/// @param {real} channels Channels number.
/// @returns {Struct,Real,undefined}
function audio_load_raw(_filePath, _sampleRate, _bitsPerSample, _channels) {
    if (file_exists(_filePath)) {
        // read file bytes
        var _fileBuff = buffer_load(_filePath);
        var _fileSize = buffer_get_size(_fileBuff);
        var _audioBuff = buffer_create(_fileSize, buffer_fixed, 1);
        buffer_copy(_fileBuff, 0, _fileSize, _audioBuff, 0);
        buffer_delete(_fileBuff);
        
        // create buffer sound
        var _format = (_bitsPerSample == 8) ? buffer_u8 : buffer_s16;
        var _channelsMode = (_channels == 2) ? audio_stereo : ((_channels == 1) ? audio_mono : audio_3d);
        var _length = _fileSize / (_sampleRate * _channels * _bitsPerSample / 8) / 60;
        
        // return data
        var _audioData = {
            format : "raw",
            channels : _channels,
            sampleRate : _sampleRate,
            bitsPerSample : _bitsPerSample,
            byteRate : _bitsPerSample / 8,
            length : _length,
            kbps : (_sampleRate * _bitsPerSample * _channels) / 1000,
            audio : audio_create_buffer_sound(_audioBuff, _format, _sampleRate, 0, _fileSize, _channelsMode),
            buffer : _audioBuff,
        };
        return _audioData;
    } else {
        return -1;
    }
    return undefined;
}


/// @desc Load an external .raw audio file. Returns a struct with information.
/// @param {string} file_path The file location.
/// @returns {Struct,Real,undefined}
function audio_load_wav(_filePath) {
	if (file_exists(_filePath)) {
        // read file bytes
        var _fileBuff = buffer_load(_filePath);
        var _fileSize = buffer_get_size(_fileBuff);
        var _audioBuff = buffer_create(_fileSize, buffer_fixed, 1);
        buffer_copy(_fileBuff, 0, _fileSize, _audioBuff, 0);
        buffer_delete(_fileBuff);
        
        // header byte offset
        var _headerLength = 44, _hoChunkId = 0, _hoChunkSize = 4, _hoFormat = 8, _hoSubchunkId1 = 12, _hoSubchunkId1Size = 16,
            _hoAudioFormat = 20, _hoChannelsNum = 22, _hoSampleRate = 24, _hoByteRate = 28, _hoBlockAlign = 32, _hoBps = 34,
            _hoSubchunkId2 = 36, _hoSubchunkId2Size = 40, _hoData = 44;
        
        // read header
        var _chunkId = "", _chunkSize = 0, _format = "", _subchunkId1 = "", _subchunkId1Size = 0, _audioFormat = 0, _channelsNum = 0,
            _sampleRate = 0, _byteRate = 0, _blockAlign = 0, _bitsPerSample = 0, _subchunkId2 = "", _subchunkId2Size = 0;
        
        var _audioBuffLength = buffer_get_size(_audioBuff);
        for (var i = 0; i <= _headerLength; i++) {
            if (i >= _hoChunkId && i < _hoChunkSize)
                _chunkId += chr(buffer_peek(_audioBuff, i, buffer_u8));
            //if (i == _hoChunkSize)
                //_chunkSize += buffer_peek(_audioBuff, i, buffer_u32);
            if (i >= _hoFormat && i < _hoSubchunkId1)
                _format += chr(buffer_peek(_audioBuff, i, buffer_u8));
            //if (i >= _hoSubchunkId1 && i < _hoSubchunkId1Size)
                //_subchunkId1 += chr(buffer_peek(_audioBuff, i, buffer_u8)); // < fmt >
            //if (i >= _hoSubchunkId1Size && i < _hoAudioFormat)
                //_subchunkId1Size += buffer_peek(_audioBuff, i, buffer_u8);
            if (i >= _hoAudioFormat && i < _hoChannelsNum)
                _audioFormat += buffer_peek(_audioBuff, i, buffer_u8); // 1 is PCM
            if (i >= _hoChannelsNum && i < _hoSampleRate)
                _channelsNum += buffer_peek(_audioBuff, i, buffer_u8);
            if (i == _hoSampleRate)
                _sampleRate += buffer_peek(_audioBuff, i, buffer_u32);
            //if (i == _hoByteRate)
                //_byteRate += buffer_peek(_audioBuff, i, buffer_u32);
            //if (i >= _hoBlockAlign && i < _hoBps)
                //_blockAlign += buffer_peek(_audioBuff, i, buffer_u8);
            if (i >= _hoBps && i < _hoSubchunkId2)
                _bitsPerSample += buffer_peek(_audioBuff, i, buffer_u8);
            //if (i >= _hoSubchunkId2 && i < _hoSubchunkId2Size)
                //_subchunkId2 += chr(buffer_peek(_audioBuff, i, buffer_u8)); // < DATA >
            //if (i == _hoSubchunkId2Size)
                //_subchunkId2Size += buffer_peek(_audioBuff, i, buffer_u32);
        }
        if (string_lower(_chunkId) != "riff" || _audioFormat != 1) return -3;
        
        // create buffer sound
        var _format = (_bitsPerSample == 8) ? buffer_u8 : buffer_s16;
        var _channels = (_channelsNum == 2) ? audio_stereo : ((_channelsNum == 1) ? audio_mono : audio_3d);
        
        // return data
        var audioData = {
            format : "wav",
            channels : _channelsNum,
            sampleRate : _sampleRate,
            bitsPerSample : _bitsPerSample, // samples per second
            byteRate : _bitsPerSample / 8, // bytes per second
            length : _fileSize / (_sampleRate * _channelsNum * _bitsPerSample / 8) / 60, // seconds
            kbps : (_sampleRate * _bitsPerSample * _channelsNum) / 1000,
            audio : audio_create_buffer_sound(_audioBuff, _format, _sampleRate, _hoData, _audioBuffLength - _hoData, _channels),
            buffer : _audioBuff,
        };
        return audioData;
    } else {
        return -1;
    }
    return undefined;
}

/// @desc Destroy previously loaded stream. Freeing the memory.
/// @param {any} streamData Stream data struct.
function audio_stream_destroy(_streamData) {
	if (is_struct(_streamData)) {
		if (_streamData.format == "ogg") {
			audio_destroy_stream(_streamData.audio);
		} else {
			if (buffer_exists(_streamData.buffer)) {
				audio_free_buffer_sound(_streamData.audio);
				buffer_delete(_streamData.buffer);
			}
		}
	}
}

/// @desc Get stream audio format.
/// @param {any} streamData Stream data struct.
function audio_stream_get_format(_streamData) {
	if (is_struct(_streamData)) return _streamData.audio.format;
	return "";
}

