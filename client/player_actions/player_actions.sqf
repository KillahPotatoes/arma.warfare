

is_leader = {
	params ["_player"];

	isPlayer (leader (group _player));   
};

initialize_ammo_boxes = {
	{
		if(_x getVariable ["HQ", false]) then {
			[_x] spawn add_HQ_actions;
		};

		if(_x getVariable ["sector", false]) then {
			[_x] spawn add_sector_actions;
		};
	} forEach entities ammo_box;
};

add_sector_actions = {
	params ["_ammo_box"];

	_ammo_box call add_arsenal_action;
	_ammo_box call add_take_manpower_action;
	_ammo_box call add_store_manpower_action;
	[_ammo_box, localize "GET_INFANTRY", infantry, arwa_infantry_menu, true] call create_menu;
};

add_HQ_actions = {
	params ["_ammo_box"];

	_ammo_box call add_arsenal_action;
	_ammo_box call add_manpower_action;
	[_ammo_box, localize "GET_VEHICLES", vehicle1, arwa_ground_vehicle_menu, false] call create_menu;
	[_ammo_box, localize "GET_HELICOPTERS", helicopter, arwa_air_vehicle_menu, false] call create_menu;
	[_ammo_box, localize "GET_INFANTRY", infantry, arwa_infantry_menu, false] call create_menu;	
};
