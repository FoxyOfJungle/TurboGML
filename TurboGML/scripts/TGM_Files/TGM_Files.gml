
/// Feather ignore all
enum DIRSCAN_DATA_TYPE {
	FULL_PATH,
	NAME_ONLY,
	FULL_INFO,
}

/// @desc Reads all files in a directory and subdirectories. Returns different types of data.
/// @param {string} pathSource The directory path.
/// @param {array} contentsArray The array to fill with contents.
/// @param {string} extension The file extension to search. Example: "*.png". Use *.* for every extension.
/// @param {bool} searchFiles Enable file search.
/// @param {bool} searchFolders Enable folder search.
/// @param {bool} searchSubdir Enable sub directory search.
/// @param {real} dataType Determines the type of date to be returned. Example: DIRSCAN_DATA_TYPE.NAME_ONLY.
/// @param {bool} getSize Get file sizes while scanning.
/// @param {bool} debug View debug messages.
/// @returns {array} Array with contents.
function directory_get_contents(_pathSource, _contentsArray, _extension="*.*", _searchFiles=true, _searchFolders=true, _searchSubdir=true, _dataType=DIRSCAN_DATA_TYPE.FULL_PATH, _getSize=false, _debug=true) {
	// based on https://yal.cc/gamemaker-recursive-folder-copying/
	if (!directory_exists(_pathSource)) {
		return undefined;
	}
	// scan contents (folders and files)
	var _contents = [];
	var _file = file_find_first(_pathSource + "/" + _extension, fa_directory | fa_archive | fa_readonly);
	var _filesCount = 0;
	while(_file != "") {
		if (_file == ".") continue;
		if (_file == "..") continue;
		array_push(_contents, _file);
		_file = file_find_next();
		_filesCount++;
	}
	file_find_close();
	// process found contents:
	var _i = 0;
	repeat(_filesCount) {
		var _fileName = _contents[_i];
		var _path = _pathSource + "/" + _fileName; // the path of the content (folder or file)
		var _dirName = filename_dir_name(_path);
		var _data = undefined;
		var _progress = (_i / _filesCount); // ready-only
		if (_debug) show_debug_message($"Scanning: [{_progress * 100}%] {_dirName} | {_fileName}");
		if (directory_exists(_path)) {
			// recursively search directories
			if (_searchSubdir) directory_get_contents(_path, _contentsArray, _extension, _searchFiles, _searchFolders, _searchSubdir, _dataType, _getSize);
			if (_searchFolders) {
			switch(_dataType) {
				case DIRSCAN_DATA_TYPE.FULL_INFO:
					_data = {
						name : _fileName,
						type : 0,
						ext : "",
						path : _path,
						rootFolder : _dirName,
						size : -1,
					};
					break;
				case DIRSCAN_DATA_TYPE.NAME_ONLY: _data = _fileName; break;
				case DIRSCAN_DATA_TYPE.FULL_PATH: _data = _path; break;
				}
			}
		} else {
			if (_searchFiles) {
				switch(_dataType) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : filename_name_noext(_fileName),
							type : 1,
							ext : filename_ext(_fileName),
							path : _path,
							rootFolder : _dirName,
							size : _getSize ? bytes_get_size(file_get_size(_path)) : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY: _data = _fileName; break;
					case DIRSCAN_DATA_TYPE.FULL_PATH: _data = _path; break;
				}
			}
		}
		if (_data != undefined) array_push(_contentsArray, _data);
		++_i;
	}
    return _contents;
}

/// @desc Load a file and get the size in bytes.
/// @param {string} file File path.
/// @returns {real} 
function file_get_size(_file) {
	var _buff = buffer_load(_file);
	if (_buff <= 0) return 0;
	var _size = buffer_get_size(_buff);
	buffer_delete(_buff);
	return _size;
}

/// @desc Convert bytes to KB, MB, GB, etc.
/// @param {real} bytes File bytes amount.
/// @returns {string} 
function bytes_get_size(_bytes) {
	static _sizes = ["B", "KB", "MB", "GB", "TB", "PB"]; // you can add more
	if (_bytes <= 0) return "0 B";
	var i = floor(log2(_bytes) / log2(1024));
	return string(round(_bytes / power(1024, i))) + " " + _sizes[i];
}

/// @desc Get directory name from a file.
/// @param {string} file File path.
/// @returns {string} 
function filename_dir_name(_file) {
	// var _dirName = filename_name(filename_dir(file));
	var _dir = filename_dir(_file), _dirName = "";
	var isize = string_length(_dir), i = isize;
	repeat(isize) {
		var _char = string_char_at(_dir, i);
		if (_char == "/") {
		_dirName = string_copy(_dir, i + 1, string_length(_dir) - i);
		break;
	}
		--i;
	}
	return _dirName;
}

/// @desc Get file name, without extension.
/// @param {string} file File path.
/// @returns {string} 
function filename_name_noext(_path) {
	return filename_name(filename_change_ext(_path, ""));
}

/// @desc Write a string to a file.
/// @param {string} filePath File path.
/// @param {any} str Description
function file_write_string(_filePath, _str) {
	var _buff = buffer_create(0, buffer_grow, 1);
	buffer_write(_buff, buffer_string, _str);
	buffer_save(_buff, _filePath);
	buffer_delete(_buff);
}

/// @desc Write a text to a file.
/// @param {string} filePath File path.
/// @param {any} str Description
function file_write_text(_filePath, _str) {
	var _buff = buffer_create(0, buffer_grow, 1);
	buffer_write(_buff, buffer_text, _str);
	buffer_save(_buff, _filePath);
	buffer_delete(_buff);
}

/// @desc Read string from file.
/// @param {string} filePath File path.
function file_read_string(_filePath) {
	if (!file_exists(_filePath)) return undefined;
	var _buffer = buffer_load(_filePath);
	if (_buffer == -1) {
		return undefined;
	}
	var _result = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	return _result;
}

/// @desc Read text from file.
/// @param {string} filePath File path.
function file_read_text(_filePath) {
	if (!file_exists(_filePath)) return undefined;
	var _buffer = buffer_load(_filePath);
	if (_buffer == -1) {
		return undefined;
	}
	var _result = buffer_read(_buffer, buffer_text);
	buffer_delete(_buffer);
	return _result;
}
