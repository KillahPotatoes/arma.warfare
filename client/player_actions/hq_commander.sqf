ARWA_hq_commander_action = {
	player addAction [[localize "ARWA_STR_HQ_COMMANDER", 0] call ARWA_add_action_text, {
			[] spawn ARWA_be_commander;
		}, [], ARWA_squad_actions, false, true, "", '[player] call ARWA_is_leader']
};

ARWA_be_commander = {
	private _pos = [playerSide] call ARWA_get_hq_pos;
	private _commander = (group player) createUnit ["B_Soldier_F", _pos, [], 0, "NONE"];
	player remoteControl _commander;
	_commander switchCamera "EXTERNAL";

	[_commander] spawn ARWA_warn_distance_to_hq;

	waitUntil { cameraOn isEqualTo (vehicle player) || (_commander distance2D _pos) > ARWA_HQ_area; };

	deleteVehicle _commander;
};

ARWA_warn_distance_to_hq = {
	params ["_commander"];

	while {!(isNil "_commander")} then {

		private _give_warning = if((_commander distance2D _pos) < (ARWA_HQ_area - 10)) then {
			true;
		};

		waitUntil { (_commander distance2D _pos) > (ARWA_HQ_area - 10); };

		if(_give_warning) then {
			systemChat localize "ARWA_STR_OUTSIDE_HQ_AREA";
			_give_warning = false;
		};
	};
};
