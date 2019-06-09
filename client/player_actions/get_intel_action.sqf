ARWA_visible_markers = [playerSide];

ARWA_create_intel_menu = {
	params ["_box"];

	_box addAction [[localize "ARWA_STR_STEAL_INTEL", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _box = _arguments select 0;
		private _owner = (_box getVariable ARWA_KEY_owned_by);

		[_owner] remoteExec ["ARWA_add_visible_markers", playerSide];

	}, [_box], ARWA_intel_menu, false, true, "", '[_target, _this] call ARWA_enemy_owns_box', 10]
};

ARWA_add_visible_markers = {
	params["_side"];

	private _faction_name = _side call ARWA_get_faction_names;

	[["ARWA_STR_STEAL_INTEL_SUCCESS", _faction_name]] spawn ARWA_HQ_report_client_all;

	ARWA_visible_markers pushBackUnique _side;

	sleep 300;

	ARWA_visible_markers = ARWA_visible_markers - [_side];
};

ARWA_enemy_owns_box = {
    params ["_box", "_player"];

	private _enemies = ARWA_all_sides - [playerSide];
	private _box_owner = (_box getVariable ARWA_KEY_owned_by);

	_box_owner in _enemies && !(_box_owner in ARWA_visible_markers);
};