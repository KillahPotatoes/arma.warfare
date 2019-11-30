ARWA_join_menu_open = false;
ARWA_join_options = [];

ARWA_remove_all_join_options = {
	{
		player removeAction _x;
	} forEach ARWA_join_options;

	ARWA_join_options = [];
};

ARWA_empty_squad = {
	params ["_player"];

	{ alive _x } count units (group _player) == 1;
};

ARWA_join_squad = {
  	params ["_group"];

	private _player_group = group player;

	[player] join _group;
	(units _player_group) joinSilent _group;

	private _new_count = { alive _x } count units _group;
	_group setVariable [ARWA_KEY_soldier_count, _new_count];

	deleteGroup _player_group;
};

ARWA_leave_squad = {
  	player addAction [[localize "ARWA_STR_LEAVE_SQUAD", 0] call ARWA_add_action_text, {

			private _enemies_nearby = [getPos player, playerSide, ARWA_sector_size] call ARWA_any_enemies_in_area;

			if(_enemies_nearby) exitWith {
				systemChat localize "ARWA_STR_CANNOT_LEAVE_TEAM_WHILE_ENEMIES_NEARBY";
			};

			private _current_group = group player;
			[player] join grpNull;
			[group player] remoteExec ["ARWA_add_battle_group", 2];
			[_current_group] remoteExec ["ARWA_add_battle_group", 2];
			}, nil, ARWA_squad_actions_leave, false, true, "",
    '!(player call ARWA_empty_squad)'
    ];
};

ARWA_find_friendly_squads = {
	params ["_pos", "_group", "_side", "_distance"];

	!(group player isEqualTo _group)
	&& (side _group isEqualTo _side)
	&& [(leader _group)] call ARWA_not_in_vehicle
	&& (_pos distance (leader _group)) < _distance;
};

ARWA_get_friendly_squads_in_area = {
	params ["_pos", "_side", ["_distance", 50]];
	allGroups select { [_pos, _x, _side, _distance] call ARWA_find_friendly_squads; };
};

ARWA_any_friendly_squads_in_area = {
	params ["_pos", "_side", ["_distance", 50]];
	private _any_nearby = allGroups findIf { [_pos, _x, _side, _distance] call ARWA_find_friendly_squads; } != -1;

	if(!_any_nearby) then {
		   [] call ARWA_remove_all_join_options;
			 ARWA_join_menu_open = false;
	};

	_any_nearby;
};

ARWA_get_squad_name = {
	params ["_group"];
	_split_string = [groupId _group, 0] call ARWA_split_string;
	_split_string select 1;
};

ARWA_list_join_options = {
	params ["_priority"];

	private _side = playerSide;
	private _squads = [getPos player, playerSide] call ARWA_get_friendly_squads_in_area;

	{
		private _name = [_x] call ARWA_get_squad_name;
		ARWA_join_options pushBack (player addAction [[_name, 2] call ARWA_add_action_text, {
			private _params = _this select 3;
			private _group = _params select 0;

			[_group] call ARWA_join_squad;
			[] call ARWA_remove_all_join_options;
			[] call ARWA_remove_all_transport_options;
		}, [_x], (_priority - 1), false, true, "", '[player] call ARWA_is_leader', 10]);

	} forEach _squads;
};

ARWA_create_join_menu = {
	player addAction [[localize "ARWA_STR_JOIN_SQUAD", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		[] call ARWA_remove_all_join_options;

		if(!ARWA_join_menu_open) then {
			[ARWA_squad_actions_join] call ARWA_list_join_options;
			ARWA_join_menu_open = true;
		} else {
			ARWA_join_menu_open = false;
		}
	}, [], ARWA_squad_actions_join, false, false, "", '[player] call ARWA_is_leader && {[getPos player, playerSide] call ARWA_any_friendly_squads_in_area}', 10]
};

ARWA_can_take_lead = {
	 	private _leader = leader (group player);
		!(_leader isEqualTo player) && !(isPlayer _leader);
};

ARWA_take_lead_menu = {
	player addAction [[localize "ARWA_STR_TAKE_LEAD", 0] call ARWA_add_action_text, {
		private _rank = rank player;
		private _rank_index = ARWA_ranks find _rank;

		if(ARWA_required_rank_take_lead > _rank_index) exitWith {
			private _required_rank_name = ARWA_ranks select ARWA_required_drone_rank;
			systemChat format[localize "ARWA_STR_LEAD_NOT_REQUIRED_RANK", _required_rank_name, _rank];
		};

		(group player) selectLeader player;
	}, [], ARWA_squad_actions, false, true, "", '[] call ARWA_can_take_lead', 10]
};
