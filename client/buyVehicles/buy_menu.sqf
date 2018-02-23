
buy_options = [];

is_close_to_hq = {
	params ["_player"];

	private _respawn_marker = [side _player, respawn_ground] call get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	(getPos player) distance _pos < 25; 
};

remove_all_options = {
	{
		player removeAction _x;
	} forEach buy_options;

	buy_options = [];
};

check_if_can_afford = {
	params ["_price"];

	private _cash = player getVariable "cash";
	_cash >= _price;
};

widthdraw_cash = {
	params ["_price"];

	private _cash = player getVariable "cash";
	private _new_amount = _cash - _price;
	player setVariable ["cash", _new_amount];
};

buy_vehicle = {
	params ["_base_marker", "_class_name", "_price"];

	private _pos = getPos _base_marker;
	private _isEmpty = [_pos] call check_if_any_units_to_close;

	if (_isEmpty) exitWith {
		
		if ([_price] call check_if_can_afford) exitWith {
			private _veh = _class_name createVehicle _pos;
			_veh setDir (getDir _base_marker);

			[_price] call widthdraw_cash;
		};

		systemChat "You cannot afford that vehicle";		
	}; 
	
	systemChat format["Something is obstructing the %1 respawn area", _type];
};

list_options = {
	params ["_type", "_priority"];

	private _options = missionNamespace getVariable format["%1_buy_%2s", side player, _type];

	{
		private _name = _x select 0;
		private _class_name = _x select 1;
		private _price = _x select 2;
		private _req_tier = _x select 3;


		if ((side player) call get_tier >= _req_tier) then {
			buy_options pushBack (player addAction [format[" %2 - %1$", _price, _name], {	
				private _params = _this select 3;
				private _type = _params select 0;
				private _class_name = _params select 1;
				private _price = _params select 2;

				[] call remove_all_options;
				
				private _base_marker_name = [side player, _type] call get_prefixed_name;
				private _base_marker = missionNamespace getVariable _base_marker_name;

				[_base_marker, _class_name, _price] call buy_vehicle;
				

			}, [_type, _class_name, _price], (_priority - 1), false, true, "", '[player] call is_close_to_hq']);
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
		[_type, _priority] call list_options;


	}, [_type, _priority], _priority, false, false, "", '[player] call is_close_to_hq'];
	
};

add_buy_options = {	
	["Buy vehicle", vehicle1, 10] call create_buy_menu;
	["Buy helicopter", helicopter, 20] call create_buy_menu;
;}
