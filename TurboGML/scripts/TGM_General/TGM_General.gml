
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

/// @desc Returns a boolean (true or false) indicating whether the game was exported as a standalone (executable).
/// @returns {bool} 
function game_is_standalone() {
	static is_standalone = (GM_build_type == "exe");
	return is_standalone;
}

/// @desc Function Description
/// @param {function} callback Description
/// @param {array} args Description
/// @param {real} time Description
/// @param {real} [repetitions]=1 Description
/// @returns {id} Description
function invoke(callback, args, time, repetitions=1) {
	var _ts = time_source_create(time_source_game, time, time_source_units_frames, callback, args, repetitions);
	time_source_start(_ts);
	return _ts;
}
