curr_options = [];

remove_all_options = {
	params ["_box"];
	
	{
		_box removeAction _x;
	} forEach curr_options;

	curr_options = [];
};

create_soldier = {
	params ["_group", "_class_name"];
	_class_name createUnit[getPos player, _group, "", ([] call get_rank_skill)];
};

get_infantry = {
	params ["_class_name"];
	_group = group player;
	_group_count = {alive _x} count units _group;
	_numberOfSoldiers = squad_size - _group_count;

	if (_numberOfSoldiers > 0) exitWith {
		[_group, _class_name] call create_soldier;			
		[_group] remoteExec ["add_battle_group", 2];
	};

	systemChat "You have the maximum allowed amount of people";		
};

get_vehicle = {
	params ["_base_marker", "_class_name", "_penalty"];

	private _pos = getPos _base_marker;
	private _isEmpty = [_pos] call check_if_any_units_to_close;

	if (_isEmpty) exitWith {
		private _veh = _class_name createVehicle _pos;
		_veh setDir (getDir _base_marker);
		_veh setVariable ["penalty", [playerSide, _penalty], true];

		[_veh] call remove_vehicle_action;
	}; 
	
	systemChat format["Something is obstructing the %1 respawn area", _type];
};

list_options = {
	params ["_type", "_priority", "_box"];

	private _side = side player;
	private _options = [_side, _type] call get_units_based_on_tier;

	if(_type isEqualTo helicopter) then {
		_options = _options + (missionNamespace getVariable format["%1_%2_transport", _side, helicopter]);
	};

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;
		
		curr_options pushBack (_box addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;
			private _box = _params select 3;

			[_box] call remove_all_options;

			if(_type isEqualTo infantry) then {
				[_class_name] call get_infantry;
			} else {
				private _base_marker_name = [side player, _type] call get_prefixed_name;
				private _base_marker = missionNamespace getVariable _base_marker_name;

				[_base_marker, _class_name, _penalty] call get_vehicle;
			};
		}, [_class_name, _penalty, _type, _box], (_priority - 1), false, true, "", '', 10]);
	} forEach _options;
};

create_menu = {
	params ["_box", "_title", "_type", "_priority", "_disable_on_enemies_nearby"];

	missionNameSpace setVariable [format["Menu_%1", _title], false];	

	_box addAction [[_title, 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _title = _arguments select 2;
		private _box = _arguments select 3;
		private __disable_on_enemies_nearby = _arguments select 4;

		if(_disable_on_enemies_nearby) then {
			private _side = side player; 
			any_enemies_in_sector
		}

		[_box] call remove_all_options;

		private _open = missionNameSpace getVariable format["Menu_%1", _title];	
		missionNameSpace setVariable [format["Menu_%1", _title], !_open];	

		if(!_open) then {
			[_type, _priority, _box] call list_options;
		};
	}, [_type, _priority, _title, _box, _disable_on_enemies_nearby], _priority, false, false, "", '[_target, _this] call owned_box', 10]	
};

