ARWA_spawn_interceptor = {
	params ["_class_name", "_penalty", "_side"];
	private _pos = [_side] call ARWA_find_spawn_pos_and_direction;

	waitUntil { [_pos select 0] call ARWA_is_air_space_clear; };

	private _veh_arr = [_pos select 0, _pos select 1, _class_name, _side, _penalty] call ARWA_spawn_vehicle;
	private _veh = _veh_arr select 0;

	[_veh] call ARWA_set_interceptor_velocity;

	_veh;
};

ARWA_find_spawn_pos_and_direction = {
	params ["_side"];

	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _base_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _dir = _pos getDir _base_pos;
	private _pos = [_pos select 0, _pos select 1, 2000];

	[_pos, _dir];
};

ARWA_set_interceptor_velocity = {
	params ["_veh"];

	private _vel_veh = velocity _veh;
	private _dir_veh = direction _veh;
	private _speed_veh = 300;

	_veh setVelocity [
		(_vel_veh select 0) + (sin _dir_veh * _speed_veh),
		(_vel_veh select 1) + (cos _dir_veh * _speed_veh),
		(_vel_veh select 2)
	];
};
