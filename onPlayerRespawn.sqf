player enableStamina false;

[] spawn create_join_menu;
[] spawn leave_squad;
[] spawn add_give_manpower_to_player_action;
[] spawn add_take_manpower_from_player_action;

["Request helicopter pick-up", helicopter, 95] spawn show_order_taxi;
["Request vehicle pick-up", vehicle1, 93] spawn show_order_taxi;

remove_squad_mates_on_death = {
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
[player] call remove_squad_mates_on_death;
