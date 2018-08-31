buy_manpower = {
	params ["_manpower"];

	player setVariable [manpower, 0];

	[side player, _manpower] remoteExec ["buy_manpower_server", 2];
	systemChat format["You added %1 manpower points", _manpower];        
};

create_manpower_menu = {
	params ["_priority"];

	player addAction ["Add manpower points", {	
		private _params = _this select 3;
		private _priority = _params select 0;
		private _manpower = player getVariable [manpower, 0];
	
		[_manpower] call buy_manpower;

	}, [_priority], _priority, false, false, "", '[player] call is_player_close_to_hq && [player] call player_has_manpower'];	
};

