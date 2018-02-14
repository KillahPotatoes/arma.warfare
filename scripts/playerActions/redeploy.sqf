AddRedeployOption = {
  _sector = _this select 0;
  _action_name = format["Redeploy to %1", _sector getVariable "name"];

  if((_sector getVariable "faction") isEqualTo (side player)) then {
    player addAction [_action_name, {
        _sector = _this select 3;
        _pos = [_sector getVariable "pos", 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
        player setPos _pos;
    }, _sector, 1.5, true, true, "",
    '[cursorTarget, player] call CanUseAmmoBox'
    ];
  };  
};

AddRedeployToSectorsActions = {
  _sectors = _this select 0;

  {
    [_x] call AddRedeployOption;
  } forEach _sectors;
};

AddRedeployToHqAction = {
  player addAction ["Redeploy to HQ", {
       _side = side player;       

	    _respawnMarker = format["respawn_ground_%1", _side];
      _pos = [getMarkerPos _respawnMarker, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
        player setPos _pos;
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call CanUseAmmoBox'
  ];
};
