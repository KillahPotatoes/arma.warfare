[] call compileFinal preprocessFileLineNumbers "server\manpower_box.sqf";


add_kill_ticker_to_all_units = {
	while {true} do {
		sleep 2;
		{
			if !(_x getVariable ["killTickerEventAdded",false]) then {
				_x spawn kill_ticker;
				_x setVariable ["killTickerEventAdded",true]
			};
		} count allUnits;
	};
};

add_kill_ticker_to_all_vehicles = {
	while {true} do {
		sleep 2;
		{
			if( _x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air") then { 
				if !(_x getVariable ["killTickerEventAdded",false]) then {
					_x spawn on_vehicle_kill;
					_x setVariable ["killTickerEventAdded",true]
				};
			};
		} count vehicles;
	};
};

on_vehicle_kill = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];
	
			[_victim, _killer] spawn report_lost_vehicle;
			[_victim] spawn induce_lost_vehicle_penalty;
			[_victim, _killer] spawn induce_vehicle_kill_bonus;
			[_victim] spawn create_manpower_box_vehicle;
		}
	];
};

induce_vehicle_kill_bonus = {
	params ["_victim", "_killer"];
	if(arwa_vehicleKillBonus > 0) then {
		if (!(isNil "_victim" || isNil "_killer")) then {
			private _killer_side = side group _killer;
			private _victim_side = _victim getVariable owned_by;    

			if (!(_victim_side isEqualTo _killer_side) && {isPlayer _killer}) then {
				private _kill_bonus = _victim getVariable arwa_kill_bonus;
				private _adjusted_kill_bonus = if(arwa_vehicleKillBonus == 1) then { _kill_bonus/2; } else { _kill_bonus; };
				private _faction_strength = _killer_side call get_strength;
				private _new_faction_strength = _faction_strength + _adjusted_kill_bonus;
				[_killer_side, _new_faction_strength] call set_strength;

				private _veh_name = (typeOf _victim) call get_vehicle_display_name;
				private _values = ["VEHICLE_KILL_BONUS", _adjusted_kill_bonus, _veh_name];	
				[_killer_side, _values] remoteExec ["HQ_report_client"];
			};		
		};		
	};
};

induce_lost_vehicle_penalty = {
	params ["_victim"];

	private _penalty = _victim getVariable [arwa_penalty, 0];

	if(_penalty > 0) exitWith {
		private _side = _victim getVariable owned_by;
		
		private _faction_strength = _side call get_strength;
		private _new_faction_strength = _faction_strength - _penalty;
		[_side, _new_faction_strength] call set_strength;

		private _veh_name = (typeOf _victim) call get_vehicle_display_name;

		[_side, ["PLAYER_VEHICLE_LOST", _penalty, _veh_name]] remoteExec ["HQ_report_client"];
	};
};

report_lost_vehicle = {
	params ["_victim", "_killer"];
		
	private _veh_name = (typeOf _victim) call get_vehicle_display_name;
	private _pos = getPosWorld _victim;
	private _closest_sector = [sectors, _pos] call find_closest_sector;
	private _sector_pos = _closest_sector getVariable pos;
	private _distance = floor(_sector_pos distance2D _pos);
	private _location = [_closest_sector getVariable sector_name] call replace_underscore;
	private _side = _victim getVariable owned_by;

	private _values = if (_distance > 200) then {
		private _direction = [_sector_pos, _pos] call get_direction;
		["VEHICLE_LOST", _veh_name, _distance, _direction, _location];	
	} else {
		["VEHICLE_LOST_IN_SECTOR", _veh_name, _location];			
	};				
	
	[_side, _values] remoteExec ["HQ_report_client"];	
};

kill_ticker = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];

			private _victim_side = side group _victim;
			private _faction_strength = _victim_side call get_strength;

			[_victim, _killer, _faction_strength] spawn register_kill;
			[_victim, _victim_side, _faction_strength] spawn create_manpower_box_unit;
		}
	];
};

calculate_kill_points = {
	params ["_killer_side"];
	1 / (((_killer_side countSide allPlayers) + 1) min 2);
};

calculate_player_death_penalty = {
	params ["_faction_strength"];
	floor (5 max (_faction_strength / 10));
};

register_kill = {
	params ["_victim", "_killer", "_faction_strength"];

	if (!(isNil "_victim" || isNil "_killer")) then {
		private _killer_side = side group _killer;
		private _victim_side = side group _victim;    

		if (!(_victim_side isEqualTo _killer_side) && {_killer_side in arwa_all_sides}) then {
			_kill_point = _killer_side call calculate_kill_points;	
			[_killer_side, _kill_point] call increment_kill_counter;
		};

		private _isKillLeader = isPlayer (leader group _killer);

		if ((isPlayer _killer) || _isKillLeader) then {
			private _player = if(_isKillLeader) then { leader group _killer; } else { _killer; };			

			private _kills = _player getVariable ["kills", 0];
			private _new_kills = if(_killer_side isEqualTo _victim_side) then { _kills - 1; } else { _kills + 1; };

			_player setVariable ["kills", _new_kills, true];
		};

		private _isVictimLeader = isPlayer (leader group _victim);

		if (_isVictimLeader) then {
			private _player = leader group _victim;
			private _kills = _player getVariable ["kills", 0];
			_player setVariable ["kills", _kills - 2, true];
		};

		if (_victim_side in arwa_all_sides) then {
			_death_penalty = ((_victim_side countSide allPlayers) + 1) min 2;
			
			private _new_faction_strength = if(isPlayer _victim) then { _faction_strength - ([_faction_strength] call calculate_player_death_penalty); } else { _faction_strength - _death_penalty };		
			[_victim_side, _new_faction_strength] call set_strength;
		};
	};	
};

