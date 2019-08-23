ARWA_get_skill_based_on_rank = {
	private _rank = rank player;
	private _max_rank = (count ARWA_ranks) - 1;
	(_rank / (_max_rank * 2)) + 0.5;
};

ARWA_calculate_rank_and_skill = {
	private _last_rank = 0;
	while {true} do {
		private _current_rank = rank player;

		if(!(_current_rank == _last_rank)) then {
			private _rank = rank player;

			private _new_skill = [_rank] call ARWA_get_skill_based_on_rank;
			if(player isEqualTo (leader group player)) then {
				[_new_skill, group player] spawn ARWA_adjust_skill;
			};
		};
		_last_rank = _current_rank;
		sleep 2;
	};
};
