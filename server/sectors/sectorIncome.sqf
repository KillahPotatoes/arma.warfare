sector_cash_generation = {
      while {true} do {
            sleep 60;
            {
                  private _sector = _x;
                  private _side = _sector getVariable owned_by;

                  if(_side in factions) then {
                        private _ammo_box = _sector getVariable box;
                        private _cash = _ammo_box getVariable cash;

                        _ammo_box setVariable [cash, (_cash + cash_per_minute + (_sector call get_additional_income_based_on_stationed_players)), true];
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
};

get_additional_income_based_on_stationed_players = {
      params ["_sector"];
      private _pos = _sector getVariable pos;
      private _side = _sector getVariable owned_by;
      private _total_factor = 0;

      { 
            if(alive _x && side _x isEqualTo _side && _pos distance2D getPos _x < sector_size) exitWith {
                  private _rank = _x getVariable ["rank", 0];
                  _total_factor = _total_factor + 1 + (_rank * 0.2);
                  true;
            };
            
            false;
      } count allPlayers;

      cash_per_minute * _total_factor;
};
