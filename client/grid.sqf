ARWA_draw_controlled_area_grid = {
	_grid_size = worldSize / 100;
	for "_markers_posx" from (_grid_size/2) to worldSize step _grid_size do {
		for "_markers_posy" from  (_grid_size/2) to worldSize step _grid_size do {
			private _markers_pos = [_markers_posx, _markers_posy, 0];
			private _area_controlled_by = [_markers_pos] call ARWA_is_in_controlled_area;

			_markers_name = format["marker_grid_%1_%2", _markers_posx, _markers_posy];
			deleteMarker _markers_name;

			private _isWater = surfaceIsWater _markers_pos;

			if(!isNil "_area_controlled_by" && !_isWater) then {
				_markers_color = [_area_controlled_by, true] call BIS_fnc_sideColor;

				createMarker[_markers_name, _markers_pos];
				_markers_name setMarkerShape "RECTANGLE";
				_markers_name setMarkerSize [(_grid_size/2), (_grid_size/2)];
				_markers_name setMarkerColor _markers_color;
				_markers_name setMarkerAlpha 0.5;
			};
		};
	};
};