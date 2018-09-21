
AddHQMenu = {
  player addAction ["Open Menu", {
	 private _test = createDialog "ICE_DIALOG";
	 waitUntil {!isNull (findDisplay 10001)};

	lbClear 1500;
	
	{	
		private _class_name = _x;
		private _name = _class_name call get_vehicle_display_name;
		
		_index = lbAdd [1500, _name];

		_data = lbSetData [1500, _index, _class_name]; // Set some data (in this case a position of the unit) for later reference based on any UI Events
		lbSetTooltip [1500, _index, _class_name]; // Set some tool tips, because they're nice to have	
	} forEach west_infantry;

  }, nil, 1.5, true, true, "",
  	'[player] call is_leader'
  ];
};

createInfantryFromGui = {
	_index = lbCurSel 1500;
	_displayName = lbText [1500, _index];
	_className = lbData [1500, _index];

	systemChat format ["_className: %1",_className];
	systemChat format ["_displayName: %1",_displayName];
};


