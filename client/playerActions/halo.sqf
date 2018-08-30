
AddHeloAction = {
  player addAction ["Halo Insertion", {
    openMap true;
    onMapSingleClick {
      onMapSingleClick {};

      private _soldiers = (units group player) select {  
        (_x distance player) < 100 
        && isTouchingGround _x
        && alive _x
        && lifeState _x != "incapacitated" 
      };

      [_soldiers, _pos] spawn helo;
      
      openMap false;
    };
    waitUntil {
      !visibleMap;
    };
    onMapSingleClick {};
  }, nil, 1.5, true, true, "",
  '[player] call is_player_close_to_hq && [player] call is_leader'
  ];
};



