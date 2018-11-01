helo_insertion = {
	params ["_side", "_can_spawn"];
	
	private _sector = [_side] call find_random_other_sector;

	if (!isNil "_sector") exitWith {};

	private _s_pos = _sector getVariable pos;
	private _pos1 = [_s_pos, 200, 600, 1, 0, 0, 0, [], [_s_pos, _s_pos]] call BIS_fnc_findSafePos;
	[_side, _can_spawn, _pos1, (_sector getVariable sector_name)] call do_helo_insertion;
};

do_helo_insertion = {
	params ["_side", "_can_spawn", "_pos1", "_sector_name"];
	private _new_pos = [_pos1 select 0, _pos1 select 1, helo_height];
	private _squad = [_new_pos, _side, _can_spawn] call spawn_squad;

	[_side, format["Paradropping squad of %1 near %2", count units _squad, [_sector_name] call replace_underscore]] spawn HQ_report;
	[units _squad, _pos1] spawn helo;

	_squad addWaypoint [_pos1, 25];

	private _units = units _squad;

	 waitUntil { 
		 ({ isTouchingGround _x && alive _x } count _units) isEqualTo ({ alive _x } count _units) }; 
	
	[_squad] call add_battle_group;
};
