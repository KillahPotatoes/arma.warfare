ARWA_request_transport = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		[_pos, _class_name, _penalty] spawn ARWA_order_transport;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

ARWA_order_transport = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [playerSide, _class_name, _penalty] call ARWA_spawn_transport;
	private _veh = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _veh) call ARWA_get_vehicle_display_name;

	[_veh, _group] spawn ARWA_cancel_on_player_death;
	[_veh] spawn ARWA_show_active_transport_menu;
	[_veh] spawn ARWA_check_status;
	[_veh] spawn ARWA_toggle_control;

	[_group, _veh, _pos, "ARWA_STR_TRANSPORT_ON_ITS_WAY"] spawn ARWA_move_transport_to_pick_up;
};

ARWA_spawn_transport = {
	params ["_side", "_class_name", "_penalty"];

	private _arr = if(_class_name isKindOf "Air") then {
	    [_side, _class_name, _penalty, ARWA_transport_helicopter_spawn_height] call ARWA_spawn_helicopter;
	} else {
		[_side, _class_name, _penalty] call ARWA_spawn_transport_vehicle;
	};

	private _group = _arr select 2;
	private _veh = _arr select 0;
	ARWA_transport_present = true;

	_veh setVariable [ARWA_KEY_transport, true];
	_veh setVariable [ARWA_penalty, _penalty, true];

	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_arr;
};