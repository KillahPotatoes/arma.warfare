close_to_any_owned_sectors = {
	params ["_pos", "_sector_boxes"];

	_is_close = 999999;

	{
		if((_x getVariable owned_by) isEqualTo playerSide) then {

			_is_close = _is_close min ((getPosWorld _x) distance2D _pos);
		};
	} forEach _sector_boxes;

	_is_close;
};

create_unit_marker = {
	params ["_group", "_alpha", "_marker_name", "_markers_pos"];

	_markers_posx = floor (_markers_pos select 0);
	_markers_posy = floor (_markers_pos select 1);

	_markers_name = format["_marker_%1_%2_%3", _marker_name, _markers_pos select 0, _markers_pos select 1];
	_markers_color = format["Color%1", side _group];
	
	createMarkerLocal[_markers_name, _markers_pos];
	_markers_name setMarkerBrushLocal "SolidBorder"; 
	_markers_name setMarkerShapeLocal "ELLIPSE";
	_markers_name setMarkerSizeLocal [15,15];
	_markers_name setMarkerAlphaLocal _alpha;
	_markers_name setMarkerColorLocal _markers_color;
	
	_markers_name;
};

show_friendly_markers = {
	_markers_array = [];
	_sector_boxes = allMissionObjects "B_CargoNet_01_ammo_F";
	_marker_name = "friendly";
		
	while {true} do {
		{deleteMarkerLocal _x;} count _markers_array;
		_markers_array = [];

		{
			if ((side _x) isEqualTo playerSide || show_all) then {
				_markers_pos = getPosWorld (leader _x);

				_distance = [_markers_pos, _sector_boxes] call close_to_any_owned_sectors;				
				_alpha = 1 min (_distance / 200);

				_markers_array pushBack ([_x, _alpha, _marker_name, _markers_pos] call create_unit_marker);					
				
			};
		} forEach allGroups;
		uiSleep (2);
	};	
};


show_enemy_markers = {
	_markers_array = [];	
	_sector_boxes = allMissionObjects "B_CargoNet_01_ammo_F";
	_enemies = factions - [playerSide];
	_marker_name = "enemy";
	
	while {true} do {
		{deleteMarkerLocal _x;} count _markers_array;
		_markers_array = [];

		{
			if ((side _x) in _enemies) then {
				_markers_pos = getPosWorld (leader _x);
				_distance = [_markers_pos, _sector_boxes] call close_to_any_owned_sectors;

				if(_distance < 300) then {				
					_alpha = (300 - _distance) / 300;		
					_markers_array pushBack ([_x, _alpha, _marker_name, _markers_pos] call create_unit_marker);			
				};
			};
		} forEach allGroups;
		uiSleep (2);
	};	
};
