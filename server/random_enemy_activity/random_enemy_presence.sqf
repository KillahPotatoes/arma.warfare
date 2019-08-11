ARWA_random_enemies = [];
ARWA_max_random_enemies = 10;
ARWA_houses_already_checked = [];

ARWA_populate_random_houses = {
	while {true} do {
		ARWA_random_enemies = [ARWA_random_enemies] call ARWA_remove_null;
		private _all_owned_sectors = [] call ARWA_get_all_owned_sectors;
		if(ARWA_max_random_enemies > (count ARWA_random_enemies) && !(_all_owned_sectors isEqualTo [])) then {
			{
				[_x] spawn ARWA_check_houses_to_populate;
			} forEach allPlayers;
		};

		sleep 10;
	};
};

ARWA_check_houses_to_populate = {
	params ["_player"];

	private _houses = _player nearObjects ["house", 600];
	_houses = _houses - ARWA_houses_already_checked;
	_houses = (_houses) call BIS_fnc_arrayShuffle;

	{
		if ((floor random 2) == 0) then {
			private _house = _x;
			private _all_owned_sectors = [] call ARWA_get_all_owned_sectors;
			private _sector = [_all_owned_sectors, getPos _house] call ARWA_find_closest_sector;
			private _side = _sector getVariable ARWA_KEY_owned_by;
			private _player_pos = getPos _player;

			if([_house, _player_pos, _sector, _side] call ARWA_house_can_be_populated) then {
				[_side, _house] call ARWA_populate_house;
			};

			if(ARWA_max_random_enemies <= (count ARWA_random_enemies)) exitWith {};
		};
	} forEach _houses;

	ARWA_houses_already_checked = _houses;
};

ARWA_populate_house = {
	params ["_side", "_building"];

	private _allpositions = _building buildingPos -1;
	private _random_number_of_soldiers = random ((count _allpositions) min (ARWA_max_random_enemies - (count ARWA_random_enemies)));
	_building setVariable [ARWA_KEY_occupied, true];

	if(_random_number_of_soldiers < 1) exitWith {};

	private _group = if((random 100) < 50) then {
		diag_log format["ARWA_spawn_sympathizers: %1", _side];
	 	[[0,0,0], _side, _random_number_of_soldiers] call ARWA_spawn_sympathizers;
	} else {
		diag_log "ARWA_spawn_civilians";
		[[0,0,0], _random_number_of_soldiers] call ARWA_spawn_civilians;
	};

	_group setBehaviour "SAFE";

	private _positions = [];
	for "_x" from 0 to (_random_number_of_soldiers - 1) do
	{
		_positions pushBack _x;
	};
	_positions = _positions call BIS_fnc_arrayShuffle;

	{
		_x setPosATL (_allpositions select (_positions select _forEachIndex));
		ARWA_random_enemies pushBack _x;
	} forEach units _group;

	[_group] spawn ARWA_remove_nvg_and_add_flash_light;

	[_group, _building] spawn ARWA_remove_when_no_player_closeby;
};

ARWA_house_can_be_populated = {
	params ["_building", "_player_pos", "_sector", "_side"];

	private _sector_pos = _sector getVariable ARWA_KEY_pos;
	private _pos = getPos _building;
	private _all_owned_sectors = [] call ARWA_get_all_owned_sectors;

	if(_all_owned_sectors isEqualTo []) exitWith { false; };

    private _closest_sector = [_all_owned_sectors, _pos] call ARWA_find_closest_sector;
    private _owner = _closest_sector getVariable ARWA_KEY_owned_by;

	(!isNil "_owner") && {!(playerSide isEqualTo _owner)} // area is under control, and not by player
	&& {(_player_pos distance2D _sector_pos) > (_pos distance2D _sector_pos)} // The house is between the player and the sector
	&& {(_sector_pos distance2D _pos) > ARWA_sector_size} // The house is outside the sector
	&& {!(_building getVariable [ARWA_KEY_occupied, false])}
	&& {!([_pos, _side, 400] call ARWA_any_enemies_in_area)}
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
