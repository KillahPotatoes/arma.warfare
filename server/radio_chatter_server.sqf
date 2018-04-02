calculate_deaths = {
	params ["_group"];

	private _curr_count = {alive _x} count units _group;		
	private _prev_count = _group getVariable [soldier_count, _curr_count];
	_group setVariable [soldier_count , _curr_count];

	_prev_count - _curr_count;
};

report_casualities_over_radio = {
	params ["_group"];
	private _deaths = [_group] call calculate_deaths;

	if (_deaths > 0) exitWith {
		private _pos = getPosWorld (leader _group);
		private _closest_sector = [sectors, _pos] call find_closest_sector;
		private _sector_pos = _closest_sector getVariable pos;
		private _distance = floor(_sector_pos distance2D _pos);
		private _location = [_closest_sector getVariable sector_name] call replace_underscore;

		if (_distance > 200) exitWith {
			private _direction = [_sector_pos, _pos] call get_direction;
			[_group, _deaths, _distance, _direction, _location] remoteExec ["report_casualities"];
		};

		[_group, _deaths, _location] remoteExec ["report_casualities_in_sector"];
	};
};

report_next_waypoint = {
	params ["_group", "_target"];

	private _veh = vehicle leader _group;
	private _is_veh = (_veh isKindOf "Car" || _veh isKindOf "Air" || _veh isKindOf "Tank") && ((group driver _veh) isEqualTo _group);
	private _sector_name = [_target getVariable sector_name] call replace_underscore;

	private _msg = if (_is_veh) then {
		private _class_name = typeOf _veh;
		private _veh_name = _class_name call get_vehicle_display_name;
		format["%1 is moving towards %2", _veh_name, _sector_name];
	} else {
		private _count = { alive _x } count units _group;
		format["Squad of %1 moving towards %2", _count, _sector_name];
	};	
	
	[_group, _msg] remoteExec ["client_report_next_waypoint"];
};

report_incoming_support = {
	params ["_side", "_msg"];
	[_side, _msg] remoteExec ["client_report_incoming_support"];
};

report_lost_support = {
	params ["_side", "_msg"];
	[_side, _msg] remoteExec ["client_report_lost_support"];
};

