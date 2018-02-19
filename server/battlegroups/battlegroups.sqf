EAST_battle_groups = [];
WEST_battle_groups = [];
GUER_battle_groups = [];

RemoveNullGroupsFromArray = {
	_array = _this select 0;

	_temp_array = [];	
	{
      	if (isNull _x) then {
        	_temp_array pushBack _x;
		}; 
	} forEach _array;

	_array - _temp_array;
};

GetBattleGroups = {
	_side = _this select 0;
	missionNamespace getVariable format["%1_battle_groups", _side];
};

AddBattleGroups = {	
	_group = _this select 0;
	_side = side _group;

	_groups = missionNamespace getVariable format["%1_battle_groups", _side];
	_groups pushBackUnique _group;
};

GetAllBattleGroups = {
	EAST_battle_groups = [EAST_battle_groups] call RemoveNullGroupsFromArray;
	WEST_battle_groups = [WEST_battle_groups] call RemoveNullGroupsFromArray;
	GUER_battle_groups = [GUER_battle_groups] call RemoveNullGroupsFromArray;

	EAST_battle_groups + WEST_battle_groups + GUER_battle_groups;
};

CountBattlegroupUnits = {
	_side = _this select 0;
	_sum = 0;

	{
		_group = _x;
		_sum = _sum + ({alive _x} count units _group);
	} forEach ([_side] call GetBattleGroups);

	_sum;
};