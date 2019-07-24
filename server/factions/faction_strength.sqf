ARWA_initialize_faction_stats = {
	params ["_manpower", "_tier"];

	[West, _manpower, _tier] call ARWA_initialize_faction;
	[East, _manpower, _tier] call ARWA_initialize_faction;
	[independent, _manpower, _tier] call ARWA_initialize_faction;
};

ARWA_initialize_faction = {
	params ["_side", "_manpower", "_tier"];

	[_side, _manpower] call ARWA_set_strength;
	[_side, _tier call ARWA_get_tier_bound] call ARWA_set_kill_count;
	[_side, _tier] call ARWA_set_tier;
	[_side, 0] call ARWA_set_tier_progress;
};

ARWA_calculate_tier_progress = {
	params ["_side"];

	_kill_count = _side call ARWA_get_kill_count;
	_tier = _side call ARWA_get_tier;

	_tier_bound =  if(_tier == 0) then { 0; } else { _tier call ARWA_get_tier_bound; };
	_next_tier_bound = (_tier + 1) call ARWA_get_tier_bound;

	_percentage = floor(((_kill_count - _tier_bound) / (_next_tier_bound - _tier_bound)) * 100);

	[_side, 99 min _percentage] call ARWA_set_tier_progress;
};

ARWA_increment_kill_counter = {
	params ["_side", "_kill_point"];
	private _tier =  _side call ARWA_get_tier;

	if(_tier < ARWA_max_tier) exitWith {
		private _new_kill_count = ([_side] call ARWA_get_kill_count) + _kill_point;

		[_side, _new_kill_count] call ARWA_increment_tier;
		[_side, _new_kill_count] call ARWA_set_kill_count;
		[_side] call ARWA_calculate_tier_progress;
	};
};

ARWA_increase_manpower_server = {
	params ["_side", "_manpower"];

	private _new_strength = ([_side] call ARWA_get_strength) + _manpower;
	[_side, _new_strength] call ARWA_set_strength;
};

ARWA_decrease_manpower_server = {
	params ["_side", "_manpower"];

	private _new_strength = ([_side] call ARWA_get_strength) - _manpower;
	[_side, _new_strength] call ARWA_set_strength;
};

ARWA_increment_tier = {
	params ["_side", "_kill_count"];

	private _tier = _side call ARWA_get_tier;
	private _next_tier = _tier + 1;
	private _tier_bound = _next_tier call ARWA_get_tier_bound;

	if(_kill_count > _tier_bound) exitWith {
		private _msg = format["%1 advanced to tier %2", _side call ARWA_get_faction_names, _next_tier]; // TODO add localization
		_msg remoteExec ["hint"];

		[_side, _next_tier] call ARWA_set_tier;
	};
};

ARWA_has_manpower = {
	params ["_side"];

	floor(_side call ARWA_get_strength) > 0;
};
