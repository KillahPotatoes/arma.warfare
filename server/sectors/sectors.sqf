ARWA_sectors = [];

ARWA_add_sector_box = {
	params ["_sector", "_first_capture_bonus"];

	private _pos = _sector getVariable ARWA_KEY_pos;
	private _ammo_box = ARWA_ammo_box createVehicle (_pos);

	_ammo_box enableRopeAttach false;
	_sector setVariable [ARWA_KEY_box, _ammo_box];
	_ammo_box setVariable [ARWA_KEY_owned_by, civilian, true];
	_ammo_box setVariable [ARWA_KEY_manpower, _first_capture_bonus, true];
	_ammo_box setVariable [ARWA_KEY_sector, true, true];
};

ARWA_initialize_sectors = {
	params ["_first_capture_bonus"];
	private _sectors = [];
	{
		_type = getMarkerType _x;

		if (_type isEqualTo "hd_objective") then {
			_split_string = [_x, 7] call ARWA_split_string;
			_first_string = _split_string select 0;
			_second_string = _split_string select 1;

			_sector = createGroup sideLogic;
			_sector setVariable [ARWA_KEY_pos, getMarkerPos _x];
			_sector setVariable [ARWA_KEY_marker, _x];
			_sector setVariable [ARWA_KEY_owned_by, civilian];
			_sector setVariable [ARWA_KEY_target_name, _second_string];

			[_sector] call ARWA_draw_sector;
			_sectors pushback _sector;

			private _capture_bonus = if(_first_capture_bonus) then {  ARWA_starting_strength / 10; } else { 0; };

			_ammo_box = [_sector, _capture_bonus] call ARWA_add_sector_box;

			[_sector] spawn ARWA_initialize_sector_control;
			[_sector] spawn ARWA_sector_rearm_player_vehicles;

			true;
		};
	} count allMapMarkers;

	ARWA_sectors = _sectors;
};

ARWA_is_sector_safe = {
	params ["_side", "_sector", "_distance"];

	private _pos = _sector getVariable ARWA_KEY_pos;

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

ARWA_get_owned_sectors = {
	params ["_side"];
	ARWA_sectors select { (_x getVariable ARWA_KEY_owned_by) isEqualTo _side; };
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
		_sector_pos = _x getVariable ARWA_KEY_pos;
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
		_sector_pos = _x getVariable ARWA_KEY_pos;
		_distance = _pos distance _sector_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_current_sector = _x;
		};

	} forEach _sectors;

	_current_sector;
};

ARWA_get_sector_manpower = {
	params ["_sector"];

	(_sector getVariable ARWA_KEY_box) getVariable ARWA_KEY_manpower;
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

ARWA_sector_rearm_player_vehicles = {
	params ["_sector"];
	private _sector_pos = _sector getVariable ARWA_KEY_pos;

    while {true} do {
		private _sector_owner = _sector getVariable ARWA_KEY_owned_by;
		{
			private _vehicle = vehicle _x;
			private _player_side = side _x;
			private _close_to_sector = (_sector_pos distance2D getPos _x) < (ARWA_sector_size / 4);

			if(_close_to_sector && {_sector_owner isEqualTo _player_side} && {_vehicle isKindOf "Car" || _vehicle isKindOf "Tank"}) then {
				_vehicle setVehicleAmmo 1;
				[["ARWA_STR_VEHICLE_REARMED"]] remoteExec ["ARWA_system_chat", group _x];
			};
		} forEach allPlayers;
		sleep 300;
      };
};