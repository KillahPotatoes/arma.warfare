arwa_cancel_transport_id = nil;
arwa_update_orders_id = nil;

show_active_transport_menu = {
	params ["_veh"];	

	[_veh] call show_cancel_transport_action;
	[_veh] call show_update_orders;
};

show_update_orders = {
	params ["_veh"];

	arwa_update_orders_id = player addAction [[localize "UPDATE_TRANSPORT_ORDERS", 0] call addActionText, {	
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		private _group = group driver _veh;
		[_group, _veh] call update_transport_orders;
		
    }, [_veh], arwa_active_transport_actions, true, false, "",
    '!([] call in_transport)'];
};

show_cancel_transport_action = {
	params ["_veh"];

	arwa_cancel_transport_id = player addAction [[localize "SEND_TRANSPORT_TO_HQ", 0] call addActionText, {	
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		private _group = group driver _veh;

		[_veh, _group, "HEAD_TO_HQ"] call interrupt_transport_misson;
    }, [_veh], arwa_active_transport_actions, true, false, "",
    '!([] call in_transport)'];
};

