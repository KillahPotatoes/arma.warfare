ARWA_hq_commander_action = {
	player addAction [[localize "ARWA_STR_HQ_COMMANDER", 0] call ARWA_add_action_text, {
			[] spawn ARWA_be_commander;
		}, [], ARWA_squad_actions, false, true, "", '[player] call ARWA_is_leader && [player] call ARWA_is_outside_hq']
};

ARWA_is_outside_hq = {
	params ["_player"];
	private _pos = [playerSide] call ARWA_get_hq_pos;
	(getPos _player) distance _pos > ARWA_HQ_area;
};

ARWA_be_commander = {
	private _pos = [playerSide] call ARWA_get_hq_pos;
	private _commander_classname = missionNamespace getVariable format["ARWA_%1_hq_commander", playerSide];
	private _commander = (group player) createUnit [_commander_classname, _pos, [], 0, "NONE"];
	_commander setName "HQ commander";
	player remoteControl _commander;
	_commander switchCamera "EXTERNAL";

	[_commander, _pos] spawn ARWA_warn_distance_to_hq;
	[_commander] spawn ARWA_remove_vehicle_action;

	waitUntil { cameraOn isEqualTo (vehicle player) || (_commander distance2D _pos) > ARWA_HQ_area; };

	deleteVehicle _commander;
};

ARWA_warn_distance_to_hq = {
	params ["_commander", "_pos"];

	while {!(isNil "_commander")} do {

		private _give_warning = (_commander distance2D _pos) < (ARWA_HQ_area - 10);

		waitUntil { (_commander distance2D _pos) > (ARWA_HQ_area - 10); };

		if(_give_warning) then {
			hint localize "ARWA_STR_OUTSIDE_HQ_AREA";
			_give_warning = false;
		};
	};
};
