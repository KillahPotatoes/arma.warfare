missionNamespace setVariable ["ARWA_sectors", [], true];

ARWA_initialize_ammoboxes = {
	params ["_first_capture_bonus"];

	private _sectors = [];

	{
		private _ammo_box = _x;
		_ammo_box setMass 100000;
		_ammo_box enableRopeAttach false;

		private _ammo_box_name = vehicleVarName _ammo_box;
		private _arr = _ammo_box_name splitString "_";
		private _type = _arr select 0;

		_arr deleteAt 0;

		private _name = _arr joinString " ";
		private _pos = getPos _ammo_box;

		if(_type isEqualTo "HQ") then {
			private _side = [_name] call ARWA_get_prefixed_side;

			if(!isNil "_side") then {
				_ammo_box setVariable [ARWA_KEY_HQ, true, true];
				_ammo_box setVariable [ARWA_KEY_manpower, 0, true];
				_ammo_box setVariable [ARWA_KEY_target_name, "HQ", true];
				_ammo_box setVariable [ARWA_KEY_owned_by, _side, true];

				missionNamespace setVariable [format["ARWA_HQ_%1", _side], _ammo_box, true];

				[_side, _pos] call BIS_fnc_addRespawnPosition;
			};
		};

		if(_type isEqualTo "FOB") then {
			private _capture_bonus = if(_first_capture_bonus) then {  ARWA_starting_strength / 10; } else { 0; };

			_ammo_box setVariable [ARWA_KEY_owned_by, civilian, true];
			_ammo_box setVariable [ARWA_KEY_manpower, _capture_bonus, true];
			_ammo_box setVariable [ARWA_KEY_sector, true, true];
			_ammo_box setVariable [ARWA_KEY_target_name, _name, true];

			private _static_spawn_positions = [_pos] call ARWA_get_all_static_spawn_areas;
			_ammo_box setVariable [ARWA_KEY_static_spawn_positions, _static_spawn_positions];

			_ammo_box setVariable [ARWA_KEY_marker, _ammo_box_name];
			[_ammo_box] call ARWA_draw_sector;
			[_ammo_box] call ARWA_draw_sector_name;
			[_ammo_box] spawn ARWA_initialize_sector_control;

			_sectors pushBack _ammo_box;
		};

	} forEach allMissionObjects ARWA_ammo_box;

	missionNamespace setVariable ["ARWA_sectors", _sectors, true];
};

ARWA_get_all_static_spawn_areas = {
	params ["_pos"];
	_pos nearObjects ["Land_ClutterCutter_large_F", ARWA_sector_size];
};

ARWA_is_sector_safe = {
	params ["_side", "_sector", "_distance"];

	private _pos = getPos _sector;

	!([_pos, _side, _distance] call ARWA_any_enemies_in_area);
};

ARWA_get_safe_sectors = {
	params ["_side", "_distance"];

	(_side call ARWA_get_owned_sectors) select { [_side, _x, _distance] call ARWA_is_sector_safe; };
};

ARWA_get_unsafe_sectors = {
	params ["_side"];

	(_side call ARWA_get_owned_sectors) select { !([_side, _x, ARWA_sector_size] call ARWA_is_sector_safe); };
};

ARWA_get_unowned_sectors = {
	ARWA_sectors select { (_x getVariable ARWA_KEY_owned_by) isEqualTo civilian; };
};

ARWA_get_all_owned_sectors = {
	ARWA_sectors select { !((_x getVariable ARWA_KEY_owned_by) isEqualTo civilian); };
};

ARWA_get_other_sectors = {
	params ["_side"];
	ARWA_sectors select { !((_x getVariable ARWA_KEY_owned_by) isEqualTo _side); };
};

ARWA_find_closest_sector_connected_by_road = {
	params ["_sectors", "_pos"];

	private _current_sector = _sectors select 0;
	private _shortest_distance = 99999;

	{
		_sector_pos = getPos _x;
		_distance = _pos distance _sector_pos;

		private _road_at_target = (_sector_pos nearRoads ARWA_sector_size);
		private _any_road = !(_road_at_target isEqualTo []);

		if (_shortest_distance > _distance && _any_road) then {
			_shortest_distance = _distance;
			_current_sector = _x;
		};

	} forEach _sectors;

	_current_sector;
};

ARWA_find_closest_sector = {
	params ["_sectors", "_pos"];

	private _current_sector = _sectors select 0;
	private _shortest_distance = 99999;

	{
		_sector_pos = getPos _x;
		_distance = _pos distance _sector_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_current_sector = _x;
		};

	} forEach _sectors;

	_current_sector;
};

ARWA_find_enemy_sectors = {
	params ["_side"];

	private _enemy = ARWA_all_sides - [_side];

	private _enemy_sectors = [];

	{
		_enemy_sectors append ([_x] call ARWA_get_owned_sectors);
	} foreach _enemy;

	_enemy_sectors;
};
