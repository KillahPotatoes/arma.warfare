spawn_sector_defense = {
	params ["_sector"];

	private _pos = _sector getVariable pos;
	private _current_faction = _sector getVariable owned_by;
	private _sector_defense = nil;
	private _static_defense = nil;
	private _sleep = 1;

	while {true} do {
		private _faction = _sector getVariable owned_by;

		if(!(_faction isEqualTo civilian) && {!([_faction, _pos] call any_enemies_in_sector)}) then {

			if(_current_faction isEqualTo _faction) then {

				_sleep = 300;

				if(isNil "_sector_defense") then {
					_sector_defense = [_pos, _current_faction] call spawn_defensive_squad;
				} else {
					if(!(side _sector_defense isEqualTo _current_faction)) then {
						if({alive _x} count units _sector_defense > 0) then {
							[_sector_defense] call add_battle_group;
						};
						_sector_defense = [_pos, _current_faction] call spawn_defensive_squad;
					} else {
						if({alive _x} count units _sector_defense < (ARWA_defender_cap / 2) && (_faction call has_manpower)) then {
							[_pos, _sector_defense] call spawn_reinforcments;
						};
					};
				};

				if(ARWA_sector_artillery && isNil "_static_defense" || {!([_static_defense] call static_alive)}) then {
					_static_defense = [_pos, _current_faction] call spawn_static;
				};

			} else {
				if(!isNil "_static_defense") then {
					[_static_defense] call remove_static;
				};

				_current_faction = _faction;
				_sleep = 1;
			};
		};


		sleep _sleep;
	};
};

initialize_sector_defense = {
	{
		[_x] spawn spawn_sector_defense;
	} forEach sectors;
};