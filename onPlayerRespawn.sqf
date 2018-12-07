player enableStamina false;

[] spawn create_join_menu;
[] spawn leave_squad;
[] spawn add_take_manpower;
[] spawn add_store_manpower;

[localize "REQUEST_AIR_TRANSPORT", helicopter, arwa_air_transport_actions] spawn show_order_transport;
[localize "REQUEST_VEHICLE_TRANSPORT", vehicle1, arwa_ground_transport_actions] spawn show_order_transport;

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

if(show_diary_hint) then {
	show_diary_hint = false;
	"HOW TO PLAY" hintC "Look in map briefing for how to play";
};
