ARWA_get_respawn = {
	params ["_sector"];
	_sector getVariable [respawn_pos, [sideUnknown, 0]];
};

ARWA_add_respawn_position = {
	params ["_sector", "_new_owner"];

	[_sector] call ARWA_remove_respawn_position;
	_respawn = [_new_owner, _sector getVariable ARWA_KEY_pos] call BIS_fnc_addRespawnPosition;
	_sector setVariable [ARWA_KEY_respawn_pos, _respawn];
};

ARWA_remove_respawn_position = {
	params ["_sector"];

	(_sector call ARWA_get_respawn) params ["_last_owner", "_index"];
	[_last_owner, _index] call bis_fnc_removeRespawnPosition;
	_sector setVariable [ARWA_KEY_respawn_pos, nil];
};

ARWA_add_initial_respawn_positions = {
	params ["_side"];

	private _respawn_marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	[_side, _pos] call BIS_fnc_addRespawnPosition;
};

ARWA_initialize_base_respawns = {
	[west] call ARWA_add_initial_respawn_positions;
	[east] call ARWA_add_initial_respawn_positions;
	[independent] call ARWA_add_initial_respawn_positions;
};
