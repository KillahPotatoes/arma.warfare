create_manpower_box_unit = {
	params ["_victim", "_side", ["_faction_strength", 0]];
	private _manpower = _victim getVariable [manpower, 0];

	if(_manpower > 0 || isPlayer _victim) then {
		_victim setVariable [manpower, 0, true];
		private _manpower_box_value = if(isPlayer _victim) then {
			private _player_penalty = [_faction_strength] call ARWA_calculate_player_death_penalty;
			_player_penalty + _manpower;
		} else {
			_manpower;
		};

		if(!(isTouchingGround _victim)) then {
			sleep 30;
		};

		[_manpower_box_value, _victim, _side] spawn create_manpower_box;
	};
};

create_manpower_box_vehicle = {
	params ["_victim"];
	private _manpower = _victim getVariable [manpower, 0];

	if(_manpower > 0) then {
		_victim setVariable [manpower, 0, true];
		private _side = _victim getVariable owned_by;

		if(!(isTouchingGround _victim)) then {
			sleep 30;
		};

		[_manpower, _victim, _side] spawn create_manpower_box;
	};
};

create_manpower_box = {
	params ["_manpower", "_victim", "_victim_side"];

	private _pos = getPos _victim;
	private _safe_pos = [_pos, 0, 5, 1, 1, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
	private _manpower_box = manpower_box createVehicle (_pos);
	_manpower_box setVariable [manpower, _manpower, true];

	private _color = [_victim_side, true] call BIS_fnc_sideColor;
	private _marker_name = format["%1-%2", "manpower-box", time];

	createMarker [_marker_name, _safe_pos];
	_marker_name setMarkerType "mil_dot";
	_marker_name setMarkerColor _color;
	_marker_name setMarkerAlpha 1;

	_marker_name setMarkerText format["%1 MP", _manpower];

	[_marker_name, _manpower_box] spawn manpower_deterioration;
	[_marker_name, _manpower_box] spawn manpower_marker_update;
};

manpower_marker_update = {
	params ["_marker_name", "_manpower_box"];

	private _manpower = _manpower_box getVariable [manpower, 0];

	while {_manpower > 0} do {
		_marker_name setMarkerText format["%1 MP", _manpower];

		sleep 1;
		_manpower = _manpower_box getVariable [manpower, 0];
	};

	deleteMarker _marker_name;

	sleep 60;
	deleteVehicle _manpower_box;
};

manpower_deterioration = {
	params ["_marker_name", "_manpower_box"];

	sleep ARWA_dropped_manpower_deterioration_time;

	private _manpower = _manpower_box getVariable [manpower, 0];

	while {_manpower > 0} do {
		sleep 10;
		_manpower = (_manpower_box getVariable [manpower, 0]) - 1;
		_manpower_box setVariable [manpower, _manpower, true];
	};
};