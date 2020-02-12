ARWA_get_prefixed_name = {
	params ["_side", "_suffix"];
	format["%1_%2", missionNamespace getVariable format["ARWA_%1_prefix", _side], _suffix];
};

ARWA_get_prefixed_side = {
	params ["_prefix"];
	missionNamespace getVariable format["ARWA_%1_side", _prefix];
};

ARWA_get_hq_pos = {
	params ["_side"];

	missionNamespace getVariable format["ARWA_HQ_%1", _side];
};

ARWA_get_tier_bound = {
	params ["_num"];
	_num * (ARWA_starting_strength / 10);
};

ARWA_set_tier_progress = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["ARWA_%1_tier_prog",  _side], _value, true];
};

ARWA_get_tier = {
	params ["_side"];
	missionNamespace getVariable format ["ARWA_%1_tier",  _side];
};

ARWA_set_tier = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["ARWA_%1_tier",  _side], _value min ARWA_max_tier, true];
};

ARWA_get_kill_count = {
	params ["_side"];
	missionNamespace getVariable format ["ARWA_%1_kill_counter",  _side];
};

ARWA_set_kill_count = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["ARWA_%1_kill_counter",  _side], _value];
};

ARWA_set_strength = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["ARWA_%1_strength", _side], 0 max _value, true];
};

ARWA_get_strength = {
	params ["_side"];
	missionNamespace getVariable format ["ARWA_%1_strength",  _side];
};

ARWA_get_faction_names = {
  params ["_side"];
  missionNamespace getVariable format["ARWA_KEY_%1_faction_name", _side];
};