
buy_options = [];

remove_all_options = {
	{
		player removeAction _x;
	} forEach buy_options;

	buy_options = [];
};

check_if_can_afford = {
	params ["_price"];

	private _cash = player getVariable cash;
	_cash >= _price;
};

widthdraw_cash = {
	params ["_price"];

	private _cash = player getVariable cash;
	private _new_amount = _cash - _price;
	player setVariable [cash, _new_amount];
};

add_buy_options = {	
	["Buy vehicle", vehicle1, 10] call create_buy_menu;
	["Buy helicopter", helicopter, 20] call create_buy_menu;
	["Buy infantry", infantry, 30] call create_infantry_buy_menu;
	["Buy manpower", infantry, 30] call create_manpower_buy_menu;
;}