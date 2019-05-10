ARWA_get_rank_skill = {
	private _rank = [] call ARWA_calculate_rank;
	_rank call ARWA_get_skill_based_on_rank;
};

ARWA_calculate_rank = {
	private _current_kill_count = player getvariable ["kills", 0];
	((_current_kill_count - (_current_kill_count mod ARWA_kills_per_rank)) / ARWA_kills_per_rank) min ARWA_max_rank;
};

ARWA_get_skill_based_on_rank = {
	params ["_rank"];
	(_rank / (ARWA_max_rank * 2)) + 0.5;
};

ARWA_calculate_rank_and_skill = {
	private _last_kill_count = 0;
	while {true} do {
		private _current_kill_count = player getvariable ["kills", 0];

		if(!(_current_kill_count == _last_kill_count)) then {
			private _new_rank = _current_kill_count call ARWA_calculate_rank;
			private _current_rank = player getVariable ["rank", 0];

			if(!(_new_rank == _current_rank)) then {
				player setVariable ["rank", _new_rank, true];

				private _new_skill = [_new_rank] call ARWA_get_skill_based_on_rank;
				if(player isEqualTo (leader group player)) then {
					[_new_skill, group player] spawn ARWA_adjust_skill;
				};
			};
		};
		_last_kill_count = _current_kill_count;
		sleep 2;
	};
};
