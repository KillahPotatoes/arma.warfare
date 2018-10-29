is_alive = {
	params ["_unit"];
	"HEALTHY" isEqualTo (lifeState _unit) || "INJURED" isEqualTo (lifeState _unit);
};

get_crew = {
	params ["_vehicles"];

	private _crew = [];

	{
		_crew = _crew + crew _x;
	} foreach _vehicles;

	_crew;
};

get_all_units_in_area = {
	params ["_pos", "_distance"];

	private _infantry = _pos nearEntities [["Man"], _distance];
	private _vehicles = _pos nearEntities [["Car", "Tank", "Static"], _distance];

	_infantry = [_infantry, { _x call is_alive && isTouchingGround _x }] call BIS_fnc_conditionalSelect;
	_vehicles = [_vehicles, { isTouchingGround _x && {_x call is_alive} count (crew _x) > 0}] call BIS_fnc_conditionalSelect;

	private _crew = [_vehicles] call get_crew;

	_infantry + _crew;
};

get_all_factions_in_list = {
	params ["_units"];

	private _factions = [];

	{
		if((_x countSide _units) > 0) then {
			_factions = _factions + [_x];
		};
	} foreach factions;
	
	_factions;
};

any_enemies_in_list = {
	params ["_units", "_side"];

	private _enemies = factions - [_side];
	private _factions = [_units] call get_all_factions_in_list;

	private _any = false;
	{
		if(_x in _factions) exitWith { _any = true; };
	} foreach _enemies;

	_any;
};

any_friendlies_in_list = {
	params ["_units", "_side"];

	private _factions = [_units] call get_all_factions_in_list;
	_side in _factions;
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

