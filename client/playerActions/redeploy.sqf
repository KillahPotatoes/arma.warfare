check_if_player_already_in_hq = {
  params ["_player"];

  private _pos = getMarkerPos ([side _player, respawn_ground] call get_prefixed_name);
  (getPos _player) distance _pos > 25; 
};

AddRedeployToHqAction = {
  player addAction ["Redeploy to HQ", {
      _side = side player;       
      
      private _pos = getMarkerPos ([_side, respawn_ground] call get_prefixed_name);
      _safe_pos = [_pos, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
        player setPos _safe_pos;
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box && [player] call check_if_player_already_in_hq'
  ];
};
