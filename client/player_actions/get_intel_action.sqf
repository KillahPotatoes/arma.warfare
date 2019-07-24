ARWA_visible_markers = [playerSide];

ARWA_create_intel_menu = {
	params ["_box"];

	_box addAction [[localize "ARWA_STR_STEAL_INTEL", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _box = _arguments select 0;
		private _owner = (_box getVariable ARWA_KEY_owned_by);
		private _capture_progress = _box getVariable [ARWA_KEY_sector_capture_progress, 0];
		private _stolen_manpower = _capture_progress;
		private _intel_visibility = _capture_progress * 10;

		[_owner, _stolen_manpower] remoteExec ["ARWA_decrease_manpower_server", 2];

		private _new_manpower = (_caller call ARWA_get_manpower) + _stolen_manpower;
		_caller setVariable [ARWA_KEY_manpower, _new_manpower, true];
		_box setVariable [ARWA_KEY_hacked, true, true];

		systemChat format["_capture_progress: %1, _stolen_manpower: %2, _intel_visibility: %3", _capture_progress, _stolen_manpower, _intel_visibility];

		systemChat format[localize "ARWA_STR_YOU_TOOK_MANPOWER", _stolen_manpower];
		[_owner, _intel_visibility, _stolen_manpower] remoteExec ["ARWA_add_visible_markers", playerSide];

	}, [_box], ARWA_intel_menu, false, true, "", '[_target, _this] call ARWA_can_hack_box', 10]
};

ARWA_add_visible_markers = {
	params["_side", "_intel_visibility", "_stolen_manpower"];

	private _faction_name = _side call ARWA_get_faction_names;
	private _stolen_intel_time_sec = _intel_visibility mod 60;
	private _stolen_intel_time_min = (_intel_visibility - _stolen_intel_time_sec) / 60;

	private _min_time_with_padding = if(_stolen_intel_time_min < 10) then { format["0%1", _stolen_intel_time_min]; } else { _stolen_intel_time_min; };
	private _sec_time_with_padding = if(_stolen_intel_time_sec < 10) then { format["0%1", _stolen_intel_time_sec]; } else { _stolen_intel_time_sec; };

	[["ARWA_STR_STEAL_INTEL_SUCCESS", _faction_name, _stolen_manpower, _min_time_with_padding, _sec_time_with_padding]] spawn ARWA_HQ_report_client_all;

	ARWA_visible_markers pushBackUnique _side;

	sleep _intel_visibility;

	ARWA_visible_markers = ARWA_visible_markers - [_side];
};

ARWA_can_hack_box = {
    params ["_box", "_player"];

	private _enemies = ARWA_all_sides - [playerSide];
	private _box_owner = (_box getVariable ARWA_KEY_owned_by);

	_box_owner in _enemies && !(_box getVariable [ARWA_KEY_hacked, false]);
};