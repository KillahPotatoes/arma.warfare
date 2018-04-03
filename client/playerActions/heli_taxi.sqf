show_order_heli_taxi = {  
  	player addAction ["Request heli pick-up - 200$", {
		private _price = 10;

		if (_price call check_if_can_afford) exitWith {		
			openMap true;
			onMapSingleClick {
				onMapSingleClick {}; 				        
				openMap false;
				[_pos, 10] spawn order_helicopter_taxi;
			};
			waitUntil {
				!visibleMap;
			};
			onMapSingleClick {};
		};
		systemChat "You cannot afford a heli pickup";	
    }, nil, 1.5, true, true, "",
    '!([player] call is_inside_heli_taxi)'
    ];
};

order_helicopter_taxi = {
	params ["_pos", "_price"];

	private _heli = [side player] call spawn_transport_heli;
	private _veh = _heli select 0;
	private _group = _heli select 2;

	_veh setVariable ["role", "taxi"];
	_veh setVariable [owned_by, player];
	_veh setVariable ["hasOrders", false];

	_price call widthdraw_cash;

	private _name = (typeOf _veh) call get_vehicle_display_name;	
	[_group, format["%1 is on its way to given pick up destination!", _name]] spawn report_heli_taxi_status;

	[_group, _veh, "GET IN", _pos] call land_helicopter;  

	[_group, format["%1 has landed. Waiting for squad to pick up!", _name]] spawn report_heli_taxi_status;
	
	[_veh, _group] spawn cancel_taxi_after_certain_time;
};

cancel_taxi_after_certain_time = {
	params ["_heli", "_group"];

	sleep 600;

	private _has_orders = _heli getVariable "hasOrders";

	while (!_has_orders) do {
		if(!(player in _heli)) exitWith {
			_heli lock true;
			private _name = (typeOf _heli) call get_vehicle_display_name;			
			[_group, format["We can't wait any longer! %1 is cancelling pick-up mission and heading back to HQ!", _name]] spawn report_heli_taxi_status;
			
			[_group, _heli] spawn take_off_and_despawn;
		};

		sleep 60;
		_has_orders = _heli getVariable "hasOrders";
	};
};

give_destination_to_heli_taxi = {
  player addAction ["Give destination", {
    openMap true;
    onMapSingleClick {
      	onMapSingleClick {};        
     	openMap false;		 
		[_pos] spawn send_heli_to_drop_off_destination;		
    };
    waitUntil {
      !visibleMap;
    };
    onMapSingleClick {};
  }, nil, 1.5, true, true, "",
  '[player] call is_inside_heli_taxi && [player] call heli_is_operational && [player] call heli_has_no_orders'
  ];
};

send_heli_to_drop_off_destination = {
	params ["_pos"];

	private _heli = vehicle player;
	private _group = group driver _heli;

	_heli setVariable ["hasOrders", true];

	private _name = (typeOf _heli) call get_vehicle_display_name;			
	[_group, format["%1 has picked up squad and heading for drop off!", _name]] spawn report_heli_taxi_status;
		
	[_group, _heli, "GET OUT", _pos] call land_helicopter;        
	{
		doGetOut _x;
	} forEach units group player; 
	
	while {player in _heli} do {
		sleep 10;
	};

	_heli lock true;
	[_group, format["Helicopter transport mission successful! %1 is heading back to HQ!", _name]] spawn report_heli_taxi_status;
	[_group, _heli] spawn take_off_and_despawn;
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

	if ((_veh getVariable owned_by) isEqualTo _player && (_veh getVariable "role") isEqualTo "taxi") exitWith {
		true;
	};

	false;
};