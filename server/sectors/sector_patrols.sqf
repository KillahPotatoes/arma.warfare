create_patrol_waypoint = {
	params ["_pos", "_group", "_type", "_offset"];

	private _w_pos = [(_pos select 0) + (_offset select 0),(_pos select 1) + (_offset select 1),_pos select 2];
	private _safe_pos = [_w_pos, 0, 5, 5, 0, 0, 0] call BIS_fnc_findSafePos;
	
	_w = _group addWaypoint [_safe_pos, 5];
	_w setWaypointType _type;	
};

add_patrol_waypoints = {
	params ["_pos", "_group"];
	_group call delete_all_waypoints; 	
	[_pos, _group, "MOVE", [0, 200, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [125, 125, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [200, 0, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [125, -125, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [0, -200, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [-125, -125, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [-200, 0, 0]] call create_patrol_waypoint;
	[_pos, _group, "MOVE", [-125, 125, 0]] call create_patrol_waypoint;
	
};

spawn_patrol_squad = {
	params ["_sector"];

	_side = _sector getVariable owned_by;
	_safe_pos = [_sector getVariable pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    
    _group = [_safe_pos, _side, patrol_cap, false] call spawn_infantry;
	
    _group setBehaviour "SAFE";	
	_group setSpeedMode "LIMITED";
	_group setFormation "FILE";
	_group call force_flash_light;

	private _pos = _sector getVariable pos;
	[_pos, _group] call add_patrol_waypoints;
};

force_flash_light = {
	params ["_group"];
	
	{
		_x unassignItem "NVGoggles"; 
		_x removeItem "NVGoggles";
		_x addPrimaryWeaponItem "acc_flashlight";
		_x  enableGunLights "forceon";
	} foreach units _group;
};