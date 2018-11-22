add_soldiers_to_helicopter_cargo = {
	params ["_veh_array", "_can_spawn"];

	private _vehicle = _veh_array select 0;
	private _crew_count = count (_veh_array select 1);
	private _side = side (_veh_array select 2);
	private _cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	private _cargo = (_cargoCapacity min _can_spawn) min squad_cap;
	private _group = [[0,0,0], _side, _cargo, false] call spawn_infantry;	
	[_group, false] call add_battle_group;

	{
		_x moveInCargo _vehicle;    
	} forEach units _group;

	_group;
};

pick_sector = {
	params ["_side"];

	private _sectors = [_side] call get_unsafe_sectors;
	
	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };

	_sectors = [] call get_unowned_sectors;	

	if(!(_sectors isEqualTo [])) exitWith { selectRandom _sectors };

	_sectors = [_side] call find_enemy_sectors;
	
	selectRandom _sectors;
};

helicopter_insertion = {
	params ["_side", "_can_spawn"];
	
	private _sector = [_side] call pick_sector;
	
	if (isNil "_sector") exitWith {};

	private _safe = !([_side, _sector getVariable pos] call any_enemies_in_sector);

	private _spawn_pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
	private _sector_pos = _sector getVariable pos;
	private _dir = _sector_pos getDir _spawn_pos;
	private _distance = if(_safe) then { 0; } else { 500 + (random 500); };

	private _pos = [_sector_pos, _distance, _dir] call BIS_fnc_relPos;

	[_side, _can_spawn, _pos, _sector getVariable sector_name] spawn do_helicopter_insertion;
};

do_helicopter_insertion = {
	params ["_side", "_can_spawn", "_pos", "_sector_name"];

	private _heli = [_side] call spawn_transport_heli;
	private _group = [_heli, _can_spawn] call add_soldiers_to_helicopter_cargo;
	private _name = (typeOf (_heli select 0)) call get_vehicle_display_name;

	[_side, format["%1 inserting squad of %2 near %3", _name, count units _group, [_sector_name] call replace_underscore]] spawn HQ_report;
	[_heli select 2, _heli select 0, _pos] call move_to_sector_outskirt; 
	
	[_group, _heli select 0] call dispatch_heli_battlegroup;	
	[_heli select 2, _heli select 0] spawn take_off_and_despawn; 	
};

dispatch_heli_battlegroup = {
	params ["_grp", "_heli_vehicle"];

	[_heli_vehicle] spawn toggle_damage_while_landing;

	{
		unassignVehicle _x;
	} forEach units _grp;

	_grp setVariable ["active", true];	
};

move_to_sector_outskirt = {
	params ["_heli_group", "_heli_vehicle", "_pos"];

	_heli_group move _pos;

	sleep 3;

	waitUntil {
		alive _heli_vehicle && unitReady _heli_vehicle
	};
};

try_spawn_heli_reinforcements = {
	params ["_side", "_sector"];
	private _unit_count = _side call count_battlegroup_units;	
	private _can_spawn = unit_cap - _unit_count; 

	if (_can_spawn > (squad_cap / 2)) exitWith {
		private _pos = _sector getVariable pos;
		[_side, _can_spawn, _pos, _sector getVariable sector_name] spawn do_helicopter_insertion;
		true;
	};	
	false;
};
