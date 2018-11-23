add_take_manpower_from_player_action = {  
  player addAction [[localize "TAKE_MANPOWER", 0] call addActionText, {
		  params ["_target", "_caller"];

      private _manpower = floor(_caller getVariable [manpower, 0]) + (cursorTarget getVariable [manpower, 0]);
    
      _caller setVariable [manpower, _manpower, true];
      cursorTarget setVariable [manpower, 0, true];
      systemChat format[localize "YOU_TOOK_MANPOWER", _manpower];
    }, nil, arwa_manpower_actions, true, true, "", '[cursorTarget] call can_take_manpower_from_player'];
}; 

add_give_manpower_to_player_action = {  
  player addAction [[localize "GIVE_MANPOWER", 0] call addActionText, {
		  params ["_target", "_caller"];
      
      private _manpower = floor(_caller getVariable [manpower, 0]) + (cursorTarget getVariable [manpower, 0]);
    
      _caller setVariable [manpower, 0, true];
      cursorTarget setVariable [manpower, _manpower, true];
      systemChat format[localize "YOU_GAVE_MANPOWER", _manpower]
    }, nil, arwa_manpower_actions, true, true, "", '[cursorTarget] call can_give_manpower_to_player'];
};

can_take_manpower_from_player = {
  params ["_other_player"];
  
  _other_player isKindOf "Man"
  && {(player distance _other_player < 3)} 
  && {(_other_player getVariable manpower) > 0}
  && {!((lifeState _other_player == "INJURED") || (lifeState _other_player == "HEALTHY"))};
};

can_give_manpower_to_player = {
  params ["_other_player"];

  isPlayer _other_player 
  && {player distance _other_player < 3} 
  && {(player getVariable manpower) > 0}
  && {(lifeState _other_player == "INJURED") || (lifeState _other_player == "HEALTHY")};
};

add_manpower_action = {
	params ["_box"];

	_box addAction [[localize "ADD_MANPOWER", 0] call addActionText, {	
		params ["_target", "_caller"];

		private _manpower = _caller getVariable [manpower, 0];
	
		_caller setVariable [manpower, 0];

		[side _caller, _manpower] remoteExec ["buy_manpower_server", 2];
		systemChat format[localize "YOU_ADDED_MANPOWER", _manpower];     

	}, nil, arwa_manpower_actions, false, false, "", 
  '[_target, _this] call owned_box && [_this] call player_has_manpower', 10
  ];	
};

add_take_manpower_action = {  
  params ["_box"];

  _box addAction [[localize "TAKE_MANPOWER", 0] call addActionText, {
      params ["_target", "_caller"];

      private _manpower = floor(_target getVariable manpower);
      _target setVariable [manpower, 0, true];
      private _player_manpower = _caller getVariable manpower;
      _caller setVariable [manpower, (_manpower + _player_manpower)];
      systemChat format[localize "YOU_TOOK_MANPOWER", _manpower];
    }, nil, arwa_manpower_actions, true, false, "",
    '[_target] call box_has_manpower', 10
    ];
};

add_store_manpower_action = {
  params ["_box"];

  _box addAction [[localize "STORE_MANPOWER", 0] call addActionText, {
      params ["_target", "_caller"];

      private _player_manpower = _caller getVariable manpower;
      _caller setVariable [manpower, 0];
      private _manpower = _target getVariable manpower;      
      _target setVariable [manpower, (_manpower + _player_manpower), true];
      systemChat format[localize "YOU_STORED_MANPOWER", _player_manpower];
  }, nil, arwa_manpower_actions, true, false, "",
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
