AddRespawnPosition = {
	_sector = _this select 0;
			
	(_sector getVariable ["currentRespawnPosition", [sideUnknown, 0]]) params ["_last_owner", "_index"];
	[_last_owner, _index] call bis_fnc_removeRespawnPosition;
	_sector setVariable ["currentRespawnPosition", nil];

	_respawnReturn = [_side, getPos _sector] call BIS_fnc_addRespawnPosition;
	_sector setVariable ["currentRespawnPosition", _respawnReturn];
};