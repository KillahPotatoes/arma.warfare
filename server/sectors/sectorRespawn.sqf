get_respawn = {
	params ["_sector"];
	_sector getVariable [respawn_pos, [sideUnknown, 0]];
};

add_respawn_position = {
	params ["_sector"];
			
	[_sector] call remove_respawn_position;
	_respawn = [_side, _sector getVariable pos] call BIS_fnc_addRespawnPosition;
	_sector setVariable [respawn_pos, _respawn];
};

remove_respawn_position = {
	params ["_sector"];

	(_sector call get_respawn) params ["_last_owner", "_index"];
	[_last_owner, _index] call bis_fnc_removeRespawnPosition;
	_sector setVariable [respawn_pos, nil];
};

add_initial_respawn_positions = {
	params ["_side"];

	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;
	
	[_side, _pos] call BIS_fnc_addRespawnPosition;	
};

initialize_base_respawns = {
	[west] call add_initial_respawn_positions;
	[east] call add_initial_respawn_positions;
	[independent] call add_initial_respawn_positions;
};

