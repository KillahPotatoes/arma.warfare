ARWA_cancel_transport_id = nil;
ARWA_update_orders_id = nil;

ARWA_show_active_transport_menu = {
	params ["_veh"];

	[_veh] call ARWA_show_cancel_transport_action;
	[_veh] call ARWA_show_update_orders;
};

ARWA_show_update_orders = {
	params ["_veh"];

	ARWA_update_orders_id = player addAction [[localize "ARWA_STR_UPDATE_TRANSPORT_ORDERS", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		private _group = group driver _veh;
		[_group, _veh] call ARWA_update_transport_orders;

    }, [_veh], ARWA_active_transport_actions, true, false, "",
    ''];
};

ARWA_show_cancel_transport_action = {
	params ["_veh"];

	ARWA_cancel_transport_id = player addAction [[localize "ARWA_STR_SEND_TRANSPORT_TO_HQ", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _veh = _arguments select 0;
		private _group = group driver _veh;

		[_veh, _group, "ARWA_STR_HEAD_TO_HQ"] call ARWA_interrupt_transport_misson;
    }, [_veh], ARWA_active_transport_actions, true, false, "",
    '!([] call ARWA_in_transport)'];
};

ARWA_in_transport = {
	(vehicle player) getVariable [ARWA_KEY_transport, false];
};
