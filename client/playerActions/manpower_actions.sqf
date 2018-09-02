add_take_manpower_from_player_action = {  
  player addAction ["Take manpower", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
}; // TODO

add_take_manpower_from_ammobox = {  
  player addAction ["Take manpower", {
      private _manpower = cursorTarget getVariable manpower;
      cursorTarget setVariable [manpower, 0, true];
      private _player_manpower = player getVariable manpower;
      player setVariable [manpower, (_manpower + _player_manpower)];
      systemChat format["You took %1 MP", _manpower];
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call is_ammo_box && !([player] call is_close_to_enemy_hq) && [cursorTarget] call box_has_manpower'
    ];
};

add_store_manpower_action = {
  player addAction ["Store manpower", {
      private _player_manpower = player getVariable manpower;
      player setVariable [manpower, 0];
      private _manpower = cursorTarget getVariable manpower;      
      cursorTarget setVariable [manpower, (_manpower + _player_manpower), true];
      systemChat format["You stored %1 MP", _player_manpower];
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box && [player] call player_has_manpower && !([player] call is_player_close_to_hq)'
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
