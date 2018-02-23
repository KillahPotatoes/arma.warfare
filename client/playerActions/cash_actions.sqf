add_take_cash_from_player_action = {  
  player addAction ["Take cash", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
};

add_take_cash_from_ammobox = {  
  player addAction ["Take cash", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call is_ammobox'
    ];
};

add_store_cash_action = {
  params ["_cash"]

  player addAction ["Store cash", {
      private _cash = _this select 3;

      

      [player side, _cash] remoteExecCall store_cash;

  }, _cash, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box && [player] call is_close_to_hq'
  ];
};
