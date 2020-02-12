ARWA_get_respawn = {
	params ["_sector"];
	_sector getVariable [ARWA_KEY_respawn_pos, [sideUnknown, 0]];
};

ARWA_add_respawn_position = {
	params ["_sector", "_new_owner"];

	[_sector] call ARWA_remove_respawn_position;
	_respawn = [_new_owner, getPos _sector] call BIS_fnc_addRespawnPosition;
	_sector setVariable [ARWA_KEY_respawn_pos, _respawn];
};

ARWA_remove_respawn_position = {
	params ["_sector"];

	(_sector call ARWA_get_respawn) params ["_last_owner", "_index"];
	[_last_owner, _index] call bis_fnc_removeRespawnPosition;
	_sector setVariable [ARWA_KEY_respawn_pos, nil];
};
