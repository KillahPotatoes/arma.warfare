ARWA_random_enemies = [];
ARWA_houses_already_checked = [];

ARWA_populate_random_houses = {
	while {true} do {
		ARWA_random_enemies = [ARWA_random_enemies] call ARWA_remove_null;

		if(ARWA_max_random_enemies > (count ARWA_random_enemies)) then {
			{
				[_x] call ARWA_check_houses_to_populate;
			} forEach allPlayers;

			ARWA_houses_already_checked = [];
		};

		sleep 10;
	};
};

ARWA_check_houses_to_populate = {
	params ["_player"];

	private _houses = (_player nearObjects ["house", ARWA_max_distance_presence]) - (_player nearObjects ["house", ARWA_min_distance_presence]);
	private _player_pos = getPos _player;

	_houses = _houses - ARWA_houses_already_checked;
	_houses = (_houses) call BIS_fnc_arrayShuffle;

	{
		private _house = _x;
		private _sector = [ARWA_sectors, getPos _house] call ARWA_find_closest_sector;
		private _owner = _sector getVariable ARWA_KEY_owned_by;
		private _hq_pos = getMarkerPos ([side _player, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		private _pos = getPos _house;
		private _distance_to_hq = _hq_pos distance2D _pos;

		if(!(side _player isEqualTo _owner) && _distance_to_hq > ARWA_min_distance_presence) then {

			private _sympathizer_side = if(_owner isEqualTo civilian) then {
				private _enemies = ARWA_all_sides - [side _player];
				[_enemies, _pos] call ARWA_closest_hq;
			} else {
				_owner;
			};

			if([_house, _player_pos, _player, _sector, _sympathizer_side] call ARWA_house_can_be_populated) then {
				[_sympathizer_side, _house] call ARWA_populate_house;
			};
		};

		if(ARWA_max_random_enemies <= (count ARWA_random_enemies)) exitWith {};

	} forEach _houses;

	ARWA_houses_already_checked append _houses;
};

ARWA_closest_hq = {
	params ["_sides", "_pos"];

	private _closest_hq = _sides select 0;
	private _shortest_distance = 99999;

	{
		private _side = _x;
		private _hq_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		private _distance = _pos distance2D _hq_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_closest_hq = _side;
		};

	} forEach _sides;

	_closest_hq;
};

ARWA_house_can_be_populated = {
	params ["_building", "_player_pos", "_player", "_sector", "_sympathizer_side"];

	private _pos = getPos _building;
	private _sector_pos = _sector getVariable ARWA_KEY_pos;

	(_sector_pos distance2D _pos) > (ARWA_sector_size/2) // The house is outside the sector center
	&& {!(_building getVariable [ARWA_KEY_occupied, false])}
	&& {!([_pos, _sympathizer_side, ARWA_min_distance_presence] call ARWA_any_enemies_in_area)}
};

ARWA_populate_house = {
	params ["_side", "_building"];

	private _allpositions = _building buildingPos -1;
	private _possible_spawns = (count _allpositions) min (ARWA_max_random_enemies - (count ARWA_random_enemies));
	private _random_number_of_soldiers = ceil random [0, _possible_spawns/2, _possible_spawns];

	_building setVariable [ARWA_KEY_occupied, true];

	if(_random_number_of_soldiers == 0) exitWith {};

	private _group = if(selectRandom[true, false]) then {
		diag_log format["Spawn %1 %2 sympathizers", _random_number_of_soldiers, _side];
	 	[[0,0,0], _side, _random_number_of_soldiers] call ARWA_spawn_sympathizers;
	} else {
		diag_log format["Spawn %1 civilians", _random_number_of_soldiers];
		[[0,0,0], _random_number_of_soldiers] call ARWA_spawn_civilians;
	};

	_group setBehaviour "SAFE";

	_allpositions = _allpositions call BIS_fnc_arrayShuffle;

	{
		_x setPosATL (_allpositions select _forEachIndex);
		ARWA_random_enemies pushBack _x;
	} forEach units _group;

	[_group] spawn ARWA_remove_nvg_and_add_flash_light;
	[_group, _building] spawn ARWA_remove_when_no_player_closeby;
};

ARWA_remove_when_no_player_closeby = {
	params ["_group", "_house"];

	private _pos = getPos (leader _group);

	waitUntil {!([_pos, 600] call ARWA_players_nearby)};

	{
		deleteVehicle _x;
	} forEach units _group;

	deleteGroup _group;
	_house setVariable [ARWA_KEY_occupied, nil];
};

ARWA_players_nearby = {
	params ["_pos", "_dist"];

	({ (_pos distance2D _x) < _dist; } count allPlayers) > 0;
};
