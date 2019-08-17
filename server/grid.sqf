ARWA_grid_start_x = worldSize;
ARWA_grid_end_x = 0;
ARWA_grid_start_y = worldSize;
ARWA_grid_end_y = 0;
ARWA_grid_size = worldSize;

ARWA_find_grid_area = {
	private _locations = [];
	{
		_locations append [(_x getVariable ARWA_KEY_pos)];
	} foreach ARWA_sectors;

	{
		private _hq_pos = getMarkerPos ([_x, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
		_locations append [_hq_pos];
	} forEach ARWA_all_sides;

	{
		private _posx = _x select 0;
		private _posy = _x select 1;

		if(_posx < ARWA_grid_start_x) then {
			ARWA_grid_start_x = _posx;
		};

		if(_posy < ARWA_grid_start_y) then {
			ARWA_grid_start_y = _posy;
		};

		if(_posx > ARWA_grid_end_x) then {
			ARWA_grid_end_x = _posx;
		};

		if(_posy > ARWA_grid_end_y) then {
			ARWA_grid_end_y = _posy;
		};
	} foreach _locations;

	ARWA_grid_size = (ARWA_grid_end_x max ARWA_grid_end_y) - (ARWA_grid_start_x min ARWA_grid_start_y);
	ARWA_buffer = ARWA_grid_size / 10;
	ARWA_cell_size = ARWA_grid_size / 100;
	ARWA_grid_start_x = ARWA_grid_start_x - ARWA_buffer;
	ARWA_grid_end_x = ARWA_grid_end_x + ARWA_buffer;
	ARWA_grid_start_y = ARWA_grid_start_y - ARWA_buffer;
	ARWA_grid_end_y = ARWA_grid_end_y + ARWA_buffer;
};

ARWA_assign_markers_to_sectors = {
	for "_cell_posx" from (ARWA_grid_start_x + (ARWA_cell_size/2)) to ARWA_grid_end_x step ARWA_cell_size do {
		private _current_sector = nil;
		private _marker_start = 0;

		for "_cell_posy" from (ARWA_grid_start_y + (ARWA_cell_size/2)) to ARWA_grid_end_y step ARWA_cell_size do {
			private _cell_pos = [_cell_posx, _cell_posy, 0];

			private _closest_sector = [ARWA_sectors, _cell_pos] call ARWA_find_closest_sector;

			if(isNil "_current_sector") then {
				_current_sector = _closest_sector;
				_marker_start = _cell_posy;
			} else {
				if(!(_current_sector isEqualTo _closest_sector)) then {

					private _marker = [_cell_posx, _cell_posy, _marker_start] call ARWA_create_controlled_area_marker;
					private _markers = _current_sector getVariable [ARWA_KEY_sector_markers, []];
					_markers pushBack _marker;
					_current_sector setVariable [ARWA_KEY_sector_markers, _markers];

					_current_sector = _closest_sector;
					_marker_start = _cell_posy;
				};

			};
		};

		private _marker = [_cell_posx, ARWA_grid_end_y, _marker_start] call ARWA_create_controlled_area_marker;
		private _markers = _current_sector getVariable [ARWA_KEY_sector_markers, []];
		_markers pushBack _marker;
		_current_sector setVariable [ARWA_KEY_sector_markers, _markers];
	};
};

ARWA_color = "ColorRed";

ARWA_create_controlled_area_marker = {
	params ["_posx", "_posy", "_start"];

	diag_log format["_posx: %1, _posy: %2, _start: %1", _posx, _posy, _start];

	private _marker_length_y = _posy - _start;
	diag_log format["_marker_length_y: %1", _marker_length_y];

	private _calc_posy = _start + (_marker_length_y/2);
	private _markers_pos = [_posx, _calc_posy, 0];
	private _markers_name = format["marker_grid_%1_%2", _posx, _posy];
	diag_log format["%1", _markers_pos];
	createMarker[_markers_name, _markers_pos];
	_markers_name setMarkerShape "RECTANGLE";
	_markers_name setMarkerSize [(ARWA_cell_size/2), (_marker_length_y/2)];
	_markers_name setMarkerAlpha 0;
	// TODO: Remove after testing
	//_markers_name setMarkerColor ARWA_color;
	//ARWA_color = if(ARWA_color isEqualTo "ColorRed") then { "ColorPink"; } else { "ColorRed"; };

	_markers_name;
};

ARWA_draw_sector_cell = {
	params ["_sector"];

	private _owner = _sector getVariable ARWA_KEY_owned_by;
	private _markers = _sector getVariable [ARWA_KEY_sector_markers, []];

	{
		diag_log format["Owner: %1", _owner];
		if(_owner isEqualTo civilian) then {
			_x setMarkerAlpha 0;
		} else {
			private _markers_color = [_owner, true] call BIS_fnc_sideColor;
			_x setMarkerAlpha 0.5;
			_x setMarkerColor _markers_color;
		};

	} forEach _markers;
};
