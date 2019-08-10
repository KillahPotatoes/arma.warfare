ARWA_infantry_reinforcement_distance = 2000;

ARWA_calculate_mission_size = {
	private _west_respawn_pos = getMarkerPos ([West, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _east_respawn_pos = getMarkerPos ([East, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _guer_respawn_pos = getMarkerPos ([Independent, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);

	ARWA_vehicle_reinforcement_distance = ((_west_respawn_pos distance2D _east_respawn_pos) + (_west_respawn_pos distance2D _guer_respawn_pos) + (_east_respawn_pos distance2D _guer_respawn_pos)) / 3;
};

ARWA_calculate_infantry_weight = {
	params ["_side", "_pos"];

	private _spawn_pos = [_side, _pos] call ARWA_get_closest_infantry_spawn_pos;
	private _distance_closest_safe_sector = _spawn_pos distance _pos;

	((ARWA_infantry_reinforcement_distance - _distance_closest_safe_sector) / ARWA_infantry_reinforcement_distance) max 0;
};

ARWA_is_connected_by_road_to_hq = {
	params ["_side", "_pos"];

	private _respawn_marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos_hq = getMarkerPos _respawn_marker;

	private _road_at_target = (_pos nearRoads 100) select 0;
	private _road_at_hq = (_pos_hq nearRoads 100) select 0;

	_connectedRoads = roadsConnectedTo _road_at_target;

	_road_at_hq in _connectedRoads;
};

ARWA_calcuate_vehicle_weight = {
	params ["_side", "_pos"];

	private _respawn_marker = [_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name;
	private _pos_hq = getMarkerPos _respawn_marker;

	private _is_connected = [_side, _pos] call ARWA_is_connected_by_road_to_hq;

	((ARWA_vehicle_reinforcement_distance - (_pos distance _pos_hq)) / ARWA_vehicle_reinforcement_distance) max 0.1;
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

	diag_log format["%2: Checking reinforcements: Can spawn %1, required: %3", _can_spawn, _side, ARWA_squad_cap/2];

	if (_can_spawn > (ARWA_squad_cap / 2) && (_side call ARWA_has_manpower)) exitWith {
		private _pos = _target getVariable ARWA_KEY_pos;

		private _reinforcement_types = [
			ARWA_KEY_infantry,
			[_side, _pos] call ARWA_calculate_infantry_weight,
			ARWA_KEY_vehicle,
			[_side, _pos] call ARWA_calcuate_vehicle_weight,
			ARWA_KEY_helicopter,
			[_side, _pos] call ARWA_calcuate_heli_weight
		];

		diag_log format["%2: Checking reinforcements: %1", _reinforcement_types, _side];

		private _reinforcement_type = selectRandomWeighted _reinforcement_types;
		diag_log format["%2: Reinforcing: %1", _reinforcement_type, _side];

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