create_manpower_box = {
	params ["_victim", ["_faction_strength", 0]];
	private _manpower = _victim getVariable [manpower, 0];
	
	if(_manpower > 0 || isPlayer _victim) then {
		_victim setVariable [manpower, 0];
		private _manpower_box_value = if(isPlayer _victim) then { 			
			private _player_penalty = [_faction_strength] call calculate_player_death_penalty;
			_player_penalty + _manpower;
		} else {
			_manpower;
		};

		if(!(isTouchingGround _victim)) then {
			sleep 30;
		};		

		private _pos = getPos _victim;
		private _safe_pos = [_pos, 0, 5, 1, 1, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
		private _manpower_box = manpower_box createVehicle (_pos);
		_manpower_box setVariable [manpower, _manpower_box_value];

		private _victim_side = side group _victim;
		private _color = [_victim_side, true] call BIS_fnc_sideColor;
		private _marker_name = format["%1-%2", "manpower-box", time];

		createMarker [_marker_name, _safe_pos]; 
		_marker_name setMarkerType "mil_dot";
		_marker_name setMarkerColor _color;
		_marker_name setMarkerAlpha 1;
		
		_marker_name setMarkerText format["%1 MP", _manpower_box_value];

		[_marker_name, _manpower_box] spawn manpower_deterioration;
	};
};

manpower_deterioration = {
	params ["_marker_name", "_manpower_box"];

	sleep 180;

	private _manpower = _manpower_box getVariable [manpower, 0]; 

	while {_manpower > 0} do {
		_marker_name setMarkerText format["%1 MP", _manpower];
		
		sleep 10;
		_manpower = (_manpower_box getVariable [manpower, 0]) - 1;
		_manpower_box setVariable [manpower, _manpower];
	};
	
	deleteMarker _marker_name;

	sleep 60;
	deleteVehicle _manpower_box;
};