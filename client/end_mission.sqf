end_mission = {
	params ["_winners"];
	["end1",playerSide in _winners,5] call BIS_fnc_endMission;
};