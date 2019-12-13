ARWA_add_take_manpower = {
  player addAction [[localize "ARWA_STR_TAKE_MANPOWER", 0] call ARWA_add_action_text, {
		  params ["_target", "_caller"];

      private _new_manpower = cursorTarget call ARWA_get_manpower;
      private _manpower = (_caller call ARWA_get_manpower) + _new_manpower;

      _caller setVariable [ARWA_KEY_manpower, _manpower, true];
      cursorTarget setVariable [ARWA_KEY_manpower, 0, true];
      systemChat format[localize "ARWA_STR_YOU_TOOK_MANPOWER", _new_manpower];
    }, nil, ARWA_manpower_actions, false, true, "", '[cursorTarget] call ARWA_can_take_manpower'];
};

ARWA_add_store_manpower = {
  player addAction [[localize "ARWA_STR_STORE_MANPOWER", 0] call ARWA_add_action_text, {
		  params ["_target", "_caller"];

      [_caller, cursorTarget] call ARWA_store_manpower;
    }, nil, ARWA_manpower_actions, false, true, "", '[cursorTarget] call ARWA_can_store_manpower'];
};

ARWA_store_manpower = {
  params ["_from", "_to"];
  private _manpower = (_from call ARWA_get_manpower) + (_to call ARWA_get_manpower);

  _from setVariable [ARWA_KEY_manpower, 0, true];
  _to setVariable [ARWA_KEY_manpower, _manpower, true];
  systemChat format[localize "ARWA_STR_YOU_STORED_MANPOWER", _manpower]
};

ARWA_can_take_manpower = {
  params ["_target"];

  (player distance _target < 5)
  && {_target call ARWA_obj_has_manpower};
};

ARWA_can_store_manpower = {
  params ["_target"];

  (player distance _target < 5)
  && {player call ARWA_obj_has_manpower};
};

ARWA_add_manpower_action = {
	params ["_box"];

	_box addAction [[localize "ARWA_STR_ADD_MANPOWER", 0] call ARWA_add_action_text, {
		params ["_target", "_caller"];

		private _manpower = _caller call ARWA_get_manpower;

		_caller setVariable [ARWA_KEY_manpower, 0];

		[side _caller, _manpower] remoteExec ["ARWA_increase_manpower_server", 2];
		systemChat format[localize "ARWA_STR_YOU_ADDED_MANPOWER", _manpower];

	}, nil, ARWA_manpower_actions, false, true, "",
  '[_target, _this] call ARWA_owned_by && [_this] call ARWA_obj_has_manpower', 10
  ];
};

ARWA_obj_has_manpower = {
    params ["_obj"];

    ([_obj] call ARWA_get_manpower) > 0;
};