add_halo_action = {
  params ["_box"];

  _box addAction [["Halo Insertion", 0] call addActionText, {
    params ["_target", "_caller"];

    openMap true;
    onMapSingleClick {
      onMapSingleClick {};

      private _soldiers = (units group _caller) select {  
        (_x distance _caller) < 100 
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
  }, nil, 90, true, true, "",
  '[_this] call is_leader && [_this] call not_in_vehicle && [_target, _this] call owned_box'
  ];
};



