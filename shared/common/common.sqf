[] call compileFinal preprocessFileLineNumbers "shared\common\string.sqf";

check_if_any_units_to_close = {
	params ["_pos"];

	count (nearestObjects[_pos, ["Tank", "Car", "Air", "Man"], 10]) == 0;
};

check_if_player_already_in_hq = {
  params ["_player"];

  private _pos = getMarkerPos ([side _player, respawn_ground] call get_prefixed_name);
  (getPos _player) distance _pos > 25; 
};