spawn_defensive_squad = {
	params ["_pos", "_side"];

	private _number_of_soldiers = arwa_defender_cap call calc_number_of_soldiers;
    private _group = [[_pos select 0, _pos select 1, 3000], _side, _number_of_soldiers, true] call spawn_infantry;
	
	[_group, _pos] call place_defensive_soldiers;
	[_group] call remove_nvg_and_add_flash_light;

	[_group] call spawn_defense_vehicle;

    _group setBehaviour "SAFE";
	_group setVariable [defense, true];

	_group;
};

place_defensive_soldiers = {
	params ["_group","_pos"];

	private _positions = [_pos] call get_positions_to_populate;
	private _units = units _group;
	
	private _counter = 1;

	{
		if (_forEachIndex < (count _positions) && _counter > 2) then { // Atleast two people spawn in center
			(_x) setPosATL (_positions select _forEachIndex);
		} else {
			private _safe_pos = [_pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
			(_x) setPos _safe_pos;
		};

		_counter = _counter + 1;

	} forEach _units;                        ;
};

get_positions_to_populate = {
	params ["_pos"];
	
	private _houses = _pos nearObjects ["house", arwa_sector_size / 2];

	private _positions = [];

	{
		_positions = _positions + (_x buildingPos -1);
	} forEach _houses;

	_positions call BIS_fnc_arrayShuffle;
};

calc_number_of_soldiers = {
	params ["_soldier_cap"];
	floor random [_soldier_cap / 2, _soldier_cap / 1.5, _soldier_cap];
};

spawn_reinforcments = {
	params ["_pos", "_group"];
	
	private _side = side _group;
    private _group_count = {alive _x} count units _group;

	private _new_soldiers = 0 max ((arwa_defender_cap call calc_number_of_soldiers) - _group_count);

	if(_new_soldiers < 1) exitWith {};

    private _pos = _sector getVariable pos;	
    private _tmp_group = [[_pos select 0, _pos select 1, 3000], _side, _new_soldiers, true] call spawn_infantry;
	
	[_tmp_group, _pos] call place_defensive_soldiers;

    {[_x] joinSilent _group} forEach units _tmp_group;
	deleteGroup _tmp_group;
};
