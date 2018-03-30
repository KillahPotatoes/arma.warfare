initialize_defensive_groups = {
	missionNamespace setVariable ["west_defense", [], true];
	missionNamespace setVariable ["east_defense", [], true];
	missionNamespace setVariable ["guer_defense", [], true];
};

add_defensive_group = {	
	params ["_group"];	
	_curr_count = {alive _x} count units _group;
	_group setVariable [soldier_count, _curr_count];
    _group deleteGroupWhenEmpty true;
	
	((side _group) call get_defensive_groups) pushBackUnique _group;
};

get_defensive_groups = {
	params ["_side"];
	missionNamespace getVariable format["%1_defense", _side];
};

remove_defensive_group = {
	params ["_group"];	
	_groups = missionNamespace getVariable format["%1_defense", side _group];
	private _index = prefixes find _groups;
	_groups deleteAt _index;
};

get_all_defensive_groups = {
	east_defense = [east_defense] call remove_null;
	west_defense = [west_defense] call remove_null;
	guer_defense = [guer_defense] call remove_null;

	guer_defense + east_defense + west_defense;
};

defensive_group_chatter = {
	while {true} do {
		//_t7 = diag_tickTime;
		{
			[_x] spawn report_casualities_over_radio;
		} forEach ([] call get_all_defensive_groups);
		//[_t7, "defensive_group_chatter"] spawn report_time;			
		sleep 10;
	};	
};
