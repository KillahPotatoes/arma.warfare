toggle_control = {
	params ["_veh"];

	private _driver = driver _veh;
	private _group = group _driver; 
	private _driver_type = typeOf _driver;

	while {canMove _veh && alive _veh} do {
		waituntil {player in _veh};
		[_group, _veh] call put_player_in_position;
		waitUntil {!(player in _veh)};
		[_driver_type, _group, _veh] call replace_player_with_driver;		
	};
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