is_alive = {
	params ["_unit"];
	"HEALTHY" isEqualTo (lifeState _unit) || "INJURED" isEqualTo (lifeState _unit);
};

get_crew = {
	params ["_vehicles"];

	private _crews = [];

	{
		_crews append crew _x;
	} foreach _vehicles;

	_crews;
};

get_all_units_in_area = {
	params ["_pos", "_distance"];

	private _infantry = _pos nearEntities [["Man"], _distance];
	private _vehicles = _pos nearEntities [["Car", "Tank", "Static"], _distance];

	_infantry = _infantry select { _x call is_alive && isTouchingGround _x };
	_vehicles = _vehicles select { isTouchingGround _x && ((crew _x) findIf {_x call is_alive} != -1)};

	private _crew = [_vehicles] call get_crew;

	_infantry + _crew;
};

any_enemies_in_list = {
	params ["_units", "_side"];

	private _enemyFactions = all_sides - [_side];

	_units findIf {(side _x) in _enemyFactions} != -1
};

any_friendlies_in_list = {
	params ["_units", "_side"];

	_units findIf {side _x isEqualTo _side} != -1
};

any_enemies_in_area = {
	params ["_pos", "_side", "_distance"];

	private _units = [_pos, _distance] call get_all_units_in_area;
	[_units, _side] call any_enemies_in_list;
};

any_friendlies_in_area = {
	params ["_pos", "_side", "_distance"];
	private _units = [_pos, _distance] call get_all_units_in_area;
	[_units, _side] call any_friendlies_in_list;
};



