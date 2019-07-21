ARWA_visible_markers = [playerSide];

ARWA_create_intel_menu = {
	params ["_box"];

	_box addAction [[localize "ARWA_STR_STEAL_INTEL", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _box = _arguments select 0;
		private _owner = (_box getVariable ARWA_KEY_owned_by);
		private _capture_progress = _box getVariable [ARWA_KEY_sector_capture_progress, 0];
		private _time_left_to_capture = _ARWA_capture_time - _capture_progress;

		private _stolen_manpower = _time_left_to_capture;
		private _intel_visibility = _time_left_to_capture * 10;

		[_owner, _stolen_manpower] remoteExec ["ARWA_decrease_manpower_server", 2];

		 private _manpower = (_caller call ARWA_get_manpower) + _stolen_manpower;

		_caller setVariable [ARWA_KEY_manpower, _manpower, true];

		systemChat format[localize "ARWA_STR_YOU_TOOK_MANPOWER", _new_manpower];
		[_owner, _intel_visibility, _stolen_manpower] remoteExec ["ARWA_add_visible_markers", playerSide];

	}, [_box], ARWA_intel_menu, false, true, "", '[_target, _this] call ARWA_enemy_owns_box', 10]
};

ARWA_add_visible_markers = {
	params["_side", "_intel_visibility", "_stolen_manpower"];

	private _faction_name = _side call ARWA_get_faction_names;
	private _stolen_intel_time_sec = _intel_visibility mod 60;
	private _stolen_intel_time_min = (_intel_visibility - (_stolen_intel_time_sec mod 60)) / 60;

	[["ARWA_STR_STEAL_INTEL_SUCCESS", _faction_name, _stolen_manpower, _stolen_intel_time_min, _stolen_intel_time_sec]] spawn ARWA_HQ_report_client_all;

	ARWA_visible_markers pushBackUnique _side;

	sleep _intel_visibility;

	ARWA_visible_markers = ARWA_visible_markers - [_side];
};

ARWA_enemy_owns_box = {
    params ["_box", "_player"];

	private _enemies = ARWA_all_sides - [playerSide];
	private _box_owner = (_box getVariable ARWA_KEY_owned_by);

	_box_owner in _enemies && !(_box_owner in ARWA_visible_markers);
};