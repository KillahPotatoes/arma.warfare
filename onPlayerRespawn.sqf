private _fatigue = ["Fatigue", 0] call BIS_fnc_getParamValue;

if(_fatigue == 0) then {
	player enableStamina false;
} else {
	player enableStamina true;
};

[] spawn create_join_menu;
[] spawn take_lead_menu;
[] spawn leave_squad;
[] spawn add_take_manpower;
[] spawn add_store_manpower;

[localize "REQUEST_AIR_TRANSPORT", helicopter, ARWA_air_transport_actions] spawn show_order_transport;
[localize "REQUEST_VEHICLE_TRANSPORT", vehicle1, ARWA_ground_transport_actions] spawn show_order_transport;
[] spawn show_order_uav;

remove_squad_mates_on_death = {
	params ["_player"];

	private _group = group _player;

	if(count units _group > 1) then {
		private _new_group = createGroup [side _player, true];
		[player] joinSilent _new_group;
		[_new_group] remoteExec ["ARWA_add_battle_group", 2];
	};

	[0.5, _group] spawn ARWA_adjust_skill;
};

reset_player_stats = {
	params ["_player"];

	_player setVariable ["kills", 0, true];
	_player setVariable ["rank", 0, true];
	_player setVariable [manpower, 0, true];
};

[player] call reset_player_stats;
[player] call remove_squad_mates_on_death;

if(show_diary_hint) then {
	show_diary_hint = false;
	"HOW TO PLAY" hintC "Look in map briefing for how to play";
};
