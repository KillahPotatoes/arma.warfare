ARWA_spawn_interceptor = {
	params ["_class_name", "_penalty", "_side", "_pos", "_dir"];

	waitUntil { [_pos] call ARWA_is_air_space_clear; };

	private _veh_arr = [_pos, _dir, _class_name, _side, _penalty] call ARWA_spawn_vehicle;
	private _veh = _veh_arr select 0;

	[_veh] call ARWA_set_interceptor_velocity;

	_veh_arr;
};

ARWA_find_spawn_pos_air = {
	params ["_side", "_distance", ["_height", 0]];

	private _pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _dir = _pos getDir ARWA_grid_center;

	_pos = ARWA_grid_center getPos [(_distance + (ARWA_grid_size / 2)), _dir - 180];
	_pos = [_pos select 0, _pos select 1, (_pos select 2) + _height];

	_pos;
};

ARWA_find_spawn_dir_air = {
	params ["_pos"];

	private _dir = _pos getDir ARWA_grid_center;

	_dir;
};

ARWA_set_interceptor_velocity = {
	params ["_veh"];

	private _vel_veh = velocity _veh;
	private _dir_veh = direction _veh;
	private _speed_veh = 100;

	_veh setVelocity [
		(_vel_veh select 0) + (sin _dir_veh * _speed_veh),
		(_vel_veh select 1) + (cos _dir_veh * _speed_veh),
		(_vel_veh select 2)
	];
};
