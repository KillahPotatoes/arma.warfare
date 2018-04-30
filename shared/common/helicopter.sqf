spawn_helicopter = {
	params ["_side", "_helicopter"];

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);

	private _dir = _pos getDir _base_pos;

	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];
    private _heli = [_pos, _dir, _helicopter, _side] call BIS_fnc_spawnVehicle;

	(_heli select 0) lockDriver true;

	_heli;
};

get_transport_heli_type = {
	params ["_side"];
	missionNamespace getVariable format["%1_transport_helis", _side];
};

spawn_transport_heli = {
	params ["_side"];

	private _transport_heli = selectRandom (_side call get_transport_heli_type);		
    private _veh = [_side, _transport_heli] call spawn_helicopter;

	private _group = _veh select 2;
	
	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_veh;
};

land_helicopter = {
	params ["_heli_group", "_heli_vehicle", "_mode", "_pos"];

	_heli_group move _pos;

	sleep 3;

	while { ( (alive _heli_vehicle) && !(unitReady _heli_vehicle) ) } do
	{
		sleep 1;
	};

	if (alive _heli_vehicle) then
	{	
		[_heli_vehicle] spawn toggle_damage_while_landing;
		_heli_vehicle land _mode;
	};

  	sleep 3;

	while { ( (alive _heli_vehicle) && !(isTouchingGround _heli_vehicle) ) } do
	{
		sleep 1;
	};		
};

toggle_damage_while_landing = {
	params ["_veh"];

	waitUntil { ((getPosATL _veh) select 2) < 3 };
	systemChat "Allow damage: false";
	_veh allowDamage false;
	waitUntil { isTouchingGround _veh };
	sleep 3;
	systemChat "Allow damage: true";
	_veh allowDamage true;
};

take_off_and_despawn = {
	params ["_heli_group", "_heli_vehicle"];
	
	private _side = side _heli_group;

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);

	_heli_group move _pos;

	sleep 3;

	while { ( (alive _heli_vehicle) && !(unitReady _heli_vehicle) ) } do
	{
		sleep 1;
	};

	if (alive _heli_vehicle) exitWith
	{
		{ deleteVehicle _x } forEach (crew _heli_vehicle); 
		deleteVehicle _heli_vehicle;
		true;
	};

	false;
};