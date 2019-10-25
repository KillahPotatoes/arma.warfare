ARWA_remove_all_options = {
	params ["_box"];

	private _options = _box getVariable [ARWA_KEY_menu, []];

	{
		_box removeAction _x;
	} forEach _options;

	_box setVariable [ARWA_KEY_menu, []];
};

ARWA_create_soldier = {
	params ["_group", "_class_name"];
	_class_name createUnit[getPos player, _group, "", ([] call ARWA_get_skill_based_on_rank)];
};

ARWA_get_infantry = {
	params ["_class_name"];
	_group = group player;
	_group_count = {alive _x} count units _group;
	private _rank = rank player;
	private _rank_index = ARWA_ranks find _rank;

	private _squad_cap_based_off_rank = (_rank_index * 2) + 6;

	_numberOfSoldiers = _squad_cap_based_off_rank - _group_count;

	if (_numberOfSoldiers > 0) exitWith {
		[_group, _class_name] call ARWA_create_soldier;
	};

	systemChat localize "ARWA_STR_MAXIMUM_AMOUNT_OF_UNITS";
};

ARWA_get_vehicle = {
	params ["_base_marker", "_class_name", "_penalty"];

	private _pos = getPos _base_marker;
	private _isEmpty = !([_pos] call ARWA_any_units_too_close);

	if (_isEmpty) exitWith {
		private _veh = _class_name createVehicle _pos;
		_veh setDir (getDir _base_marker);

		_veh setVariable [ARWA_penalty, _penalty, true];
		_veh setVariable [ARWA_kill_bonus, _penalty, true];
		_veh setVariable [ARWA_KEY_owned_by, playerSide, true];

		[_veh] call ARWA_remove_vehicle_action;
	};
	private _type = _class_name call ARWA_get_vehicle_display_name;
	systemChat format[localize "ARWA_STR_OBSTRUCTING_THE_RESPAWN_AREA", _type];
};

ARWA_get_interceptor = {
	params ["_class_name", "_penalty", "_side"];

	private _veh = [_class_name, _penalty, playerSide] call ARWA_spawn_interceptor;

	_veh setVariable [ARWA_penalty, _penalty, true];
	[_veh] spawn ARWA_rearm_interceptor;
	[_veh] spawn ARWA_return_interceptor;

	private _pilot = driver _veh;
	private _pilot_group = group _pilot;
	deleteVehicle _pilot;
	deleteGroup _pilot_group;
	player moveInDriver _veh;
};

ARWA_list_options = {
	params ["_type", "_priority", "_box", "_title", "_options"];

	if(_type isEqualTo ARWA_KEY_helicopter) then {
		_options append (missionNamespace getVariable format["ARWA_%1_%2_transport", playerSide, ARWA_KEY_helicopter]);
	};

	if(_type isEqualTo ARWA_KEY_vehicle) then {
		_options append (missionNamespace getVariable format["ARWA_%1_%2_transport", playerSide, ARWA_KEY_vehicle]);
	};

	private _sub_options = [];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call ARWA_get_vehicle_display_name;

		_sub_options pushBack (_box addAction [[_name, 2] call ARWA_add_action_text, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;
			private _box = _params select 3;
			private _title = _params select 4;

			_box setVariable [format["Menu_%1", _title], false];

			[_box] call ARWA_remove_all_options;

			if(([playerSide] call ARWA_get_strength) <= 0) exitWith {
				systemChat localize "ARWA_STR_NOT_ENOUGH_MANPOWER";
			};

			if(_type isEqualTo ARWA_KEY_infantry) exitWith {
				[_class_name] call ARWA_get_infantry;
			};

			if (_type isEqualTo ARWA_KEY_interceptor) exitWith {
				[_class_name, _penalty] call ARWA_get_interceptor;
			};

			private _base_marker_name = [playerSide, _type] call ARWA_get_prefixed_name;
			private _base_marker = missionNamespace getVariable _base_marker_name;

			[_base_marker, _class_name, _penalty] call ARWA_get_vehicle;

		}, [_class_name, _penalty, _type, _box, _title], (_priority - 1), false, true, "", '', 10]);

	} forEach _options;

	_box setVariable [ARWA_KEY_menu, _sub_options];
};

ARWA_create_menu = {
	params ["_box", "_title", "_type", "_priority", "_disable_on_enemies_nearby"];

	_box setVariable [format["Menu_%1", _title], false];

	_box addAction [[_title, 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _title = _arguments select 2;
		private _box = _arguments select 3;
		private _disable_on_enemies_nearby = _arguments select 4;

		if(_disable_on_enemies_nearby && {[playerSide, getPos _box] call ARWA_any_enemies_in_sector}) exitWith {
			systemChat localize "ARWA_STR_CANNOT_SPAWN_UNITS_ENEMIES_NEARBY";
		};

		[_box] call ARWA_remove_all_options;

		if(([playerSide] call ARWA_get_strength) <= 0) exitWith {
			systemChat localize "ARWA_STR_NOT_ENOUGH_MANPOWER";
		};

		private _options = [playerSide, _type] call ARWA_get_units_based_on_tier;

		if(_options isEqualTo []) exitWith {
			systemChat localize "NO_AVAILABLE_OPTIONS";
		};

		private _open = _box getVariable format["Menu_%1", _title];

		if(!_open) then {
			[_type, _priority, _box, _title, _options] call ARWA_list_options;
			_box setVariable [format["Menu_%1", _title], true];
		} else {
			_box setVariable [format["Menu_%1", _title], false];
		}
	}, [_type, _priority, _title, _box, _disable_on_enemies_nearby], _priority, false, false, "", '[_target, _this] call ARWA_owned_by', 10]
};
