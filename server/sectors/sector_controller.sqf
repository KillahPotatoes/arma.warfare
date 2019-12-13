ARWA_decrement_counter = {
	params ["_counter", "_sector", "_side"];

	if(_counter > 0) exitWith {
		[_counter - 1, _sector, _side] spawn ARWA_update_progress_bar;
		[_counter - 1, _sector] spawn ARWA_update_counter;
		_counter - 1;
	};

	[0, _sector, civilian] spawn ARWA_update_progress_bar;

	_counter;
};

ARWA_increment_counter = {
	params ["_counter", "_sector", "_side"];

	if(_counter < ARWA_capture_time) exitWith {

		[_counter + 1, _sector, _side] spawn ARWA_update_progress_bar;
		[_counter + 1, _sector] spawn ARWA_update_counter;

		_counter + 1;
	};
	_counter;
};

ARWA_update_counter = {
	params ["_counter", "_sector"];

	_sector setVariable [ARWA_KEY_sector_capture_progress, _counter, true];
};

ARWA_capture_sector = {
	params ["_sector", "_new_owner", "_sector_name", "_old_owner"];

	_sector setVariable ["reinforements_available", true];

	format["%1 has captured %2", _new_owner, _sector_name] spawn ARWA_debugger;
	_msg = format[localize "ARWA_STR_HAS_CAPTURED_SECTOR", _new_owner call ARWA_get_faction_names, _sector_name];
	_msg remoteExec ["hint"];

	[_sector, _new_owner, _sector_name, _old_owner] call ARWA_change_sector_ownership;
};

ARWA_players_nearby_captured_sector = {
	params ["_pos", "_side"];

	({ alive _x && side _x isEqualTo _side && _pos distance2D getPos _x < ARWA_sector_size; } count allPlayers) > 0;
};

ARWA_lose_sector = {
	params ["_sector", "_old_owner", "_sector_name"];

	_sector setVariable ["reinforements_available", false];
	_msg = format[localize "ARWA_STR_HAS_LOST_SECTOR", _old_owner call ARWA_get_faction_names, _sector_name];
	_msg remoteExec ["hint"];

	format["%1 has lost %2", _old_owner, _sector_name] spawn ARWA_debugger;

	[_sector, civilian, _sector_name, _old_owner] call ARWA_change_sector_ownership;
};

ARWA_change_sector_ownership = {
	params ["_sector", "_new_owner", "_sector_name", "_previous_faction"];

	_old_owner = _sector getVariable ARWA_KEY_owned_by;
	_sector setVariable [ARWA_KEY_owned_by, _new_owner, true];
	_sector call ARWA_draw_sector;

	_sector setVariable [ARWA_KEY_owned_by, _new_owner, true];

	if (!(_old_owner isEqualTo civilian)) then {
		_sector call ARWA_remove_respawn_position;
	};

	if(!(_new_owner isEqualTo civilian)) then {
		[_sector, _new_owner] call ARWA_add_respawn_position;
		[_sector] spawn ARWA_spawn_sector_defense;
	};

	[_new_owner, _previous_faction, _sector, _sector_name] call ARWA_reset_sector;
	[_sector] spawn ARWA_draw_sector_cell;
};

ARWA_reinforcements_cool_down = {
	params ["_sector"];

	_sector setVariable [ARWA_KEY_reinforements_available, false];
	private _current_owner = _sector getVariable ARWA_KEY_owned_by;

	sleep ARWA_respawn_cooldown;

	if((_sector getVariable ARWA_KEY_owned_by) isEqualTo _current_owner) exitWith {
		_sector setVariable [ARWA_KEY_reinforements_available, true];
	};
};

ARWA_initialize_sector_control = {
	params ["_sector"];

	private _pos = getPos _sector;
	private _counter = 0;
	private _current_faction = _sector getVariable ARWA_KEY_owned_by;
	_sector setVariable [ARWA_KEY_reinforements_available, false];
	private _sector_name = [_sector getVariable ARWA_KEY_target_name] call ARWA_replace_underscore;
	private _report_attack = true;
	private _old_owner = _sector getVariable ARWA_KEY_owned_by;

	while {true} do {
		private _owner = _sector getVariable ARWA_KEY_owned_by;

		if (_owner isEqualTo civilian) then {
			private _units = [_sector] call ARWA_get_all_units_in_sector;

			if(count _units == 0) exitWith { _counter = [_counter, _sector, _current_faction] call ARWA_decrement_counter; }; // if no units, no change

			private _factions = ARWA_all_sides select {_x countSide _units > 0};
			if(count _factions > 1) exitWith { _counter = [_counter, _sector, _current_faction] call ARWA_decrement_counter; }; // if more than one faction present, no change

			// Get the only faction in sector
			private _faction = _factions select 0;
			if(!([_faction, _pos] call ARWA_any_friendlies_in_sector_center)) exitWith { _counter = [_counter, _sector, _current_faction] call ARWA_decrement_counter; }; // no units in sector center, no change

			if(_current_faction isEqualTo _faction) then {
				if(_counter == ARWA_capture_time) then {
					[_sector, _current_faction, _sector_name, _old_owner] call ARWA_capture_sector;
				} else {
					_counter = [_counter, _sector, _current_faction] call ARWA_increment_counter;
				};
			} else {
				if(_counter == 0) then {
					_current_faction = _faction;
				} else {
					 _counter = [_counter, _sector, _current_faction] call ARWA_decrement_counter;
				};
			};
		} else {
			if(_counter == 0) exitWith {
				_old_owner = _current_faction;
				[_sector, _old_owner, _sector_name] call ARWA_lose_sector;
			};

			private _friendles_in_sector = ([_owner, _pos, false] call ARWA_any_friendlies_in_sector);
			private _under_attack = ([_owner, _pos] call ARWA_any_enemies_in_sector);
			private _being_overtaken = ([_owner, _pos] call ARWA_any_enemies_in_sector_center);

			if(_under_attack) then {
					if(_report_attack && _counter == ARWA_capture_time) then {
						_report_attack = false;
						[_owner, ["ARWA_STR_SECTOR_IS_UNDER_ATTACK", _sector_name]] remoteExec ["ARWA_HQ_report_client"];
						format["%1 sector %2 is under attack", _owner, _sector_name] spawn ARWA_debugger;
					};

					if(_sector getVariable "reinforements_available") then {
					private _success = [_owner, _sector] call ARWA_try_spawn_reinforcements;

					if(_success) then {
						[_sector] spawn ARWA_reinforcements_cool_down;
					};
				};
			};

			if(!_friendles_in_sector || _being_overtaken) then {
				_counter = [_counter, _sector, _owner] call ARWA_decrement_counter;
			};

			if(!_under_attack && _friendles_in_sector) then {
				_counter = [_counter, _sector, _owner] call ARWA_increment_counter;

				if(_counter == ARWA_capture_time) then {
					_report_attack = true;
				};
			};
		};

		sleep 1;
	};
};