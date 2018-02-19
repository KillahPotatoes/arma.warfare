ShowArsenalAction = {  
  player addAction ["Arsenal", {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 1.5, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
};


