player enableFatigue false;

[] call ShowArsenalAction;
[] call AddHeloAction;
[] call add_buy_options;
[] call add_take_cash_from_ammobox;
[] call add_store_cash_action;

RemoveSquadMatesWhenPlayerDies = {
	params ["_player"];

	_group = group player;

	if(count units _group > 1) then {
		_new_group = createGroup [side _player, true];

		{
			if (!(isPlayer _x)) then {
				[_x] joinSilent _new_group;
			};
			
		} count units _group;

		[_new_group] remoteExec  ["add_battle_group", 2];
	};	
};

[player] call RemoveSquadMatesWhenPlayerDies;
