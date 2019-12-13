
ARWA_spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos = getMarkerPos _marker;
	private _ammo_box = ARWA_ammo_box createVehicle (_pos);
	_ammo_box enableRopeAttach false;
	//_ammo_box enableSimulationGlobal false;
	_ammo_box setVariable [ARWA_KEY_HQ, true, true];
	_ammo_box setVariable [ARWA_KEY_manpower, 0, true];
	_ammo_box setVariable [ARWA_KEY_target_name, "HQ", true];
	_ammo_box setVariable [ARWA_KEY_owned_by, _side, true];

	missionNamespace setVariable [format["ARWA_HQ_%1", _side], _ammo_box, true];
};

ARWA_initialize_bases = {
	{
		[_x] call ARWA_spawn_base_ammobox;
	} foreach ARWA_all_sides;
};