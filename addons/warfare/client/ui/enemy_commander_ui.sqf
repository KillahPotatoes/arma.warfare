ARWA_commander_marker_client = {
	params ["_marker", "_markerPos", "_commander"];
	createMarkerLocal [_marker, _markerPos];
	_marker setMarkerColorLocal "ColorUNKNOWN";
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerBrushLocal "Grid";
	_marker setMarkerAlphaLocal 0.8;
	_marker setMarkerSizeLocal [200,200];

	[playerSide, ["ARWA_STR_ENEMY_COMMANDER_IN_AREA"]] remoteExec ["ARWA_HQ_report_client"];
	waitUntil { isNull _commander || {!alive _commander} };

	if(isNull _commander) then {
		sleep 30 + (random 30);
		[playerSide, ["ARWA_STR_ENEMY_COMMANDER_LOST"]] spawn ARWA_HQ_report_client;
	} else {
		sleep 5 + (random 5);
		[playerSide, ["ARWA_STR_ENEMY_COMMANDER_KILLED"]] spawn ARWA_HQ_report_client;
	};

	deleteMarkerLocal _marker;
};