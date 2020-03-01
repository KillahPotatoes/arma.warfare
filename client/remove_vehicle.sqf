ARWA_remove_vehicle_action = {
	params["_veh"];

  	player addAction [[localize "ARWA_STR_RETURN_VEHICLE", 0] call ARWA_add_action_text, {
    	params ["_target", "_caller"];

		[vehicle cursorTarget, playerSide] spawn ARWA_delete_vehicle;

  	}, nil, ARWA_return_vehicle, false, true, "",
  	'[_this] call ARWA_is_player_in_hq && [_this] call ARWA_not_in_vehicle && [cursorTarget] call ARWA_target_is_vehicle', 10
  	];
};

ARWA_target_is_vehicle = {
	params ["_target"];

	(_target isKindOf "Car" || _target isKindOf "Air" || _target isKindOf "Tank");
};

ARWA_is_player_in_hq = {
	params ["_player"];

	private _pos = [playerSide] call ARWA_get_hq_pos;

	(getPos _player) distance _pos < ARWA_HQ_area;
};
