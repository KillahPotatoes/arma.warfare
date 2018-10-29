clean_up_sector_squad = {
	params ["_group"];
	
	// Move group to battlegroup or delete if empty

	if({alive _x} count units _group > 0) then {			
		_group call add_battle_group;
	} else {
		deleteGroup _group;
	};
};

clean_up_sector_static = {
	params ["_group", "_static"];
	
	// Move group to battlegroup or delete if empty

	if({alive _x} count units _group > 0) then {			
		_group call add_battle_group;
	} else {
		deleteGroup _group;
	};
	
	// Delete statics
	{
		deleteVehicle _x;
	} forEach _static;

	[];
};

spawn_sector_defense = {
	params ["_sector"];

	private _pos = _sector getVariable pos;
	private _current_faction = _sector getVariable owned_by; 
	private _counter = 0;
	private _def_group = nil;
	private _static_group = nil;
	private _static_type = nil;
	private _static = [];

	while {true} do {		
		private _faction = _sector getVariable owned_by; 

		if(!(_faction isEqualTo civilian) && {!([_faction, _pos] call any_enemies_in_sector)}) then {
		
			if(_current_faction isEqualTo _faction) then {				
				_counter = _counter + 1;

				if((_counter mod 10) == 0 && ({ alive _x } count _static) < static_cap) then {

					private _veh = if(isNil "_static_group") then {
						 [_sector, _static_type] call spawn_static;
					} else {
						 [_sector, _static_type, _static_group] call spawn_static;
					};

					if ((isNil "_veh")) exitWith {};

					_static pushBack (_veh)
				};

				[_sector, _def_group] call spawn_defensive_reinforcements;

			} else {
				if(!(isNil "_def_group")) then {
					_static = [_static_group, _static] call clean_up_sector_static;
					[_def_group] call clean_up_sector_squad;
				};

				if(!(isNil "_static_group")) then {
					_static = [_static_group, _static] call clean_up_sector_static;
				};

				_unit_count = defender_cap call calc_number_of_soldiers;
				_def_group = [_sector, _unit_count] call spawn_defensive_squad;

				_static_type = selectRandom (missionNamespace getVariable format["%1_static", _faction]);
				
				_counter = 0;				
			};
		};	

		_current_faction = _faction;

		sleep 1;

	};
};

initialize_sector_defense = {
	{
		[_x] spawn spawn_sector_defense;
	} forEach sectors;
};