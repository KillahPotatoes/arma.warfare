sector_cash_generation = {
      while {true} do {
            sleep 60;
            {
                  private _sector = _x;
                  private _side = _sector getVariable owned_by;

                  if(_side in factions) then {
                        private _ammo_box = _sector getVariable box;
                        private _cash = _ammo_box getVariable cash;

                        _ammo_box setVariable [cash, (_cash + cash_per_minute), true];
                  };

            } forEach sectors;      
      };
};

reset_sector_cash = {
      params ["_new_owner", "_sector"];

      if(_new_owner countSide allPlayers == 0 && !(_new_owner isEqualTo civilian)) then {
            _ammo_box = _sector getVariable box;
            _ammo_box setVariable [cash, 0, true];
      };
}