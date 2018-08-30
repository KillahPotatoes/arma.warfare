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
		}
	];
};

induce_lost_vehicle_penalty = {
	params ["_victim"];

	private _penalty = _victim getVariable "penalty";

	if(!(isNil "_penalty")) exitWith {
		private _side = _penalty select 0;
		private _penalty_size = _penalty select 1;

		_faction_strength = _side call get_strength;
		_new_faction_strength = _faction_strength - _penalty_size;
		[_side, _new_faction_strength] call set_strength;

		private _veh_name = (typeOf _victim) call get_vehicle_display_name;

		private _msg = format["We lost %1 manpower points due to the loss of %2", _penalty_size, _veh_name];
		
		[_side, _msg] call HQ_report;
	};
};

report_lost_vehicle = {
	params ["_victim", "_killer"];
	
	if(count (crew _victim) > 0) then {
		private _veh_name = (typeOf _victim) call get_vehicle_display_name;
		private _pos = getPosWorld _victim;
		private _closest_sector = [sectors, _pos] call find_closest_sector;
		private _sector_pos = _closest_sector getVariable pos;
		private _distance = floor(_sector_pos distance2D _pos);
		private _location = [_closest_sector getVariable sector_name] call replace_underscore;
		private _side = side ((crew _victim) select 0);

		private _msg = if (_distance > 200) then {
			private _direction = [_sector_pos, _pos] call get_direction;
			format["We lost a %1 %2m %3 of %4", _veh_name, _distance, _direction, _location];	
		} else {
			format["We lost a %1 in %2", _veh_name, _location];			
		};				
		
		[_side, _msg] call HQ_report;
	};
};

kill_ticker = {
	_this addMPEventHandler ['MPKilled',{
			params ["_victim", "_killer"];
			[_victim, _killer] spawn register_kill;
		}
	];
};

calculate_kill_points = {
	params ["_killer_side"];
	1 / (((_killer_side countSide allPlayers) + 1) min 2);
};

register_kill = {
	params ["_victim", "_killer"];

	if (!(isNil "_victim" || isNil "_killer")) then {
		private _killer_side = side group _killer;
		private _victim_side = side group _victim;    

		if (!(_victim_side isEqualTo _killer_side) && {_killer_side in factions}) then {
			_kill_point = _killer_side call calculate_kill_points;	
			[_killer_side, _kill_point] call increment_kill_counter;
		};

		if ((isPlayer _killer)) then {
			[] remoteExec ["increment_player_kill_counter", _killer];
		};

		_death_penalty = ((_victim_side countSide allPlayers) + 1) min 2;

		_faction_strength = _victim_side call get_strength;
		_new_faction_strength = if(isPlayer _victim) then { _faction_strength - (5 max (_faction_strength / 10)); } else { _faction_strength - _death_penalty };		
		[_victim_side, _new_faction_strength] call set_strength;
	};	
};

