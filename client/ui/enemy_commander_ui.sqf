ARWA_commander_marker_client = {
	params ["_marker", "_markerPos", "_commander", "_player_side"];
	createMarkerLocal [_marker, _markerPos];
	_marker setMarkerColorLocal "ColorRedAlpha";
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "Cross";
	_marker setMarkerAlphaLocal 0.8;
	_marker setMarkerSizeLocal [ARWA_min_distance_presence,ARWA_min_distance_presence];

	waitUntil { isNull _commander || {!alive _commander} };

	if(isNull _commander) then {
		sleep 30 + (random 30);
		[_player_side, ["ARWA_STR_ENEMY_COMMANDER_LOST"]] spawn ARWA_HQ_report_client;
	} else {
		sleep 5 + (random 5);
		[_player_side, ["ARWA_STR_ENEMY_COMMANDER_KILLED"]] spawn ARWA_HQ_report_client;
	};

	deleteMarkerLocal _marker;
};