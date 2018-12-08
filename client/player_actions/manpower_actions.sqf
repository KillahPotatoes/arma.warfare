add_take_manpower = {  
  player addAction [[localize "TAKE_MANPOWER", 0] call addActionText, {
		  params ["_target", "_caller"];

      private _new_manpower = (cursorTarget getVariable [manpower, 0]);
      private _manpower = floor(_caller getVariable [manpower, 0]) + _new_manpower;
    
      _caller setVariable [manpower, _manpower, true];
      cursorTarget setVariable [manpower, 0, true];
      systemChat format[localize "YOU_TOOK_MANPOWER", _new_manpower];
    }, nil, arwa_manpower_actions, true, true, "", '[cursorTarget] call can_take_manpower'];
}; 

add_store_manpower = {  
  player addAction [[localize "STORE_MANPOWER", 0] call addActionText, {
		  params ["_target", "_caller"];
      
      private _manpower = floor(_caller getVariable [manpower, 0]) + (cursorTarget getVariable [manpower, 0]);
    
      _caller setVariable [manpower, 0, true];
      cursorTarget setVariable [manpower, _manpower, true];
      systemChat format[localize "YOU_STORED_MANPOWER", _manpower]
    }, nil, arwa_manpower_actions, true, true, "", '[cursorTarget] call can_store_manpower'];
};

can_take_manpower = {
  params ["_target"];  
  
  (player distance _target < 3)
  && {(_target getVariable [manpower, 0]) > 0}
};

can_store_manpower = {
  params ["_target"]; 
    
  player distance _target < 3
  && {(player getVariable [manpower, 0]) > 0};
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

player_has_manpower = {
    params ["_player"];

    _manpower = _player getVariable manpower;
    _manpower > 0;
};