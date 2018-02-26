create_cash_markers = {
	params ["_boxes"];
	
	{
		private _marker_name = format["%1-%2", "cash-box", _forEachIndex];
		createMarkerLocal [_marker_name, getPosWorld _x]; 
		_marker_name setMarkerTypeLocal "mil_box";
		_marker_name setMarkerTextLocal format["%1 $", 0];
		_marker_name setMarkerAlphaLocal 0;
	} forEach _boxes;
};

update_cash_markers = {
	params ["_boxes"];

	{
		private _side = _x getVariable owned_by;
		private _marker_name = format["%1-%2", "cash-box", _forEachIndex];

		if (_side isEqualTo playerSide) then {
			
			private _color = [_side, true] call BIS_fnc_sideColor;
			private _cash = _x getVariable cash;
			
			_marker_name setMarkerTextLocal format["%1 $", _cash];
			_marker_name setMarkerColorLocal _color;
			_marker_name setMarkerAlphaLocal 1;
		} else {
			_marker_name setMarkerAlphaLocal 0;
		}

	} forEach _boxes;
};

show_cash_markers = {
	_cash_storage_boxes = allMissionObjects ammo_box;
	[_cash_storage_boxes] call create_cash_markers;
	_side = playerSide;

	while {true} do {
		[_cash_storage_boxes] call update_cash_markers;
	};
};