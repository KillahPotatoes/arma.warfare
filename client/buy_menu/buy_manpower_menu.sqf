buy_manpower = {
	params ["_manpower", "_price"];

	if (_price call check_if_can_afford) exitWith {
		_price call widthdraw_cash;

		[side player, _manpower] remoteExec ["buy_manpower_server", 2];
		systemChat format["You bought %1 manpower points for %2$", _manpower, _price];        
	};

	systemChat format["You cannot afford %1 manpower points", _manpower];
};

list_manpower_options = {
	params ["_type", "_priority"];
	private _options = [10, 50, 100, 500, 1000];

	{
		private _manpower = _x select 0;
		private _price = _manpower * 10;
		private _cash = player getVariable [cash, 0];

		if (_cash <= _price) then {
			[_manpower, _price] call list_manpower_option;
		};
	
	} forEach _options;
};

list_max_manpower_option = {
	private _cash = player getVariable [cash, 0];
	private _manpower = (_cash - (_cash mod 10)) / 10;
	if (_manpower > 10) then {
		private _price = _manpower * 10;
		[_manpower, _price] call list_manpower_option;
	}
};

list_manpower_option = {
	params ["_manpower", "_price"];
	buy_options pushBack (player addAction [format[" %2 - %1$", _price, _manpower], {	
		private _params = _this select 3;
		private _manpower = _params select 0;
		private _price = _params select 1;

		[] call remove_all_options;
		[_manpower, _price] call buy_manpower;
	}, [_manpower, _price], (_priority - 1), false, true, "", '[player] call is_player_close_to_hq']);
};

create_manpower_buy_menu = {
	params ["_title", "_priority"];

	player addAction [_title, {
		private _params = _this select 3;
		private _priority = _params select 0;
		[] call remove_all_options;
		[_priority] call list_options;
	}, [_priority], _priority, false, false, "", '[player] call is_player_close_to_hq'];	
};

