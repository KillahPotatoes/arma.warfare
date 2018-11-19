taxi_wait_period_on_despawn = 300;
taxi_wait_period_on_crash = 900;
taxi_will_wait_time = 300;

taxi_active = false;	
taxi_timer = time;
taxi_arrived_at_HQ = false;

in_taxi = {	
	(vehicle player) getVariable ["taxi", false];
};

send_to_HQ = {
	params ["_group", "_veh"];
	
	private _side = side _group;
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);

	_group addWaypoint [_pos, 100];
	
	waitUntil { !(alive _veh) || ((_pos distance2D (getPos _veh)) < 100) };
	
	if (alive _veh) exitWith
	{
		[_veh] call remove_soldiers; 
		deleteVehicle _veh;
		true;
	};

	false;
};

update_taxi_orders = {
	params ["_group", "_taxi", "_pos"];

	openMap true;
	[_group, _taxi, _pos] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _group = _this select 0;
		private _taxi = _this select 1;
		private _pos = _this select 2;
		
		[_group, _taxi, _pos] call move_taxi_to_pick_up;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

transport_available = {
	params ["_type"];

	private _wait_period = (missionNameSpace getVariable format["%1_taxi_wait_period", _type]);
	private _time = taxi_timer + _wait_period;

	if(_time > time) exitWith {
		private _time_left = _time - time;
		private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
		systemChat format["Transport is not available yet! Try again in %1 minutes", _wait_minutes];
		false;
	};
	true;
};

toggle_control = {
	params ["_taxi"];

	private _driver = driver _taxi;
	private _group = group _driver; 
	private _driver_type = typeOf _driver;

	while {canMove _taxi && alive _taxi} do {
		waituntil {player in _taxi};
		[_group, _taxi] call put_player_in_position;
		waitUntil {!(player in _taxi)};
		[_driver_type, _group, _taxi] call replace_player_with_driver;		
	};
};

request_taxi = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		taxi_active = true;
		taxi_arrived_at_HQ = false; // TODO make type dependent
		[_pos, _class_name, _penalty] spawn order_taxi;	
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

order_taxi = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [side player, _class_name, _penalty] call spawn_taxi;
	private _taxi = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _taxi) call get_vehicle_display_name;	
	
	[_taxi] spawn show_active_taxi_menu;
	[_taxi] spawn check_status;

	[_group, _taxi, _pos] call move_taxi_to_pick_up;
};

move_taxi_to_pick_up = {
	params ["_group", "_taxi", "_pos"];

	[_group, "Transport is on its way to given pick up destination!"] spawn group_report_client;

	if(_taxi isKindOf "Air") then {
		[_group, _taxi, "GET IN", _pos] call land_helicopter; 
	} else {		
		[_group, _taxi, _pos] call send_vehicle_taxi;			
	};	

	if (canMove _taxi) exitWith {
		[_group, "Transport has arrived. Waiting for squad to pick up!"] spawn group_report_client;
		[taxi_will_wait_time, _taxi, _group] spawn on_taxi_idle_wait;
		[_taxi] spawn toggle_control;
	};
};

spawn_taxi = {
	params ["_side", "_class_name", "_penalty"];

	private _veh = if(_class_name isKindOf "Air") then {
	    [_side, _class_name] call spawn_helicopter;
	} else {
		[_side, _class_name] call spawn_vehicle;
	};

	private _group = _veh select 2;
	private _taxi = _veh select 0;

	_taxi setVariable ["penalty", [playerSide, _penalty], true];
		
	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_veh;
};

replace_player_with_driver = {
	params ["_driver_type", "_group", "_taxi"];

	private _driver = _group createUnit [_driver_type, [0,0,0], [], 0, "NONE"];
	_driver moveInDriver _taxi;
	_group deleteGroupWhenEmpty true;
	_taxi lockDriver true;
	_taxi engineOn true;

	[taxi_will_wait_time, _taxi, _group] spawn on_taxi_idle_wait;
};

put_player_in_position = {
	params ["_group", "_taxi"];

	_group deleteGroupWhenEmpty false;
	deleteVehicle (driver _taxi);
	_taxi lockDriver false;
	moveOut player;
	player moveInDriver _taxi;
};

check_status = {
	params ["_taxi"];

	waitUntil {!(alive _taxi && canMove _taxi)};
	sleep 3; // to make sure heli_active is updated
	if (!taxi_arrived_at_HQ) then {
		if(!(player in _taxi)) then {			
			[playerSide, "Transport vehicle is down! You are on your own!"] spawn HQ_report_client; // TODO make classname specific
		};

		missionNamespace setVariable [format["%1_taxi_wait_period", _type],taxi_wait_period_on_crash];
	} else {
		missionNamespace setVariable [format["%1_taxi_wait_period", _type],taxi_wait_period_on_despawn];
	};

	taxi_active = false;
	player removeAction cancel_taxi_id;
	taxi_timer = time;
};

on_taxi_idle_wait = {
	params ["_wait_period", "_taxi", "_group"];

	private _timer = time + _wait_period;
	waituntil {(player in _taxi) || time > _timer || !(alive _taxi)};

	if (!(player in _taxi) && (alive _taxi)) exitWith {
		[_taxi, _group, "We can't wait any longer! Transport is heading back to HQ!", true] call interrupt_taxi_misson;
	};
};

interrupt_taxi_misson = {
	params ["_taxi", "_group", "_msg", ["empty_vehicle", false]];
		
	player removeAction cancel_taxi_id;
	player removeAction update_orders_id;

	_veh lock true;
	[_group, _msg] spawn group_report_client;
	
	if(empty_vehicle) then {
		_taxi call empty_vehicle_cargo;
	} else {
		_taxi call throw_out_players;
	};

	sleep 3;

	if(_taxi isKindOf "Air") then {
		taxi_arrived_at_HQ = [_group, _taxi] call take_off_and_despawn;
	} else {
		taxi_arrived_at_HQ = [_group, _taxi] call send_to_HQ;
	};
};

empty_vehicle_cargo = {
	params ["_taxi"];
	{
		if(!((group _x) isEqualTo (group _taxi))) then {
			moveOut _x;			
		};
	} forEach crew _taxi;	
};

throw_out_players = {
	params ["_taxi"];
	{
		if(isPlayer _x) then {
			moveOut _x;			
		};
	} forEach crew _taxi;	
};

