add_sector_box = {
	params ["_sector"];

	private _pos = _sector getVariable pos;
	private _ammo_box = ammo_box createVehicle (_pos);

	_ammo_box enableRopeAttach false;
	_sector setVariable [box, _ammo_box];
	_ammo_box setVariable [owned_by, civilian, true];
	_ammo_box setVariable [manpower, 0, true];
	_ammo_box setVariable ["sector", true, true];
};

initialize_sectors = {
	private _sectors = [];
	{
		_type = getMarkerType _x;

		if (_type isEqualTo "hd_objective") then {
			_split_string = [_x, 7] call ARWA_split_string;
			_first_string = _split_string select 0;
			_second_string = _split_string select 1;

			_sector = createGroup sideLogic;
			_sector setVariable [pos, getMarkerPos _x];
			_sector setVariable [marker, _x];
			_sector setVariable [owned_by, civilian];
			_sector setVariable [sector_name, _second_string];

			[_sector] call draw_sector;
			_sectors pushback _sector;

			_ammo_box = [_sector] call add_sector_box;

			[_sector] spawn initialize_sector_control;

			true;
		};
	} count allMapMarkers;

	missionNamespace setVariable ["sectors", _sectors];
	missionNamespace setVariable ["west_sectors", []];
	missionNamespace setVariable ["east_sectors", []];
	missionNamespace setVariable ["guer_sectors", []];
};

is_sector_safe = {
	params ["_side", "_sector", "_distance"];

	private _pos = _sector getVariable pos;

	!([_pos, _side, _distance] call ARWA_any_enemies_in_area);
};

get_safe_sectors = {
	params ["_side", "_distance"];

	(_side call get_owned_sectors) select { [_side, _x, _distance] call is_sector_safe; };
};

get_unsafe_sectors = {
	params ["_side"];

	private _safe_sectors = [_side, ARWA_sector_size] call get_safe_sectors;

	(_side call get_owned_sectors) - _safe_sectors;
};

add_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["%1_sectors", _side];
	_sectors pushBack _sector;
};

remove_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["%1_sectors", _side];
	private _index = _sectors find (_sector);
	_sectors deleteAt (_index);
};

get_unowned_sectors = {
	private _sectors = sectors;

	{
		_sectors = _sectors - (missionNamespace getVariable format["%1_sectors", _x]);
	} foreach ARWA_all_sides;

	_sectors;
};

get_owned_sectors = {
	params ["_side"];
	missionNamespace getVariable format["%1_sectors", _side];
};

get_other_sectors = {
	params ["_side"];
	sectors - (_side call get_owned_sectors);
};

find_closest_sector = {
	params ["_sectors", "_pos"];

	_current_sector = _sectors select 0;
	_shortest_distance = 99999;

	{
		_sector_pos = _x getVariable pos;
		_distance = _pos distance _sector_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_current_sector = _x;
		};

	} forEach _sectors;

	_current_sector;
};

get_sector_manpower = {
	params ["_sector"];

	(_sector getVariable box) getVariable manpower;
};

find_closest_friendly_sector = {
	params ["_side", "_pos"];

	private _sectors = [_side] call get_owned_sectors;
	[_sectors, _pos] call find_closest_sector;
};

find_enemy_sectors = {
	params ["_side"];

	private _enemy = ARWA_all_sides - [_side];
	([_enemy select 0] call get_owned_sectors) + ([_enemy select 1] call get_owned_sectors);
};

count_enemy_sectors = {
	params ["_side"];

	count ([_side] call find_enemy_sectors);
};