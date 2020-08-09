ARWA_support_soldiers = [];
ARWA_support_soldiers_class_names = [];
ARWA_support_soldiers_loadouts = [];

ARWA_remove_all_support_options = {
	private _options = player getVariable [ARWA_KEY_menu, []];

	{
		player removeAction _x;
	} forEach _options;

	player setVariable [ARWA_KEY_menu, []];
};

ARWA_get_support_infantry = {
	params ["_class_name", "_type"];
	_group = group player;
	_group_count = {alive _x} count units _group;
	private _rank = rank player;
	private _rank_index = ARWA_ranks find _rank;

	private _squad_cap_based_off_rank = (_rank_index * 2) + 6;

	_numberOfSoldiers = _squad_cap_based_off_rank - _group_count - (count ARWA_support_soldiers);

	if (_numberOfSoldiers > 0) exitWith {
		if(_type isEqualTo ARWA_KEY_custom_infantry) then {
			ARWA_support_soldiers append [_class_name];
			ARWA_support_soldiers_loadouts append [_class_name];
		} else {
			private _name = _class_name call ARWA_get_vehicle_display_name;
			ARWA_support_soldiers append [_name];
			ARWA_support_soldiers_class_names append [_class_name];
		};
	};

	systemChat localize "ARWA_STR_MAXIMUM_AMOUNT_OF_UNITS";
};


ARWA_get_support_interceptor = {
	params ["_class_name", "_penalty", "_side"];

	private _pos = [_side, ARWA_interceptor_safe_distance, ARWA_interceptor_flight_height] call ARWA_find_spawn_pos_air;
	private _dir = [_pos] call ARWA_find_spawn_dir_air;

	private _veh_arr = [_class_name, _penalty, playerSide, _pos, _dir] call ARWA_spawn_interceptor;
	private _veh = _veh_arr select 0;

	_veh setVariable [ARWA_penalty, _penalty, true];

	// TODO add to team under different team color
};

ARWA_get_support_vehicle = {
	params ["_base_marker", "_class_name", "_penalty"];

	private _pos = getPos _base_marker;
	private _isEmpty = !([_pos] call ARWA_any_units_too_close);

	if (_isEmpty) exitWith {
		private _veh_arr = [_pos, getDir _base_marker, _class_name, playerSide, _penalty] call ARWA_spawn_vehicle;

		private _veh = _veh_arr select 0;
		private _group = _veh_arr select 2;

		_veh setDir (getDir _base_marker);

		_veh setVariable [ARWA_penalty, _penalty, true];
		_veh setVariable [ARWA_KEY_owned_by, playerSide, true];

		[_group, "YELLOW"] call ARWA_add_support_to_squad;

		_veh doMove (getPos player);
	};
	private _type = _class_name call ARWA_get_vehicle_display_name;
	systemChat format[localize "ARWA_STR_OBSTRUCTING_THE_RESPAWN_AREA", _type];
};

ARWA_get_support_helicopter = {
	params ["_class_name", "_penalty"];

	private _veh_arr = [playerSide, _class_name, _penalty, ARWA_gunship_spawn_height] call ARWA_spawn_helicopter;
	private _veh = _veh_arr select 0;
	private _group = _veh_arr select 2;

	_veh setVariable [ARWA_penalty, _penalty, true];
	_veh setVariable [ARWA_KEY_owned_by, playerSide, true];

	[_group, "RED"] call ARWA_add_support_to_squad;

	_veh doMove (getPos player);
};

ARWA_add_support_to_squad = {
	params ["_group", "_team"];

	private _player_group = group player;

	private _new_units = units _group;
	_new_units joinSilent _player_group;

	{ _x assignTeam _team; } count _new_units;

	private _new_count = { alive _x } count units _player_group;
	_player_group setVariable [ARWA_KEY_soldier_count, _new_count];

	deleteGroup _group;
};

