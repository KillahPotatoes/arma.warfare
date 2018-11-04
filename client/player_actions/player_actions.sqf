not_in_vehicle = {
	params ["_player"];
	_player isEqualTo (vehicle _player);
};

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
		 } forEach allMissionObjects ammo_box;
};

add_sector_actions = {
	params ["_ammo_box"];

	_ammo_box call add_arsenal_action;
	_ammo_box call add_take_manpower_action;
	_ammo_box call add_store_manpower_action;
	[_ammo_box, "Get infantry", infantry, 130, true] call create_menu;
};

add_HQ_actions = {
	params ["_ammo_box"];

	_ammo_box call add_arsenal_action;
	_ammo_box call add_manpower_action;
	[_ammo_box, "Get vehicle", vehicle1, 110, false] call create_menu;
	[_ammo_box, "Get helicopter", helicopter, 120, false] call create_menu;
	[_ammo_box, "Get infantry", infantry, 130, false] call create_menu;	
};