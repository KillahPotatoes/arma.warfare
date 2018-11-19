taxi_options = [];

remove_all_taxi_options = {
	{
		player removeAction _x;
	} forEach taxi_options;

	taxi_options = [];
};

show_order_taxi = {
	params ["_title", "_type", "_priority"];
	missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	

  	player addAction [[_title, 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _open = missionNameSpace getVariable [format["taxi_%1_menu", _type], false];

		[player] call remove_all_taxi_options;
		if(!_open && {[_type] call transport_available}) then {	
			missionNameSpace setVariable [format["taxi_%1_menu", _type], true];
			[_type, _priority] call show_taxi_options;
		} else {
			missionNameSpace setVariable [format["taxi_%1_menu", _type], false];	
		};	
    }, [_type, _priority], _priority, false, false, "",
    '!taxi_active && [player] call is_leader'
    ];
};

show_taxi_options = {
	params ["_type", "_priority"];

	private _side = side player;
	private _options = missionNamespace getVariable format["%1_%2_transport", _side, _type];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;
		
		taxi_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;

			[player] call remove_all_taxi_options;
			[_class_name, _penalty] call request_taxi;
		}, [_class_name, _penalty], (_priority - 1), false, true]);
	} forEach _options;
};