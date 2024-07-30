
/// Feather ignore all

#macro fps_average ___fps_average()
/// @ignore
function ___fps_average() {
	static fpsList = ds_list_create();
	static maxFpsValues = 50;
	static fpsSmooth = 0;
	static fpsSmoothRate = 0.1;
	ds_list_add(fpsList, fps_real);
	if (ds_list_size(fpsList) > maxFpsValues) {
		ds_list_delete(fpsList, 0);
	}
	fpsSmooth = lerp(fpsSmooth, ds_list_mean(fpsList), fpsSmoothRate);
	return fpsSmooth;
}

/// @desc Returns a boolean (true or false) indicating whether the game was exported as a standalone (executable).
/// @returns {bool} 
function game_is_standalone() {
	static isStandalone = (GM_build_type == "exe");
	return isStandalone;
}

/// @desc Function Description
/// @param {function} callback Description
/// @param {array} args Description
/// @param {real} time Description
/// @param {real} [repetitions]=1 Description
/// @returns {id} Description
function invoke(_callback, _args, _time, _repetitions=1) {
	var _ts = time_source_create(time_source_game, _time, time_source_units_frames, _callback, _args, _repetitions);
	time_source_start(_ts);
	return _ts;
}
