ARWA_get_next_vehicle_cycle = {
	params ["_curr_cycle"];

	private _min_cycles_between_vehicle_spawn = 2;
	private _max_cycles_between_vehicle_spawn = 5;

	_curr_cycle + (_min_cycles_between_vehicle_spawn + floor random (_max_cycles_between_vehicle_spawn - _min_cycles_between_vehicle_spawn));
};

ARWA_get_unit_cap = {
	ARWA_unit_cap / (count ([] call ARWA_get_active_factions));
};

ARWA_spawn_battle_groups = {
	params ["_side"];

	private _cycle_counter = 0;
	private _next_vehicle_cycle = 0;

	sleep 10;

	while {true} do {

		if(_side call ARWA_has_manpower && !ARWA_cease_fire) then {
			private _unit_count = _side call ARWA_count_battlegroup_units;
			private _can_spawn = floor (([] call ARWA_get_unit_cap) * (2/3)) - _unit_count;

			if (_can_spawn > ARWA_squad_cap / 2) then {
				if(_cycle_counter == _next_vehicle_cycle) then {
					[_side, _can_spawn] spawn ARWA_spawn_random_vehicle_group;
					_next_vehicle_cycle = [_cycle_counter] call ARWA_get_next_vehicle_cycle;
				} else {
					[_side, _can_spawn] spawn ARWA_spawn_random_infantry_group;
				};
				_cycle_counter = _cycle_counter + 1;
			};
		};

		sleep (ARWA_spawn_forces_interval + (floor random ARWA_spawn_forces_interval_variation));
	};
};

ARWA_initialize_spawn_battle_groups = {
	{
		[_x] spawn ARWA_spawn_battle_groups;
	} foreach ARWA_all_sides;
};
