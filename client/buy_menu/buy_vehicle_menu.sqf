buy_vehicle = {
	params ["_base_marker", "_class_name"];

	private _pos = getPos _base_marker;
	private _isEmpty = [_pos] call check_if_any_units_to_close;

	if (_isEmpty) exitWith {			
		private _veh = _class_name createVehicle _pos;
		_veh setDir (getDir _base_marker);			
	}; 
	
	systemChat format["Something is obstructing the %1 respawn area", _type];
};

list_vehicle_options = {
	params ["_type", "_priority"];

	private _options = missionNamespace getVariable format["%1_buy_%2", side player, _type];

	{
		private _name = _x select 0;
		private _class_name = _x select 1;
		private _req_tier = _x select 3;


		if ((side player) call get_tier >= _req_tier) then {
			buy_options pushBack (player addAction [format[" %1", _name], {	
				private _params = _this select 3;
				private _type = _params select 0;
				private _class_name = _params select 1;

				[] call remove_all_options;
				
				private _base_marker_name = [side player, _type] call get_prefixed_name;
				private _base_marker = missionNamespace getVariable _base_marker_name;

				[_base_marker, _class_name] call buy_vehicle;
				

			}, [_type, _class_name], (_priority - 1), false, true, "", '[player] call is_player_close_to_hq']);
		};
	
	} forEach _options;
};

create_buy_menu = {
	params ["_title", "_type", "_priority"];

	player addAction [_title, {
		private _params = _this select 3;

		private _type = _params select 0;
		private _priority = _params select 1;
		[] call remove_all_options;
		[_type, _priority] call list_vehicle_options;


	}, [_type, _priority], _priority, false, false, "", '[player] call is_player_close_to_hq'];	
};

