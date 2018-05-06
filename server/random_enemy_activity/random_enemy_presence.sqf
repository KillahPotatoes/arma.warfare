random_enemies = [];
max_random_enemies = 30;

populate_random_houses = {
	while {true} do {
		{
			random_enemies = [random_enemies] call remove_null;
			private _player = _x;
			private _houses = nearestObjects [_player, ["house"], 600];

			{
				private _house = _x;
				private _sector = [sectors, getPos _player] call find_closest_sector;
				
				if([_house, _player, _sector] call house_can_be_populated) then {
					if((random 100) < 100) then {
						private _side = _sector getVariable owned_by;
						[_side, _house] spawn populate_house;
					};
				};
			} forEach _houses;

		} forEach allPlayers;
		systemChat format["%1 random enemies", count random_enemies];
		sleep 60;
	};

};

populate_house = {
	params ["_side", "_building"];

	systemChat "Populating house";
	private _allpositions = _building buildingPos -1;
	private _random_number_of_soldiers = random (count _allpositions);
	_building setVariable ["occupied", true];

	private _group = [[0,0,0], _side, _random_number_of_soldiers, true] call spawn_infantry;
	_group setBehaviour "SAFE";

	{
		_x setPosATL (_allpositions select _forEachIndex);
		_x unassignItem "NVGoggles"; 
		_x removeItem "NVGoggles";
		_x addPrimaryWeaponItem "acc_flashlight";
		_x enableGunLights "forceon";
		random_enemies pushBack _x;
	} forEach units _group;

	[_group, _building] spawn remove_when_no_player_closeby;
};

house_can_be_populated = {
	params ["_building", "_player", "_sector"];

	private _sector_pos = _sector getVariable pos;
	private _side = _sector getVariable owned_by;
	private _pos = getPos _building;
	private _player_pos = getPos _player;
	private _not_nearby_players = !([_pos, 400] call players_nearby);
	// only pick houses that are closer to enemy sector than player
	private _closer_to_sector_than_player = (_player_pos distance2D _sector_pos) > (_pos distance2D _sector_pos);
	private _not_within_sector = (_sector_pos distance2D _player_pos) > 200;
	private _not_populated = !(_building getVariable ["occupied", false]);
	private _is_enemy_sector = (_side in factions) && !((side _player) isEqualTo _side);
	private _not_over_cap = max_random_enemies > (count random_enemies);

	_not_nearby_players && _closer_to_sector_than_player && _not_populated && _not_within_sector && _is_enemy_sector && _not_over_cap;
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
	systemChat "Removing group from house";
};

players_nearby = {
	params ["_pos", "_dist"];

	({ (_pos distance2D _x) < _dist; } count allPlayers) > 0;
};

