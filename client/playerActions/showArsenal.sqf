ShowArsenalAction = {  
  player addAction [["Arsenal", 0] call addActionText, {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 150, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
};


