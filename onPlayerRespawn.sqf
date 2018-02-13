player enableFatigue false;
["Open",true] spawn BIS_fnc_arsenal;

[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\spawnSquad.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\showArsenal.sqf";

_group = group player;
_new_group = createGroup [side player, true];

{
	if (!(isPlayer _x)) then {
		[_x] joinSilent _new_group
	};
	
} forEach units _group;

[_new_group] remoteExec  ["AddBattleGroups", 2];