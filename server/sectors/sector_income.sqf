ARWA_sector_manpower_generation = {
      while {true} do {
            sleep ARWA_manpower_generation_time;
            {
                  private _sector = _x;
                  private _side = _sector getVariable owned_by;

                  if(_side in ARWA_all_sides) then {
                        private _ammo_box = _sector getVariable box;
                        private _manpower = _ammo_box getVariable manpower;

                        private _generated = 1 + (_sector call ARWA_get_additional_income_based_on_stationed_players);

                        _ammo_box setVariable [manpower, (_manpower + _generated), true];
                  };

            } forEach ARWA_sectors;
      };
};

ARWA_reset_sector_manpower = {
      params ["_new_owner", "_old_owner", "_sector", "_sector_name"];

      if(_new_owner countSide allPlayers == 0 && !(_new_owner isEqualTo civilian) && _old_owner countSide allPlayers > 0) exitWith {
            private _ammo_box = _sector getVariable box;
            private _manpower = _ammo_box call ARWA_get_manpower;

            if(_manpower > 0) exitWith {
                  private _faction_name = _new_owner call ARWA_get_faction_names;

                  [_new_owner, _manpower] spawn ARWA_buy_manpower_server;
                  [["MANPOWER_IS_LOST", _faction_name, _manpower, _sector_name]] remoteExec ["ARWA_HQ_report_client_all"];
                  diag_log format["%1 got %2 manpower by capturing %3", _faction_name, _manpower, _sector_name];

                  _ammo_box setVariable [manpower, 0, true];
            };
      };
};

ARWA_get_additional_income_based_on_stationed_players = {
      params ["_sector"];
      private _pos = _sector getVariable pos;
      private _side = _sector getVariable owned_by;
      private _total_factor = 0;

      {
            if(alive _x && side _x isEqualTo _side && _pos distance2D getPos _x < ARWA_sector_size) exitWith {
                  private _rank = _x getVariable ["rank", 0];
                  _total_factor = _total_factor + 1 + (_rank * 0.2);
                  true;
            };

            false;
      } count allPlayers;

      _total_factor;
};
