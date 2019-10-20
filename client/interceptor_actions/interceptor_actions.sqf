ARWA_return_interceptor = {
	player addAction [[localize "ARWA_STR_RETURN_INTERCEPTOR", 0] call ARWA_add_action_text, {
		
		private _enemies_nearby = [getPos player, playerSide, ARWA_interceptor_safe_distance] call ARWA_any_enemies_in_area;
		if(_enemies_nearby) exitWith { player sideChat localize ARWA_KEY_STR; };

		private _veh = vehicle player;
		private _base_pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		_safe_pos = [_base_pos, 5, 25, 5, 0, 0, 0, [], [_base_pos, _base_pos]] call BIS_fnc_findSafePos;
		moveOut player;
		player setPos _safe_pos;
		deleteVehicle _veh;

	}, [], ARWA_interceptor_actions, false, true, "", '[] call ARWA_can_take_lead', 10]
};

ARWA_interceptor_safe_zone = {
	params ["_pos", "_side"];

	private _color = [_side, true] call BIS_fnc_sideColor;
	private _marker_name = format ["Interceptor_safe_zone_%1", _side];

	createMarker [_marker_name, _pos];
	_marker_name setMarkerColor _color;
	_marker_name setMarkerShape "POLYLINE";
	_marker_name setMarkerBrush "SolidBorder";
	_marker_name setMarkerSize [2000,2000];
};

ARWA_rearm_interceptor = {
	params ["_vehicle"];

	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _distance = _pos distance2D (getPos _vehicle);

	while(!(isNil "_vehicle")) do {
		if(_distance < ARWA_interceptor_safe_distance) then {
			_vehicle setVehicleAmmo 1;
			sleep 60;
		};
	};
};
