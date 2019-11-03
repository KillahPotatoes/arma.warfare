ARWA_return_interceptor = {
	params ["_vehicle"];
	private _actionId = player addAction [[localize "ARWA_STR_RETURN_INTERCEPTOR", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _vehicle = _arguments select 0;

		private _enemies_nearby = [getPos player, playerSide, 2000] call ARWA_any_enemies_in_area;
		if(_enemies_nearby) exitWith { player sideChat localize "ARWA_STR_CANNOT_RETURN_INTERCEPTOR"; };

		private _base_pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		_safe_pos = [_base_pos, 5, 25, 5, 0, 0, 0, [], [_base_pos, _base_pos]] call BIS_fnc_findSafePos;
		moveOut player;
		player setPos _safe_pos;
		player setVelocity [0,0,0];
		deleteVehicle _vehicle;


	}, [_vehicle], ARWA_interceptor_actions, false, true, "", '[vehicle player] call ARWA_outside_radar_zone'];
	waitUntil { isNil "_vehicle" || {!(alive _vehicle)}; };

	player removeAction _actionId;
};

ARWA_rearm_interceptor = {
	params ["_vehicle"];

	while{!(isNil "_vehicle") && {alive _vehicle}} do {
		if([_vehicle] call ARWA_outside_radar_zone) then {
			_vehicle setVehicleAmmo 1;
		};
	};
};

ARWA_outside_radar_zone = {
	params ["_vehicle"];

	private _distance = ARWA_grid_center distance2D (getPos _vehicle);
	_distance > (ARWA_interceptor_safe_distance + (ARWA_grid_size / 2));
};