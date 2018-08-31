add_soldiers_to_helicopter_cargo = {
	params ["_veh_array", "_can_spawn"];

	private _vehicle = _veh_array select 0;
	private _crew_count = count (_veh_array select 1);
	private _side = side (_veh_array select 2);
	private _cargoCapacity = (_vehicle emptyPositions "cargo") - _crew_count;
	private _cargo = (_cargoCapacity min _can_spawn) min squad_cap;
	private _group = [[0,0,0], _side, _cargo, false] call spawn_infantry;	

	{
		_x moveInCargo _vehicle;    
	} forEach units _group;

	[_group, false] call add_battle_group;

	_group;
};

helicopter_insertion = {
	params ["_side", "_can_spawn"];
	
	private _sector = [_side] call find_random_enemy_sector;

	if (!(_sector isEqualTo [])) exitWith {
		private _spawn_pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
		private _sector_pos = _sector getVariable pos;
		private _dir = _sector_pos getDir _spawn_pos;
		private _pos = [_sector_pos, 500, _dir] call BIS_fnc_relPos;

		[_side, _can_spawn, _pos, _sector getVariable sector_name] spawn do_helicopter_insertion;
	};	
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

