if (!(playerSide isEqualTo civilian) && playerSide call get_strength <= 0) exitWith {
	["end1",false,5] call BIS_fnc_endMission;
};

removeAllActions player;