helo_insertion = {
	params ["_side", "_can_spawn"];
	
	private _sector = [_side] call find_random_enemy_sector;

	if (!(_sector isEqualTo [])) exitWith {
		private _sector_pos = _sector getVariable pos;
		private _pos = [_sector_pos, 400, 600, 0, 0, 20, 0] call BIS_fnc_findSafePos;

		[_side, _can_spawn, _pos, _sector getVariable sector_name] spawn do_helo_insertion;
	};	
};

do_helo_insertion = {
	params ["_side", "_can_spawn", "_pos", "_sector_name"];

	private _new_pos = [_pos select 0, _pos select 1, (_pos select 2) + helo_height];
	private _squad = [_new_pos, _side, _can_spawn] call spawn_squad;

	[_side, format["Paradropping squad of %1 near %2", count units _group, [_sector_name] call replace_underscore]] spawn HQ_report;
	[squad, _pos] spawn helo;
};
