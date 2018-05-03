kills_per_rank = 10;

get_rank_skill = {
	private _kills = player getvariable ["kills", 0];
	private _rank = _kills call get_rank;
	_rank call get_skill_based_on_rank;
};

get_rank = {
	params ["_current_kill_count"];
	((_current_kill_count - (_current_kill_count mod kills_per_rank)) / kills_per_rank) min 5;	
};

get_skill_based_on_rank = {
	params ["_rank"];
	(_rank / 10) + 0.5;
};

calculate_rank_and_skill = {
	private _last_kill_count = 0;
	while {true} do {
		private _current_kill_count = player getvariable ["kills", 0];

		if(!(_current_kill_count == _last_kill_count)) then {
			private _new_rank = _current_kill_count call get_rank;
			private _current_rank = player getVariable ["rank", 0];

			if(!(_new_rank == _current_rank)) then {
				player setVariable ["rank", _new_rank];

				private _new_skill = [_new_rank] call get_skill_based_on_rank;
				if(player isEqualTo (leader group player)) then {
					[_new_skill, group player] spawn adjust_skill;	
				};
			};
		};
		_last_kill_count = _current_kill_count;
		sleep 2;
	};
};

increment_player_kill_counter = {	
	private _kills = player getVariable ["kills", 0];
	player setVariable ["kills", _kills + 1];			
};

	