ARWA_random_vehicle_activity = 1000;

ARWA_find_possible_roads = {
	private _all_roads = getPos player nearRoads ARWA_random_vehicle_activity;
	private _edge_roads = _all_roads select { _x distance2D player > ARWA_random_vehicle_activity - 10; };

	if(!_edge_roads isEqualTo []) exitWith {
		selectRandom _edge_roads;
	};
};

ARWA_find_direction_of_road_towards_player = {
	params ["_road"];

	private _dir_towards_player = _road getRelDir player;
	[_road, _dir_towards_player] call ARWA_find_right_road_dir;
};

ARWA_create_waypoint = {
	params ["_vehicle"];

	private _group = group _vehicle;
	private _dir = _vehicle getDir player;
	private _pos = player getPos [worldSize, _dir];

	_w = (group _vehicle) addWaypoint [_pos, 0];
	_w setWaypointType "MOVE";
	_group setBehaviour "SAFE";
};