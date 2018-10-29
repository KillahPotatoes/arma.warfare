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

spawn_defensive_squad = {
	params ["_sector"];

	private _side = _sector getVariable owned_by;
	private _pos = _sector getVariable pos;
    private _group = [[_pos select 0, _pos select 1, 3000], _side, defender_cap call calc_number_of_soldiers, true] call spawn_infantry;
	
	[_group, _pos] call place_defensive_soldiers;
	[_group] call remove_nvg_and_add_flash_light;

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
		}

		_counter = _counter + 1;

	} forEach                                                                   ;
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

calc_number_of_soldiers = {
	params ["_soldier_cap"];
	floor random [_soldier_cap / 2, _soldier_cap / 1.5, _soldier_cap];
};

spawn_reinforcments = {
	params ["_sector", "_defenders", "_side"];
	
    private _group_count = {alive _x} count units _defenders;

	private _new_soldiers = 0 max ((defender_cap call calc_number_of_soldiers) - _group_count);

    private _pos = _sector getVariable pos;	
    private _group = [[_pos select 0, _pos select 1, 3000], _side, _new_soldiers, true] call spawn_infantry;
	
	[_group, _pos] call place_defensive_soldiers;

    {[_x] joinSilent _defenders} forEach units _group;
	deleteGroup _group;
	_defenders;
};

spawn_sector_squad = {
	params ["_sector"];

	sleep 10; // So you wont hit them with your car!

	private _side = _sector getVariable owned_by;
	private _sector_defense = _sector getVariable sector_def;

	if(isNil "_sector_defense") exitWith {
		_defensive_squad = [_sector] call spawn_defensive_squad;	
		_sector setVariable [sector_def, _defensive_squad];		
	}; 	

	if (side _sector_defense isEqualTo _side) exitWith {
		_defensive_squad = [_sector, _sector_defense, _side] call spawn_reinforcments;
		
	};

	if(!(side _sector_defense isEqualTo _side)) exitWith {
		if({alive _x} count units _sector_defense > 0) then {			
			_sector_defense call add_battle_group;
		};

		_defensive_squad = [_sector] call spawn_defensive_squad;	
		_sector setVariable [sector_def, _defensive_squad];
	};
};
