add_take_manpower_from_player_action = {  
  player addAction ["Take manpower", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 80, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
}; // TODO

add_manpower_action = {
	params ["_box"];

	_box addAction [["Add manpower points", 0] call addActionText, {	
		params ["_target", "_caller"];

		private _manpower = _caller getVariable [manpower, 0];
	
		_caller setVariable [manpower, 0];

		[side _caller, _manpower] remoteExec ["buy_manpower_server", 2];
		systemChat format["You added %1 manpower points", _manpower];     

	}, nil, 100, false, false, "", '[_target, _this] call owned_box && [_this] call player_has_manpower'], 10	
};

add_take_manpower_action = {  
  params ["_box"];

  _box addAction [["Take manpower", 0] call addActionText, {
      params ["_target", "_caller"];

      private _manpower = floor(_target getVariable manpower);
      _target setVariable [manpower, 0, true];
      private _player_manpower = _caller getVariable manpower;
      _caller setVariable [manpower, (_manpower + _player_manpower)];
      systemChat format["You took %1 MP", _manpower];
    }, nil, 80, true, false, "",
    '[_target] call box_has_manpower', 10
    ];
};

add_store_manpower_action = {
  params ["_box"];

  player addAction [["Store manpower", 0] call addActionText, {
      params ["_target", "_caller"];

      private _player_manpower = _caller getVariable manpower;
      _caller setVariable [manpower, 0];
      private _manpower = _target getVariable manpower;      
      _target setVariable [manpower, (_manpower + _player_manpower), true];
      systemChat format["You stored %1 MP", _player_manpower];
  }, nil, 80, true, false, "",
  '[_this] call player_has_manpower',10
  ];
};

player_has_manpower = {
    params ["_player"];

    _manpower = _player getVariable manpower;
    _manpower > 0;
};

box_has_manpower = {
  params ["_box"];

  _manpower = _box getVariable manpower;
  _manpower > 0;
};
