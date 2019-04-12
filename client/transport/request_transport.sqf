request_transport = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		[_pos, _class_name, _penalty] spawn order_transport;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

order_transport = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [playerSide, _class_name, _penalty] call spawn_transport;
	private _veh = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _veh) call get_vehicle_display_name;

	[_veh, _group] spawn cancel_on_player_death;
	[_veh] spawn show_active_transport_menu;
	[_veh] spawn check_status;
	[_veh] spawn toggle_control;

	[_group, _veh, _pos, "TRANSPORT_ON_ITS_WAY"] spawn move_transport_to_pick_up;
};

spawn_transport = {
	params ["_side", "_class_name", "_penalty"];

	private _arr = if(_class_name isKindOf "Air") then {
	    [_side, _class_name, _penalty] call spawn_helicopter;
	} else {
		[_side, _class_name, _penalty] call spawn_transport_vehicle;
	};

	private _group = _arr select 2;
	private _veh = _arr select 0;
	arwa_transport_present = true;

	_veh setVariable ["transport", true];
	_veh setVariable [arwa_penalty, _penalty, true];

	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_arr;
};