ARWA_minimum_active_vehicles = 2;

ARWA_needs_vehicles = {
	params ["_side"];
	private _groups = [_side] call ARWA_get_battlegroups;
	{ !((vehicle leader _x) isEqualTo (leader _x)) && (isTouchingGround (vehicle leader _x)); } count _groups < ARWA_minimum_active_vehicles;
};

ARWA_get_unit_cap = {
	ARWA_unit_cap / (count ([] call ARWA_get_active_factions));
};

ARWA_spawn_battle_groups = {
	params ["_side"];

	sleep 10;

	while {true} do {

		if(_side call ARWA_has_manpower) then {
			private _unit_count = _side call ARWA_count_battlegroup_units;
			private _can_spawn = floor (([] call ARWA_get_unit_cap) * (2/3)) - _unit_count;

			if (_can_spawn > ARWA_squad_cap / 2) then {
				if([_side] call ARWA_needs_vehicles) then {
					[_side, _can_spawn] spawn ARWA_spawn_random_vehicle_group;
				} else {
					[_side, _can_spawn] spawn ARWA_spawn_random_infantry_group;
				};
			};
		};

		sleep (60 + random 300);
	};
};

ARWA_initialize_spawn_battle_groups = {
	{
		[_x] spawn ARWA_spawn_battle_groups;
	} foreach ARWA_all_sides;
};
