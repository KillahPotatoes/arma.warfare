ARWA_visible_markers = [playerSide];

ARWA_create_intel_menu = {
	params ["_box"];

	_box addAction [[localize "ARWA_STR_STEAL_INTEL", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _box = _arguments select 0;
		private _owner = (_box getVariable ARWA_KEY_owned_by);
		[_owner] spawn add_visible_markers;

	}, [_box], ARWA_intel_menu, false, true, "", '[_target, _this] call ARWA_enemy_owns_box', 10]
};

add_visible_markers = {
	params["_side"];

	if (_side in ARWA_visible_markers) exitWith {};

	ARWA_visible_markers pushBackUnique _side;

	sleep 30;

	ARWA_visible_markers = ARWA_visible_markers - [_side];
};

ARWA_enemy_owns_box = {
    params ["_box", "_player"];

	private _enemies = ARWA_all_sides - [playerSide];
	private _box_owner = (_box getVariable ARWA_KEY_owned_by);

	_box_owner in _enemies;
};