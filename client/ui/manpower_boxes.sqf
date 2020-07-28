ARWA_create_manpower_markers = {
	params ["_boxes"];

	{
		private _marker_name = format["%1-%2", ARWA_KEY_manpower_box, _forEachIndex];
		createMarkerLocal [_marker_name, getPos _x];
		_marker_name setMarkerTypeLocal "mil_box";
		_marker_name setMarkerAlphaLocal 0;
	} forEach _boxes;
};

ARWA_update_manpower_markers = {
	params ["_boxes"];

	{
		if(_x getVariable [ARWA_KEY_sector, false]) then {
			private _side = _x getVariable ARWA_KEY_owned_by;
			private _marker_name = format["%1-%2", ARWA_KEY_manpower_box, _forEachIndex];
			private _color = [_side, true] call BIS_fnc_sideColor;

			_marker_name setMarkerColorLocal _color;
			_marker_name setMarkerAlphaLocal 1;

			private _manpower = floor (_x getVariable ARWA_KEY_manpower);

			if(!(isNil "_manpower")) then {
				_marker_name setMarkerTextLocal format["%1 MP", _manpower];
			};
		};
	} forEach _boxes;
};

ARWA_show_manpower_markers = {
	_manpower_storage_boxes = allMissionObjects ARWA_ammo_box;
	[_manpower_storage_boxes] call ARWA_create_manpower_markers;

	while {true} do {
		[_manpower_storage_boxes] call ARWA_update_manpower_markers;
		sleep 2;
	};
};