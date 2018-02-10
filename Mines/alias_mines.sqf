
generateMines = {
	if (!isServer) exitwith {};

	_field_center = _this select 0;
	_field_radius = _this select 1;
	_nclass_mines = _this select 2;
	_number_mines = _this select 3;
	_debugs_mines = _this select 4;
	_name = _this select 5;

	_IED_blow_trigger = false;

	if ((_nclass_mines=="IEDLandBig_F") or (_nclass_mines=="IEDUrbanBig_F") or (_nclass_mines=="IEDUrbanSmall_F") or (_nclass_mines=="IEDLandSmall_F")) then {
	_IED_blow_trigger = true; //_IED_blow_trigger = "APERSBoundingMine";
	};

	_nm =0;
	while {_nm<_number_mines} do {
		_pos_mine= [_field_center,random [_field_radius / 2, _field_radius, _field_radius * 2], random 360] call BIS_fnc_relPos;
		_al_mine = createMine [_nclass_mines, _pos_mine, [], 0];

		if (_IED_blow_trigger) then {
			_al_ied_trigger = createMine ["APERSMine", _pos_mine, [], 0]
		};

		if (_debugs_mines) then {
			_markern = format[ "markern_%1_%2", str (_nm+1), _name];
			_markerstr = createMarker [_markern,_pos_mine];
			_markerstr setMarkerShape "ICON";
			_markerstr setMarkerType "hd_dot";
			_markerstr setMarkerColor "ColorRed";
		};

		_nm=_nm+1;
	};
};

_sectors = [true] call BIS_fnc_moduleSector;
{
	  _name = _x getVariable "name";
	  [getPos _x,150,"APERSBoundingMine",random [25, 100, 150],false, _name] call generateMines;
      [getPos _x,500,"APERSBoundingMine",random [25, 100, 150],false, format[ "%1_distant", _name]] call generateMines;



} forEach _sectors;
