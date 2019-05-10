ARWA_spawn_defense_vehicle = {
	params ["_group", "_pos"];

	private _rnd = random 100;

	if(_rnd < 30) then {

		private _side = side _group;
		private _options = [_side, ARWA_KEY_vehicle] call ARWA_get_units_based_on_tier;

		private _option = (selectRandom _options);
		private _class_name = _option select 0;
		private _kill_bonus = _option select 1;

		_safe_pos = [_pos, 10, 50, 15, 0, 0, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;

		if(!(_safe_pos isEqualTo _pos)) then {
			private _veh_array = [_safe_pos, random 360, _class_name, _side, _kill_bonus] call ARWA_spawn_vehicle;

			private _veh = _veh_array select 0;

			private _tmp_group = _veh_array select 2;
			[_tmp_group] call ARWA_remove_nvg_and_add_flash_light;
			{[_x] joinSilent _group} forEach units _tmp_group;
			deleteGroup _tmp_group;
		};
	};
}