
ARWA_spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, respawn_ground] call ARWA_get_prefixed_name;
	private _pos = (getMarkerPos _marker) getPos [5, random 360];
	private _ammo_box = ammo_box createVehicle (_pos);
	_ammo_box enableRopeAttach false;

	_ammo_box setVariable ["HQ", true, true];

	_ammo_box setVariable [owned_by, _side, true];
};

ARWA_initialize_bases = {
	[WEST] call ARWA_spawn_base_ammobox;
	[EAST] call ARWA_spawn_base_ammobox;
	[independent] call ARWA_spawn_base_ammobox;
};