ARWA_hide_respawn_markers = {
	_prefixes = ["alpha", "bravo", "charlie"];

	{
		format["%1_respawn_air", _x] setMarkerAlpha 0;
		format["%1_respawn_ground", _x] setMarkerAlpha 0;

	} forEach _prefixes;
};
