ARWA_mission_size = worldSize;

ARWA_calculate_mission_size = {
	private _west_respawn_pos = getMarkerPos ([West, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _east_respawn_pos = getMarkerPos ([East, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
	private _guer_respawn_pos = getMarkerPos ([Independent, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);

	ARWA_mission_size = ((_west_respawn_pos distance2D _east_respawn_pos) + (_west_respawn_pos distance2D _guer_respawn_pos) + (_east_respawn_pos distance2D _guer_respawn_pos)) / 3;
};