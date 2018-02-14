player enableFatigue false;
["Open",true] spawn BIS_fnc_arsenal;

[sectors] call AddRedeployToSectorsActions;
[] call ShowRequestSquadAction;
[] call ShowArsenalAction;
[] call AddRedeployToHqAction;
[] call AddHeloAction;

RemoveSquadMatesWhenPlayerDies = {
	_group = group player;

	if(count unit _group > 1) then {
		_new_group = createGroup [side player, true];

		{
			if (!(isPlayer _x)) then {
				[_x] joinSilent _new_group
			};
			
		} forEach units _group;

		[_new_group] remoteExec  ["AddBattleGroups", 2];
	};	
};

[] call RemoveSquadMatesWhenPlayerDies;