ARWA_sector_manpower_generation = {
      while {true} do {
            sleep ARWA_manpower_generation_time;
            {
                  private _sector = _x;
                  private _side = _sector getVariable ARWA_KEY_owned_by;

                  if(_side in ARWA_all_sides) then {
                        private _ammo_box = _sector getVariable ARWA_KEY_box;
                        private _manpower = _ammo_box getVariable ARWA_KEY_manpower;
                        private _sector_pos = _sector getVariable ARWA_KEY_pos;

                        private _hq_pos = getMarkerPos ([_side, ARWA_KEY_respawn_ground] call ARWA_get_prefixed_name);
                        private _distance_to_HQ = _sector_pos distance2D _hq_pos;
                        private _manpower_generation_distance_coef = _distance_to_HQ / ARWA_mission_size;

                        private _generated = _manpower_generation_distance_coef * (1 + ([_sector_pos, _side] call ARWA_get_additional_income_based_on_stationed_players));

                        _ammo_box setVariable [ARWA_KEY_manpower, (_manpower + _generated), true];
                  };
            } forEach ARWA_sectors;
      };
};

ARWA_reset_sector = {
      params ["_new_owner", "_old_owner", "_sector", "_sector_name"];

      private _ammo_box = _sector getVariable ARWA_KEY_box;
      _ammo_box setVariable [ARWA_KEY_hacked, false, true];

      if((playersNumber _new_owner) == 0 && !(_new_owner isEqualTo civilian) && ((playersNumber _old_owner) > 0 || _old_owner isEqualTo civilian)) exitWith {
            private _manpower = _ammo_box call ARWA_get_manpower;

            if(_manpower > 0) exitWith {
                  private _faction_name = _new_owner call ARWA_get_faction_names;

                  [_new_owner, _manpower] spawn ARWA_increase_manpower_server;
                  [["ARWA_STR_MANPOWER_IS_LOST", _faction_name, _manpower, _sector_name]] remoteExec ["ARWA_HQ_report_client_all"];
                  format["%1 got %2 manpower by capturing %3", _faction_name, _manpower, _sector_name] spawn ARWA_debugger;

                  _ammo_box setVariable [ARWA_KEY_manpower, 0, true];
            };
      };
};

ARWA_get_additional_income_based_on_stationed_players = {
      params ["_pos", "_side"];
      private _total_factor = 0;

      {
            if(alive _x && side _x isEqualTo _side && _pos distance2D getPos _x < ARWA_sector_size) exitWith {
                  private _rank = rank _x;
	            private _rank_index = ARWA_ranks find _rank;

                  _total_factor = _total_factor + 1 + (_rank_index * 0.2);
                  true;
            };

            false;
      } count allPlayers;

      _total_factor;
};