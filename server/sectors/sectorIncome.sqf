calc_income = {
      params ["_side"];

      private _count = _side call get_sector_count;
      private _strength = _side call get_strength;
      private _new_strength = _strength + (_count  / 30);

      [_side, _new_strength] call set_strength;
      [_side, _count] call set_income;
};

sector_income = {
      while {true} do {
            west call calc_income;
            east call calc_income;
            independent call calc_income;
            sleep 2;
      };
};


