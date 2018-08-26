
spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, respawn_ground] call get_prefixed_name;	
	private _pos = getMarkerPos _marker;	 
	private _ammo_box = ammo_box createVehicle (_pos);

	_ammo_box setVariable [owned_by, _side, true];
	_ammo_box setVariable [cash, 0, true];
};

initialize_bases = {
	[WEST] call spawn_base_ammobox;	
	[EAST] call spawn_base_ammobox;	
	[independent] call spawn_base_ammobox;	
};