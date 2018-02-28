get_prefixed_name = {
	params ["_side", "_suffix"];
	format["%1_%2", missionNamespace getVariable format["%1_prefix", _side], _suffix];
};

get_tier_bound = {
	params ["_num"];
	_num * starting_strength;
};

set_tier_progress = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["%1_tier_prog",  _side], _value, true];
};

get_tier_progress = {
	params ["_side"];
	missionNamespace getVariable format ["%1_tier_prog",  _side];
};

get_tier = {
	params ["_side"];
	missionNamespace getVariable format ["%1_tier",  _side];
};

set_tier = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["%1_tier",  _side], _value, true];
};

get_kill_count = {
	params ["_side"];
	missionNamespace getVariable format ["%1_kill_counter",  _side];
};

set_kill_count = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["%1_kill_counter",  _side], _value];
};

set_strength = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["%1_strength", _side], ((starting_strength * 2) max _value), true];
}; 

get_strength = {
	params ["_side"];
	missionNamespace getVariable format ["%1_strength",  _side];
};

set_income = {
	params ["_side", "_value"];
	missionNamespace setVariable [format ["%1_income", _side], _value, true];
}; 

get_income = {
	params ["_side"];
	missionNamespace getVariable format ["%1_income", _side];
};

get_faction_names = {
  params ["_side"];
  missionNamespace getVariable format["%1_faction_name", _side];
};