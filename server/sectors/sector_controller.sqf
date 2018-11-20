decrement_counter = {
	params ["_counter", "_sector", "_side"];

	if(_counter > 0) exitWith {		
		[_counter - 1, _sector, _side] spawn update_progress_bar;
		_counter - 1;		
	};
	
	[0, _sector, civilian] spawn update_progress_bar;
	
	_counter;
};

increment_counter = {
	params ["_counter", "_sector", "_side"];

	if(_counter < capture_time) exitWith {		
		[_counter + 1, _sector, _side] spawn update_progress_bar;
		_counter + 1;
	};
	_counter;
};

capture_sector = {
	params ["_sector", "_side"];

	_name = [_sector getVariable sector_name] call replace_underscore;
	_msg = format["%1 has captured %2", _side call get_faction_names, _name];
	_msg remoteExec ["hint"]; 

	[_sector, _side] call change_sector_ownership;
};

lose_sector = {
	params ["_sector", "_side"];

	_name = [_sector getVariable sector_name] call replace_underscore;
	_msg = format["%1 has lost %2", _side call get_faction_names, _name];
	_msg remoteExec ["hint"]; 

	[_sector, civilian] call change_sector_ownership;
};

change_sector_ownership = {
	params ["_sector", "_new_owner"];

	_old_owner = _sector getVariable owned_by;
	_sector setVariable [owned_by, _new_owner, true];
	_sector call draw_sector;

	_ammo_box = _sector getVariable box;		
	_ammo_box setVariable [owned_by, _new_owner, true];

	if (!(_old_owner isEqualTo civilian)) then {
		_sector call remove_respawn_position;	
		[_old_owner, _sector] call remove_sector;
	};

	if(!(_new_owner isEqualTo civilian)) then {
		[_sector] call add_respawn_position;		
		[_new_owner, _sector] call add_sector;
	};

	[_new_owner, _sector] call reset_sector_manpower;
};

initialize_sector_control = {
	params ["_sector"];
	
	private _pos = _sector getVariable pos;
	private _counter = 0;
	private _current_faction = _sector getVariable owned_by;

	while {true} do {	
		private _owner = _sector getVariable owned_by;

		if (_owner isEqualTo civilian) then {
			private _units = [_sector] call get_all_units_in_sector;

			if(count _units == 0) exitWith { _counter = [_counter, _sector, _current_faction] call decrement_counter; }; // if no units, no change

			private _factions = all_sides select {_x countSide _units > 0};
			if(count _factions > 1) exitWith { _counter = [_counter, _sector, _current_faction] call decrement_counter; }; // if more than one faction present, no change

			// Get the only faction in sector
			private _faction = _factions select 0;
			if(!([_faction, _pos] call any_friendlies_in_sector_center)) exitWith { _counter = [_counter, _sector, _current_faction] call decrement_counter; }; // no units in sector center, no change

			if(_current_faction isEqualTo _faction) then {

				if(_counter == capture_time) then {					
					[_sector, _current_faction] call capture_sector;
				} else {
					_counter = [_counter, _sector, _current_faction] call increment_counter; 
				}

			} else {
				if(_counter == 0) then {
					_current_faction = _faction;
				} else {
					 _counter = [_counter, _sector, _current_faction] call decrement_counter;
				};
			};
		} else {
			if(!([_owner, _pos] call any_enemies_in_sector_center)) exitWith { 
				if(!([_owner, _pos] call any_enemies_in_sector)) exitWith {
					_counter = [_counter, _sector, _owner] call increment_counter; 
				};
			};
	
			if(_counter == 0) then {
				[_sector, _current_faction] call lose_sector;
			} else {
				[_owner, _sector] spawn try_spawn_heli_reinforcements;
				_counter = [_counter, _sector, _owner] call decrement_counter; 
			};

		};

		sleep 1;
	};
};