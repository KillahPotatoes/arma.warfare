helicopter_transport_wait_period = 0;

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