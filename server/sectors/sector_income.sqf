ARWA_sector_manpower_generation = {
      private _manpower_limit = 15 + (ARWA_manpower_automatically_added * 15);
      while {true} do {
            sleep ARWA_manpower_generation_time;
            {
                  private _sector = _x;
                  private _side = _sector getVariable ARWA_KEY_owned_by;

                  if(_side in ARWA_all_sides) then {
                        private _manpower = _sector getVariable ARWA_KEY_manpower;

                        if(ARWA_manpower_automatically_added != 0 && _manpower >= _manpower_limit) then {
                              [_side, _manpower] spawn ARWA_increase_manpower_server;
                               _sector setVariable [ARWA_KEY_manpower, 0, true];

                               private _faction_name = _side call ARWA_get_faction_names;
                               private _sector_name = [_sector getVariable ARWA_KEY_target_name] call ARWA_replace_underscore;
                              [["ARWA_STR_GOT_MANPOWER_FROM_SECTOR", _faction_name, _manpower, _sector_name]] remoteExec ["ARWA_HQ_report_client_all"];
                        } else {
                               _sector setVariable [ARWA_KEY_manpower, (_manpower + 1), true];
                        };
                  };
            } forEach ARWA_sectors;
      };
};

ARWA_reset_sector = {
      params ["_new_owner", "_old_owner", "_sector", "_sector_name"];

      if(!(_new_owner isEqualTo civilian) && (_old_owner isEqualTo civilian)) exitWith {
            private _manpower = _sector call ARWA_get_manpower;

            if(_manpower > 0) exitWith {
                  private _faction_name = _new_owner call ARWA_get_faction_names;

                  [_new_owner, _manpower] spawn ARWA_increase_manpower_server;
                  [["ARWA_STR_MANPOWER_IS_LOST", _faction_name, _manpower, _sector_name]] remoteExec ["ARWA_HQ_report_client_all"];
                  format["%1 got %2 manpower by capturing %3", _faction_name, _manpower, _sector_name] spawn ARWA_debugger;

                  _sector setVariable [ARWA_KEY_manpower, 0, true];
            };
      };
};
