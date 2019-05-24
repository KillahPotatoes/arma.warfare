ARWA_add_soldiers_to_helicopter_cargo = {
	params ["_veh_array", "_can_spawn"];

	private _vehicle = _veh_array select 0;
	private _crew_count = count (_veh_array select 1);
	private _side = side (_veh_array select 2);
	private _cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	private _cargo = (_cargoCapacity min _can_spawn) min ARWA_squad_cap;
	private _group = [[0,0,0], _side, _cargo, false] call ARWA_spawn_infantry;
	[_group, false] call ARWA_add_battle_group;

	{
		_x moveInCargo _vehicle;
	} forEach units _group;

	_group;
};

ARWA_pick_most_valued_player_owned_sector = {
	params ["_side"];

	_sectors = [_side] call ARWA_find_enemy_sectors;

	if(_sectors isEqualTo []) exitWith {};

	_sectors = _sectors select { (_x getVariable ARWA_KEY_owned_by) countSide allPlayers > 0 };

	if(_sectors isEqualTo []) exitWith {};

	_sectors = _sectors apply { [([_x] call ARWA_get_sector_manpower), _x] };
	_sectors sort false;

	(_sectors select 0) select 1;
};

ARWA_pick_sector = {
	params ["_side"];

	_sectors = [] call ARWA_get_unowned_sectors;

	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };

	_sectors = [_side] call ARWA_find_enemy_sectors;

	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };
};

ARWA_special_forces_insertion = {
	params ["_side", "_can_spawn", "_sector"];

	private _safe = !([_side, _sector getVariable ARWA_KEY_pos] call ARWA_any_enemies_in_sector);

	private _spawn_pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _sector_pos = _sector getVariable ARWA_KEY_pos;
	private _dir = _sector_pos getDir _spawn_pos;
	private _distance = if(_safe) then { 0; } else { 500 + (random 500); };

	private _pos = [_sector_pos, _distance, _dir] call BIS_fnc_relPos;

	[_side, _can_spawn, _pos, _sector, [true, true]] spawn ARWA_do_helicopter_insertion;
};

ARWA_helicopter_insertion = {
	params ["_side", "_can_spawn"];

	private _sector = [_side] call ARWA_pick_sector;

	if (isNil "_sector") exitWith {};

	private _safe = !([_side, _sector getVariable ARWA_KEY_pos] call ARWA_any_enemies_in_sector);

	private _spawn_pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _sector_pos = _sector getVariable ARWA_KEY_pos;
	private _dir = _sector_pos getDir _spawn_pos;
	private _distance = if(_safe) then { 0; } else { 500 + (random 500); };

	private _pos = [_sector_pos, _distance, _dir] call BIS_fnc_relPos;

	[_side, _can_spawn, _pos, _sector] spawn ARWA_do_helicopter_insertion;
};

ARWA_do_helicopter_insertion = {
	params ["_side", "_can_spawn", "_pos", "_target", ["_mission_attr", [false, false]]];

	private _heli = [_side] call ARWA_spawn_transport_heli;
	private _group = [_heli, _can_spawn] call ARWA_add_soldiers_to_helicopter_cargo;
	private _name = (typeOf (_heli select 0)) call ARWA_get_vehicle_display_name;

	private _has_owner = _target getVariable ARWA_KEY_owned_by;

	private _sector_name = if(isNil "_has_owner") then {
		_target;
	} else {
		[_target getVariable ARWA_KEY_sector_name] call ARWA_replace_underscore;
	};

	[_mission_attr, _group, _target] call ARWA_set_special_mission_attr;

	diag_log format["%5: Inserting %1 soldiers at %2 (special forces: %3 / priority target: %4)", (count units _group), _sector_name, _mission_attr select 0, _mission_attr select 1, _side];
	diag_log format["%1 manpower: %2", _side, [_side] call ARWA_get_strength];

	[_side, ["ARWA_STR_INSERTING_SQUAD", _name, count units _group, _sector_name]] remoteExec ["ARWA_HQ_report_client"];
	[_heli select 2, _heli select 0, _pos] call ARWA_move_to_sector_outskirt;

	[_group, _heli select 0] call ARWA_dispatch_heli_battlegroup;
	[_heli select 2, _heli select 0] spawn ARWA_take_off_and_despawn;
};

ARWA_dispatch_heli_battlegroup = {
	params ["_grp", "_heli_vehicle"];

	[_heli_vehicle] spawn ARWA_toggle_damage_while_landing;

	{
		unassignVehicle _x;
	} forEach units _grp;

	_grp setVariable [ARWA_KEY_active, true];
};

ARWA_move_to_sector_outskirt = {
	params ["_heli_group", "_heli_vehicle", "_pos"];

	_heli_group move _pos;

	sleep 3;

	waitUntil {
		alive _heli_vehicle && unitReady _heli_vehicle
	};
};