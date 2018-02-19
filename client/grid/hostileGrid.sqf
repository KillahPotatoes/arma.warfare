waitUntil {!isNull player};

_kp_markers_array = [];
_kp_markers_start = 0.5;
_kp_markers_change = 0.02;

while {true} do {
	{deleteMarkerLocal _x;} count _kp_markers_array;
	_kp_markers_array = [];
	{
		if ((side _x == east || side _x == independent) && (({!captive _x} count (units _x) ) > 0)) then {
      _kp_markers_pos = getPosATL leader _x;
			_kp_markers_posx = floor (_kp_markers_pos select 0);
			_kp_markers_posx = _kp_markers_posx - (_kp_markers_posx mod 200);
			_kp_markers_posy = floor (_kp_markers_pos select 1);
			_kp_markers_posy = _kp_markers_posy - (_kp_markers_posy mod 200);

			// Chernarus Grid Fix
			if (worldName == "Chernarus") then {
				_kp_markers_posy = _kp_markers_posy - 140;
				if ((_kp_markers_posy + 200) < (_kp_markers_pos select 1)) then {
					_kp_markers_posy = _kp_markers_posy + 200;
				};
			};

			// Sahrani Grid Fix
			if (worldName == "Sara") then {
				_kp_markers_posy = _kp_markers_posy - 20;
				if ((_kp_markers_posy + 200) < (_kp_markers_pos select 1)) then {
					_kp_markers_posy = _kp_markers_posy + 200;
				};
			};

			_kp_markers_name = format["kp_marker_grid_%1_%2", _kp_markers_posx, _kp_markers_posy];
			_kp_markers_color = format["Color%1", side _x];

			if ((markerShape _kp_markers_name) isEqualTo "RECTANGLE") then {
				_kp_markers_name setMarkerAlphaLocal ((markerAlpha _kp_markers_name) +  _kp_markers_change);
			} else {
				createMarkerLocal[_kp_markers_name, [_kp_markers_posx + 100, _kp_markers_posy + 100, 0]];
				_kp_markers_name setMarkerShapeLocal "RECTANGLE";
				_kp_markers_name setMarkerSizeLocal [100,100];
				_kp_markers_name setMarkerColorLocal _kp_markers_color;
				_kp_markers_name setMarkerAlphaLocal (_kp_markers_start +  _kp_markers_change);
				_kp_markers_array pushBack _kp_markers_name;
			};
		};
	} count allGroups;
	uiSleep (2);
};
