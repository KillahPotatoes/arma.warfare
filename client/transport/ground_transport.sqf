vehicle_transport_wait_period = 0;

send_vehicle_transport = {
	params ["_veh_group", "_veh_vehicle", "_pos"];

	_veh_group move _pos;
	sleep 3;
	waitUntil { !(alive _veh_vehicle) || (unitReady _veh_vehicle) };
};

spawn_vehicle = {
	params ["_side", "_penalty"];

	private _base_marker_name = [_side, _type] call get_prefixed_name;
	private _base_marker = missionNamespace getVariable _base_marker_name;

	private _pos = getPos _base_marker;

	waitUntil { !([_pos] call any_units_too_close); };

	private _veh = [_pos, getDir _base_marker, _class_name, _side] call BIS_fnc_spawnVehicle;

	(_veh select 0) lockDriver true;
	_veh;	
};