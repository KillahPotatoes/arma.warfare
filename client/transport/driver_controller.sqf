toggle_control = {
	params ["_veh"];

	private _driver = driver _veh;
	private _group = group _driver; 
	private _driver_type = typeOf _driver;

	while {[_veh] call check_if_transport_alive} do {

		waituntil {player in _veh};		
		if([_veh] call check_if_transport_dead) exitWith {};

		_veh setVariable ["player_driver", true];
		[_group, _veh] call put_player_in_position;

		waitUntil {!(player in _veh)};
		if([_veh] call check_if_transport_dead) exitWith {};

		[_driver_type, _group, _veh] call replace_player_with_driver;
		_veh setVariable ["player_driver", false];
	};
};

check_if_transport_alive = {
	params ["_veh"];

	!(isNull _veh) &&  {(alive _veh && canMove _veh)} && {(alive driver _veh) || (_veh getVariable ["player_driver", false])};
};


replace_player_with_driver = {
	params ["_driver_type", "_group", "_veh"];

	private _driver = _group createUnit [_driver_type, [0,0,0], [], 0, "NONE"];
	_driver moveInDriver _veh;
	_group deleteGroupWhenEmpty true;
	_veh lockDriver true;
	_veh engineOn true;

	[_veh, _group] spawn on_transport_idle_wait;
};

put_player_in_position = {
	params ["_group", "_veh"];

	_group deleteGroupWhenEmpty false;
	deleteVehicle (driver _veh);
	_veh lockDriver false;
	moveOut player;
	player moveInDriver _veh;
};