ARWA_list_support_options = {
	params ["_type", "_priority", "_title", "_options"];

	/*if(_type isEqualTo ARWA_KEY_helicopter) then {
		_options append (missionNamespace getVariable format["ARWA_%1_%2_transport", playerSide, ARWA_KEY_helicopter]);
	};

	if(_type isEqualTo ARWA_KEY_vehicle) then {
		_options append (missionNamespace getVariable format["ARWA_%1_%2_transport", playerSide, ARWA_KEY_vehicle]);
	};*/

	private _sub_options = [];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call ARWA_get_vehicle_display_name;

		_sub_options pushBack (player addAction [[_name, 2] call ARWA_add_action_text, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;
			private _title = _params select 3;

			player setVariable [format["Menu_support_%1", _title], false];

			[] call ARWA_remove_all_support_options;

			if(([playerSide] call ARWA_get_strength) <= 0) exitWith {
				systemChat localize "ARWA_STR_NOT_ENOUGH_MANPOWER";
			};

			if(_type isEqualTo ARWA_KEY_infantry || _type isEqualTo ARWA_KEY_custom_infantry) exitWith {
				[_class_name, _type] call ARWA_get_support_infantry;
			};

			if (_type isEqualTo ARWA_KEY_helicopter) exitWith {
				[_class_name, _penalty] call ARWA_get_support_helicopter;
			};

			if (_type isEqualTo ARWA_KEY_vehicle) exitWith {
				private _base_marker_name = [playerSide, _type] call ARWA_get_prefixed_name;
				private _base_marker = missionNamespace getVariable _base_marker_name;

				[_base_marker, _class_name, _penalty] call ARWA_get_support_vehicle;
			};

			if (_type isEqualTo ARWA_KEY_interceptor) exitWith {
				[_class_name, _penalty, playerSide] call ARWA_get_support_interceptor;
			};
		}, [_class_name, _penalty, _type, _title], (_priority - 1), false, true, "", '', 10]);

	} forEach _options;

	_current_options = player getVariable [ARWA_KEY_menu, []];
	_current_options append _sub_options;
	player setVariable [ARWA_KEY_menu, _current_options];
};

ARWA_add_clear_selection = {
	private _sub_options = (player addAction [[localize "ARWA_STR_CLEAR_SELECTION", 2] call ARWA_add_action_text, {
		ARWA_support_soldiers = [];
		ARWA_support_soldiers_class_names = [];
		ARWA_support_soldiers_loadouts = [];
		[] call ARWA_remove_all_support_options;
	}, [], (_priority - 1), false, true, "", '', 10]);

	_current_options = player getVariable [ARWA_KEY_menu, []];
	_current_options pushBack _sub_options;
	player setVariable [ARWA_KEY_menu, _current_options];
};

ARWA_create_support_menu = {
	params ["_title", "_type", "_priority"];

	player setVariable [format["Menu_support_%1", _title], false];

	player addAction [[_title, 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _title = _arguments select 2;

		[] call ARWA_remove_all_support_options;

		if(([playerSide] call ARWA_get_strength) <= 0) exitWith {
			systemChat localize "ARWA_STR_NOT_ENOUGH_MANPOWER";
		};

		private _options = [playerSide, _type] call ARWA_get_units_based_on_tier;

		if(_options isEqualTo []) exitWith {
			systemChat localize "NO_AVAILABLE_OPTIONS";
		};

		private _open = player getVariable format["Menu_support_%1", _title];

		if(!_open) then {
			[_type, _priority, _title, _options] call ARWA_list_support_options;

			if(ARWA_AllowCustomInfantry && _type isEqualTo ARWA_KEY_infantry) then {
				private _custom_options = [] call ARWA_get_custom_infantry_options;
				[ARWA_KEY_custom_infantry, _priority - 1, _title, _custom_options] call ARWA_list_support_options;
			};

			if((_type isEqualTo ARWA_KEY_infantry || _type isEqualTo ARWA_KEY_custom_infantry) && ((count ARWA_support_soldiers) > 0)) then {
				[] call ARWA_add_clear_selection;
			};

			player setVariable [format["Menu_support_%1", _title], true];
		} else {
			player setVariable [format["Menu_support_%1", _title], false];
		}
	}, [_type, _priority, _title], _priority, false, false, "", '[player] call ARWA_is_leader', 10]
};
