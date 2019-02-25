vehicle_transport_wait_period = 0;
vehicle_transport_timer = time;


send_vehicle_transport = {
	params ["_group", "_veh", "_pos"];

	_group move _pos;

	sleep 3;

	waitUntil { !(alive _veh) || (unitReady _veh) };
};

spawn_vehicle = {
	params ["_side", "_class_name"];

	private _base_marker_name = [_side, vehicle1] call get_prefixed_name;
	private _base_marker = missionNamespace getVariable _base_marker_name;

	private _pos = getPos _base_marker;

	waitUntil { !([_pos] call any_units_too_close); };

	private _veh_arr = [_pos, getDir _base_marker, _class_name, _side] call BIS_fnc_spawnVehicle;
	private _veh = _veh_arr select 0;

	_veh lockDriver true;
	_veh_arr;	
};

send_to_HQ = {
	params ["_group", "_veh"];
	
	private _side = side _group;
	private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);

	_group addWaypoint [_pos, 20];
	
	waitUntil { !(alive _veh) || ((_pos distance2D (getPos _veh)) < 100) };
	
	if (alive _veh) exitWith
	{
		private _manpower = _veh call get_manpower;
		_veh setVariable [manpower, 0];

		if(_manpower > 0) then {
			[playerSide, _manpower] remoteExec ["buy_manpower_server", 2];
			systemChat format[localize "YOU_ADDED_MANPOWER", _manpower];     
		};

		[_veh] call remove_soldiers; 
		deleteVehicle _veh;
		true;
	};

	false;
};