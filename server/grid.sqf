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
	ARWA_buffer = (ARWA_grid_size / 10) min 500;
	ARWA_cell_size = ARWA_grid_size / 100;
	ARWA_grid_start_x = ARWA_grid_start_x - ARWA_buffer;
	ARWA_grid_end_x = ARWA_grid_end_x + ARWA_buffer;
	ARWA_grid_start_y = ARWA_grid_start_y - ARWA_buffer;
	ARWA_grid_end_y = ARWA_grid_end_y + ARWA_buffer;
};

ARWA_assign_markers_to_sectors = {
	for "_cell_posx" from (ARWA_grid_start_x + (ARWA_cell_size/2)) to ARWA_grid_end_x step ARWA_cell_size do {
		private _marker_start = (ARWA_grid_start_y + (ARWA_cell_size/2));

		private _cell_pos = [_cell_posx, _marker_start];
		private _current_sector = [ARWA_sectors, _cell_pos] call ARWA_find_closest_sector;

		private _is_water = surfaceIsWater _cell_pos;
		private _was_water = surfaceIsWater _cell_pos;

		for "_cell_posy" from (ARWA_grid_start_y + (ARWA_cell_size/2)) to ARWA_grid_end_y step ARWA_cell_size do {
			_cell_pos = [_cell_posx, _cell_posy];

			_is_water = surfaceIsWater _cell_pos;

			if(!_is_water && _was_water) then {
				_marker_start = _cell_posy;
			};

			if(!_was_water && _is_water) then {
				[_cell_posx, _cell_posy, _marker_start, _current_sector] call ARWA_create_marker_and_add_to_sector;
			};

			private _closest_sector = [ARWA_sectors, _cell_pos] call ARWA_find_closest_sector;
			if(!(_closest_sector isEqualTo _current_sector) && !_is_water) then {
				[_cell_posx, _cell_posy, _marker_start, _current_sector] call ARWA_create_marker_and_add_to_sector;
				_marker_start = _cell_posy;
			};

			_current_sector = _closest_sector;
			_was_water = _is_water;
		};

		if(!_is_water) then {
			[_cell_posx, ARWA_grid_end_y, _marker_start, _current_sector] call ARWA_create_marker_and_add_to_sector;
		}
	};
};

ARWA_create_marker_and_add_to_sector = {
	params ["_row", "_end", "_start", "_sector"];

	_start = _start - (ARWA_cell_size/2);
	_end = _end - (ARWA_cell_size/2);

	private _marker_length_y = _end - _start;
	private _calc_posy = _start + (_marker_length_y/2);
	private _markers_pos = [_row, _calc_posy];
	private _marker = format["marker_grid_%1_%2", _row, _end];

	createMarker[_marker, _markers_pos];
	_marker setMarkerShape "RECTANGLE";
	_marker setMarkerSize [(ARWA_cell_size/2), (_marker_length_y/2)];
	_marker setMarkerAlpha 0;

	private _markers = _sector getVariable [ARWA_KEY_sector_markers, []];
	_markers pushBack _marker;
	_sector setVariable [ARWA_KEY_sector_markers, _markers];
};

ARWA_draw_sector_cell = {
	params ["_sector"];

	private _owner = _sector getVariable ARWA_KEY_owned_by;
	private _markers = _sector getVariable [ARWA_KEY_sector_markers, []];

	{
		if(_owner isEqualTo civilian) then {
			_x setMarkerAlpha 0;
		} else {
			private _markers_color = [_owner, true] call BIS_fnc_sideColor;
			_x setMarkerAlpha 0.5;
			_x setMarkerColor _markers_color;
		};

	} forEach _markers;
};
