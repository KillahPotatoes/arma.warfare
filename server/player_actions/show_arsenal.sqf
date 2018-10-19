add_arsenal_action = {  
  params ["_box"];

  _box addAction [["Arsenal", 0] call addActionText, {
      ["Open",true] spawn BIS_fnc_arsenal;
    }, nil, 150, true, false, "",
    '[_target, _this] call owned_box && [_this] call not_in_vehicle', 10
    ];
};

owned_box = {
    params ["_box", "_player"];
    (_box getVariable owned_by) isEqualTo (side _player);
};


