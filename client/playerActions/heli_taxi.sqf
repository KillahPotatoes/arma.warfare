heli_wait_period_on_despawn = 10;
heli_wait_period_on_crash = 900;
heli_will_wait_time = 600;

heli_wait_period = heli_wait_period_on_despawn;
heli_price = 10;

landing_marker = "landing";
destination_marker = "destination";

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
    '[player] call can_order_heli'
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
	_veh setVariable ["hasOrders", false];

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
	deleteMarkerLocal destination_marker;
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
		private _has_orders = _heli getVariable "hasOrders";

		while {!_has_orders} do {
			if(!(player in _heli)) exitWith {
				_heli lock true;
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

			_has_orders = _heli getVariable "hasOrders";
		};
	};	
};

give_destination_to_heli_taxi = {
  player addAction ["Give destination", {
    openMap true;
    onMapSingleClick {
      	onMapSingleClick {};        
     	openMap false;		 
		deleteMarkerLocal landing_marker;
		[_pos, destination_marker, "hd_end"] call create_heli_marker;
		[_pos] spawn send_heli_to_drop_off_destination;		
    };
    waitUntil {
      !visibleMap;
    };
    onMapSingleClick {};
  }, nil, 1.5, true, true, "",
  '[player] call can_give_destination'
  ];
};

send_heli_to_drop_off_destination = {
	params ["_pos"];

	private _heli = vehicle player;
	private _group = group driver _heli;

	_heli setVariable ["hasOrders", true];

	private _name = (typeOf _heli) call get_vehicle_display_name;			
	[_group, format["%1 has picked up squad and heading for drop off!", _name]] spawn group_report_client;
		
	[_group, _heli, "GET OUT", _pos] call land_helicopter;    
	_heli call empty_vehicle_cargo;
	
	if(canMove _heli) exitWith {
		while {player in _heli} do {
			sleep 10;
		};

		_heli lock true;
		[_group, format["Helicopter transport mission successful! %1 is heading back to HQ!", _name]] spawn group_report_client;
		deleteMarkerLocal destination_marker;
		[_group, _heli] spawn take_off_and_despawn_heli_taxi;
	} ;	
};

heli_has_no_orders = {
	params ["_player"];
	
	private _veh = vehicle _player;
	private _orders = _veh getVariable "hasOrders";;
	if (!_orders) exitWith {
		true;
	};

	false;
};

can_order_heli = {
	params ["_player"];
	!(_player call is_inside_heli_taxi) && !heli_active;
};

can_give_destination = {
	params ["_player"];
	(_player call heli_is_operational) && (_player call is_inside_heli_taxi) && (_player call heli_has_no_orders);
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