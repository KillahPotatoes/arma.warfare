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
	} forEach allMissionObjects ARWA_ammo_box;
};

ARWA_owned_by = {
    params ["_box", "_player"];
    (_box getVariable ARWA_KEY_owned_by) isEqualTo playerSide;
};

ARWA_add_sector_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {[_target, _this] call ARWA_can_use_arsenal}]] call BIS_fnc_arsenal;

	if(ARWA_AllowFastTravel) then {
		[_ammo_box] call ARWA_fast_travel_menu;
	};

};

ARWA_can_use_arsenal = {
	params ["_target", "_this"];
	(_this distance _target) < 10 && {[_target, _this] call ARWA_owned_by} && {[_this] call ARWA_not_in_vehicle};
};

ARWA_add_HQ_actions = {
	params ["_ammo_box"];

	["AmmoboxInit", [_ammo_box, true, {[_target, _this] call ARWA_can_use_arsenal}]] call BIS_fnc_arsenal;
	_ammo_box call ARWA_add_manpower_action;

	[_ammo_box, ARWA_KEY_vehicle, ARWA_ground_vehicle_menu, "ARWA_STR_GET_VEHICLES"] call ARWA_create_get_menu;
	[_ammo_box, ARWA_KEY_helicopter, ARWA_air_vehicle_menu, "ARWA_STR_GET_HELICOPTERS"] call ARWA_create_get_menu;
	[_ammo_box, ARWA_KEY_infantry, ARWA_infantry_menu, "ARWA_STR_GET_INFANTRY"] call ARWA_create_get_menu;

	if(ARWA_allow_interceptors) then {
		[_ammo_box, ARWA_KEY_interceptor, ARWA_interceptor_menu, "ARWA_STR_GET_INTERCEPTORS"] call ARWA_create_get_menu;
	};

	if(ARWA_AllowFastTravel) then {
		[_ammo_box] call ARWA_fast_travel_menu;
	};
};

ARWA_create_get_menu = {
	params ["_ammo_box", "_type", "_menu_placement_value", "_text_key"];

	if(!([playerSide, _type] call ARWA_get_all_units_side isEqualTo [])) then {
		[_ammo_box, localize _text_key, _type, _menu_placement_value, false] call ARWA_create_menu;
	};
};

ARWA_create_custom_get_menu = {
	params ["_ammo_box", "_type", "_menu_placement_value", "_text_key"];

	[_ammo_box, localize _text_key, _type, _menu_placement_value, false] call ARWA_create_menu;
};