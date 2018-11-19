transport_wait_period_on_despawn = 300;
transport_wait_period_on_crash = 900;
transport_will_wait_time = 300;

transport_active = false;	
transport_timer = time;
transport_arrived_at_HQ = false;

in_transport = {	
	(vehicle player) getVariable ["transport", false];
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

update_transport_orders = {
	params ["_group", "_veh", "_pos"];

	openMap true;
	[_group, _veh, _pos] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _group = _this select 0;
		private _veh = _this select 1;
		private _pos = _this select 2;
		
		[_group, _veh, _pos] call move_transport_to_pick_up;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

transport_available = {
	params ["_type"];

	private _wait_period = (missionNameSpace getVariable format["%1_transport_wait_period", _type]);
	private _time = transport_timer + _wait_period;

	if(_time > time) exitWith {
		private _time_left = _time - time;
		private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
		systemChat format["Transport is not available yet! Try again in %1 minutes", _wait_minutes];
		false;
	};
	true;
};

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

request_transport = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		transport_active = true;
		transport_arrived_at_HQ = false; // TODO make type dependent
		[_pos, _class_name, _penalty] spawn order_transport;	
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

order_transport = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [side player, _class_name, _penalty] call spawn_transport;
	private _veh = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _veh) call get_vehicle_display_name;	
	
	[_veh] spawn show_active_transport_menu;
	[_veh] spawn check_status;

	[_group, _veh, _pos] call move_transport_to_pick_up;
};

move_transport_to_pick_up = {
	params ["_group", "_veh", "_pos"];

	[_group, "Transport is on its way to given pick up destination!"] spawn group_report_client;

	if(_veh isKindOf "Air") then {
		[_group, _veh, "GET IN", _pos] call land_helicopter; 
	} else {		
		[_group, _veh, _pos] call send_vehicle_transport;			
	};	

	if (canMove _veh) exitWith {
		[_group, "Transport has arrived. Waiting for squad to pick up!"] spawn group_report_client;
		[transport_will_wait_time, _veh, _group] spawn on_transport_idle_wait;
		[_veh] spawn toggle_control;
	};
};

spawn_transport = {
	params ["_side", "_class_name", "_penalty"];

	private _arr = if(_class_name isKindOf "Air") then {
	    [_side, _class_name] call spawn_helicopter;
	} else {
		[_side, _class_name] call spawn_vehicle;
	};

	private _group = _arr select 2;
	private _veh = _arr select 0;

	_veh setVariable ["penalty", [playerSide, _penalty], true];
		
	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_arr;
};

replace_player_with_driver = {
	params ["_driver_type", "_group", "_veh"];

	private _driver = _group createUnit [_driver_type, [0,0,0], [], 0, "NONE"];
	_driver moveInDriver _veh;
	_group deleteGroupWhenEmpty true;
	_veh lockDriver true;
	_veh engineOn true;

	[transport_will_wait_time, _veh, _group] spawn on_transport_idle_wait;
};

put_player_in_position = {
	params ["_group", "_veh"];

	_group deleteGroupWhenEmpty false;
	deleteVehicle (driver _veh);
	_veh lockDriver false;
	moveOut player;
	player moveInDriver _veh;
};

check_status = {
	params ["_veh"];

	waitUntil {!(alive _veh && canMove _veh)};
	sleep 3; // to make sure heli_active is updated
	if (!transport_arrived_at_HQ) then {
		if(!(player in _veh)) then {			
			[playerSide, "Transport vehicle is down! You are on your own!"] spawn HQ_report_client; // TODO make classname specific
		};

		missionNamespace setVariable [format["%1_transport_wait_period", _type],transport_wait_period_on_crash];
	} else {
		missionNamespace setVariable [format["%1_transport_wait_period", _type],transport_wait_period_on_despawn];
	};

	transport_active = false;
	player removeAction cancel_transport_id;
	transport_timer = time;
};

on_transport_idle_wait = {
	params ["_wait_period", "_veh", "_group"];

	private _timer = time + _wait_period;
	waituntil {(player in _veh) || time > _timer || !(alive _veh)};

	if (!(player in _veh) && (alive _veh)) exitWith {
		[_veh, _group, "We can't wait any longer! Transport is heading back to HQ!", true] call interrupt_transport_misson;
	};
};

interrupt_transport_misson = {
	params ["_veh", "_group", "_msg", ["empty_vehicle", false]];
		
	player removeAction cancel_transport_id;
	player removeAction update_orders_id;

	_veh lock true;
	[_group, _msg] spawn group_report_client;
	
	if(empty_vehicle) then {
		_veh call empty_vehicle_cargo;
	} else {
		_veh call throw_out_players;
	};

	sleep 3;

	if(_veh isKindOf "Air") then {
		transport_arrived_at_HQ = [_group, _veh] call take_off_and_despawn;
	} else {
		transport_arrived_at_HQ = [_group, _veh] call send_to_HQ;
	};
};

empty_vehicle_cargo = {
	params ["_veh"];
	{
		if(!((group _x) isEqualTo (group _veh))) then {
			moveOut _x;			
		};
	} forEach crew _veh;	
};

throw_out_players = {
	params ["_veh"];
	{
		if(isPlayer _x) then {
			moveOut _x;			
		};
	} forEach crew _veh;	
};

