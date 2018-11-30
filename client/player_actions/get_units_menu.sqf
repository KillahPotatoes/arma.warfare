remove_all_options = {
	params ["_box"];
	
	private _options = _box getVariable ["menu", []];

	{
		_box removeAction _x;
	} forEach _options;

	_box setVariable ["menu", []];
};

create_soldier = {
	params ["_group", "_class_name"];
	_class_name createUnit[getPos player, _group, "", ([] call get_rank_skill)];
};

get_infantry = {
	params ["_class_name"];
	_group = group player;
	_group_count = {alive _x} count units _group;
	_numberOfSoldiers = arwa_squad_cap - _group_count;

	if (_numberOfSoldiers > 0) exitWith {
		[_group, _class_name] call create_soldier;			
		[_group] remoteExec ["add_battle_group", 2];
	};

	systemChat localize "MAXIMUM_AMOUNT_OF_UNITS";		
};

get_vehicle = {
	params ["_base_marker", "_class_name", "_penalty"];

	private _pos = getPos _base_marker;
	private _isEmpty = !([_pos] call any_units_too_close);

	if (_isEmpty) exitWith {
		private _veh = _class_name createVehicle _pos;
		_veh setDir (getDir _base_marker);
		_veh setVariable ["penalty", [playerSide, _penalty], true];

		[_veh] call remove_vehicle_action;
	}; 
	
	systemChat format[localize "OBSTRUCTING_THE_RESPAWN_AREA", _type];
};

list_options = {
	params ["_type", "_priority", "_box"];

	private _side = side player;
	private _options = [_side, _type] call get_units_based_on_tier;

	if(_type isEqualTo helicopter) then {
		_options = _options + (missionNamespace getVariable format["%1_%2_transport", _side, helicopter]);
	};

	if(_type isEqualTo vehicle1) then {
		_options = _options + (missionNamespace getVariable format["%1_%2_transport", _side, vehicle1]);
	};

	private _sub_options = [];

	{
		private _class_name = _x select 0;
		private _penalty = _x select 1;
		private _name = _class_name call get_vehicle_display_name;		

		_sub_options pushBack (_box addAction [[_name, 2] call addActionText, {
			private _params = _this select 3;
			private _class_name = _params select 0;
			private _penalty = _params select 1;
			private _type = _params select 2;
			private _box = _params select 3;

			[_box] call remove_all_options;	

			if(((side player) call get_strength) <= 0) exitWith { systemChat localize "NOT_ENOUGH_MANPOWER"; }	

			if(_type isEqualTo infantry) then {
				[_class_name] call get_infantry;
			} else {
				private _base_marker_name = [side player, _type] call get_prefixed_name;
				private _base_marker = missionNamespace getVariable _base_marker_name;

				[_base_marker, _class_name, _penalty] call get_vehicle;
			};
			
		}, [_class_name, _penalty, _type, _box], (_priority - 1), false, true, "", '', 10]);

	} forEach _options;

	_box setVariable ["menu", _sub_options];
};

create_menu = {
	params ["_box", "_title", "_type", "_priority", "_disable_on_enemies_nearby"];

	_box setVariable [format["Menu_%1", _title], false];	

	_box addAction [[_title, 0] call addActionText, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		private _type = _arguments select 0;
		private _priority = _arguments select 1;
		private _title = _arguments select 2;
		private _box = _arguments select 3;
		private _disable_on_enemies_nearby = _arguments select 4;

		if(_disable_on_enemies_nearby && {[side player, getPos _box] call any_enemies_in_sector}) exitWith { 
			systemChat localize "CANNOT_SPAWN_UNITS_ENEMIES_NEARBY";
		};			

		[_box] call remove_all_options;

		if(((side player) call get_strength) <= 0) exitWith { systemChat localize "NOT_ENOUGH_MANPOWER"; }

		private _open = _box getVariable format["Menu_%1", _title];	
		
		if(!_open) then {
			[_type, _priority, _box] call list_options;
			_box setVariable [format["Menu_%1", _title], true];	
		} else {
			_box setVariable [format["Menu_%1", _title], false];	
		}
	}, [_type, _priority, _title, _box, _disable_on_enemies_nearby], _priority, false, false, "", '[_target, _this] call owned_box', 10]	
};

