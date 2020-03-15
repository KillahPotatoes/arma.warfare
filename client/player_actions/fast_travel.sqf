ARWA_remove_all_fast_travel_options = {
	params ["_box"];

	private _options = _box getVariable [ARWA_KEY_fast_travel_options, []];
	{
		_box removeAction _x;
	} forEach _options;

	_box setVariable [ARWA_KEY_fast_travel_options, []];
};

ARWA_fast_travel = {
	params ["_destination", "_ammo_box"];

	private _pos = getPos _destination;
	private _safe = [_pos, playerSide, ARWA_sector_size] call ARWA_any_enemies_in_area;
	private _owned_by = _destination getVariable ARWA_KEY_owned_by;

	if(!(_owned_by isEqualTo playerSide)) exitWith { systemChat localize "ARWA_STR_CANNOT_TRAVEL_TO_THIS_SECTOR_ANYMORE"; };
	if(_safe) exitWith { systemChat localize "ARWA_STR_SECTOR_NOT_SAFE"; };

	private _units = units group player select { player distance2D _x < 100; };

	{
		private _safe_pos = [_pos, 2, 5, 2, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
		[_x, _ammo_box] call ARWA_store_manpower;
		_x setPos _safe_pos;
	} forEach _units;
};

ARWA_list_fast_travel_options = {
	params ["_box"];

	private _side = playerSide;
	private _all_destinations = ([_side] call ARWA_get_owned_sectors) + [missionNamespace getVariable format["ARWA_HQ_%1", playerSide]];
	private _destinations = _all_destinations select { (_x distance2D player) > 200; };
	private _sub_options = [];

	if(!(_destinations isEqualTo [])) then {
		{
			private _name = [_x getVariable ARWA_KEY_target_name] call ARWA_replace_underscore;
			_sub_options pushBack (_box addAction [[_name, 2] call ARWA_add_action_text, {
				private _params = _this select 3;
				private _box = _params select 0;
				private _destination = _params select 1;

				[_destination, _box] call ARWA_fast_travel;
				[_box] call ARWA_remove_all_fast_travel_options;
				_box setVariable [ARWA_KEY_fast_travel_menu, false];
			}, [_box, _x], (ARWA_fast_travel_actions - 1), false, true, "", '[player] call ARWA_is_leader', 10]);
		} forEach _destinations;
	} else {
		systemChat localize "ARWA_STR_NO_OWNED_SECTORS";
		_box setVariable [ARWA_KEY_fast_travel_menu, false];
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
		[_box] call ARWA_remove_all_fast_travel_options;

		if([_pos, playerSide, ARWA_sector_size] call ARWA_any_enemies_in_area) exitWith { systemChat localize "ARWA_STR_CANNOT_FAST_TRAVEL_ENEMIES_NEARBY";};

		private _open = _box getVariable ARWA_KEY_fast_travel_menu;

		if(!_open) then {
			[_box] call ARWA_list_fast_travel_options;
			_box setVariable [ARWA_KEY_fast_travel_menu, true];
		} else {
			_box setVariable [ARWA_KEY_fast_travel_menu, false];
		}
	}, [_box, _name, _pos], ARWA_fast_travel_actions, false, false, "", '[player] call ARWA_is_leader && [_target, _this] call ARWA_owned_by && [] call ARWA_is_not_commander', 10]
};

