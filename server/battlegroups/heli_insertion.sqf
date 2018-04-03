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

do_helicopter_insertion = {
	params ["_side", "_can_spawn", "_pos", "_sector_name"];

	private _heli = [_side] call spawn_transport_heli;
	private _group = [_heli, _can_spawn] call add_soldiers_to_helicopter_cargo;

	private _name = (typeOf (_heli select 0)) call get_vehicle_display_name;	
	[_side, format["%1 inserting squad of %2 near %3", _name, count units _group, [_sector_name] call replace_underscore]] spawn report_incoming_support;

	[_heli select 2, _heli select 0, "GET OUT", _pos] call land_helicopter; 
	[_group, _heli] call dispatch_heli_battlegroup;
	[_heli select 2, _heli select 0] spawn take_off_and_despawn; 	
};

dispatch_heli_battlegroup = {
	params ["_grp", "_heli"];

	{
		unassignVehicle _x;
	} forEach units _grp;

	_group setVariable ["active", true];
};

