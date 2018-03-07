
show_ui = {
	
	with uiNamespace do {
		systemChat "Uinamespace";
		get_tier_progress = {
			params ["_side"];
			missionNamespace getVariable format ["%1_tier_prog",  _side];
		};

		get_tier = {
			params ["_side"];
			missionNamespace getVariable format ["%1_tier",  _side];
		};


		get_strength = {
			params ["_side"];
			missionNamespace getVariable format ["%1_strength",  _side];
		};


		get_income = {
			params ["_side"];
			missionNamespace getVariable format ["%1_income", _side];
		};

		print_percentage = {
			params ["_side"];

			_tier = _side call get_tier; 
			_percentage = _side call get_tier_progress;

			if (_tier == 3) exitWith {
				"";
			}; 

			format[" %1%2", _percentage, "%"];
		};

		print_faction_stats = {
			params ["_side", "_color"];

			format[
				"<t color='%1' align='right' size='1'>T%2%3 (+%4) %5</t>",
				_color,
				[_side] call get_tier,
				[_side] call print_percentage,
				[_side] call get_income,
				[_side] call print_strength
				];
		};

		print_strength = {
			params ["_side"];
			0 max (ceil ([_side] call get_strength));
		};

		print_cash = {
			format["<t color='#000000' align='right' size='1'>$ %1</t>", player getVariable "cash"];
		};

		[] spawn {
			systemChat "spawn Uinamespace";
			
			waitUntil {!isNull findDisplay 46};
			disableSerialization;

			private _ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
			_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH * 0.5, safeZoneW, safeZoneH * 0.10];
			_ctrl ctrlCommit 0;

			while {true} do {			
				
				_ctrl ctrlSetStructuredText parseText format[
					"%1<br />%2<br />%3<br />%4",
					[] call print_cash,
					[west, '#000f72'] call print_faction_stats,
					[east, '#720000'] call print_faction_stats,
					[independent, '#097200'] call print_faction_stats
					];
			sleep 2;
			};
		};

	};
	
};

