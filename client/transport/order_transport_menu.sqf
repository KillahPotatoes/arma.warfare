[] call compileFinal preprocessFileLineNumbers "client\transport\active_transport_menu.sqf";
[] call compileFinal preprocessFileLineNumbers "client\transport\ground_transport.sqf";
[] call compileFinal preprocessFileLineNumbers "client\transport\transport_controller.sqf";
[] call compileFinal preprocessFileLineNumbers "client\transport\driver_controller.sqf";
[] call compileFinal preprocessFileLineNumbers "client\transport\request_transport.sqf";

ARWA_transport_options = [];
ARWA_transport_present = false;

ARWA_remove_all_transport_options = {
	{
		player removeAction _x;
	} forEach ARWA_transport_options;

	ARWA_transport_options = [];
};

ARWA_show_order_transport = {
	params ["_title", "_type", "_priority"];
	missionNameSpace setVariable [format["transport_%1_menu", _type], false];

	player addAction [[_title, 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _open = missionNameSpace getVariable [format["transport_%1_menu", _type], false];

		[player] call ARWA_remove_all_transport_options;
		if(!_open) then {
			missionNameSpace setVariable [format["transport_%1_menu", _type], true];
			[_type, _priority] call ARWA_show_transport_options;
		} else {
			missionNameSpace setVariable [format["transport_%1_menu", _type], false];
		};
		}, [_type, _priority], _priority, false, false, "",
		'[player] call ARWA_is_leader && !ARWA_transport_present'
	];
};

ARWA_show_transport_options = {
	params ["_type", "_priority"];

	private _side = playerSide;
	private _options = missionNamespace getVariable format["%1_%2_transport", _side, _type];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call ARWA_get_vehicle_display_name;

		ARWA_transport_options pushBack (player addAction [[_name, 2] call ARWA_add_action_text, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;

			[player] call ARWA_remove_all_transport_options;
			[_class_name, _penalty] call ARWA_request_transport;
		}, [_class_name, _penalty], (_priority - 1), false, true, "",
		'[player] call ARWA_is_leader && !ARWA_transport_present'
		]);
	} forEach _options;
};