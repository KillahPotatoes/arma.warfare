sector_manpower_generation = {
      while {true} do {
            sleep arwa_manpower_generation_time;
            {
                  private _sector = _x;
                  private _side = _sector getVariable owned_by;

                  if(_side in arwa_all_sides) then {
                        private _ammo_box = _sector getVariable box;
                        private _manpower = _ammo_box getVariable manpower;

                        private _generated = 1 + (_sector call get_additional_income_based_on_stationed_players);

                        _ammo_box setVariable [manpower, (_manpower + _generated), true];
                  };

            } forEach sectors;      
      };
};

reset_sector_manpower = {
      params ["_new_owner", "_old_owner", "_sector", "_sector_name"];

      if(_new_owner countSide allPlayers == 0 && !(_new_owner isEqualTo civilian)) then {
            private _ammo_box = _sector getVariable box;
            private _manpower = _ammo_box call get_manpower;

            if(_old_owner countSide allPlayers > 0 && _manpower > 0) then {
                  private _faction_name = _new_owner call get_faction_names;

                  [_new_owner, _manpower] spawn buy_manpower_server;                  
                  [["MANPOWER_IS_LOST", _faction_name, _manpower, _sector_name]] remoteExec ["HQ_report_client_all"];
            };

            _ammo_box setVariable [manpower, 0, true];
      };
};

get_additional_income_based_on_stationed_players = {
      params ["_sector"];
      private _pos = _sector getVariable pos;
      private _side = _sector getVariable owned_by;
      private _total_factor = 0;

      { 
            if(alive _x && side _x isEqualTo _side && _pos distance2D getPos _x < arwa_sector_size) exitWith {
                  private _rank = _x getVariable ["rank", 0];
                  _total_factor = _total_factor + 1 + (_rank * 0.2);
                  true;
            };
            
            false;
      } count allPlayers;

      _total_factor;
};
