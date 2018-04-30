heli_wait_period_on_despawn = 0;
heli_wait_period_on_crash = 900;
heli_will_wait_time = 600;

heli_wait_period = heli_wait_period_on_despawn;
heli_price = 0;

landing_marker = "landing";

heli_active = false;	
heli_timer = time;

show_order_heli_taxi = {  
  	player addAction [format["Request heli pick-up - %1$", heli_price], {
		private _price = heli_price;
		private _time = time - heli_timer;
		if(!(_price call check_if_can_afford)) exitWith {
			systemChat "You cannot afford a heli pickup";				
		};

		if(_time < heli_wait_period) exitWith {
			private _time_left = heli_wait_period - _time;
			private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;	
			[playerSide, format["Helicopter transport is not available yet! Try again in %1 minutes", _wait_minutes]] spawn HQ_report_client;
		};
		
		openMap true;
		onMapSingleClick {
			onMapSingleClick {}; 				        
			openMap false;
			heli_active = true;
			[_pos, heli_price] spawn order_helicopter_taxi;	
			[_pos, landing_marker, "hd_pickup"] call create_heli_marker;
		};
		waitUntil {
			!visibleMap;
		};
		onMapSingleClick {};
		
    }, nil, 1.5, true, true, "",
    '[player] call can_order_heli && [player] call is_leader'
    ];
};

create_heli_marker = {
	params ["_pos", "_name", "_type"];
	createMarkerLocal [_name, _pos];
	_name setMarkerColorLocal "ColorBlack";
	_name setMarkerAlphaLocal 1;
	_name setMarkerTypeLocal _type;
};

take_off_and_despawn_heli_taxi = {
	params ["_heli_group", "_heli_vehicle"];
	private _success = [_heli_group, _heli_vehicle] call take_off_and_despawn;	
	heli_active = false;
	heli_timer = time;

	heli_wait_period = if (_success) then { heli_wait_period_on_despawn } else { heli_wait_period_on_crash };
};

order_helicopter_taxi = {
	params ["_pos", "_price"];

	private _heli = [side player] call spawn_transport_heli;

	_heli spawn check_status;

	private _veh = _heli select 0;
	private _group = _heli select 2;

	_veh setVariable ["role", "taxi"];

	_price call widthdraw_cash;

	private _name = (typeOf _veh) call get_vehicle_display_name;	
	[_group, format["%1 is on its way to given pick up destination!", _name]] spawn group_report_client;

	[_group, _veh, "GET IN", _pos] call land_helicopter;  
	if (canMove _veh) then {
		[_group, format["%1 has landed. Waiting for squad to pick up!", _name]] spawn group_report_client;
		[_veh, _group] spawn cancel_taxi_after_certain_time;
	};
};

set_heli_crashed_state = {
	heli_wait_period = heli_wait_period_on_crash;
	heli_active = false;		
	deleteMarkerLocal landing_marker;
};

check_status = {
	params ["_heli"];
	while {alive _heli && canMove _heli} do {
		sleep 2;
	};

	sleep 10; // to make sure heli_active is updated
	
	private _name = (typeOf _heli) call get_vehicle_display_name;
	if (!(alive _heli) && heli_active) exitWith {
		[playerSide, format["%1 is down! You are on your own!", _name]] spawn HQ_report_client;
		[] call set_heli_crashed_state;
	};

	if (!(canMove _heli) && heli_active) exitWith {
		[playerSide, format["%1 has crashlanded. You are on your own!", _name]] spawn HQ_report_client;	
		[] call set_heli_crashed_state;
	};
};

group_is_in_vehicle = {
	params ["_group", "_veh"];
	
	private _in_vehicle = false;
	{
		if(_x in _veh) exitWith {
			_in_vehicle = true;
		};
	} foreach _group;

	_in_vehicle;
};

empty_vehicle_cargo = {
	params ["_vehicle"];
	
	{
		if(!((group _x) isEqualTo (group _vehicle))) then {
			doGetOut _x;			
		};
	} forEach crew _vehicle;	
};

cancel_taxi_after_certain_time = {
	params ["_heli", "_group"];

	sleep heli_will_wait_time;
	if(alive _heli && canMove _heli) then {		
		
		if(!(player in _heli)) exitWith {			
			private _name = (typeOf _heli) call get_vehicle_display_name;			
			[_group, format["We can't wait any longer! %1 is cancelling pick-up mission and heading back to HQ!", _name]] spawn group_report_client;
			
			_heli call empty_vehicle_cargo;

			deleteMarkerLocal landing_marker;

			[_group, _heli] spawn take_off_and_despawn_heli_taxi;
		};

		sleep 60;
		if(!(alive _heli && canMove _heli)) exitWith {
			false;
		};
		
	};	
};

take_control_over_heli = {
  player addAction ["Take control", {
	  private _heli = vehicle player;
	  private _pilot = driver _heli;
	  private _group = group _pilot;
	  private _pilot_type = typeOf _pilot;

	  _group deleteGroupWhenEmpty false;
	  deleteVehicle _pilot;
	  _heli lockDriver false;
	  moveOut player;
	  player moveInDriver _heli;
	  
	  waituntil { !(player in _heli) };
	  [_pilot_type, _group, _heli] spawn send_heli_to_HQ;

  }, nil, 1.5, true, true, "",
  '[player] call can_take_control'
  ];
};

send_heli_to_HQ = {
	params ["_pilot_type", "_group", "_heli"];
		
	private _pilot = _group createUnit [_pilot_type, [0,0,0], [], 0, "NONE"];
	_pilot moveInDriver _heli;
	_group deleteGroupWhenEmpty true;
	_heli lockDriver true;

	if(canMove _heli) exitWith {
		private _name = (typeOf _heli) call get_vehicle_display_name;	
		[_group, format["Helicopter transport mission successful! %1 is heading back to HQ!", _name]] spawn group_report_client;		
		[_group, _heli] spawn take_off_and_despawn_heli_taxi;
	} ;	
};

can_order_heli = {
	params ["_player"];
	!(_player call is_inside_heli_taxi) && !heli_active;
};

can_take_control = {
	params ["_player"];
	(_player call heli_is_operational) && (_player call is_inside_heli_taxi);
};

heli_is_operational = {
	params ["_player"];
	
	private _veh = vehicle _player;

	if (canMove _veh) exitWith {
		true;
	};

	false;
};

is_inside_heli_taxi = {
	params ["_player"];

	private _veh = vehicle _player;

	if ((_veh getVariable "role") isEqualTo "taxi") exitWith {
		true;
	};

	false;
};