
ARWA_spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos = (getMarkerPos _marker) getPos [5, random 360];
	private _ammo_box = ARWA_ammo_box createVehicle (_pos);
	_ammo_box enableRopeAttach false;

	_ammo_box setVariable [ARWA_KEY_HQ, true, true];
	_ammo_box setVariable [ARWA_KEY_owned_by, _side, true];
	_ammo_box setVariable [ARWA_KEY_pos, getPos _ammo_box];

	_ammo_box;
};

ARWA_initialize_bases = {
	private _hq_bases = [];
	{
		_hq_bases pushBack ([_x] call ARWA_spawn_base_ammobox);
	} foreach ARWA_all_sides;

	_hq_bases;
};