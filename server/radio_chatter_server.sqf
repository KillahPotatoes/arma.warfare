calculate_deaths = {
	params ["_group"];

	private _prev_count = _group getVariable soldier_count;
	private _curr_count = {alive _x} count units _group;	
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

	_name = [_target getVariable sector_name] call replace_underscore;
	[_group, _name] remoteExec ["report_next_waypoint"];
};

report_incoming_support = {
	params ["_side", "_msg"];
	[_side, _msg] remoteExec ["report_incoming_support"];
};

