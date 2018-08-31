
buy_options = [];

remove_all_options = {
	{
		player removeAction _x;
	} forEach buy_options;

	buy_options = [];
};

add_get_options = {	
	["Get vehicle", vehicle1, 10] call create_menu;
	["Get helicopter", helicopter, 20] call create_menu;
	["Get infantry", 30] call create_infantry_menu;
	[40] call create_manpower_menu;
;}