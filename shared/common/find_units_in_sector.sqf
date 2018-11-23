get_all_units_in_sector_center = {
	params ["_sector"];

	private _pos = _sector getVariable pos;
	[_pos, arwa_sector_size / 4] call get_all_units_in_area;
};

get_all_units_in_sector = {
	params ["_sector"];

	private _pos = _sector getVariable pos;
	[_pos, arwa_sector_size] call get_all_units_in_area;
};

any_enemies_in_sector = {
	params ["_side", "_pos"];
	[_pos, _side, arwa_sector_size] call any_enemies_in_area;
};

any_enemies_in_sector_center = {
	params ["_side", "_pos"];
	[_pos, _side, arwa_sector_size / 4] call any_enemies_in_area;
};

any_friendlies_in_sector = {
	params ["_side", "_pos"];
	[_pos, _side, arwa_sector_size] call any_friendlies_in_area;
};

any_friendlies_in_sector_center = {
	params ["_side", "_pos"];
	[_pos, _side, arwa_sector_size / 4] call any_friendlies_in_area;
};