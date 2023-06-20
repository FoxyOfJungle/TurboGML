
/// Feather ignore all

#macro fps_average ___fps_average()
/// @ignore
function ___fps_average() {
	static frames = 0;
	static total_fps = 1;
	static total_smooth = 0;
	frames++;
	if (frames > 250) {
		frames = 1;
		total_fps = 1;
	}
	total_fps += fps_real;
	var _fps_avg = total_fps / frames;
	total_smooth = lerp(total_smooth, _fps_avg, 0.2);
	return floor(total_smooth);
}

function game_is_compiled() {
	return (GM_build_type == "exe");
}

function generate_code(chars, size) {
	var _len = string_length(chars), _str_final = "", _str_chars = [];
	var i = 0;
	repeat(size) {
		_str_chars[i] = string_char_at(chars, irandom(_len));
		_str_final += _str_chars[i];
		i++;
	}
	return string(_str_final);
}

function invoke(callback, args, time, repetitions=1) {
	var _ts = time_source_create(time_source_game, time, time_source_units_frames, callback, args, repetitions);
	time_source_start(_ts);
	return _ts;
}
