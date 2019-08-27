ARWA_spawn_sector_defense = {
	params ["_sector"];

	private _pos = _sector getVariable ARWA_KEY_pos;
	private _owner = _sector getVariable ARWA_KEY_owned_by;

	private _sector_defense = _sector getVariable ARWA_KEY_sector_defense;
	if(!isNil "_sector_defense" && {{ alive _x } count units _sector_defense > 0}) then {
		[_sector_defense] call ARWA_add_battle_group;
	};

	private _static_defense = _sector getVariable ARWA_KEY_static_defense;
	if(!isNil "_static_defense") then {
		[_static_defense] spawn ARWA_remove_static;
	};

	if(_owner call ARWA_has_manpower) then {
		private _new_sector_defense = [_pos, _owner] call ARWA_spawn_defensive_squad;
		_sector setVariable [ARWA_KEY_sector_defense, _new_sector_defense];


		if(ARWA_sector_artillery) then {
			sleep 5;

			private _new_static_defense = [_pos, _owner] call ARWA_spawn_static;
			_sector setVariable [ARWA_KEY_static_defense, _new_static_defense];
		};
	};

	[_sector, _owner, _pos] spawn ARWA_reinforce_sector_defense;
	[_sector, _owner, _pos] spawn ARWA_reinforce_static_defense;
};

ARWA_reinforce_sector_defense = {
	params ["_sector", "_side", "_pos"];
	private _current_owner = _side;
	private _sector_defense = _sector getVariable ARWA_KEY_sector_defense;

	while {_current_owner isEqualTo _side} do {
		private _current_owner = _sector getVariable ARWA_KEY_owned_by;
		private _enemies_nearby = [_pos, _current_owner, ARWA_sector_size] call ARWA_any_enemies_in_area;

		if(!_enemies_nearby) then {
			private _defenders_alive = { alive _x } count units _sector_defense;
			if(_defenders_alive < (ARWA_defender_cap / 2) && {_current_owner call ARWA_has_manpower}) then {
				[_pos, _sector_defense] call ARWA_spawn_reinforcments;
			};
		};

		sleep ARWA_sector_defense_reinforcement_interval;
		_current_owner = _sector getVariable ARWA_KEY_owned_by;
	};
};

ARWA_reinforce_static_defense = {
	params ["_sector", "_side", "_pos"];
	private _current_owner = _side;
	private _static_defense = _sector getVariable ARWA_KEY_static_defense;

	while {_current_owner isEqualTo _side} do {
		private _enemies_nearby = [_pos, _current_owner, ARWA_sector_size] call ARWA_any_enemies_in_area;

		if(ARWA_sector_artillery && {!([_static_defense] call ARWA_static_alive)}) then {
			_static_defense = [_pos, _current_owner] call ARWA_spawn_static;
		};

		sleep ARWA_static_defense_reinforcement_interval;
		_current_owner = _sector getVariable ARWA_KEY_owned_by;
	};
};
