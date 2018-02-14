[] call compileFinal preprocessFileLineNumbers "scripts\common\string.sqf";

Get = {
	_str = _this select 0;
	_side = _this select 1;

	missionNamespace getVariable [format[_str, _side], nil];
};