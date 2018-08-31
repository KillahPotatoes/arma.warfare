spawn_helicopter = {
	params ["_side", "_helicopter"];

	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];

	waitUntil { [_pos] call is_air_space_clear; };

    private _heli = [_pos, _dir, _helicopter, _side] call BIS_fnc_spawnVehicle;

	(_heli select 0) lockDriver true;
	_heli;
};

get_transport_heli_type = {
	params ["_side"];
	missionNamespace getVariable format["%1_helicopter_transport", _side];
};

spawn_transport_heli = {
	params ["_side"];

	private _arr = selectRandom (_side call get_transport_heli_type);	
	private _class_name = _arr select 0;		
    private _veh = [_side, _class_name] call spawn_helicopter;

	private _group = _veh select 2;
	
	_group setBehaviour "AWARE";
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
	_veh allowDamage false;
	waitUntil { isTouchingGround _veh };
	sleep 3;
	_veh allowDamage true;
};

take_off_and_despawn = {
	params ["_heli_group", "_heli_vehicle"];
	
	private _side = side _heli_group;
	private _pos = getMarkerPos ([_side, respawn_air] call get_prefixed_name);

	_heli_group move _pos;

	waitUntil { !(alive _heli_vehicle) || ((_pos distance2D (getPos _heli_vehicle)) < 200) };
	
	if (alive _heli_vehicle) exitWith
	{
		[_heli_vehicle] call remove_soldiers; 
		deleteVehicle _heli_vehicle;
		true;
	};

	false;
};

remove_soldiers = {
	params ["_heli_vehicle"];
	{ 
		if(hasInterface && ((group _x) isEqualTo (group player))) then {
			_x call refund;
		};
		
		deleteVehicle _x 
	} forEach (crew _heli_vehicle); 
};

refund = {
	params ["_soldier"];

	private _side = side _soldier;
	private _soldier_types = missionNamespace getVariable format["%1_buy_infantry", _side];
	private _manpower = player getVariable [manpower, 0];

	{
		if ((typeOf _soldier) isEqualTo (_x select 1)) then {
			private _price = _x select 2;
			player setVariable [manpower, _manpower + _price];
			systemChat format["A soldier has been refunded for %1", _price];
		};
	} forEach _soldier_types;
};
