get_transport_heli_type = {
	params ["_side"];
	missionNamespace getVariable format["%1_transport_helis", _side];
};

spawn_transport_heli = {
	params ["_side"];

	private _transport_heli = selectRandom (_side call get_transport_heli_type);		
    private _veh = [_side, _transport_heli] call spawn_helicopter;

	(_veh select 2) deleteGroupWhenEmpty true;
	_veh;
};

take_off_and_despawn = {
	params ["_veh_array"];
	
	private _heli_group = _veh_array select 2;
	private _heli_vehicle = _veh_array select 0;

	private _side = side _heli_group;

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);

	_heli_group move _pos;

	sleep 3;

	while { ( (alive _heli_vehicle) && !(unitReady _heli_vehicle) ) } do
	{
		sleep 1;
	};

	if (alive _heli_vehicle) then
	{
		{ deleteVehicle _x } forEach (crew _heli_vehicle); 
		deleteVehicle _heli_vehicle;
	};
};

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

	[_heli, "GET OUT", _pos] call land_helicopter; 
	[_group, _heli] call dispatch_heli_battlegroup;
	[_heli] call take_off_and_despawn; 	
};

dispatch_heli_battlegroup = {
	params ["_grp", "_heli"];

	{
		unassignVehicle _x;
	} forEach units _grp;

	_group setVariable ["active", true];
};

land_helicopter = {
	params ["_helicopter", "_mode", "_pos"];

	private _heli_group = _helicopter select 2;
	private _heli_vehicle = _helicopter select 0;

	_heli_group move _pos;

	sleep 3;

	while { ( (alive _heli_vehicle) && !(unitReady _heli_vehicle) ) } do
	{
		sleep 1;
	};

	if (alive _heli_vehicle) then
	{
		_heli_vehicle land _mode;
	};
};
