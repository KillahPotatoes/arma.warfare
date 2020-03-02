ARWA_mission_size = worldSize;

ARWA_calculate_mission_size = {
	private _west_respawn_pos = [West] call ARWA_get_hq_pos;
	private _east_respawn_pos = [East] call ARWA_get_hq_pos;
	private _guer_respawn_pos = [Independent] call ARWA_get_hq_pos;

	ARWA_mission_size = ((_west_respawn_pos distance2D _east_respawn_pos) + (_west_respawn_pos distance2D _guer_respawn_pos) + (_east_respawn_pos distance2D _guer_respawn_pos)) / 3;
};