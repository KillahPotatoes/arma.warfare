populate_random_houses = {
	while (true) do {
		{
			private _player = _x;
			private _houses = nearestObjects [_player, ["house"], 600];

			{
				private _house = _x;
				private _sector = [sectors, getPos _player] call find_closest_sector;
				if([_house, _player, _sector] call house_can_be_populated) then {
					if((random 100) < 10) then {
						[side _player, _house] spawn populate_house;
					};
				};
			} forEach _houses;

		} forEach allPlayers;
		sleep 60;
	};

};

populate_house = {
	params ["_side", "_building"];

	private _allpositions = _building buildingPos -1;
	private _random_number_of_soldiers = random (count _allpositions);
	_house setVariable ["occupied", true];

	private _group = [[0,0,0], _side, _random_number_of_soldiers, true] call spawn_infantry;

	{
		_x setPosATL (_allpositions select _forEachIndex);
	} forEach units _group;

	[_group, _house] spawn remove_when_no_player_closeby;
};

house_can_be_populated = {
	params ["_building", "_player", "_sector"];

	private _sector_pos = _sector getVariable pos;
	private _side = _sector getVariable owned_by;
	private _pos = getPos _building;
	private _player_pos = getPos _player;
	private _not_nearby_players = ({ (_pos distance2D _x) > 400; } count allPlayers) == 0;
	// only pick houses that are closer to enemy sector than player
	private _closer_to_sector_than_player = (_player_pos distance2D _sector_pos) > (_pos distance2D _sector_pos);
	private _not_within_sector = (_sector_pos distance2D _player_pos) > 200;
	private _not_populated = !(_building getVariable ["occupied", false]);
	private _is_enemy_sector = (_side in factions) && !((side _player) isEqualTo _side)

	_not_nearby_players && _closer_to_sector_than_player && _not_populated && _not_within_sector && _is_enemy_sector;
};

remove_when_no_player_closeby = {
	_params ["_group", "_house"];

	private _pos = getPos (leader _group);

	waitUntil {!([_pos] call players_nearby)};

	{
		deleteVehicle _x;
	} forEach units _group;

	deleteGroup _group;
	_house setVariable ["occupied", nil];
};

players_nearby = {
	params ["_pos"];

	({ (_pos distance2D _x) < 400; } count allPlayers) > 0;
};

