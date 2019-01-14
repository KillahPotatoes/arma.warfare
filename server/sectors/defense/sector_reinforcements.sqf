arwa_infantry_reinforcement_distance = 2000;

calculate_mission_size = {
	private _west_respawn_pos = getMarkerPos ([West, respawn_ground] call get_prefixed_name);
	private _east_respawn_pos = getMarkerPos ([East, respawn_ground] call get_prefixed_name);
	private _guer_respawn_pos = getMarkerPos ([Independent, respawn_ground] call get_prefixed_name);

	arwa_vehicle_reinforcement_distance = ((_west_respawn_pos distance2D _east_respawn_pos) + (_west_respawn_pos distance2D _guer_respawn_pos) + (_east_respawn_pos distance2D _guer_respawn_pos)) / 3;
};

calculate_infantry_weight = {
	params ["_side", "_sector"];

	private _pos = _sector getVariable pos;
	private _spawn_pos = [_side, _sector] call get_closest_infantry_spawn_pos;
	private _distance_closest_safe_sector = _spawn_pos distance _pos;

	((arwa_infantry_reinforcement_distance - _distance_closest_safe_sector) / arwa_infantry_reinforcement_distance) max 0;
};

calcuate_vehicle_weight = {
	params ["_side", "_sector"];

	private _pos = _sector getVariable pos;
	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos_hq = getMarkerPos _respawn_marker;

	((arwa_vehicle_reinforcement_distance - (_pos distance _pos_hq)) / arwa_vehicle_reinforcement_distance) max 0.1;
};

calcuate_heli_weight = {
	params ["_side", "_sector"];

	(1 - ([_side, _sector] call calcuate_vehicle_weight)) min 0.5;
};

try_spawn_reinforcements = {
	params ["_side", "_sector"];
	private _unit_count = _side call count_battlegroup_units;	
	private _can_spawn = arwa_unit_cap - _unit_count; 
	private _rnd = random 100;

	if (_can_spawn > (arwa_squad_cap / 2) && (_rnd > 95) && (_side in active_factions)) exitWith {
		private _pos = _sector getVariable pos;

		private _reinforcement_type = selectRandomWeighted [
			infantry,
			[_side, _sector] call calculate_infantry_weight,
			vehicle1,
			[_side, _sector] call calcuate_vehicle_weight,
			helicopter,
			[_side, _sector] call calcuate_heli_weight
		];

		if(_reinforcement_type isEqualTo infantry) exitWith {
			[_side, _can_spawn, _sector] spawn spawn_reinforcement_squad;
			true;
		};

		if(_reinforcement_type isEqualTo helicopter) exitWith {
			[_side, _can_spawn, _pos, _sector, [false, true]] spawn do_helicopter_insertion;		

			true;
		};

		if(_reinforcement_type isEqualTo vehicle1) exitWith {
			[_side, _can_spawn, _sector] spawn spawn_reinforcement_vehicle_group;
			true;
		};		
	};	
	
	false;
};