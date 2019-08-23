ARWA_remove_vehicle_action = {
	params["_veh"];

  	_veh addAction [[localize "ARWA_STR_RETURN_VEHICLE", 0] call ARWA_add_action_text, {
    	params ["_target", "_caller"];

		if(0 == count crew _target) exitWith {
			deleteVehicle _target;
			systemChat localize "ARWA_STR_VEHICLE_RETURNED";
		};

		systemChat localize "ARWA_STR_VEHICLE_NOT_EMPTY";
  	}, nil, ARWA_return_vehicle, false, true, "",
  	'[_this] call ARWA_is_player_in_hq && [_target, _this] call ARWA_is_same_side && [_this] call ARWA_not_in_vehicle', 10
  	];
};

ARWA_is_same_side = {
	params ["_vehicle","_player"];
	(side _vehicle) isEqualTo civilian || (side _vehicle) isEqualTo (side _player);
};

ARWA_is_player_in_hq = {
	params ["_player"];

  	private _side = side _player;
  	private _respawn_marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	(getPos _player) distance _pos < 50;
};
