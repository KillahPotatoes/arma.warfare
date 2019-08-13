ARWA_grid_start_x = worldSize;
ARWA_grid_end_x = 0;
ARWA_grid_start_y = worldSize;
ARWA_grid_end_y = 0;
ARWA_grid_size = worldSize;

ARWA_find_grid_area = {
	{
		private _sector_pos = _x getVariable ARWA_KEY_pos;
		private _posx = _sector_pos select 0;
		private _posy = _sector_pos select 1;

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
	} foreach ARWA_sectors;

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
		private _marker_start = nil;

		for "_cell_posy" from (ARWA_grid_start_y + (ARWA_cell_size/2)) to ARWA_grid_end_y step ARWA_cell_size do {
			private _cell_pos = [_cell_posx, _cell_posy, 0];

			if(!(surfaceIsWater _cell_pos)) then {
				private _closest_sector = [ARWA_sectors, _cell_pos] call ARWA_find_closest_sector;

				if(isNil "_current_sector") then {
					_current_sector = _closest_sector;
					private _marker_start = _cell_posy;
				} else {
					if(!(_closest_sector isEqualTo _current_sector)) then {

						private _marker_length_y = _cell_posy - _marker_start;
						private _markers_pos = [_cell_posx, _marker_start + _marker_length_y/2, 0];

						createMarker[_markers_name, _markers_pos];
						_markers_name = format["marker_grid_%1_%2", _cell_posx, _cell_posy];
						_markers_name setMarkerShape "RECTANGLE";
						_markers_name setMarkerSize [(ARWA_cell_size/2), (_marker_length_y/2)];
						_markers_name setMarkerAlpha 0.5;

						private _markers = _current_sector getVariable ARWA_KEY_sector_markers;
						_markers pushBack _markers_name;

						_current_sector = _closest_sector;
						private _marker_start = _cell_posy;
					};
				};
			};
		};

		private _marker_length_y = ARWA_grid_end_y - _marker_start;
		private _markers_pos = [_cell_posx, _marker_start + _marker_length_y/2, 0];
		createMarker[_markers_name, _markers_pos];
		_markers_name = format["marker_grid_%1_%2", _cell_posx, ARWA_grid_end_y];
		_markers_name setMarkerShape "RECTANGLE";
		_markers_name setMarkerSize [(ARWA_cell_size/2), (_marker_length_y/2)];
		_markers_name setMarkerAlpha 0.5;

		private _markers = _current_sector getVariable ARWA_KEY_sector_markers;
		_markers pushBack _markers_name;

	};
};

ARWA_draw_sector_cell = {
	params ["_sector"];

	private _owner = _sector getVariable ARWA_KEY_owned_by;
	private _markers = _sector getVariable ARWA_KEY_sector_markers;

	{
		private _markers_name = _x;
		private _markers_color = [_owner, true] call BIS_fnc_sideColor;
		_markers_name setMarkerColor _markers_color;
	} forEach _markers;
};
