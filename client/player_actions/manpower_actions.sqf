ARWA_add_take_manpower = {
  player addAction [[localize "TAKE_MANPOWER", 0] call ARWA_add_action_text, {
		  params ["_target", "_caller"];

      private _new_manpower = cursorTarget call ARWA_get_manpower;
      private _manpower = (_caller call ARWA_get_manpower) + _new_manpower;

      _caller setVariable [manpower, _manpower, true];
      cursorTarget setVariable [manpower, 0, true];
      systemChat format[localize "YOU_TOOK_MANPOWER", _new_manpower];
    }, nil, ARWA_manpower_actions, true, true, "", '[cursorTarget] call ARWA_can_take_manpower'];
};

ARWA_add_store_manpower = {
  player addAction [[localize "STORE_MANPOWER", 0] call ARWA_add_action_text, {
		  params ["_target", "_caller"];

      private _manpower = (_caller call ARWA_get_manpower) + (cursorTarget call ARWA_get_manpower);

      _caller setVariable [manpower, 0, true];
      cursorTarget setVariable [manpower, _manpower, true];
      systemChat format[localize "YOU_STORED_MANPOWER", _manpower]
    }, nil, ARWA_manpower_actions, true, true, "", '[cursorTarget] call ARWA_can_store_manpower'];
};

ARWA_can_take_manpower = {
  params ["_target"];

  (player distance _target < 3)
  && {(_target call ARWA_get_manpower) > 0}
};

ARWA_can_store_manpower = {
  params ["_target"];

  player distance _target < 3
  && {(player call ARWA_get_manpower) > 0};
};

ARWA_add_manpower_action = {
	params ["_box"];

	_box addAction [[localize "ADD_MANPOWER", 0] call ARWA_add_action_text, {
		params ["_target", "_caller"];

		private _manpower = _caller call ARWA_get_manpower;

		_caller setVariable [manpower, 0];

		[side _caller, _manpower] remoteExec ["ARWA_buy_manpower_server", 2];
		systemChat format[localize "YOU_ADDED_MANPOWER", _manpower];

	}, nil, ARWA_manpower_actions, false, false, "",
  '[_target, _this] call ARWA_owned_box && [_this] call ARWA_player_has_manpower', 10
  ];
};

ARWA_player_has_manpower = {
    params ["_player"];

    _manpower = _player getVariable manpower;
    _manpower > 0;
};