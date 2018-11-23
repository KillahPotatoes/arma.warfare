join_menu_open = false;
join_options = [];

remove_all_join_options = {
	{
		player removeAction _x;
	} forEach join_options;

	join_options = [];
};

empty_squad = {
	params ["_player"];

	{ alive _x } count units (group _player) == 1;
};

join_squad = {  
  	params ["_group"];

	private _player_group = group player;	
	[player] join _group;

	private _new_count = { alive _x } count units _group;
	_group setVariable [soldier_count, _new_count];		

	deleteGroup _player_group;
};

leave_squad = {  
  	player addAction [["Leave squad", 0] call addActionText, {
		private _current_group = group player;
		[player] join grpNull;

		private _new_count = { alive _x } count units _current_group;
		_current_group setVariable [soldier_count, _new_count];	
    }, nil, arwa_squad_actions, true, true, "",
    '!(player call empty_squad)'
    ];
};

find_friendly_squads = {
	params ["_group", "_side", "_distance"];
		
	!(group player isEqualTo _group)
	&& (side _group isEqualTo _side) 
	&& [(leader _group)] call not_in_vehicle 
	&& (_pos distance (leader _group)) < _distance;
};

get_friendly_squads_in_area = {
	params ["_pos", "_side", ["_distance", 50]];
	allGroups select { [_x, _side, _distance] call find_friendly_squads; };
};

any_friendly_squads_in_area = {
	params ["_pos", "_side", ["_distance", 50]];
	allGroups findIf { [_x, _side, _distance] call find_friendly_squads; } != -1;
};

get_squad_name = {
	params ["_group"];
	_split_string = [groupId _group, 0] call split_string;
	_split_string select 1;
};

list_join_options = {
	params ["_priority"];

	private _side = side player;
	private _squads = [getPos player, side player] call get_friendly_squads_in_area;

	{
		private _name = [_x] call get_squad_name;
		join_options pushBack (player addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _group = _params select 0;

			[_group] call join_squad;
			[] call remove_all_join_options;
		}, [_x], (_priority - 1), false, true, "", 'player call empty_squad', 10]);

	} forEach _squads;
};

create_join_menu = {
	player addAction [["Join squad", 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		[] call remove_all_join_options;

		if(!join_menu_open) then {
			[91] call list_join_options;
			join_menu_open = true;
		} else {
			join_menu_open = false;
		}
	}, [], arwa_squad_actions, false, false, "", 'player call empty_squad && {[getPos player, side player] call any_friendly_squads_in_area}', 10]	
};
