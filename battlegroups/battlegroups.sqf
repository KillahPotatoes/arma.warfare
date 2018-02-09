EAST_battle_groups = [];
WEST_battle_groups = [];
GUER_battle_groups = [];

GetBattleGroups = {
	_side = _this select 0;
	missionNamespace getVariable format["%1_battle_groups", _side];
};

AddBattleGroups = {	
	_group = _this select 0;
	_side = side _group;

	_groups = missionNamespace getVariable format["%1_battle_groups", _side];
	_groups pushBack _group;
};

GetAllBattleGroups = {
	EAST_battle_groups + WEST_battle_groups + GUER_battle_groups;
};
