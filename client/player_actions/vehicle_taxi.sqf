taxi_options = [];

taxi_wait_period_on_despawn = 300;
taxi_wait_period_on_crash = 900;
taxi_will_wait_time = 300;

helicopter_taxi_wait_period = 0;
vehicle_taxi_wait_period = 0;

taxi_active = false;	
taxi_timer = time;
taxi_arrived_at_HQ = false;

cancel_taxi_id = nil;

remove_all_taxi_options = {
	
	{
		player removeAction _x;
	} forEach taxi_options;

	taxi_options = [];
};

show_cancel_taxi_action = {
	params ["_veh"];

	_veh setVariable ["taxi", true];

	cancel_taxi_id = player addAction [["Cancel taxi", 0] call addActionText, {	
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		_veh lock true;
		private _group = group driver _veh;

		[_veh] call throw_out_players;

		player removeAction cancel_taxi_id;

		[_group, "Heading back to HQ"] spawn group_report_client;	

		sleep 3;

		if(_veh isKindOf "Air") then {
			taxi_arrived_at_HQ = [_group, _veh] call take_off_and_despawn;
		} else {
			taxi_arrived_at_HQ = [_group, _veh] call send_to_HQ;
		};
    }, [_veh], 90, true, false, "",
    '!([] call in_taxi)'];
};

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

show_order_taxi = {
	params ["_title", "_type", "_priority"];
	missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	

  	player addAction [[_title, 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _open = missionNameSpace getVariable [format["taxi_%1_menu", _type], false];

		[player] call remove_all_taxi_options;
		if(!_open && {[_type] call check_if_transport_available}) then {	
			missionNameSpace setVariable [format["taxi_%1_menu", _type], true];
			[_type, _priority] call show_taxi_options;
		} else {
			missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	
		};	
    }, [_type, _priority], _priority, false, false, "",
    '!taxi_active && [player] call is_leader'
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
		
		taxi_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;

			[player] call remove_all_taxi_options;
			[_class_name, _penalty, _type] call request_taxi;
		}, [_class_name, _penalty, _type], (_priority - 1), false, true]);
	} forEach _options;
};

request_taxi = {
	params ["_class_name", "_penalty", "_type"];

	openMap true;
	[_class_name, _penalty, _type] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;
		private _type = _this select 2;

		taxi_active = true;
		taxi_arrived_at_HQ = false; // TODO make type dependent
		[_pos, _class_name, _penalty, _type] spawn order_taxi;	
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

order_taxi = {
	params ["_pos", "_class_name", "_penalty", "_type"];

	private _arr = [side player, _class_name, _penalty, _type] call spawn_taxi;
	private _taxi = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _taxi) call get_vehicle_display_name;	
	
	[_taxi] spawn show_cancel_taxi_action;
	[_taxi, _type] spawn check_status;

	[_group, "Transport is on its way to given pick up destination!"] spawn group_report_client;

	if(_type isEqualTo helicopter) then {
		[_group, _taxi, "GET IN", _pos] call land_helicopter; 
	} else {		
		[_group, _taxi, _pos] call send_vehicle_taxi;			
	};	

	if (canMove _taxi) exitWith {
		[_group, "Transport has arrived. Waiting for squad to pick up!"] spawn group_report_client;
		[taxi_will_wait_time, _taxi, _group, _type] spawn on_taxi_idle_wait;
		[_taxi, _type] spawn toggle_control;
	};
};

send_vehicle_taxi = {
	params ["_veh_group", "_veh_vehicle", "_pos"];

	_veh_group move _pos;
	sleep 3;
	waitUntil { !(alive _veh_vehicle) || (unitReady _veh_vehicle) };
};

spawn_taxi = {
	params ["_side", "_class_name", "_penalty", "_type"];

	private _veh = if(_type isEqualTo helicopter) then {
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

spawn_helicopter = {
	params ["_side", "_helicopter"];

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];

	waitUntil { [_pos] call is_air_space_clear; };

    private _heli = [_pos, _dir, _helicopter, _side] call BIS_fnc_spawnVehicle;

	(_heli select 0) lockDriver true;
	_heli;
};

spawn_vehicle = {
	params ["_side", "_penalty"];

	private _base_marker_name = [_side, _type] call get_prefixed_name;
	private _base_marker = missionNamespace getVariable _base_marker_name;

	private _pos = getPos _base_marker;

	waitUntil { !([_pos] call any_units_to_close); };

	private _veh = [_pos, getDir _base_marker, _class_name, _side] call BIS_fnc_spawnVehicle;

	(_veh select 0) lockDriver true;
	_veh;	
};

check_if_transport_available = {
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
	params ["_taxi", "_type"];

	private _driver = driver _taxi;
	private _group = group _driver; 
	private _driver_type = typeOf _driver;

	while {canMove _taxi && alive _taxi} do {
		waituntil {player in _taxi};
		[_group, _taxi] call put_player_in_position;
		waitUntil {!(player in _taxi)};
		[_driver_type, _group, _taxi, _type] call replace_player_with_driver;		
	};
};

replace_player_with_driver = {
	params ["_driver_type", "_group", "_taxi", "_type"];

	private _driver = _group createUnit [_driver_type, [0,0,0], [], 0, "NONE"];
	_driver moveInDriver _taxi;
	_group deleteGroupWhenEmpty true;
	_taxi lockDriver true;
	_taxi engineOn true;

	[taxi_will_wait_time, _taxi, _group, _type] spawn on_taxi_idle_wait;
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
	params ["_taxi", "_type"];

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
	params ["_wait_period", "_taxi", "_group", "_type"];

	private _timer = time + _wait_period;
	waituntil {(player in _taxi) || time > _timer || !(alive _taxi)};

	if (!(player in _taxi) && (alive _taxi)) exitWith {
		[_taxi, _group, _type] call interrupt_taxi_misson;
	};
};

interrupt_taxi_misson = {
	params ["_taxi", "_group", "_type"];
		
	[_group, "We can't wait any longer! Transport is heading back to HQ!"] spawn group_report_client;
	_taxi call empty_vehicle_cargo;

	if(_type isEqualTo helicopter) then {
		taxi_arrived_at_HQ = [_group, _taxi] call take_off_and_despawn;
	} else {
		taxi_arrived_at_HQ = [_group, _taxi] call send_to_HQ;
	};

	player removeAction cancel_taxi_id;
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

