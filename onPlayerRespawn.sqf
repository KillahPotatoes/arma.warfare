player enableFatigue false;

[] call join_squad;
[] call leave_squad;
[helicopter] call show_order_taxi;
[vehicle1] call show_order_taxi;

RemoveSquadMatesWhenPlayerDies = {
	params ["_player"];

	private _group = group player;

	if(count units _group > 1) then {
		private _new_group = createGroup [side _player, true];
		[player] joinSilent _new_group;		
	};

	[0.5, _group] spawn adjust_skill;
};

reset_player_stats = {
	params ["_player"];

	_player setVariable ["kills", 0];
	_player setVariable ["rank", 0, true];
	_player setVariable [manpower, 0];
};

[player] call reset_player_stats;
[player] call RemoveSquadMatesWhenPlayerDies;
