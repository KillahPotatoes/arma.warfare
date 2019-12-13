
ARWA_generate_mines = {
	params ["_field_center", "_field_radius", "_number_mines", "_debugs_mines", "_name"];

	_nm =0;
	while {_nm<_number_mines} do {
		private _pos_mine= [_field_center,random [_field_radius / 2, _field_radius, _field_radius * 2], random 360] call BIS_fnc_relPos;

		private _mines = if (isOnRoad _pos_mine) then {
			if(isNil "ARWA_anti_vehicle_mines" || ARWA_anti_vehicle_mines isEqualTo []) exitWith {};

			ARWA_anti_vehicle_mines;
		} else {

			if(isNil "ARWA_anti_personel_mines" || ARWA_anti_personel_mines isEqualTo []) exitWith {};
			ARWA_anti_personel_mines;
		};

		if(isNil "_mines") exitWith {};

		if (!(surfaceIsWater _pos_mine)) then {
			private _type = selectRandom _mines;
			createMine [_type, _pos_mine, [], 0];

			if (_debugs_mines) then {
				_markern = format[ "markern_%1_%2", str (_nm+1), _name];
				_markerstr = createMarker [_markern,_pos_mine];
				_markerstr setMarkerShape "ICON";
				_markerstr setMarkerType "hd_dot";
				_markerstr setMarkerColor "ColorRed";
			};
		};


		_nm=_nm+1;
	};
};

ARWA_initialize_mine_fields = {
	{
	  _pos = getPosWorld _x;
	  _name = _x getVariable ARWA_KEY_target_name;
      [_pos,300,random [0, 25, 50],false, _name] call ARWA_generate_mines;

	} count ARWA_sectors;
};
