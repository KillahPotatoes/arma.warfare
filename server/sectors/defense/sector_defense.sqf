ARWA_spawn_sector_defense = {
	params ["_sector"];

	private _pos = _sector getVariable ARWA_KEY_pos;
	private _current_faction = _sector getVariable ARWA_KEY_owned_by;
	private _sector_defense = nil;
	private _static_defense = nil;

	while {true} do {
		private _faction = _sector getVariable ARWA_KEY_owned_by;

		if(!(_faction isEqualTo civilian)) then {
			private _enemies_nearby = [_pos, _current_faction, ARWA_sector_size] call ARWA_any_enemies_in_area;

			if(_enemies_nearby) exitWith {};

			if(_current_faction isEqualTo _faction) then {

				if(isNil "_sector_defense") then {
					_sector_defense = [_pos, _current_faction] call ARWA_spawn_defensive_squad;
				} else {
					private _defenders_alive = {alive _x} count units _sector_defense;

					if(side _sector_defense isEqualTo _current_faction) then {
						if(_defenders_alive < (ARWA_defender_cap / 2) && {(_faction call ARWA_has_manpower)}) then {
							[_pos, _sector_defense] call ARWA_spawn_reinforcments;
						};
					} else {
						if(_defenders_alive > 0) then {
							[_sector_defense] call ARWA_add_battle_group;
						};
						_sector_defense = [_pos, _current_faction] call ARWA_spawn_defensive_squad;
					};
				};

				if(ARWA_sector_artillery && (isNil "_static_defense" || {!([_static_defense] call ARWA_static_alive)})) then {
					_static_defense = [_pos, _current_faction] call ARWA_spawn_static;
				};

			} else {
				if(!isNil "_static_defense") then {
					[_static_defense] spawn ARWA_remove_static;
				};

				_current_faction = _faction;
			};
		};

		sleep 5;
	};
};

ARWA_initialize_sector_defense = {
	{
		[_x] spawn ARWA_spawn_sector_defense;
	} forEach ARWA_sectors;
};