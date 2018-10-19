taxi_wait_period_on_despawn = 300;
taxi_wait_period_on_crash = 900;
taxi_will_wait_time = 300;

taxi_wait_period = taxi_wait_period_on_despawn;

taxi_active = false;	
taxi_timer = time - taxi_wait_period;
taxi_arrived_at_HQ = false;

show_send_to_HQ_action = {
	params ["_veh"];

	_veh addAction [["Send off", 0] call addActionText, {	
		params ["_target", "_caller"];

		private _vehicle = _target;
		private _group = group driver _vehicle;
		[_group, "Heading back to HQ"] spawn group_report_client;	

		if(_vehicle isKindOf "Air") then {
			heli_arrived_at_HQ = [_group, _vehicle] call take_off_and_despawn;

		} else if(_veh isKindOf "Car" || _veh isKindOf "Tank") then {
			
		};

    }, nil, 90, true, false, "",
    '[_target] call is_taxi', 10
    ];
};

show_taxi_options = {
	params ["_type", "_priority"];

	private _side = side player;
	private _options = missionNamespace getVariable format["%1_%2_transport", _side, _type];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;
		
		curr_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;

			[] call remove_all_options;
			[_class_name, _penalty] call request_taxi;
		}, [_class_name, _penalty], (_priority - 1), false, true]);
	} forEach _options;
};

request_taxi = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		heli_active = true;
		heli_arrived_at_HQ = false;
		[_pos, _class_name, _penalty] spawn order_helicopter_taxi;	
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

show_order_taxi = {
	params ["_title", "_type"];
	missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	

  	player addAction [[_title, 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _open = missionNameSpace getVariable [format["taxi_%1_menu", _type], false];

		[] call remove_all_options;
		if(!_open && {[_type] call check_if_transport_available}) then {	
			missionNameSpace setVariable [format["taxi_%1_menu", _type], true];
			[_type, 100] call show_taxi_options;
		} else {
			missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	
		};	
    }, [_type], 100, false, false, "",
    '[player] call can_order_taxi && [player] call is_leader'
    ];
};

check_if_transport_available = {
	params [_type];

	private _timer = missionNameSpace getVariable format["%1_timer", _type];
	private _wait_period = missionNameSpace getVariable format["%1_wait_period", _type];
	private _time = time - _timer;

	if(_time < _wait_period) exitWith {
		private _time_left = _wait_period - _time;
		private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
		[playerSide, format["Helicopter transport is not available yet! Try again in %1 minutes", _wait_minutes]] spawn HQ_report_client;
		false;
	};
	true;
};

spawn_taxi = {
	params ["_type", "_side", "_class_name", "_penalty"];

	if(_type isEqualTo helicopter) then {
	    private _veh = [_side, _class_name] call spawn_helicopter;
	} else if(_type isEqualTo vehicle1) {
	    systemChat "Spawn vehicle taxi"
	}

	private _group = _veh select 2;
	private _taxi = _veh select 0;

	_taxi call show_send_to_HQ_action;

	_taxi setVariable ["penalty", [playerSide, _penalty], true];
		
	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_veh;
};

order_taxi = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [side player, _class_name, _penalty] call spawn_taxi;
	private _taxi = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _taxi) call get_vehicle_display_name;	
	
	_taxi spawn check_status;
	_taxi setVariable ["taxi", true];

	[_group, "Transport heli is on its way to given pick up destination!"] spawn group_report_client;
	[_group, _taxi, "GET IN", _pos] call land_helicopter; 

	if (canMove _taxi) exitWith {
		[_group, "Transport heli has landed. Waiting for squad to pick up!"] spawn group_report_client;
		[heli_will_wait_time, _taxi, _group] spawn on_taxi_idle_wait;
		[_taxi] spawn toggle_control;
	};
};

toggle_control = {
	params ["_taxi"];

	private _pilot = driver _taxi;
	private _group = group _pilot;
	private _pilot_type = typeOf _pilot;

	while {canMove _taxi && alive _taxi} do {
		waituntil {player in _taxi};
		[_group, _taxi] call put_player_in_position;
		waitUntil {!(player in _taxi)};
		[_pilot_type, _group, _taxi] call replace_player_with_driver;		
	};
};

replace_player_with_driver = {
	params ["_pilot_type", "_group", "_taxi"];

	private _pilot = _group createUnit [_pilot_type, [0,0,0], [], 0, "NONE"];
	_pilot moveInDriver _taxi;
	_group deleteGroupWhenEmpty true;
	_taxi lockDriver true;
	_taxi engineOn true;

	[heli_will_wait_time, _taxi, _group] spawn on_taxi_idle_wait;
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
	if (!heli_arrived_at_HQ) then {
		if(!(player in _taxi)) then {			
			[playerSide, "Transport heli is down! You are on your own!"] spawn HQ_report_client;
		};
		heli_wait_period = heli_wait_period_on_crash;
	} else {
		heli_wait_period = heli_wait_period_on_despawn;
	};

	heli_active = false;
	heli_timer = time;
};

on_taxi_idle_wait = {
	params ["_wait_period", "_taxi", "_group"];

	private _timer = time + _wait_period;
	waituntil {(player in _taxi) || time > _timer || !(alive _taxi)};

	if (!(player in _taxi) && (alive _taxi)) exitWith {
		[_taxi, _group] call interrupt_taxi_misson;
	};
};

interrupt_taxi_misson = {
	params ["_taxi", "_group"];
		
	[_group, "We can't wait any longer! Transport heli is heading back to HQ!"] spawn group_report_client;
	_taxi call empty_vehicle_cargo;
	heli_arrived_at_HQ = [_group, _taxi] call take_off_and_despawn;
};

empty_vehicle_cargo = {
	params ["_taxi"];
	{
		if(!((group _x) isEqualTo (group _taxi))) then {
			moveOut _x;			
		};
	} forEach crew _taxi;	
};

can_order_taxi = {
	params [];
	!heli_active;
};

is_taxi = {
	params ["_taxi"];
	(_taxi getVariable ["taxi", false]) && ((_taxi distance player) < 25);
};