ARWA_get_skill_based_on_rank = {
	private _rank = rank player;
	private _rank_index = ARWA_ranks find _rank;
	private _max_rank = (count ARWA_ranks) - 1;
	(_rank_index / (_max_rank * 2)) + 0.5;
};

ARWA_calculate_rank_and_skill = {
	private _last_rating = rating player;
	while {true} do {
		private _current_rating = rating player;

		private _new_rank_index = (_current_rating - (_current_rating % ARWA_rating_per_rank)) / ARWA_rating_per_rank;
		private _max_rank = (count ARWA_ranks) - 1;
		private _new_rank = ARWA_ranks select ((_new_rank_index min _max_rank) max 0);
		// systemChat format["_new_rank_index: %1, _max_rank: %2, _new_rank: %3", _new_rank_index, _max_rank, _new_rank];

		if(!(_new_rank isEqualTo (rank player))) then {
			diag_log format["_new_rank: %1", _new_rank];
			player setUnitRank _new_rank;

			private _skill_coef = 1 - (0.5 * (_new_rank_index / _max_rank));
			player setCustomAimCoef _skill_coef;
			player setUnitRecoilCoefficient _skill_coef;

			private _new_stamina = 60 + (60 * (_new_rank_index / _max_rank));
			player setStamina _new_stamina;

			if(player isEqualTo (leader group player)) then {
				private _new_skill = [] call ARWA_get_skill_based_on_rank;
				[_new_skill, group player] spawn ARWA_adjust_skill;
			};
			sleep 2;
			player addRating _current_rating; // Set rating after sleep because setUnitRank sets it to 0 but after a small delay
		} else {
			sleep 2;
		};
		_last_rating = _current_rating;
	};
};
