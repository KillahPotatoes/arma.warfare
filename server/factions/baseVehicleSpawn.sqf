
spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, respawn_ground] call get_prefixed_name;	
	private _pos = getMarkerPos _marker;	 
	private _box = ammo_box createVehicle (_pos);

	_box setVariable [owned_by, _side, true];
};

initialize_bases = {
	[WEST] call spawn_base_ammobox;	
	[EAST] call spawn_base_ammobox;	
	[independent] call spawn_base_ammobox;	
};