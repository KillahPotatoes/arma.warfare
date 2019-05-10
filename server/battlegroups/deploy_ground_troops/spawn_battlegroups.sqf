ARWA_get_next_vehicle_cycle = {
	params ["_curr_cycle"];

	private _min_cycles_between_vehicle_spawn = 0;
	private _max_cycles_between_vehicle_spawn = 4;

	_curr_cycle + (_min_cycles_between_vehicle_spawn + floor random (_max_cycles_between_vehicle_spawn - _min_cycles_between_vehicle_spawn));
};

ARWA_spawn_battle_groups = {
	params ["_side"];

	private _cycle_counter = 0;
	private _next_vehicle_cycle = [_cycle_counter] call ARWA_get_next_vehicle_cycle;

	sleep 10;

	while {true} do {

		if(_side call ARWA_has_manpower && !ARWA_cease_fire) then {
			private _unit_count = _side call ARWA_count_battlegroup_units;
			private _can_spawn = ARWA_unit_cap - _unit_count;

			if (_can_spawn > ARWA_squad_cap) then {
				if(_cycle_counter == _next_vehicle_cycle) then {
					_cycle_counter = _cycle_counter + 1;
					[_side, _can_spawn] spawn ARWA_spawn_random_vehicle_group;
					_next_vehicle_cycle = [_cycle_counter] call ARWA_get_next_vehicle_cycle;
				} else {
					_cycle_counter = _cycle_counter + 1;
					[_side, _can_spawn] spawn ARWA_spawn_random_infantry_group;
				};
			};
		};

		sleep (ARWA_spawn_forces_interval + (floor random ARWA_spawn_forces_interval_variation));
	};
};

ARWA_initialize_spawn_battle_groups = {
	[West] spawn ARWA_spawn_battle_groups;
	[East] spawn ARWA_spawn_battle_groups;
	[Independent] spawn ARWA_spawn_battle_groups;
};
