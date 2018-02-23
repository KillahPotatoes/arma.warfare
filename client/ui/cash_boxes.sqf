create_cash_markers = {
	params ["_boxes"];
	
	{
		private _marker_name = format["%1-%2", "cash-box", _forEachIndex];
		createMarkerLocal [_marker_name, getPosWorld _x]; 
		_marker_name setMarkerTypeLocal "mil_box";
		_marker_name setMarkerTextLocal "0";
	} forEach _boxes;
};

update_cash_markers = {
	params ["_boxes"];

	{
		private _marker_name = format["%1-%2", "cash-box", _forEachIndex];
		private _cash = _x getVariable cash;
		_marker_name setMarkerTextLocal format["%1 $", _cash];
	} forEach _boxes;
};

show_cash_markers = {
	_cash_storage_boxes = allMissionObjects "B_CargoNet_01_ammo_F";
	[_cash_storage_boxes] call create_cash_markers;
	_side = playerSide;

	while {true} do {
		[_cash_storage_boxes] call update_cash_markers;

		sleep 2;
	};
};