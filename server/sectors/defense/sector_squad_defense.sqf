spawn_defensive_squad = {
	params ["_sector", "_number"];

	private _side = _sector getVariable owned_by;
	private _pos = _sector getVariable pos;
    private _group = [[_pos select 0, _pos select 1, 3000], _side, _number, true] call spawn_infantry;
	
	[_group, _pos] call place_defensive_soldiers;
	[_group] call remove_nvg_and_add_flash_light;

    _group setBehaviour "SAFE";
	_group setVariable [defense, true];

	_group;
};

spawn_defensive_reinforcements = {
	params ["_sector", "_group"];

	private _count = {alive _x} count units _group;

	if(_count <  (defender_cap / 2)) then {
		private _max_count = defender_cap - _count;
		private _unit_count = _max_count call calc_number_of_soldiers;

		private _reinforcments = [_sector, _unit_count] call spawn_defensive_squad;

		{[_x] joinSilent _group} forEach units _reinforcments;
		deleteGroup _reinforcments;
	};	
};

place_defensive_soldiers = {
	params ["_group","_pos"];

	private _positions = [_pos] call get_positions_to_populate;
	private _units = units _group;
	private _counter = 0;
	{
		if (_forEachIndex < (count _positions) && _counter > 2) then {
			(_x) setPosATL (_positions select _forEachIndex);
		} else {
			private _safe_pos = [_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
			(_x) setPos _safe_pos;
		};

		_counter = _counter + 1; // Make sure atleast three units in center

	} forEach _units;
};

get_positions_to_populate = {
	params ["_pos"];
	
	private _houses = _pos nearObjects ["house", sector_size / 2];

	private _positions = [];

	{
		_positions = _positions + (_x buildingPos -1);
	} forEach _houses;

	_positions call BIS_fnc_arrayShuffle;
};