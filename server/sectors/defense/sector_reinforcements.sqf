calculate_infantry_weight = {
	params ["_side", "_sector"];

	private _pos = _sector getVariable pos;
	private _safe_sectors = [_side, arwa_sector_size] call get_safe_sectors;

	if((_safe_sectors isEqualTo [])) exitWith { 0; }

	private _closest_safe_sectors = [_safe_sectors, _pos] call find_closest_sector;
	private _distance_closest_safe_sector = (_closest_safe_sector getVariable pos) distance _pos;

	((3000 - _distance_closest_safe_sector) / 3000) max 0;
};

calcuate_vehicle_weight = {
	params ["_side", "_sector"];

	private _pos = _sector getVariable pos;
	private _frontline_sectors = ["_side"] call find_preferred_targets;

	if(!(_sector in _frontline_sectors)) exitWith { 0; }

	private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos_hq = getMarkerPos _respawn_marker;

	((10000 - (_pos distance _pos_hq)) / 10000) max 0;
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
			([_side, _sector] call calculate_infantry_weight),
			vehicle1,
			([_side, _sector] call calcuate_vehicle_weight),
			helicopter,
			0.5
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