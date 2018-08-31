random_enemies = [];
max_random_enemies = 10;
houses_already_checked = [];

populate_random_houses = {
	while {true} do {
		random_enemies = [random_enemies] call remove_null;
		if(max_random_enemies > (count random_enemies)) then {
			{		
				[_x] spawn check_houses_to_populate;
			} forEach allPlayers;
		};		
		
		sleep 10;
	};
};

check_houses_to_populate = {
	params ["_player"];
	
	private _houses = _player nearObjects ["house", 600];
	_houses = _houses - houses_already_checked;
	_houses = (_houses) call BIS_fnc_arrayShuffle;

	{
		if ((floor random 2) == 0) then {
			private _house = _x;
			private _sector = [sectors, getPos _house] call find_closest_sector;
			private _side = _sector getVariable owned_by;

			if([_house, _player, _sector, _side] call house_can_be_populated) then {							
				[_side, _house] spawn populate_house;			
			};

			if(max_random_enemies <= (count random_enemies)) exitWith {};
		};
	} forEach _houses;

	houses_already_checked = _houses;
};

populate_house = {
	params ["_side", "_building"];

	private _allpositions = _building buildingPos -1;
	private _random_number_of_soldiers = random ((count _allpositions) min (max_random_enemies - (count random_enemies)));
	_building setVariable ["occupied", true];

	private _group = [[0,0,0], _side, _random_number_of_soldiers, true] call spawn_infantry;
	_group setBehaviour "SAFE";

	private _positions = [];
	for "_x" from 0 to (_random_number_of_soldiers - 1) do
	{
		_positions pushBack _x;
	};
	_positions = _positions call BIS_fnc_arrayShuffle;

	{
		_x setPosATL (_allpositions select (_positions select _forEachIndex));
		_x unassignItem "NVGoggles"; 
		_x removeItem "NVGoggles";
		_x addPrimaryWeaponItem "acc_flashlight";
		_x enableGunLights "forceon";
		random_enemies pushBack _x;
	} forEach units _group;

	[_group, _building] spawn remove_when_no_player_closeby;
};

house_can_be_populated = {
	params ["_building", "_player", "_sector", "_side"];

	private _sector_pos = _sector getVariable pos;
	private _pos = getPos _building;	
	private _player_pos = getPos _player;

	(_side in factions) && !((side _player) isEqualTo _side)
	&& {(_player_pos distance2D _sector_pos) > (_pos distance2D _sector_pos)}
	&& {(_sector_pos distance2D _pos) > 200}
	&& {!(_building getVariable ["occupied", false])}	
	&& {!([_pos, _side] call any_enemies_nearby)}
};

remove_when_no_player_closeby = {
	params ["_group", "_house"];

	private _pos = getPos (leader _group);

	waitUntil {!([_pos, 600] call players_nearby)};

	{
		deleteVehicle _x;
	} forEach units _group;

	deleteGroup _group;
	_house setVariable ["occupied", nil];
};

players_nearby = {
	params ["_pos", "_dist"];

	({ (_pos distance2D _x) < _dist; } count allPlayers) > 0;
};

