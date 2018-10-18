get_vehicle = {
	params ["_base_marker", "_class_name", "_penalty"];

	private _pos = getPos _base_marker;
	private _isEmpty = [_pos] call check_if_any_units_to_close;

	if (_isEmpty) exitWith {
		private _veh = _class_name createVehicle _pos;
		_veh setDir (getDir _base_marker);
		_veh setVariable ["penalty", [playerSide, _penalty], true];
	}; 
	
	systemChat format["Something is obstructing the %1 respawn area", _type];
};

list_vehicle_options = {
	params ["_type", "_priority"];

	private _side = side player;
	private _options = [_side, _type] call get_vehicles_based_on_tier;

	if(_type isEqualTo helicopter) then {
		_options = _options + (missionNamespace getVariable format["%1_%2_transport", _side, helicopter]);
	};

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;
		
		curr_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;

			[] call remove_all_options;
			
			private _base_marker_name = [side player, _type] call get_prefixed_name;
			private _base_marker = missionNamespace getVariable _base_marker_name;

			[_base_marker, _class_name, _penalty] call get_vehicle;
			

		}, [_class_name, _penalty, _type], (_priority - 1), false, true, "", '[player] call is_player_close_to_hq']);
	

	} forEach _options;
};

create_menu = {
	params ["_title", "_type", "_priority"];

	missionNameSpace setVariable [format["Menu_%1", _title], false];	

	player addAction [[_title, 0] call addActionText, {
		private _params = _this select 3;

		private _type = _params select 0;
		private _priority = _params select 1;
		private _title = _params select 2;

		[] call remove_all_options;

		private _open = missionNameSpace getVariable format["Menu_%1", _title];	
		missionNameSpace setVariable [format["Menu_%1", _title], !_open];	
		if(!_open) then {
			[_type, _priority] call list_vehicle_options;
		};
	}, [_type, _priority, _title], _priority, false, false, "", '[player] call is_player_close_to_hq'];	
};

