ARWA_end_mission = {
	params ["_winner"];
	["end1",playerSide isEqualTo _winner,5] call BIS_fnc_endMission;
};