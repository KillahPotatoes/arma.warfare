ARWA_spawn_point_defense_vehicle = {
	params ["_sector"];

	private _spawn_positions = _sector getVariable [ARWA_KEY_static_spawn_positions, []];
	if(_spawn_positions isEqualTo []) exitWith {};

	private _clear_spawn_positions = _spawn_positions select { !([getPos _x] call ARWA_anything_too_close); };

	if(_clear_spawn_positions isEqualTo []) exitWith {};

	selectRandom _clear_spawn_positions;
};

ARWA_spawn_defense_vehicle = {
	params ["_group", "_sector"];

	if(selectRandom[true, false]) then {

		private _side = side _group;
		private _options = [_side, ARWA_KEY_vehicle] call ARWA_get_units_based_on_tier;

		private _option = (selectRandom _options);
		private _class_name = _option select 0;
		private _kill_bonus = _option select 1;

		private _spawn_position = [_sector] call ARWA_spawn_point_defense_vehicle;

		if(!isNil "_spawn_position") then {

			private _pos = getPos _spawn_position;
			private _dir = getDir _spawn_position;
			private _veh_array = [_pos, _dir, _class_name, _side, _kill_bonus] call ARWA_spawn_vehicle;

			private _veh = _veh_array select 0;

			private _tmp_group = _veh_array select 2;
			[_tmp_group] call ARWA_remove_nvg_and_add_flash_light;
			{[_x] joinSilent _group} forEach units _tmp_group;
			deleteGroup _tmp_group;

			private _veh_name = _class_name call ARWA_get_vehicle_display_name;
			format ["Spawn %1 defensive vehicle for %2", _veh_name, _side] spawn ARWA_debugger;
		};
	};
}