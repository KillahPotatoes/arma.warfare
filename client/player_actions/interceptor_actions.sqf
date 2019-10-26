ARWA_return_interceptor = {
	params ["_vehicle"];
	systemChat "Adding return interceptor action";
	private _actionId = player addAction [[localize "ARWA_STR_RETURN_INTERCEPTOR", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _vehicle = _arguments select 0;

		private _enemies_nearby = [getPos player, playerSide, ARWA_interceptor_safe_distance] call ARWA_any_enemies_in_area;
		if(_enemies_nearby) exitWith { player sideChat localize "ARWA_STR_CANNOT_RETURN_INTERCEPTOR"; };

		private _base_pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		_safe_pos = [_base_pos, 5, 25, 5, 0, 0, 0, [], [_base_pos, _base_pos]] call BIS_fnc_findSafePos;
		moveOut player;
		player setPos _safe_pos;
		player setVelocity [0,0,0];
		deleteVehicle _vehicle;


	}, [_vehicle], ARWA_interceptor_actions, false, true, "", '[vehicle player] call ARWA_within_interceptor_safe_zone'];
	waitUntil { isNil "_vehicle" || {!(alive _vehicle)}; };

	systemChat "Removing return interceptor action";
	player removeAction _actionId;
};

ARWA_interceptor_safe_zone = {
	systemChat "Draw interceptor safe zone";
	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _color = [playerSide, true] call BIS_fnc_sideColor;
	private _marker_name = format ["Interceptor_safe_zone_%1", playerSide];

	createMarker [_marker_name, _pos];
	_marker_name setMarkerColor _color;
	_marker_name setMarkerShape "ELLIPSE";
	_marker_name setMarkerBrush "Border";
	_marker_name setMarkerSize [ARWA_interceptor_safe_distance,ARWA_interceptor_safe_distance];
};

ARWA_rearm_interceptor = {
	params ["_vehicle"];
	systemChat "adding Rearming interceptor";
	while{!(isNil "_vehicle") && {alive _vehicle}} do {
		if([_vehicle] call ARWA_within_interceptor_safe_zone) then {

			private _enemies_nearby = [getPos player, playerSide, ARWA_interceptor_safe_distance] call ARWA_any_enemies_in_area;
			if(_enemies_nearby) exitWith { player sideChat localize "ARWA_STR_CANNOT_REARM_INTERCEPTOR"; };
			_vehicle setVehicleAmmo 1;
		};
	};
	systemChat "Removing rearm interceptor";
};

ARWA_within_interceptor_safe_zone = {
	params ["_vehicle"];

	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _distance = _pos distance2D (getPos _vehicle);

	_distance < ARWA_interceptor_safe_distance;
};