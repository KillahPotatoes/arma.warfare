ARWA_add_soldiers_to_air_cargo = {
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

	private _sectors = [_side] call ARWA_find_enemy_sectors;

	if(_sectors isEqualTo []) exitWith {};

	_sectors = _sectors select { playersNumber (_x getVariable ARWA_KEY_owned_by) > 0 };

	if(_sectors isEqualTo []) exitWith {};

	_sectors = _sectors apply { [([_x] call ARWA_get_sector_manpower), _x] };
	_sectors sort false;

	(_sectors select 0) select 1;
};

ARWA_pick_sector = {
	params ["_side"];

	private _sectors = [] call ARWA_get_unowned_sectors;

	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };

	_sectors = [_side] call ARWA_find_enemy_sectors;

	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };
};

ARWA_special_forces_insertion = {
	params ["_side", "_can_spawn", "_sector"];

	private _available_helis = !((_side call ARWA_get_transport_heli_type) isEqualTo []);

	if(selectRandom[_available_helis, false]) then {
		private _pos = [_side, _sector] call ARWA_find_insertion_location;
		[_side, _can_spawn, _pos, _sector, [true, true]] spawn ARWA_do_helicopter_insertion;
	} else {
		[_side, _can_spawn, _sector, [true, true]] call ARWA_do_paradrop_insertion;
	};


};

ARWA_find_insertion_location = {
	params ["_side", "_sector"];

	private _safe = !([_side, _sector getVariable ARWA_KEY_pos] call ARWA_any_enemies_in_sector);

	private _spawn_pos = [_side, ARWA_helicopter_safe_distance] call ARWA_find_spawn_pos_air;
	private _sector_pos = _sector getVariable ARWA_KEY_pos;
	private _dir = [_spawn_pos, ARWA_grid_center] call ARWA_find_spawn_dir_air;

	private _distance = if(_safe) then { 0; } else { 500 + (random 500); };
	[_sector_pos, _distance, _dir] call BIS_fnc_relPos;
};

ARWA_do_paradrop_insertion = {
	params ["_side", "_can_spawn", "_target", ["_mission_attr", [false, false]]];

	private _target_pos = _target getVariable ARWA_KEY_pos;
	private _veh_array = [_target_pos, _side] call ARWA_spawn_paradrop_plane;

	private _vehicle = _veh_array select 0;
	private _crew_count = count (_veh_array select 1);
	private _cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	private _cargo = (_cargoCapacity min _can_spawn) min ARWA_squad_cap;
	private _group = [[0,0,0], _side, _cargo, false] call ARWA_spawn_infantry;

	[_mission_attr, _group, _target] call ARWA_set_special_mission_attr;
	[_group, false] call ARWA_add_battle_group;
	[_target_pos, _veh_array, units _group, _side] spawn ARWA_perform_paradrop;
};

ARWA_airborne_insertion = {
	params ["_side", "_can_spawn"];

	private _available_helis = !((_side call ARWA_get_transport_heli_type) isEqualTo []);

	private _sector = [_side] call ARWA_pick_sector;

	if (isNil "_sector") exitWith {};

	if(selectRandom[_available_helis, false]) then {
		private _pos = [_side, _sector] call ARWA_find_insertion_location;
		[_side, _can_spawn, _pos, _sector] spawn ARWA_do_helicopter_insertion;
	} else {
		[_side, _can_spawn, _sector] call ARWA_do_paradrop_insertion;
	};
};

ARWA_do_helicopter_insertion = {
	params ["_side", "_can_spawn", "_pos", "_target", ["_mission_attr", [false, false]]];

	private _heli = [_side] call ARWA_spawn_transport_heli;
	private _group = [_heli, _can_spawn] call ARWA_add_soldiers_to_air_cargo;
	private _name = (typeOf (_heli select 0)) call ARWA_get_vehicle_display_name;
	private _target_name = _target getVariable ARWA_KEY_target_name;

	[_mission_attr, _group, _target] call ARWA_set_special_mission_attr;

	format["%5: Inserting %1 soldiers at %2 (special forces: %3 / priority target: %4)", (count units _group), [_target_name] call ARWA_replace_underscore, _mission_attr select 0, _mission_attr select 1, _side] spawn ARWA_debugger;
	format["%1 manpower: %2", _side, [_side] call ARWA_get_strength] spawn ARWA_debugger;

	[_side, ["ARWA_STR_INSERTING_SQUAD", _name, count units _group, [_target_name] call ARWA_replace_underscore]] remoteExec ["ARWA_HQ_report_client"];
	[_heli select 2, _heli select 0, _pos] call ARWA_move_to_sector_outskirt;

	[_group, _heli select 0] call ARWA_dispatch_heli_battlegroup;
	[_heli select 2, _heli select 0, ARWA_helicopter_safe_distance] spawn ARWA_despawn_air;
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