

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

owned_box = {
    params ["_box", "_player"];
    (_box getVariable owned_by) isEqualTo (side _player);
};

add_sector_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {(_this distance _target) < 10 && [_target, _this] call owned_box && [_this] call not_in_vehicle}]] call BIS_fnc_arsenal;
	[_ammo_box, localize "GET_INFANTRY", infantry, ARWA_infantry_menu, true] call create_menu;
};

add_HQ_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {(_this distance _target) < 10 && [_target, _this] call owned_box && [_this] call not_in_vehicle}]] call BIS_fnc_arsenal;
	_ammo_box call add_manpower_action;
	[_ammo_box, localize "GET_VEHICLES", vehicle1, ARWA_ground_vehicle_menu, false] call create_menu;
	[_ammo_box, localize "GET_HELICOPTERS", helicopter, ARWA_air_vehicle_menu, false] call create_menu;
	[_ammo_box, localize "GET_INFANTRY", infantry, ARWA_infantry_menu, false] call create_menu;	
};
