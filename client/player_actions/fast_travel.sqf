ARWA_remove_all_fast_travel_options = {
	params ["_box"];

	private _options = _box getVariable [ARWA_KEY_fast_travel_options, []];

	{
		_box removeAction _x;
	} forEach _options;

	_box setVariable [ARWA_KEY_fast_travel_options, []];
};

ARWA_fast_travel = {
	params ["_sector", "_ammo_box"];

	private _pos = [_sector] getVariable ARWA_KEY_pos;
	private _safe = [playerSide, _pos, ARWA_sector_size] call ARWA_is_sector_safe;
	private _owned_by = _sector getVariable ARWA_KEY_owned_by;

	if(!_owned_by isEqualTo playerSide) exitWith { systemChat localize "ARWA_STR_CANNOT_TRAVEL_TO_THIS_SECTOR_ANYMORE"; };
	if(!_safe) exitWith { systemChat localize "ARWA_STR_SECTOR_NOT_SAFE"; };

	[player, _ammo_box] call ARWA_store_manpower;

	private _units = units group player select { player distance2D _x < 100; };

	{
		private _safe_pos = [_pos, 2, 25, 2, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
		_x setPos _safe_pos;
	} forEach _units;
};

ARWA_list_fast_travel_options = {
	params ["_box"];

	private _side = playerSide;
	private _sectors = [_side] call ARWA_get_owned_sectors;
	private _sub_options = [];

	if(!(_sectors isEqualTo [])) then {
		{
			private _name = [_x] getVariable ARWA_KEY_TARGET_NAME;
			ARWA_join_options pushBack (player addAction [[_name, 2] call ARWA_add_action_text, {
				private _params = _this select 3;
				private _box = _params select 0;
				private _sector = _params select 1;

				[_sector, _box] call ARWA_fast_travel;
				[_box] call ARWA_remove_all_fast_travel_options;
			}, [_box, _x], (ARWA_fast_travel_actions - 1), false, true, "", '[player] call ARWA_is_leader', 10]);
		} forEach _sectors;
	} else {
		systemChat localize "ARWA_STR_NO_OWNED_SECTORS";
	};

	_box setVariable [ARWA_KEY_fast_travel_options, _sub_options];
};

ARWA_fast_travel_menu = {
	params ["_box"];

	private _pos = getPos _box;
	_box setVariable [ARWA_KEY_fast_travel_menu, false];

	_box addAction [[localize "ARWA_STR_FAST_TRAVEL_SQUAD", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _box = _arguments select 0;
		private _name = _arguments select 1;
		private _pos = _arguments select 2;

		if([_pos, playerSide, ARWA_sector_size] call ARWA_any_enemies_in_area) exitWith { systemChat localize "ARWA_STR_CANNOT_FAST_TRAVEL_ENEMIES_NEARBY";};

		[_box] call ARWA_remove_all_fast_travel_options;

		private _open = _box getVariable ARWA_KEY_fast_travel_menu;

		if(!_open) then {
			[_box] call ARWA_list_fast_travel_options;
			_box setVariable [ARWA_KEY_fast_travel_menu, true];
		} else {
			_box setVariable [ARWA_KEY_fast_travel_menu, false];
		}
	}, [_box, _name, _pos], ARWA_fast_travel_actions, false, false, "", '[player] call ARWA_is_leader && [_target, _this] call ARWA_owned_by', 10]
};