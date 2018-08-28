remove_vehicle = {
  	player addAction ["Halo Insertion", {
    	private _veh = cursorTarget;

		if(0 == count crew _veh) exitWith {
			deleteVehicle _veh;
			systemChat "Vehicle returned";
		};
		
		systemChat "Vehicle is not empty";
  	}, nil, 1.5, true, true, "",
  	'[player] call is_player_in_hq && [cursorTarget] call is_close_to_vehicle'
  	];
};

is_close_to_vehicle = {
	params ["_cursorTarget", "_player"];

	_cursorTarget getVariable ["penalty", false] && ((getPos _cursorTarget) distance (getPos _player) < 25);	
};

is_player_in_hq = {
	params ["_player"];

  	private _side = side _player;
  	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	(getPos player) distance _pos < 50; 
};
