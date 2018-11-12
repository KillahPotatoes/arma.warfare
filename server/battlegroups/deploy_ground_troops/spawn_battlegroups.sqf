get_next_vehicle_cycle = {
	params ["_curr_cycle"];

	private _min_cycles_between_vehicle_spawn = 0;
	private _max_cycles_between_vehicle_spawn = 3;

	_curr_cycle + (_min_cycles_between_vehicle_spawn + floor random (_max_cycles_between_vehicle_spawn - _min_cycles_between_vehicle_spawn));
};

spawn_battle_groups = {
	params ["_side"];

	private _cycle_counter = 0;
	private _next_vehicle_cycle = [_cycle_counter] call get_next_vehicle_cycle;

	sleep 10;		

	while {_side in active_factions} do {
		private _unit_count = _side call count_battlegroup_units;	
		private _can_spawn = unit_cap - _unit_count; 

		if (_can_spawn > (squad_cap / 2)) then {
			if(_cycle_counter == _next_vehicle_cycle) then {
				_cycle_counter = _cycle_counter + 1;
				[_side, _can_spawn] spawn spawn_random_vehicle_group;
				 _next_vehicle_cycle = [_cycle_counter] call get_next_vehicle_cycle;
			} else {
				_cycle_counter = _cycle_counter + 1;
				[_side, _can_spawn] spawn spawn_random_infantry_group;	
			};
		};	
		
		sleep (120 + (floor random 60));
	};
};

initialize_spawn_battle_groups = {	
	[West] spawn spawn_battle_groups;
	[East] spawn spawn_battle_groups;
	[Independent] spawn spawn_battle_groups;
};




