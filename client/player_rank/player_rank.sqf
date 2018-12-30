kills_per_rank = 5;
max_rank = 5;

get_rank_skill = {
	private _rank = [] call calculate_rank;
	_rank call get_skill_based_on_rank;
};

calculate_rank = {
	private _current_kill_count = player getvariable ["kills", 0];
	((_current_kill_count - (_current_kill_count mod kills_per_rank)) / kills_per_rank) min max_rank;	
};

get_skill_based_on_rank = {
	params ["_rank"];
	(_rank / (max_rank * 2)) + 0.5;
};

calculate_rank_and_skill = {
	private _last_kill_count = 0;
	while {true} do {
		private _current_kill_count = player getvariable ["kills", 0];

		if(!(_current_kill_count == _last_kill_count)) then {
			private _new_rank = _current_kill_count call calculate_rank;
			private _current_rank = player getVariable ["rank", 0];

			if(!(_new_rank == _current_rank)) then {
				player setVariable ["rank", _new_rank, true];

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



	