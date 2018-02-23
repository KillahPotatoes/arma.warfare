add_take_cash_from_player_action = {  
  player addAction ["Take cash", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
};

add_take_cash_from_ammobox = {  
  player addAction ["Take cash", {
      _cash = cursorTarget getVariable cash;
      cursorTarget setVariable [cash, 0, true];
      _player_cash = player getVariable cash;
      player setVariable [cash, (_cash + _player_cash)];
      systemChat format["You took %1 $", _cash];
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call is_ammo_box && !([player] call is_close_to_enemy_hq) && [cursorTarget] call box_has_cash'
    ];
};

add_store_cash_action = {
  player addAction ["Store cash", {
     _player_cash = player getVariable cash;
      player setVariable [cash, 0];
      _cash = cursorTarget getVariable cash;      
      cursorTarget setVariable [cash, (_cash + _player_cash), true];
      systemChat format["You stored %1 $", _player_cash];
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box && [player] call is_player_close_to_hq && [player] call player_has_cash'
  ];
};

player_has_cash = {
    params ["_player"];

    _cash = _player getVariable cash;
    _cash > 0;
};

box_has_cash = {
  params ["_box"];

  _cash = _box getVariable cash;
  _cash > 0;
};
