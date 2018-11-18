
spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, respawn_ground] call get_prefixed_name;	
	private _pos = (getMarkerPos _marker) getPos [5, random 360];
	private _ammo_box = ammo_box createVehicle (_pos);

	_ammo_box setVariable ["HQ", true, true];

	_ammo_box setVariable [owned_by, _side, true];	
};

initialize_bases = {
	[WEST] call spawn_base_ammobox;	
	[EAST] call spawn_base_ammobox;	
	[independent] call spawn_base_ammobox;	
};