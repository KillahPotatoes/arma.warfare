find_units_in_area = {
	params ["_position", "_distance", "_side"];

	_infantrycount = _side countSide ( [ _position nearEntities [ "Man", _distance] , { !("INCAPACITATED" isEqualTo (lifeState _x)) && ((getpos _x) select 2 < 100) } ] call BIS_fnc_conditionalSelect );
	_countedvehicles =  [ ( _position nearEntities [ ["Car", "Tank"], _distance] ), { ((getpos _x) select 2 < 200) && count (crew _x) > 0 } ] call BIS_fnc_conditionalSelect;
	_vehiclecrewcount = 0;
	{ _vehiclecrewcount = _vehiclecrewcount + (_side countSide (crew _x)) } count _countedvehicles;

	(_infantrycount + _vehiclecrewcount);
};

any_units_in_sector = {
	params ["_position", "_side"];
	
	[_position, sector_size, _side] call find_units_in_area > 0;
}; 

any_units_in_sector_center = {
	params ["_position", "_side"];
	
	[_position, sector_size / 4, _side] call find_units_in_area > 0;
}; 

any_enemies_nearby_sector = {
	params ["_position", "_side"];

	private _enemies = (factions - [_side]);

	_faction_nearby = {
		[_position, sector_size * 2, _x] call find_units_in_area > 0;
	} count _enemies;
	
	_faction_nearby > 0;
}; 

is_air_space_clear = {
	params ["_pos"];
	(count (_pos nearEntities [ ["Air"], 100]) == 0); 
};