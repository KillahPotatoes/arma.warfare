if (!(playerSide isEqualTo civilian) && playerSide call ARWA_get_owned_sectors <= 0) exitWith {
	["end1",false,5] call BIS_fnc_endMission;
};

removeAllActions player;