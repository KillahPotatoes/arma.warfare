ARWA_calculate_deaths = {
	params ["_group"];

	private _curr_count = {alive _x} count units _group;		
	private _prev_count = _group getVariable [soldier_count, _curr_count];
	_group setVariable [soldier_count , _curr_count];

	_prev_count - _curr_count;
};

ARWA_report_casualities_over_radio = {
	params ["_group"];
	private _deaths = [_group] call ARWA_calculate_deaths;

	if (_deaths > 0) exitWith {
		private _pos = getPosWorld (leader _group);
		private _closest_sector = [sectors, _pos] call find_closest_sector;
		private _sector_pos = _closest_sector getVariable pos;
		private _distance = floor(_sector_pos distance2D _pos);
		private _location = [_closest_sector getVariable sector_name] call ARWA_replace_underscore;

		if (_distance > 200) exitWith {
			private _direction = [_sector_pos, _pos] call ARWA_get_direction;
			[_group, _deaths, _distance, _direction, _location] remoteExec ["report_casualities"];
		};

		[_group, _deaths, _location] remoteExec ["report_casualities_in_sector"];
	};
};

report_next_waypoint = {
	params ["_group", "_target"];

	private _count = { alive _x } count units _group;
	if (_count > 0) then {
		private _veh = vehicle leader _group;
		private _is_veh = (_veh isKindOf "Car" || _veh isKindOf "Air" || _veh isKindOf "Tank") && ((group driver _veh) isEqualTo _group);
		private _sector_name = [_target getVariable sector_name] call ARWA_replace_underscore;

		private _values = if (_is_veh) then {
			private _class_name = typeOf _veh;
			private _veh_name = _class_name call ARWA_get_vehicle_display_name;
			["VEHICLE_MOVING_TO", _veh_name, _sector_name];
		} else {
			private _count = { alive _x } count units _group;
			["SQUAD_MOVING_TO", _count, _sector_name];
		};

		[_group, _values] remoteExec ["group_report_client"];
	};
};


