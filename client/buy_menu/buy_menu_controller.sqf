
curr_options = [];

remove_all_options = {
	{
		player removeAction _x;
	} forEach curr_options;

	curr_options = [];
};

add_get_options = {	
	["Get vehicle", vehicle1, 110] call create_menu;
	["Get helicopter", helicopter, 120] call create_menu;
	["Get infantry", 130] call create_infantry_menu;	
;}