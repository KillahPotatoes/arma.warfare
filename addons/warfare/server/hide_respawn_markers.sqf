ARWA_hide_respawn_markers = {
	{
		format["%1_respawn_air", _x] setMarkerAlpha 0; // TODO: Remove when all missions have this marker removed
		format["%1_respawn_ground", _x] setMarkerAlpha 0;

	} forEach ARWA_ARRAY_KEY_prefixes;
};