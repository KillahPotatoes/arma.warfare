remove_vehicle_action = {
	params["_veh"];

  	_veh addAction [["Return vehicle", 0] call addActionText, {
    	params ["_target", "_caller"];

		if(0 == count crew _target) exitWith {
			deleteVehicle _target;
			systemChat localize "VEHICLE_RETURNED";
		};
		
		systemChat localize "VEHICLE_NOT_EMPTY";
  	}, nil, ARWA_return_vehicle, false, true, "",
  	'[_this] call is_player_in_hq && [_target, _this] call is_same_side && [_this] call not_in_vehicle', 10
  	];
};

is_same_side = {
	params ["_vehicle","_player"];
	(side _vehicle) isEqualTo civilian || (side _vehicle) isEqualTo (side _player);
};

is_player_in_hq = {
	params ["_player"];

  	private _side = side _player;
  	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	(getPos _player) distance _pos < 50; 
};
