initialize_faction_stats = {
	params ["_manpower", "_tier"];

	[West, _manpower, _tier] call initialize_faction;
	[East, _manpower, _tier] call initialize_faction;
	[independent, _manpower, _tier] call initialize_faction;
};

initialize_faction = {
	params ["_side", "_manpower", "_tier"];

	[_side, _manpower] call set_strength;
	[_side, _tier call get_tier_bound] call set_kill_count;
	[_side, _tier] call set_tier;
	[_side, 0] call set_tier_progress;	
};

calculate_tier_progress = {
	params ["_side"];
	
	_kill_count = _side call get_kill_count;
	_tier = _side call get_tier;

	_tier_bound =  if(_tier == 0) then { 0; } else { _tier call get_tier_bound; };
	_next_tier_bound = (_tier + 1) call get_tier_bound;

	_percentage = floor(((_kill_count - _tier_bound) / (_next_tier_bound - _tier_bound)) * 100);

	[_side, 99 min _percentage] call set_tier_progress;
};

increment_kill_counter = {
	params ["_side", "_kill_point"];
	private _tier =  _side call get_tier;

	if(_tier < max_tier) exitWith {
		private _new_kill_count = ([_side] call get_kill_count) + _kill_point;		

		[_side, _new_kill_count] call increment_tier;
		[_side, _new_kill_count] call set_kill_count;
		[_side] call calculate_tier_progress;
	};
}; 

buy_manpower_server = {
	params ["_side", "_manpower"];

	private _new_strength = ([_side] call get_strength) + _manpower;
	[_side, _new_strength] call set_strength;
};

increment_tier = {
	params ["_side", "_kill_count"];

	private _tier = _side call get_tier;
	private _next_tier = _tier + 1;
	private _tier_bound = _next_tier call get_tier_bound;

	if(_kill_count > _tier_bound) exitWith {
		private _msg = format["%1 advanced to tier %2", _side call get_faction_names, _next_tier];
		_msg remoteExec ["hint"]; 
		
		[_side, _next_tier] call set_tier;
	};
};



