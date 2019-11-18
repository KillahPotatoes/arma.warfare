ARWA_random_vehicle_activity_dist = 1000;

ARWA_spawn_random_vehicle = {
	params ["_player"];
	private _player_pos = getPos _player;

	private _all_roads = _player_pos nearRoads ARWA_random_vehicle_activity_dist;
	private _edge_roads = _all_roads select { _x distance2D _player_pos > ARWA_random_vehicle_activity_dist - 100; };

	if(_edge_roads isEqualTo []) exitWith {
		["No roads found"]  call ARWA_debugger;
	};

	private _edge_road = selectRandom _edge_roads;
	private _road_pos = getPos _edge_road;
	private _most_distant_edge_road = [_road_pos, _edge_roads] call find_most_distance_edge_road;

	[format["_most_distant_edge_road: %1", _most_distant_edge_road]]  call ARWA_debugger;

	if((_most_distant_edge_road select 0) < ARWA_random_vehicle_activity_dist) exitWith {
		[format["Not enough distance: %1", _most_distant_edge_road select 0]]  call ARWA_debugger;
	};

	private _dir = [_edge_road, _player_pos] call ARWA_find_direction_of_road_towards_player;

	private _sector = [ARWA_sectors, _road_pos] call ARWA_find_closest_sector;
	private _owner = _sector getVariable ARWA_KEY_owned_by;
	private _is_safe_area = (side group _player) isEqualTo _owner;

	private _side = nil;
	private _preset = nil;

	if(selectRandom[_is_safe_area, true]) then {
		["Spawning civilian vehicle"]  call ARWA_debugger;
		_side = civilian;
		_preset = missionNamespace getVariable "ARWA_civilian_vehicles";
	} else {
		private _civilian_area = _owner isEqualTo civilian;

		if(selectRandom[true, false, _civilian_area]) then {
			_side = civilian;
		} else {
			_side = if(_civilian_area) then {
				private _enemies = ARWA_all_sides - [(side group _player)];
				_side = [_enemies, _player_pos] call ARWA_closest_hq;
			} else {
				_owner;
			};
		};

		[format["Spawning %1 vehicle", _side]]  call ARWA_debugger;
		_preset = missionNamespace getVariable format["ARWA_%1_sympathizers_vehicles", _side];
	};

	private _vehicle_type = selectRandom _preset;
	private _veh_array = [getPos _edge_road, _dir, _vehicle_type, _side] call ARWA_spawn_vehicle;
	private _veh = _veh_array select 0;
	private _group = _veh_array select 2;

	{
		ARWA_random_enemies pushBack _x;
	} forEach units _group;

	if(_side isEqualTo civilian) then {
		_veh forceFollowRoad true;
	};

	[_group, ARWA_random_vehicle_activity_dist * 1.5, _veh] spawn ARWA_remove_when_no_player_closeby;
	[_veh, _edge_roads] spawn ARWA_create_waypoint;
};

ARWA_find_direction_of_road_towards_player = {
	params ["_road", "_pos"];

	private _dir_towards_player = _road getRelDir _pos;
	[_road, _dir_towards_player] call ARWA_find_right_road_dir;
};

find_most_distance_edge_road = {
	params ["_pos", "_edge_roads"];
	private _pos_and_distance_arr = _edge_roads apply { [_pos distance2D _x, _x] };
	_pos_and_distance_arr sort false;
	_pos_and_distance_arr select 0;
};

ARWA_create_waypoint = {
	params ["_vehicle", "_edge_roads"];

	if(isNil "_vehicle") exitWith {
		["Vehicle does not exits. Not creating new waypoint"] call ARWA_debugger;
	};

	private _veh_pos = getPos _vehicle;
	private _pos_and_distance = [_veh_pos, _edge_roads] call find_most_distance_edge_road;
	private _pos = getPos (_pos_and_distance select 1);
	private _group = group _vehicle;

	private _w = _group addWaypoint [_pos, 0];
	_w setWaypointCompletionRadius 100;

	[format["Vehicle moving from %1 to %2. Distance: %3", _veh_pos, _pos, _pos_and_distance select 0]] call ARWA_debugger;

	_w setWaypointStatements ["true","[group this] call ARWA_free_road_waypoint"];
	_w setWaypointType "MOVE";

	_group setBehaviour "SAFE";
};

ARWA_free_road_waypoint = {
	params ["_group"];

	if({ alive _x; } count units _group == 0) exitWith {
		["Vehicle does not exits. Not creating new waypoint", true] call ARWA_debugger;
	};

	private _pos = getPos leader _group;
	private _all_roads = _pos nearRoads ARWA_random_vehicle_activity_dist;
	private _edge_roads = _all_roads select { _x distance2D _pos > ARWA_random_vehicle_activity_dist - 100; };

	if(_edge_roads isEqualTo []) exitWith {
		["No roads found"] call ARWA_debugger;
	};

	private _edge_road = selectRandom _edge_roads;
	private _road_pos = getPos _edge_road;

	private _w = _group addWaypoint [_road_pos, 0];
	_w setWaypointCompletionRadius 100;

	[format["Vehicle moving from %1 to %2", _pos, _road_pos]] call ARWA_debugger;

	_w setWaypointStatements ["true","[group this] call ARWA_free_road_waypoint"];
	_w setWaypointType "MOVE";

	_group setBehaviour "SAFE";
};