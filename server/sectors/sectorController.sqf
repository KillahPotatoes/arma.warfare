decrement_counter = {
	params ["_counter"];

	if(_counter > 0) exitWith {
		systemChat format["%1", capture_time - (_counter-1)];
		_counter - 1;
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
		[_sector] call spawn_sector_defense;
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

			if(count _units == 0) exitWith { _counter = [_counter] call decrement_counter; }; // if no units, no change

			private _factions = [_units] call get_all_factions_in_list;
			if(count _factions > 1) exitWith { _counter = [_counter] call decrement_counter; }; // if more than one faction present, no change

			private _faction = _factions select 0;
			if(!([_faction, _pos] call any_friendlies_in_sector_center)) exitWith { _counter = [_counter] call decrement_counter; }; // no units in sector center, no change

			if(_current_faction isEqualTo _faction) then {

				if(_counter >= capture_time) exitWith {
					_counter = 0;
					[_sector, _current_faction] call capture_sector;
				};

				_counter = _counter + 1;				
				
				systemChat format["%1 will captured this sector in %2", _current_faction, capture_time - _counter];

			} else {
				_counter = 0;
				_current_faction = _faction;
			};
		} else {
			if(!([_owner, _pos] call any_enemies_in_sector_center)) exitWith { 
				systemchat "No enemies in center";
				if(!([_owner, _pos] call any_enemies_in_sector)) exitWith {
					systemchat "No enemies in sector";

					_counter = [_counter] call decrement_counter; 
				};
			};

			_counter = _counter + 1;
			systemChat format["%1 will lose this sector in %2", _owner, capture_time - _counter];

			if(_counter >= capture_time) exitWith {
					_counter = 0;
					[_sector, _current_faction] call lose_sector;
			};

		};
		sleep 1;
	};
};