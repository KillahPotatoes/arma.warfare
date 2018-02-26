delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

create_waypoint = {
	params ["_target", "_group"];
	private _pos = [(_target getVariable pos), 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;

	_group call delete_all_waypoints; 
	_w = _group addWaypoint [_pos, 5];
	_w setWaypointType "SAD";
	
	_group setBehaviour "AWARE";
	_group setSpeedMode "NORMAL";
	groupId (_group) setCombatMode "YELLOW";
	_group setVariable ["target", _target];	
};

move_to_sector = {
	params ["_target", "_group"];

	private _curr_target = _group getVariable "target";

	if (isNil "_curr_target" || {!(_target isEqualTo _curr_target)}) then {
		[_target, _group] call create_waypoint;
	};

	if ((_target getVariable pos) distance2D (getPosWorld _group) < 200) then {

		if ((behaviour _group) isEqualTo "AWARE" || (behaviour _group) isEqualTo "SAFE") then {
			_group setBehaviour "STEALTH";			
		};
		
		_group setSpeedMode "LIMITED";		
		groupId (_group) setCombatMode "RED";
	};		
};

group_ai = {
	while {true} do {
		{		
			private _group = _x;
			private _side = side _group; 

			if (!(player isEqualTo leader _group) && _side in factions) then { // TODO check if in group && (leader or injured) to avoid getting new checkpoints while waiting for revive
				private _pos = getPosWorld (leader _group);

				private _sector_c = [_side] call count_other_sectors; // gets list of uncapturedSectors

				private _target = if(_sector_c > 0) 
					then { 
						[_side, _pos] call find_closest_target_sector;
					} else {
						[_side, _pos] call find_closest_friendly_sector;	
					};
				
				[_target, _group] call move_to_sector;
				[_group] spawn report_casualities;
			};
		} forEach ([] call get_all_battle_groups);
		sleep 10;
	};
};

report_casualities = {
	params [_group];
	sleep random 10;
	_prev_count = _group getVariable soldier_count;
	_curr_count = {alive _x} count units _group;	
	_deaths = _prev_count - _curr_count;
	_group setVariable [soldier_count , _curr_count];
	_gridPos = mapGridPosition leader _group;
	
	if(_deaths == 1) exitWith {
		 (leader _group) sideChat format[selectRandom oneCasualty, _gridPos];
	};

	if(_deaths > 3) exitWith {
		 (leader _group) sideChat format[selectRandom multipleCasualties, _deaths, _gridPos];
	};

	if(_deaths > 1) exitWith {
		 (leader _group) sideChat format[selectRandom heavyCasualties, _deaths, _gridPos];
	};	
};

oneCasualty = [
	"We lost a soldier at %1", 
	"We have one down at %1", 
	"We are one less at %1", 
	"We lost one at %1"
];

multipleCasualties = [
	"We are taking casualties. %1 down at %2", 
	"We just lost %1 soldiers at %2", 
	"We lost %1 guys at %2"
];

heavyCasualties = [
	"We need backup! Just lost %1 at %2",
	"We are taking heavy casualties at %2",
	"Send backup. %1 just got killed at %2"
];
