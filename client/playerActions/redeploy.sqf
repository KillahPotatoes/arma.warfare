AddRedeployOption = {
  params ["_sector"];
  _action_name = format["Redeploy to %1", _sector getVariable "name"];

  if((_sector getVariable owned_by) isEqualTo (side player)) then {
    player addAction [_action_name, {
        _sector = _this select 3;
        _pos = [_sector getVariable pos, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
        player setPos _pos;
    }, _sector, 1.5, true, true, "",
    '[cursorTarget, player] call can_use_ammo_box'
    ];
  };  
};

AddRedeployToSectorsActions = {
  params ["_sectors"];
  
  {
    [_x] call AddRedeployOption;
  } forEach _sectors;
};

AddRedeployToHqAction = {
  player addAction ["Redeploy to HQ", {
      _side = side player;       
      
      private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
      _safe_pos = [_pos, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
        player setPos _safe_pos;
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box'
  ];
};
