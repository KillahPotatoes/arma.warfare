[] call compileFinal preprocessFileLineNumbers "server\manpower_box.sqf";


ARWA_add_kill_ticker_to_all_units = {
	while {true} do {
		sleep 2;
		{
			if !(_x getVariable ["killTickerEventAdded",false]) then {
				_x spawn ARWA_kill_ticker;
				_x setVariable ["killTickerEventAdded",true]
			};
		} count allUnits;
	};
};

ARWA_add_kill_ticker_to_all_vehicles = {
	while {true} do {
		sleep 2;
		{
			if( _x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air") then {
				if !(_x getVariable ["killTickerEventAdded",false]) then {
					_x spawn ARWA_on_vehicle_kill;
					_x setVariable ["killTickerEventAdded",true]
				};
			};
		} count vehicles;
	};
};

ARWA_on_vehicle_kill = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];

			[_victim, _killer] spawn ARWA_report_lost_vehicle;
			[_victim] spawn ARWA_induce_lost_vehicle_penalty;
			[_victim, _killer] spawn ARWA_induce_vehicle_kill_bonus;
			[_victim] spawn ARWA_create_manpower_box_vehicle;
		}
	];
};

ARWA_induce_vehicle_kill_bonus = {
	params ["_victim", "_killer"];
	if(ARWA_vehicleKillBonus > 0) then {
		if (!(isNil "_victim" || isNil "_killer")) then {
			private _killer_side = side group _killer;
			private _victim_side = _victim getVariable ARWA_KEY_owned_by;

			if(isNil "_victim_side") exitWith {};

			if (!(_victim_side isEqualTo _killer_side) && {isPlayer _killer}) then {
				private _kill_bonus = _victim getVariable [ARWA_kill_bonus, 0];

				if(_kill_bonus == 0) exitWith {};

				private _adjusted_kill_bonus = if(ARWA_vehicleKillBonus == 1) then { _kill_bonus/2; } else { _kill_bonus; };
				private _faction_strength = _killer_side call ARWA_get_strength;
				private _new_faction_strength = _faction_strength + _adjusted_kill_bonus;
				[_killer_side, _new_faction_strength] call ARWA_set_strength;

				private _veh_name = (typeOf _victim) call ARWA_get_vehicle_display_name;
				private _values = ["ARWA_STR_VEHICLE_KILL_BONUS", _adjusted_kill_bonus, _veh_name];
				[_killer_side, _values] remoteExec ["ARWA_HQ_report_client"];
			};
		};
	};
};

ARWA_induce_lost_vehicle_penalty = {
	params ["_victim"];

	private _penalty = _victim getVariable [ARWA_penalty, 0];

	if(_penalty > 0) exitWith {
		private _side = _victim getVariable ARWA_KEY_owned_by;

		if(isNil "_side") exitWith {};

		private _faction_strength = _side call ARWA_get_strength;
		private _new_faction_strength = _faction_strength - _penalty;
		[_side, _new_faction_strength] call ARWA_set_strength;

		private _veh_name = (typeOf _victim) call ARWA_get_vehicle_display_name;

		[_side, ["ARWA_STR_PLAYER_VEHICLE_LOST", _penalty, _veh_name]] remoteExec ["ARWA_HQ_report_client"];
	};
};

ARWA_report_lost_vehicle = {
	params ["_victim", "_killer"];

	private _veh_name = (typeOf _victim) call ARWA_get_vehicle_display_name;
	private _pos = getPos _victim;
	private _closest_sector = [ARWA_sectors, _pos] call ARWA_find_closest_sector;
	private _sector_pos = getPos _closest_sector;
	private _distance = floor(_sector_pos distance2D _pos);
	private _location = [_closest_sector getVariable ARWA_KEY_target_name] call ARWA_replace_underscore;
	private _side = _victim getVariable ARWA_KEY_owned_by;

	if(isNil "_side") exitWith {};

	private _values = if (_distance > 200) then {
		private _direction = [_sector_pos, _pos] call ARWA_get_direction;
		["ARWA_STR_VEHICLE_LOST", _veh_name, _distance, _direction, _location];
	} else {
		["ARWA_STR_VEHICLE_LOST_IN_SECTOR", _veh_name, _location];
	};

	[_side, _values] remoteExec ["ARWA_HQ_report_client"];
};

ARWA_kill_ticker = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];

			[_victim, _killer] spawn ARWA_register_kill;
			[_victim] spawn ARWA_create_manpower_box_unit;
		}
	];
};

ARWA_calculate_kill_points = {
	params ["_killer_side"];
	1 / ((playersNumber _killer_side) + 1);
};

ARWA_register_kill = {
	params ["_victim", "_killer", "_faction_strength"];

	if (!(isNil "_victim" || isNil "_killer")) then {
		private _killer_side = side group _killer;
		private _victim_side = side group _victim;

		private _penalty_multiplier = [0, 0.05, 0.1] select ARWA_manpower_penalty_on_player_death;
		private _manpower_penalty = ARWA_starting_strength * _penalty_multiplier;

		if(_victim_side isEqualTo civilian && isPlayer _killer) exitWith {
			private _civilian_killed_penalty = (ARWA_starting_strength / 10);
			private _killer_faction_strength = (_killer_side call ARWA_get_strength) - _civilian_killed_penalty;
			[_killer_side, _killer_faction_strength] call ARWA_set_strength;

			private _faction_name = _killer_side call ARWA_get_faction_names;
			[["ARWA_STR_KILLED_CIVILIAN_PENALTY", _faction_name, _civilian_killed_penalty]] remoteExec ["ARWA_system_chat", _killer_side];
		};

		private _enemy_killed = !(_victim_side isEqualTo _killer_side) && {_killer_side in ARWA_all_sides};

		if (_enemy_killed) then {
			_kill_point = _killer_side call ARWA_calculate_kill_points;
			[_killer_side, _kill_point] call ARWA_increment_kill_counter;
		};

		private _isKillLeader = isPlayer (leader group _killer) && !(isPlayer _killer);

		if (_isKillLeader && _enemy_killed) then {
			private _player = leader group _killer;

			_player addRating ARWA_squad_kill_rating;
		};

		private _isVictimLeader = isPlayer (leader group _victim) && !(isPlayer _victim);

		if (_isVictimLeader) then {
			private _player = leader group _victim;
			private _score = rating _player;

			if(_score > 0) exitWith {
				private _penalty = -(_score min ARWA_squad_kill_rating);
				_player addRating _penalty;
			};
		};

		if (_victim_side in ARWA_all_sides) then {
			private _victim_faction_strength = _victim_side call ARWA_get_strength;

			private _new_faction_strength = if(isPlayer _victim) then {
				_victim_faction_strength - (_manpower_penalty min _victim_faction_strength);
			} else {
				private _death_penalty = (playersNumber _victim_side) + 1;
				_victim_faction_strength - _death_penalty;
			};

			[_victim_side, _new_faction_strength] call ARWA_set_strength;
		};
	};
};
