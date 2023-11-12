
/// Feather ignore all

enum DIRSCAN_DATA_TYPE {
	FULL_PATH,
	NAME_ONLY,
	FULL_INFO,
}

/// @desc Reads all files in a directory and subdirectories. Returns different types of data.
/// @param {string} path The directory path.
/// @param {string} extension The file extension to search. Use *.* for every extension.
/// @param {bool} search_files Enable file search.
/// @param {bool} search_folders Enable folder search.
/// @param {bool} search_subdir Enable sub directory search.
/// @param {real} data_type Determines the type of date to be returned. Example: DIRSCAN_DATA_TYPE.NAME_ONLY.
/// @param {bool} get_size Get file sizes while scanning.
function DirectoryScanner(path, extension="*.*", search_files=true, search_folders=true, search_subdir=true, data_type=DIRSCAN_DATA_TYPE.NAME_ONLY, get_size=false) constructor {
	__contents = [];
	__loaded = false;
	__path_exists = false;
	
	if (directory_exists(path)) {
		__directory_recursive_search(__contents, path, string(extension), search_files, search_folders, search_subdir, data_type, get_size);
		__loaded = true;
		__path_exists = true;
	} else {
		show_debug_message("Directory Scanner: Error, can't find directory to scan.");
	}
	
	static GetContents = function() {
		return __path_exists ? __contents : undefined;
	}
	
	static GetFilesAmount = function() {
		return array_length(__contents);
	}
	
	static IsLoaded = function() {
		return __loaded;
	}
	
}

// based on https://yal.cc/gamemaker-recursive-folder-copying/
/// @ignore
function __directory_recursive_search(contents, source, extension, search_files, search_folders, search_subdir, data_type, get_size) {
	// Feather disable GM1044
	// scan contents (folders and files)
	var _contents = [];
	var _file = file_find_first(source + "/" + extension, fa_directory | fa_archive | fa_readonly);
	var _files_count = 0;
	while(_file != "") {
		if (_file == ".") continue;
		if (_file == "..") continue;
		array_push(_contents, _file);
		_file = file_find_next();
		_files_count++;
	}
	file_find_close();
	
	// process found contents:
	var i = 0;
	repeat(_files_count) {
		var _fname = _contents[i];
		var _path = source + "/" + _fname; // the path of the content (folder or file)
		var _dir_name = filename_dir_name(_path);
		var _data = -1;
		
		var _progress = (i/_files_count); // ready-only
		show_debug_message("Scanning: [" + string(_progress*100) + "%] " + _dir_name + " | " + string(_fname));
		
		if (directory_exists(_path)) {
			// recursively search directories
			if (search_subdir) __directory_recursive_search(contents, _path, extension, search_files, search_folders, search_subdir, data_type, get_size);
			if (search_folders) {
				switch(data_type) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : _fname,
							type : 0,
							ext : "",
							path : _path,
							root_folder : _dir_name,
							size : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY:
						_data = _fname;
						break;
					case DIRSCAN_DATA_TYPE.FULL_PATH:
						_data = _path;
						break;
				}
			}
		} else {
			if (search_files) {
				switch(data_type) {
					case DIRSCAN_DATA_TYPE.FULL_INFO:
						_data = {
							name : filename_name_noext(_fname),
							type : 1,
							ext : filename_ext(_fname),
							path : _path,
							root_folder : _dir_name,
							size : get_size ? bytes_get_size(file_get_size(_path)) : -1,
						};
						break;
					case DIRSCAN_DATA_TYPE.NAME_ONLY:
						_data = _fname;
						break;
					case DIRSCAN_DATA_TYPE.FULL_PATH:
						_data = _path;
						break;
				}
			}
		}
		
		array_push(contents, _data);
		++i;
	}
	
	return _contents;
}


/// @desc Get directory name from a file.
/// @param {string} file File path.
/// @returns {string} 
function filename_dir_name(file) {
	//var _dir_name = filename_name(filename_dir(file));
	var _dir = filename_dir(file), _dir_name = "";
	var isize = string_length(_dir), i = isize;
	repeat(isize) {
		var _char = string_char_at(_dir, i);
		if (_char == "/") {
			_dir_name = string_copy(_dir, i+1, string_length(_dir)-i);
			break;
		}
		--i;
	}
	return _dir_name;
}

/// @desc Get file name, without extension.
/// @param {string} file File path.
/// @returns {string} 
function filename_name_noext(path) {
	return filename_name(filename_change_ext(path, ""));
	//var _name = filename_name(path);
	//var _size = string_length(_name);
	//for (var i = 1; i <= _size; ++i) {
	//	var _char = string_char_at(_name, i);
	//	if (_char == ".") {
	//		var _pos = string_pos(".", _name);
	//		var _word = string_copy(_name, _pos+1, string_length(_name)-_pos);
	//		_name = string_delete(_name, _pos, string_length(_word)+1);
	//	}
	//}
	//return _name;
}

/// @desc Write a string to a file.
/// @param {string} file_path File path.
/// @param {any} str Description
function file_write_string(file_path, str) {
	var _buff = buffer_create(1, buffer_grow, 1);
	buffer_write(_buff, buffer_string, str);
	buffer_save(_buff, file_path);
	buffer_delete(_buff);
}

/// @desc Write a text to a file.
/// @param {string} file_path File path.
/// @param {any} str Description
function file_write_text(file_path, str) {
	var _buff = buffer_create(1, buffer_grow, 1);
	buffer_write(_buff, buffer_text, str);
	buffer_save(_buff, file_path);
	buffer_delete(_buff);
}

/// @desc Read string from file.
/// @param {string} file_path File path.
function file_read_string(file_path) {
	if (!file_exists(file_path)) return undefined;
	var _buffer = buffer_load(file_path);
	var _result = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	return _result;
}

/// @desc Read text from file.
/// @param {string} file_path File path.
function file_read_text(file_path) {
	if (!file_exists(file_path)) return undefined;
	var _buffer = buffer_load(file_path);
	var _result = buffer_read(_buffer, buffer_text);
	buffer_delete(_buffer);
	return _result;
}

/// @desc Convert bytes to KB, MB, GB, etc.
/// @param {real} bytes File bytes amount.
/// @returns {string} 
function bytes_get_size(bytes) {
	var _sizes = ["B", "KB", "MB", "GB", "TB", "PB"]; // you can add more
	if (bytes <= 0) return "0 B";
	var i = floor(log2(bytes) / log2(1024));
	return string(round(bytes / power(1024, i))) + " " + _sizes[i];
}

/// @desc Load a file and get the size in bytes.
/// @param {string} file File path.
/// @returns {real} 
function file_get_size(file) {
	var _buff = buffer_load(file);
	if (_buff <= 0) return 0;
	var _size = buffer_get_size(_buff);
	buffer_delete(_buff);
	return _size;
}

