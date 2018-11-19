cancel_taxi_id = nil;
update_orders_id = nil;

show_active_taxi_menu = {
	params ["_taxi"];

	_taxi setVariable ["taxi", true];

	[_taxi] spawn show_cancel_taxi_action;
	[_taxi] spawn show_update_orders;
};

show_update_orders = {
	params ["_veh"];

	update_orders_id = player addAction [["Update taxi orders", 0] call addActionText, {	
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		private _group = group driver _veh;
		[_group, _veh] call update_taxi_orders;
		
    }, [_veh], 90, true, false, "",
    '!([] call in_taxi)'];
};

show_cancel_taxi_action = {
	params ["_veh"];

	_veh setVariable ["taxi", true];

	cancel_taxi_id = player addAction [["Cancel taxi", 0] call addActionText, {	
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _group = group driver _veh;

		[_veh, _group, "Heading back to HQ"] call interrupt_taxi_misson;
    }, [_veh], 90, true, false, "",
    '!([] call in_taxi)'];
};