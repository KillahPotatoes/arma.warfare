initialize_spawn_vehicle_groups = {
	params ["_side"];

	sleep 120;		

	while {true} do {
		[_side] spawn spawn_vehicle_groups;
		sleep 300 + (random + 120);
	};
};

initialize_spawn_infantry_groups = {
	params ["_side"];

	sleep 10;		

	while {true} do {
		[_side] spawn spawn_infantry_groups;
		sleep 120 + (random 60);
	};
};

initialize_spawn_battle_groups = {	
	[West] spawn initialize_spawn_infantry_groups;
	[East] spawn initialize_spawn_infantry_groups;
	[Independent] spawn initialize_spawn_infantry_groups;

	[West] spawn initialize_spawn_vehicle_groups;
	[East] spawn initialize_spawn_vehicle_groups;
	[Independent] spawn initialize_spawn_vehicle_groups;
};




