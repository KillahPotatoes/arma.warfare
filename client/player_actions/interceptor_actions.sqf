ARWA_return_interceptor = {
	params ["_vehicle"];
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

	player removeAction _actionId;
};

ARWA_interceptor_safe_zone = {
	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _color = [playerSide, true] call BIS_fnc_sideColor;
	private _marker_name = format ["Interceptor_safe_zone_%1", playerSide];

	private _marker_name_label = format ["Interceptor_safe_zone_%1_label", playerSide];
	createMarker [_marker_name_label, _pos];
	_marker_name_label setMarkerType "hd_dot";
	_marker_name_label setMarkerColor _color;
	_marker_name_label setMarkerText (localize "ARWA_STR_aerial_safe_zone");

	createMarker [_marker_name, _pos];
	_marker_name setMarkerColor _color;
	_marker_name setMarkerShape "ELLIPSE";
	_marker_name setMarkerBrush "Border";
	_marker_name setMarkerSize [ARWA_interceptor_safe_distance,ARWA_interceptor_safe_distance];
};

ARWA_rearm_interceptor = {
	params ["_vehicle"];
	private _give_warning = true;

	while{!(isNil "_vehicle") && {alive _vehicle}} do {
		if([_vehicle] call ARWA_within_interceptor_safe_zone) then {
			private _enemies_nearby = [getPos player, playerSide, ARWA_interceptor_safe_distance] call ARWA_any_enemies_in_area;
			if(_enemies_nearby) exitWith {
				if(_give_warning) then {
					player sideChat localize "ARWA_STR_CANNOT_REARM_INTERCEPTOR";
				};
				_gave_warning = false;
			};
			_gave_warning = true;
			_vehicle setVehicleAmmo 1;
		};
	};
};

ARWA_within_interceptor_safe_zone = {
	params ["_vehicle"];

	private _pos = getMarkerPos ([playerSide, ARWA_KEY_respawn_air] call ARWA_get_prefixed_name);
	private _distance = _pos distance2D (getPos _vehicle);

	_distance < ARWA_interceptor_safe_distance;
};