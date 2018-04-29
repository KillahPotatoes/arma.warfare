player enableFatigue false;

[] call ShowArsenalAction;
[] call AddHeloAction;
[] call add_buy_options;
[] call add_take_cash_from_ammobox;
[] call add_store_cash_action;
[] call join_squad;
[] call leave_squad;
[] call show_order_heli_taxi;
[] call give_destination_to_heli_taxi;
[] call buy_manpower;

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
	_player setVariable ["rank", 0];
	_player setVariable [cash, 0];
};

[player] call reset_player_stats;
[player] call RemoveSquadMatesWhenPlayerDies;
