ARWA_add_sector_box = {
	params ["_sector"];

	private _pos = _sector getVariable ARWA_KEY_pos;
	private _ammo_box = ammo_box createVehicle (_pos);

	_ammo_box enableRopeAttach false;
	_sector setVariable [box, _ammo_box];
	_ammo_box setVariable [ARWA_KEY_owned_by, civilian, true];
	_ammo_box setVariable [ARWA_KEY_manpower, 0, true];
	_ammo_box setVariable [ARWA_KEY_sector, true, true]; // Add key
};

ARWA_initialize_sectors = {
	private _sectors = [];
	{
		_type = getMarkerType _x;

		if (_type isEqualTo "hd_objective") then { // add key
			_split_string = [_x, 7] call ARWA_split_string;
			_first_string = _split_string select 0;
			_second_string = _split_string select 1;

			_sector = createGroup sideLogic;
			_sector setVariable [ARWA_KEY_pos, getMarkerPos _x];
			_sector setVariable [ARWA_KEY_marker, _x];
			_sector setVariable [ARWA_KEY_owned_by, civilian];
			_sector setVariable [ARWA_KEY_sector_name, _second_string];

			[_sector] call ARWA_draw_sector;
			_sectors pushback _sector;

			_ammo_box = [_sector] call ARWA_add_sector_box;

			[_sector] spawn ARWA_initialize_sector_control;

			true;
		};
	} count allMapMarkers;

	missionNamespace setVariable ["ARWA_sectors", _sectors];
	missionNamespace setVariable ["ARWA_west_sectors", []];
	missionNamespace setVariable ["ARWA_east_sectors", []];
	missionNamespace setVariable ["ARWA_guer_sectors", []];
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

	private _safe_sectors = [_side, ARWA_sector_size] call ARWA_get_safe_sectors;

	(_side call ARWA_get_owned_sectors) - _safe_sectors;
};

ARWA_add_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["ARWA_%1_sectors", _side];
	_sectors pushBack _sector;
};

ARWA_remove_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["ARWA_%1_sectors", _side];
	private _index = _sectors find (_sector);
	_sectors deleteAt (_index);
};

ARWA_get_unowned_sectors = {
	private _sectors = ARWA_sectors;

	{
		_sectors = _sectors - (missionNamespace getVariable format["ARWA_%1_sectors", _x]);
	} foreach ARWA_all_sides;

	_sectors;
};

ARWA_get_owned_sectors = {
	params ["_side"];
	missionNamespace getVariable format["ARWA_%1_sectors", _side];
};

ARWA_get_other_sectors = {
	params ["_side"];
	ARWA_sectors - (_side call ARWA_get_owned_sectors);
};

ARWA_find_closest_sector = {
	params ["_sectors", "_pos"];

	_current_sector = _sectors select 0;
	_shortest_distance = 99999;

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

ARWA_find_closest_friendly_sector = { // TODO dead code?
	params ["_side", "_pos"];

	private _sectors = [_side] call ARWA_get_owned_sectors;
	[_sectors, _pos] call ARWA_find_closest_sector;
};

ARWA_find_enemy_sectors = {
	params ["_side"];

	private _enemy = ARWA_all_sides - [_side];
	([_enemy select 0] call ARWA_get_owned_sectors) + ([_enemy select 1] call ARWA_get_owned_sectors);
};

ARWA_count_enemy_sectors = { // TODO dead code?
	params ["_side"];

	count ([_side] call ARWA_find_enemy_sectors);
};