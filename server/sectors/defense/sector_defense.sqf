ARWA_spawn_sector_defense = {
	params ["_sector"];

	private _pos = getPos _sector;
	private _owner = _sector getVariable ARWA_KEY_owned_by;

	private _sector_defense = _sector getVariable ARWA_KEY_sector_defense;
	if(!isNil "_sector_defense" && {{ alive _x } count units _sector_defense > 0}) then {
		format["Adding %2 sector defense at sector %1 to battlegroup", _sector getVariable ARWA_KEY_target_name, side _sector_defense] spawn ARWA_debugger;
		[_sector_defense] call ARWA_add_battle_group;
	};

	private _new_sector_defense = [_pos, _owner] call ARWA_spawn_defense;
	_sector setVariable [ARWA_KEY_sector_defense, _new_sector_defense];
	[_sector, _pos] spawn ARWA_reinforce_sector_defense;

	if(ARWA_sector_artillery) then {
		[_sector] spawn ARWA_spawn_static_sector_defense;
	};
};

ARWA_reinforce_sector_defense = {
	params ["_sector", "_pos"];

	private _sector_defense = _sector getVariable ARWA_KEY_sector_defense;
	private _initial_owner = side _sector_defense;
	private _current_owner = _initial_owner;
	private _timer = time;
	private _reinforce = false;

	while {_current_owner isEqualTo _initial_owner} do {
		private _enemies_nearby = [_pos, _current_owner, ARWA_sector_size] call ARWA_any_enemies_in_area;

		if(!_enemies_nearby && time > _timer) then {
			if(_reinforce) exitWith {

				private _defenders_alive = { alive _x } count units _sector_defense;
				if(_defenders_alive < (ARWA_defender_cap / 2) && {_current_owner call ARWA_has_manpower}) then {
					format["Reinforcing sector %1 for %2", _sector getVariable ARWA_KEY_target_name, _initial_owner] spawn ARWA_debugger;
					[_pos, _sector_defense] call ARWA_spawn_reinfore_sector_defense;
					_reinforce = false;
				};
			};
			_timer = time + ARWA_sector_defense_reinforcement_interval;
			_reinforce = true;
		};
		sleep 10;
		_current_owner = _sector getVariable ARWA_KEY_owned_by;
	};

	format["Stopped reinforcing sector %1 for %2", _sector getVariable ARWA_KEY_target_name, _initial_owner] spawn ARWA_debugger;
};




