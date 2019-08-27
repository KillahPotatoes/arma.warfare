ARWA_is_leader = {
	params ["_player"];

	isPlayer (leader (group _player));
};

ARWA_initialize_ammo_boxes = {
	{
		if(_x getVariable [ARWA_KEY_HQ, false]) then {
			[_x] spawn ARWA_add_HQ_actions;
		};

		if(_x getVariable [ARWA_KEY_sector, false]) then {
			[_x] spawn ARWA_add_sector_actions;
		};
	} forEach entities ARWA_ammo_box;
};

ARWA_owned_by = {
    params ["_box", "_player"];
    (_box getVariable ARWA_KEY_owned_by) isEqualTo (side _player);
};

ARWA_add_sector_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {(_this distance _target) < 10 && [_target, _this] call ARWA_owned_by && [_this] call ARWA_not_in_vehicle}]] call BIS_fnc_arsenal;
	[_ammo_box, localize "ARWA_STR_GET_INFANTRY", ARWA_KEY_infantry, ARWA_infantry_menu, true] call ARWA_create_menu;
	[_ammo_box] call ARWA_create_intel_menu;
};

ARWA_add_HQ_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {(_this distance _target) < 10 && [_target, _this] call ARWA_owned_by && [_this] call ARWA_not_in_vehicle}]] call BIS_fnc_arsenal;
	_ammo_box call ARWA_add_manpower_action;
	[_ammo_box, localize "ARWA_STR_GET_VEHICLES", ARWA_KEY_vehicle, ARWA_ground_vehicle_menu, false] call ARWA_create_menu;
	[_ammo_box, localize "ARWA_STR_GET_HELICOPTERS", ARWA_KEY_helicopter, ARWA_air_vehicle_menu, false] call ARWA_create_menu;
	[_ammo_box, localize "ARWA_STR_GET_INFANTRY", ARWA_KEY_infantry, ARWA_infantry_menu, false] call ARWA_create_menu;
	[_ammo_box, localize "ARWA_STR_GET_INTERCEPTORS", ARWA_KEY_interceptors, ARWA_interceptor_menu, false] call ARWA_create_menu;
};
