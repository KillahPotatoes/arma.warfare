ARWA_spawn_gunship_groups = {
	[West] spawn ARWA_spawn_gunships;
	[East] spawn ARWA_spawn_gunships;
	[independent] spawn ARWA_spawn_gunships;
};

ARWA_find_target_sectors = {
	params ["_side"];

	([_side] call ARWA_find_enemy_sectors) + ([_side] call ARWA_get_unsafe_sectors);
};

ARWA_spawn_gunships = {
	params ["_side"];

	while {true} do {

		private _tier = [_side] call ARWA_get_tier;
		private _wait_time = tier_base_gunship_respawn_time + (random (missionNamespace getVariable format["tier_%1_gunship_respawn_time", _tier]));

		sleep _wait_time;

		if(_side call ARWA_has_manpower && !ARWA_cease_fire) then {
			private _sectors = [_side] call ARWA_find_target_sectors;

			if ((count _sectors) == 0) exitWith {};

			private _gunship = [_side] call ARWA_spawn_gunship_group;
			if (isNil "_gunship") exitWith {};
			[_gunship select 2] spawn ARWA_add_battle_group;
		};

	};
};

ARWA_spawn_gunship_group = {
	params ["_side"];

	private _options = [_side, helicopter] call ARWA_get_units_based_on_tier;

	if((_options isEqualTo [])) exitWith {};

	private _random_selection = selectRandom _options;
	private _gunship = _random_selection select 0;
	private _kill_bonus = _random_selection select 1;
	private _gunship_name = _gunship call ARWA_get_vehicle_display_name;

	diag_log format ["%1: Spawn gunship: %2", _side, _gunship_name];
	diag_log format["%1 manpower: %2", _side, [_side] call ARWA_get_strength];

	[_side, ["SENDING_VEHICLE_YOUR_WAY", _gunship_name]] remoteExec ["ARWA_HQ_report_client"];
	sleep 120;

	private _veh_arr = [_side, _gunship, _kill_bonus] call ARWA_spawn_helicopter;

	private _veh = _veh_arr select 0;
	_veh_arr;
};
