initialize_battle_groups = {
	missionNamespace setVariable ["west_groups", [], true];
	missionNamespace setVariable ["east_groups", [], true];
	missionNamespace setVariable ["guer_groups", [], true];
};

get_battlegroups = {
	params ["_side"];
	missionNamespace getVariable format["%1_groups", _side];
};

remove_null = {
	params ["_array"];
	private _new_arr = [];	

	{
      	if (!isNull _x) then {
        	_new_arr pushBack _x;
		}; 
	} forEach _array;

	_new_arr;
};

add_battle_group = {	
	params ["_group", ["_active", true]];	
	_group setVariable ["active", _active];
	_curr_count = {alive _x} count (units _group);
	_group setVariable [soldier_count, _curr_count];
    _group deleteGroupWhenEmpty true;

	((side _group) call get_battlegroups) pushBackUnique _group;

	_group call initialize_battlegroup_ai;
};

get_all_battle_groups = {
	EAST_groups = [EAST_groups] call remove_null;
	WEST_groups = [WEST_groups] call remove_null;
	GUER_groups = [GUER_groups] call remove_null;

	EAST_groups + WEST_groups + GUER_groups;
};

count_battlegroup_units = {
	params ["_side"];
	
	private _groups = [_side] call get_battlegroups;
	_sum = 0;

	{
		_group = _x;
		_sum = _sum + ({alive _x} count units _group);
	} forEach _groups;

	_sum;
};

group_nearby = {
	params ["_group", "_pos", "_distance"];

	((getPos leader _group) distance _pos) < _distance;
};

in_vehicle = {
	params ["_group"];
	private _veh = vehicle leader _group;
	(_veh isKindOf "Car" || _veh isKindOf "Tank" || _veh isKindOf "Air");
};


