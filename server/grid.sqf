
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

ARWA_draw_controlled_area_grid = {
	for "_markers_posx" from (ARWA_grid_start_x + (ARWA_cell_size/2)) to ARWA_grid_end_x step ARWA_cell_size do {
		for "_markers_posy" from (ARWA_grid_start_y + (ARWA_cell_size/2)) to ARWA_grid_end_y step ARWA_cell_size do {
			[_markers_posx, _markers_posy] spawn ARWA_draw_cell;
		};
	};
};

ARWA_draw_cell = {
	params ["_markers_posx", "_markers_posy"];

	private _markers_pos = [_markers_posx, _markers_posy, 0];
	private _isWater = surfaceIsWater _markers_pos;

	if(!_isWater) then {
		private _area_controlled_by = [_markers_pos] call ARWA_is_in_controlled_area;
		_markers_name = format["marker_grid_%1_%2", _markers_posx, _markers_posy];

		if(isNil "_area_controlled_by") then {
			deleteMarker _markers_name;
		} else {
			_color = getMarkerColor _markers_name;

			if(_color isEqualTo "") then {
				createMarker[_markers_name, _markers_pos];
				_markers_name setMarkerShape "RECTANGLE";
				_markers_name setMarkerSize [(ARWA_cell_size/2), (ARWA_cell_size/2)];
				_markers_name setMarkerAlpha 0.5;
			};

			_markers_color = [_area_controlled_by, true] call BIS_fnc_sideColor;
			if(!(_color isEqualTo _markers_color)) then {
				_markers_name setMarkerColor _markers_color;
			};
		};
	};
};