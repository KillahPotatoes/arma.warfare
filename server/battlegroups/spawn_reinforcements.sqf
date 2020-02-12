
ARWA_calculate_infantry_weight = {
	params ["_side", "_pos"];

	private _spawn_pos = [_side, _pos] call ARWA_get_closest_infantry_spawn_pos;
	private _distance_closest_safe_sector = _spawn_pos distance _pos;

	((ARWA_infantry_reinforcement_distance - _distance_closest_safe_sector) / ARWA_infantry_reinforcement_distance) max 0;
};

ARWA_calcuate_vehicle_weight = {
	params ["_side", "_pos"];

	private _road_at_target = (_pos nearRoads ARWA_sector_size);
	if(_road_at_target isEqualTo []) exitWith { 0; };

	private _pos_hq = [_side] call ARWA_get_hq_pos;

	((ARWA_mission_size - (_pos distance _pos_hq)) / ARWA_mission_size) max 0.1;
};

ARWA_calcuate_heli_weight = {
	params ["_side", "_pos"];

	private _available_helis = _side call ARWA_get_transport_heli_type;

	if(_available_helis isEqualTo []) exitWith { 0; };

	(1 - ([_side, _pos] call ARWA_calcuate_vehicle_weight)) min 0.5;
};

ARWA_try_spawn_reinforcements = {
	params ["_side", "_target"];
	private _unit_count = _side call ARWA_count_battlegroup_units;
	private _can_spawn = ([] call ARWA_get_unit_cap) - _unit_count;

	format["%2: Checking reinforcements: Can spawn %1, required: %3", _can_spawn, _side, ARWA_squad_cap/2] spawn ARWA_debugger;

	if (_can_spawn > (ARWA_squad_cap / 2) && (_side call ARWA_has_manpower)) exitWith {
		private _pos = getPos _target;

		private _reinforcement_types = [
			ARWA_KEY_infantry,
			[_side, _pos] call ARWA_calculate_infantry_weight,
			ARWA_KEY_vehicle,
			[_side, _pos] call ARWA_calcuate_vehicle_weight,
			ARWA_KEY_helicopter,
			[_side, _pos] call ARWA_calcuate_heli_weight
		];

		format["%2: Checking reinforcements: %1", _reinforcement_types, _side] spawn ARWA_debugger;

		private _reinforcement_type = selectRandomWeighted _reinforcement_types;
		private _target_name = _target getVariable ARWA_KEY_target_name;
		format["%2: Seing reinforcing: %1 to %3", _reinforcement_type, _side, _target_name] spawn ARWA_debugger;

		if(_reinforcement_type isEqualTo ARWA_KEY_infantry) exitWith {
			[_side, _can_spawn, _target] spawn ARWA_spawn_reinforcement_squad;
			true;
		};

		if(_reinforcement_type isEqualTo ARWA_KEY_helicopter) exitWith {
			[_side, _can_spawn, _pos, _target, [false, true]] spawn ARWA_do_helicopter_insertion;

			true;
		};

		if(_reinforcement_type isEqualTo ARWA_KEY_vehicle) exitWith {
			[_side, _can_spawn, _target] spawn ARWA_spawn_reinforcement_vehicle_group;
			true;
		};
	};

	false;
};