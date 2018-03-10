player enableFatigue false;

[] call ShowArsenalAction;
[] call AddHeloAction;
[] call add_buy_options;
[] call add_take_cash_from_ammobox;
[] call add_store_cash_action;
[] call join_squad;
[] call leave_squad;

RemoveSquadMatesWhenPlayerDies = {
	params ["_player"];

	private _group = group player;

	if(count units _group > 1) then {
		private _new_group = createGroup [side _player, true];
		[player] joinSilent _new_group;		
	};	
};

[player] call RemoveSquadMatesWhenPlayerDies;
