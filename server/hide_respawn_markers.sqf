ARWA_hide_respawn_markers = {
	{
		format["%1_respawn_air", _x] setMarkerAlpha 0;
		format["%1_respawn_ground", _x] setMarkerAlpha 0;

	} forEach ARWA_ARRAY_KEY_prefixes;
};