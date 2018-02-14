[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\playerActions.sqf";

player enableFatigue false;

[] call ShowRequestSquadAction;
[] call ShowArsenalAction;
[] call AddRedeployToHqAction;
[] call AddHeloAction;
[sectors] call AddRedeployToSectorsActions;

RemoveSquadMatesWhenPlayerDies = {
	_player = _this select 0;
	_group = group player;

	if(count units _group > 1) then {
		_new_group = createGroup [side _player, true];

		{
			if (!(isPlayer _x)) then {
				[_x] joinSilent _new_group;
			};
			
		} forEach units _group;

		[_new_group] remoteExec  ["AddBattleGroups", 2];
	};	
};

[player] call RemoveSquadMatesWhenPlayerDies;