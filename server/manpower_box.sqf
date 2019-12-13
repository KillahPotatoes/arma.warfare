ARWA_create_manpower_box_unit = {
	params ["_victim"];
	private _manpower = _victim getVariable [ARWA_KEY_manpower, 0];
	private _victim_side = side group _victim;

	if(_manpower > 0 || isPlayer _victim) then {
		_victim setVariable [ARWA_KEY_manpower, 0, true];
		private _manpower_box_value = if(isPlayer _victim) then {

			private _player_penalty = ARWA_starting_strength / 10;
			_player_penalty + _manpower;
		} else {
			_manpower;
		};

		private _vehicle = vehicle _victim;

		if(!(_victim isEqualTo _vehicle)) exitWith {
			private _vehicle_manpower = _vehicle getVariable [ARWA_KEY_manpower, 0];
			_vehicle setVariable [ARWA_KEY_manpower, _vehicle_manpower + _manpower_box_value, true];
			[_vehicle, _victim_side] call ARWA_create_manpower_box_vehicle;
		};

		waitUntil { isTouchingGround vehicle _victim; };

		[_manpower_box_value, _victim, _victim_side] spawn ARWA_create_manpower_box;
	};
};

ARWA_create_manpower_box_vehicle = {
	params ["_victim", ["_side", nil]];
	private _manpower = _victim getVariable [ARWA_KEY_manpower, 0];

	_side = if(isNil "_side") then { _victim getVariable ARWA_KEY_owned_by; } else { _side; };

	if(_manpower > 0) then {
		_victim setVariable [ARWA_KEY_manpower, 0, true];
		waitUntil { isTouchingGround vehicle _victim; };
		[_manpower, _victim, _side] spawn ARWA_create_manpower_box;
	};
};

ARWA_pick_responder = {
	params ["_area_controlled_by", "_victim_side", "_safe_pos"];

	format["_victim_side: %1, _area_controlled_by: %2, players_on_victim_side", _victim_side, _area_controlled_by] spawn ARWA_debugger;

	if(_area_controlled_by isEqualTo _victim_side || (playersNumber _victim_side) == 0) exitWith {
		format["1 Sending %1 to get manpower box", _victim_side] spawn ARWA_debugger;
		_victim_side;
	};

	if(_area_controlled_by isEqualTo civilian) exitWith {
		private _enemies = ARWA_all_sides - [_victim_side];
		private _responder = [_enemies, _safe_pos] call ARWA_closest_hq;
		format["2 Sending %1 to get manpower box", _responder] spawn ARWA_debugger;
		_responder;
	};

	format["3 Sending %1 to get manpower box", _area_controlled_by] spawn ARWA_debugger;
	_area_controlled_by;
};

ARWA_create_manpower_box = {
	params ["_manpower", "_victim", "_victim_side"];

	private _pos = getPos _victim;
	private _safe_pos = [_pos, 0, 5, 1, 1, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
	private _manpower_box = ARWA_manpower_box createVehicle (_safe_pos);
	_manpower_box setVariable [ARWA_KEY_manpower, _manpower, true];

	private _color = [_victim_side, true] call BIS_fnc_sideColor;
	private _marker_name = format["%1-%2", ARWA_KEY_manpower_box, time];

	createMarker [_marker_name, _safe_pos];
	_marker_name setMarkerType "mil_dot";
	_marker_name setMarkerColor _color;
	_marker_name setMarkerAlpha 1;

	_marker_name setMarkerText format["%1 MP", _manpower];
	_manpower_box setVariable [ARWA_KEY_pos, _safe_pos];
	_manpower_box setVariable [ARWA_KEY_target_name, "manpower box"];

	private _isWater = surfaceIsWater _safe_pos;

	if(!_isWater) then {
		private _closest_sector = [ARWA_sectors, _safe_pos] call ARWA_find_closest_sector;
		private _area_controlled_by = _closest_sector getVariable [ARWA_KEY_owned_by, civilian];
		private _sector_pos = getPosWorld _closest_sector;
		private _distance_from_sector = _safe_pos distance2D _sector_pos;
		private _distance_to_hq = [ARWA_all_sides, _safe_pos] call ARWA_closest_hq_distance;

		if(_distance_to_hq > ARWA_min_distance_presence) then {
			private _responder = [_area_controlled_by, _victim_side, _safe_pos] call ARWA_pick_responder;
			[_responder, _manpower_box] spawn ARWA_try_spawn_reinforcements;
		};
	};

	[_marker_name, _manpower_box] spawn ARWA_manpower_deterioration;
	[_marker_name, _manpower_box] spawn ARWA_manpower_marker_update;
};

ARWA_manpower_marker_update = {
	params ["_marker_name", "_manpower_box"];

	private _manpower = _manpower_box getVariable [ARWA_KEY_manpower, 0];

	while {_manpower > 0} do {
		_marker_name setMarkerText format["%1 MP", _manpower];

		sleep 1;
		_manpower = _manpower_box getVariable [ARWA_KEY_manpower, 0];
	};

	deleteMarker _marker_name;

	sleep 300;
	deleteVehicle _manpower_box;
};

ARWA_manpower_deterioration = {
	params ["_marker_name", "_manpower_box"];

	sleep ARWA_dropped_manpower_deterioration_time;

	private _manpower = _manpower_box getVariable [ARWA_KEY_manpower, 0];

	while {_manpower > 0} do {
		sleep 10;
		_manpower = (_manpower_box getVariable [ARWA_KEY_manpower, 0]) - 1;
		_manpower_box setVariable [ARWA_KEY_manpower, _manpower, true];
	};
};