ARWA_spawn_helicopter = {
	params ["_side", "_helicopter", "_kill_bonus"];

	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, (_pos select 2) + 100];

	waitUntil { [_pos] call ARWA_is_air_space_clear; };

    private _heli = [_pos, _dir, _helicopter, _side, _kill_bonus] call ARWA_spawn_vehicle; // TODO add kill bonus
	private _veh = _heli select 0;
	(driver _veh) disableAI "LIGHTS";
	_veh lockDriver true;
	_heli;
};

ARWA_is_air_space_clear = {
	params ["_pos"];
	(count (_pos nearEntities [ ["Air"], 100]) == 0);
};

ARWA_get_transport_heli_type = {
	params ["_side"];
	missionNamespace getVariable format["%1_helicopter_transport", _side];
};

ARWA_spawn_transport_heli = {
	params ["_side"];

	private _arr = selectRandom (_side call ARWA_get_transport_heli_type);
	private _class_name = _arr select 0;
	private _kill_bonus = _arr select 1;
    private _veh_arr = [_side, _class_name, _kill_bonus] call ARWA_spawn_helicopter;
	private _veh = _veh_arr select 0;

	private _group = _veh_arr select 2;

	_group setBehaviour "AWARE";
	_group deleteGroupWhenEmpty true;
	_veh_arr;
};

ARWA_land_helicopter = {
	params ["_heli_group", "_heli_vehicle", "_mode", "_pos"];

	_heli_group move _pos;

	sleep 3;

	waitUntil { !(alive _heli_vehicle) || (unitReady _heli_vehicle) };

	if (alive _heli_vehicle) then
	{
		[_heli_vehicle] spawn ARWA_toggle_damage_while_landing;
		_heli_vehicle land _mode;
	};

  	sleep 3;

	waitUntil { !(alive _heli_vehicle) || (isTouchingGround _heli_vehicle) };
};

ARWA_toggle_damage_while_landing = {
	params ["_veh"];

	waitUntil { ((getPosATL _veh) select 2) < 3 };
	_veh allowDamage false;
	waitUntil { isTouchingGround _veh };
	sleep 3;
	_veh allowDamage true;
};

ARWA_take_off_and_despawn = {
	params ["_heli_group", "_heli_vehicle"];

	private _side = side _heli_group;
	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);

	while {alive _heli_vehicle} do {
		_heli_group move _pos;
		_heli_group setCombatMode "BLUE";

		sleep 3;

		waitUntil { !(alive _heli_vehicle) || ((_pos distance2D (getPos _heli_vehicle)) < 200) || (unitReady _heli_vehicle) };

		if ((alive _heli_vehicle) && ((_pos distance2D (getPos _heli_vehicle)) < 200)) exitWith	{
			private _manpower = (_heli_vehicle call ARWA_remove_soldiers) + (_heli_vehicle call ARWA_get_manpower);

			_heli_vehicle setVariable [manpower, 0];

			if(_manpower > 0) then {
				[playerSide, _manpower] remoteExec ["ARWA_buy_manpower_server", 2];
				systemChat format[localize "YOU_ADDED_MANPOWER", _manpower];
			};

			deleteVehicle _heli_vehicle;
			true;
		};

		false;
	};
};

ARWA_remove_soldiers = {
	params ["_veh"];

	private _manpower = 0;

	{
		_manpower = _manpower + (_x call ARWA_get_manpower);
		deleteVehicle _x
	} forEach (crew _veh);

	_manpower;
};