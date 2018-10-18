heli_wait_period_on_despawn = 300;
heli_wait_period_on_crash = 900;
heli_will_wait_time = 300;

heli_wait_period = heli_wait_period_on_despawn;

heli_active = false;	
heli_timer = time - heli_wait_period;
heli_arrived_at_HQ = false;

show_send_heli_off_action = {
	player addAction [["Send off", 0] call addActionText, {		
		private _heli = cursorTarget;
		private _group = group driver _heli;
		[_group, "Heading back to HQ"] spawn group_report_client;		
		heli_arrived_at_HQ = [_group, _heli] call take_off_and_despawn;
		
    }, nil, 90, true, true, "",
    '[cursorTarget] call is_heli_taxi'
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
						
			[_class_name, _penalty] call request_heli_taxi;
			

		}, [_class_name, _penalty], (_priority - 1), false, true]);
	

	} forEach _options;
};

request_heli_taxi = {
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

show_order_heli_taxi = {  
	missionNameSpace setVariable ["Request_heli_menu", false];	

  	player addAction [["Request heli pick-up", 0] call addActionText, {
		
		private _open = missionNameSpace getVariable "Request_heli_menu";

		[] call remove_all_options;
		if(!_open && {[] call check_if_transport_helicopter_available}) then {	
			missionNameSpace setVariable ["Request_heli_menu", true];	
			[helicopter, 100] call show_taxi_options;	
		} else {
			missionNameSpace setVariable ["Request_heli_menu", false];	
		};	
		
    }, nil, 100, false, false, "",
    '[player] call can_order_heli && [player] call is_leader'
    ];
};

check_if_transport_helicopter_available = {
	private _time = time - heli_timer;
	if(_time < heli_wait_period) exitWith {
		private _time_left = heli_wait_period - _time;
		private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
		[playerSide, format["Helicopter transport is not available yet! Try again in %1 minutes", _wait_minutes]] spawn HQ_report_client;
		false;
	};
	true;
};

spawn_taxi_heli = {
	params ["_side", "_class_name", "_penalty"];

    private _veh = [_side, _class_name] call spawn_helicopter;

	private _group = _veh select 2;
	private _heli = _veh select 0;

	_heli setVariable ["penalty", [playerSide, _penalty], true];
		
	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_veh;
};

order_helicopter_taxi = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [side player, _class_name, _penalty] call spawn_taxi_heli;
	private _heli = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _heli) call get_vehicle_display_name;	
	
	_heli spawn check_status;
	_heli setVariable ["taxi", true];

	[_group, "Transport heli is on its way to given pick up destination!"] spawn group_report_client;
	[_group, _heli, "GET IN", _pos] call land_helicopter; 

	if (canMove _heli) exitWith {
		[_group, "Transport heli has landed. Waiting for squad to pick up!"] spawn group_report_client;
		[heli_will_wait_time, _heli, _group] spawn on_heli_idle_wait;
		[_heli] spawn toggle_pilot_control;
	};
};

toggle_pilot_control = {
	params ["_heli"];

	private _pilot = driver _heli;
	private _group = group _pilot;
	private _pilot_type = typeOf _pilot;

	while {canMove _heli && alive _heli} do {
		waituntil {player in _heli};
		[_group, _heli] call put_player_in_pilot_position;
		waitUntil {!(player in _heli)};
		[_pilot_type, _group, _heli] call replace_player_with_pilot;		
	};
};

replace_player_with_pilot = {
	params ["_pilot_type", "_group", "_heli"];

	private _pilot = _group createUnit [_pilot_type, [0,0,0], [], 0, "NONE"];
	_pilot moveInDriver _heli;
	_group deleteGroupWhenEmpty true;
	_heli lockDriver true;
	_heli engineOn true;

	[heli_will_wait_time, _heli, _group] spawn on_heli_idle_wait;
};

put_player_in_pilot_position = {
	params ["_group", "_heli"];

	_group deleteGroupWhenEmpty false;
	deleteVehicle (driver _heli);
	_heli lockDriver false;
	moveOut player;
	player moveInDriver _heli;
};

check_status = {
	params ["_heli"];

	waitUntil {!(alive _heli && canMove _heli)};
	sleep 3; // to make sure heli_active is updated
	if (!heli_arrived_at_HQ) then {
		if(!(player in _heli)) then {			
			[playerSide, "Transport heli is down! You are on your own!"] spawn HQ_report_client;
		};
		heli_wait_period = heli_wait_period_on_crash;
	} else {
		heli_wait_period = heli_wait_period_on_despawn;
	};

	heli_active = false;
	heli_timer = time;
};

on_heli_idle_wait = {
	params ["_wait_period", "_heli", "_group"];

	private _timer = time + _wait_period;
	waituntil {(player in _heli) || time > _timer || !(alive _heli)};

	if (!(player in _heli) && (alive _heli)) exitWith {
		[_heli, _group] call interrupt_heli_transport_misson;
	};
};

interrupt_heli_transport_misson = {
	params ["_heli", "_group"];
		
	[_group, "We can't wait any longer! Transport heli is heading back to HQ!"] spawn group_report_client;
	_heli call empty_vehicle_cargo;
	heli_arrived_at_HQ = [_group, _heli] call take_off_and_despawn;
};

empty_vehicle_cargo = {
	params ["_heli"];
	{
		if(!((group _x) isEqualTo (group _heli))) then {
			moveOut _x;			
		};
	} forEach crew _heli;	
};

can_order_heli = {
	!heli_active;
};

is_heli_taxi = {
	params ["_heli"];
	(_heli getVariable ["taxi", false]) && ((_heli distance player) < 25);
};