create_manpower_menu = {
	params ["_priority"];

	player addAction [["Add manpower points", 0] call addActionText, {	
		private _manpower = player getVariable [manpower, 0];
	
		player setVariable [manpower, 0];

		[side player, _manpower] remoteExec ["buy_manpower_server", 2];
		systemChat format["You added %1 manpower points", _manpower];     

	}, nil, _priority, false, false, "", '[player] call is_player_close_to_hq && [player] call player_has_manpower'];	
};

