arwa_transport_will_wait_time = 300;

in_transport = {	
	(vehicle player) getVariable ["transport", false];
};

update_transport_orders = {
	params ["_group", "_veh"];

	openMap true;
	[_group, _veh] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice 				        
		openMap false;

		private _group = _this select 0;
		private _veh = _this select 1;
		
		[_group, _veh, _pos, "TRANSPORT_RECEIVED_NEW_ORDERS"] spawn move_transport_to_pick_up;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

move_transport_to_pick_up = {
	params ["_group", "_veh", "_pos", "_msg"];

	[_group, [_msg]] spawn group_report_client;

	_veh setVariable ["active", true];

	if(_veh isKindOf "Air") then {
		[_group, _veh, "GET IN", _pos] call land_helicopter; 
	} else {		
		[_group, _veh, _pos] call send_vehicle_transport;			
	};	

	private _is_done = _veh getVariable ["is_done", false];

	if (canMove _veh && !_is_done) exitWith {
		[_group, ["TRANSPORT_HAS_ARRIVED"]] spawn group_report_client;
		[_veh, _group] spawn on_transport_idle_wait;
	};
};

check_if_transport_dead = {
	params ["_veh"];

	!([_veh] call check_if_transport_alive);
};

check_status = {
	params ["_veh"];

	private _cancel_transport_id = _veh getVariable ["_cancel_transport_id", nil];
	private _update_orders_id = _veh getVariable ["_update_orders_id", nil];

	waitUntil {[_veh] call check_if_transport_dead};
	
	player removeAction _cancel_transport_id;
	player removeAction _update_orders_id;

	arwa_transport_active = false;
		
	if(!(player in _veh) && !isNull _veh) then {
		_veh lockDriver false;			
		[playerSide, ["TRANSPORT_DOWN"]] spawn HQ_report_client; // TODO make classname specific
	};	
};

cancel_on_player_death = {
	params ["_veh", "_group"];
	waituntil {!(alive _veh) || !(alive player)};

	if (!(alive player) && [_veh] call check_if_transport_alive) exitWith {		
		[_veh, _group, "CANCELING_TRANSPORT_MISSION", true] call interrupt_transport_misson;
	};
};

on_transport_idle_wait = {
	params ["_veh", "_group"];
	
	_veh setVariable ["active", false];

	private _timer = time + arwa_transport_will_wait_time;
	waituntil {(player in _veh) || time > _timer || !(alive _veh) || _veh getVariable ["active", false]};
	
	if (!(player in _veh) && [_veh] call check_if_transport_alive && !(_veh getVariable ["active", false])) exitWith {
		[_veh, _group, "TRANSPORT_CANT_WAIT_ANY_LONGER", true] call interrupt_transport_misson;
	};
};

interrupt_transport_misson = {
	params ["_veh", "_group", "_msg", ["_empty_vehicle", false]];
		
	private _is_done = _veh getVariable ["is_done", false];

	if(!_is_done) exitWith {
		_veh setVariable ["is_done", true];	

		player removeAction (_veh getVariable ["_cancel_transport_id", nil]);
		player removeAction (_veh getVariable ["_update_orders_id", nil]);
	
		_veh lock true;
		[_group, [_msg]] spawn group_report_client;
		
		if(_empty_vehicle) then {
			_veh call empty_vehicle_cargo;
		} else {
			_veh call throw_out_players;
		};

		sleep 3;

		private _success = if(_veh isKindOf "Air") then {
			[_group, _veh] call take_off_and_despawn;
		} else {
			[_group, _veh] call send_to_HQ;
		};

		if(_success) then {
			[playerSide, ["TRANSPORT_ARRIVED_IN_HQ"]] spawn HQ_report_client;
		};	
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

