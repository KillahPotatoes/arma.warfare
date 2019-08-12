ARWA_is_alive = {
	params ["_unit"];
	"HEALTHY" isEqualTo (lifeState _unit) || "INJURED" isEqualTo (lifeState _unit);
};

ARWA_get_crew = {
	params ["_vehicles"];

	private _crews = [];

	{
		_crews append crew _x;
	} foreach _vehicles;

	_crews;
};

ARWA_get_all_units_in_area = {
	params ["_pos", "_distance", ["_touch_ground", true]];

	private _infantry = _pos nearEntities [["Man"], _distance];
	private _vehicles = _pos nearEntities [["Car", "Tank", "Static"], _distance];

	_infantry = _infantry select { !((side _x) isEqualTo civilian) && _x call ARWA_is_alive && (isTouchingGround _x || !_touch_ground) };
	_vehicles = _vehicles select { !((side _x) isEqualTo civilian) && (isTouchingGround _x || !_touch_ground) && ((crew _x) findIf {_x call ARWA_is_alive} != -1)};

	private _crew = [_vehicles] call ARWA_get_crew;

	_infantry + _crew;
};

ARWA_any_enemies_in_list = {
	params ["_units", "_side"];

	private _enemyFactions = ARWA_all_sides - [_side];

	_units findIf {(side _x) in _enemyFactions} != -1
};

ARWA_any_friendlies_in_list = {
	params ["_units", "_side"];

	_units findIf {side _x isEqualTo _side} != -1
};

ARWA_any_enemies_in_area = {
	params ["_pos", "_side", "_distance"];

	private _units = [_pos, _distance] call ARWA_get_all_units_in_area;
	[_units, _side] call ARWA_any_enemies_in_list;
};

ARWA_any_friendlies_in_area = {
	params ["_pos", "_side", "_distance", ["_touch_ground", true]];
	private _units = [_pos, _distance, _touch_ground] call ARWA_get_all_units_in_area;
	[_units, _side] call ARWA_any_friendlies_in_list;
};



