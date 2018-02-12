player enableFatigue false;
["Open",true] spawn BIS_fnc_arsenal;

[] call compileFinal preprocessFileLineNumbers "scripts\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\spawnSquad.sqf";

_group = group player;
_new_group = createGroup [side player, true];

{
	if (!(isPlayer _x)) then {
		[_x] joinSilent _new_group
	};
	
} forEach units _group;

[_new_group] remoteExec  ["AddBattleGroups", 2];