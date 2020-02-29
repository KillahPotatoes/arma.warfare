ARWA_remove_vehicle_action = {
	params["_veh"];

  	_veh addAction [[localize "ARWA_STR_RETURN_VEHICLE", 0] call ARWA_add_action_text, {
    	params ["_target", "_caller"];

		[_target, playerSide] spawn ARWA_delete_vehicle;

  	}, nil, ARWA_return_vehicle, false, true, "",
  	'[_this] call ARWA_is_player_in_hq && [_this] call ARWA_not_in_vehicle', 10
  	];
};

ARWA_is_player_in_hq = {
	params ["_player"];

	private _pos = [playerSide] call ARWA_get_hq_pos;

	(getPos _player) distance _pos < 50;
};
