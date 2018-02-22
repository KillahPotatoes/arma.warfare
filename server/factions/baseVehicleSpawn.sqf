set_base_vehicle = {
	params ["_side", "_type", "_veh"];
	missionNamespace setVariable [format ["%1_%2", _side, _type], _veh];
};

get_base_vehicles = {
	params ["_side", "_type"];
	missionNamespace getVariable format ["%1_%2s", _side, _type];
};

spawn_base_vehicle = {
	params ["_side", "_obj", "_vehicles", "_type"];

	private _pos = getPos _obj;
	private _isEmpty = [_pos] call check_if_any_units_to_close;

	if (_isEmpty) exitWith {
		private _veh_type = selectRandom _vehicles;
		private _veh = _veh_type createVehicle _pos;

		[_side, _type, _veh] call set_base_vehicle;

		_veh setDir (getDir _obj);
		_veh;
	}; 
	
	systemChat format["Something is obstructing the %1 respawn area", _type];
};

spawn_base_ammobox = {
	params ["_side"];

	private _marker = [_side, respawn_ground] call get_prefixed_name;	
	private _pos = getMarkerPos _marker;	 
	private _box = ammo_box createVehicle (_pos);

	_box setVariable [owned_by, _side, true];
};

initialize_base = {
	params ["_side"];

	[_side] call spawn_base_ammobox;
	[_side, 3, "gunship"] spawn base_vehicle;
	[_side, 0, "transport_heli"] spawn base_vehicle;
	[_side, 2, "heavy_vehicle"] spawn base_vehicle;
	[_side, 1, "light_vehicle"] spawn base_vehicle;
};

base_vehicle = {
	params ["_side", "_req_tier", "_type"];

	private _veh_types = [_side, _type] call get_base_vehicles;
	private _base_marker_name = [_side, _type] call get_prefixed_name;
	private _base_marker = missionNamespace getVariable _base_marker_name;
	
	while {true} do {
		private _tier = [_side] call get_tier;

		if (_tier >= _req_tier) then {
			private _veh = [_side, _base_marker, _veh_types, _type] call spawn_base_vehicle;

			if(!isNil "_veh") exitWith {
				waitUntil {!canMove _veh};
				sleep 120;
				_veh setDamage 1;
			};
		};
		sleep 120;
	};
};

initialize_bases = {
	[WEST] call initialize_base;
	[EAST] call initialize_base;
	[independent] call initialize_base;
};