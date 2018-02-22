[] call compileFinal preprocessFileLineNumbers "shared\common\string.sqf";

check_if_any_units_to_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man"], 10]) == 0;
};
