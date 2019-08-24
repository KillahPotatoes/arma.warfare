ARWA_sectors = [];

ARWA_add_sector_box = {
	params ["_sector"];

	private _pos = _sector getVariable ARWA_KEY_pos;
	private _ammo_box = ARWA_ammo_box createVehicle (_pos);

	_ammo_box enableRopeAttach false;
	_sector setVariable [ARWA_KEY_box, _ammo_box];
	_ammo_box setVariable [ARWA_KEY_owned_by, civilian, true];
	_ammo_box setVariable [ARWA_KEY_manpower, 0, true];
	_ammo_box setVariable [ARWA_KEY_sector, true, true];
};

ARWA_initialize_sectors = {
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

			_ammo_box = [_sector] call ARWA_add_sector_box;

			[_sector] spawn ARWA_initialize_sector_control;

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