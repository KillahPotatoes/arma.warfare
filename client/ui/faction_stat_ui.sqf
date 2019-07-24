
ARWA_show_ui = {

	with uiNamespace do {
		ARWA_max_rank = missionNamespace getVariable "ARWA_max_rank";
		ARWA_kills_per_rank = missionNamespace getVariable "ARWA_kills_per_rank";
		ARWA_KEY_rank = missionNamespace getVariable "ARWA_KEY_rank";
		ARWA_KEY_manpower = missionNamespace getVariable "ARWA_KEY_manpower";
		ARWA_KEY_kills = missionNamespace getVariable "ARWA_KEY_kills";
		ARWA_ranks =  missionNamespace getVariable "ARWA_ranks";
		ARWA_all_sides =  missionNamespace getVariable "ARWA_all_sides";
		ARWA_max_tier =  missionNamespace getVariable "ARWA_max_tier";

		ARWA_get_tier_progress = {
			params ["_side"];
			missionNamespace getVariable format ["ARWA_%1_tier_prog",  _side]; // TODO add key
		};

		ARWA_get_tier = {
			params ["_side"];
			missionNamespace getVariable format ["ARWA_%1_tier",  _side]; // TODO add key
		};

		ARWA_get_strength = {
			params ["_side"];
			missionNamespace getVariable format ["ARWA_%1_strength",  _side]; // TODO add key
		};

		ARWA_print_percentage = {
			params ["_side"];

			private _tier = _side call ARWA_get_tier;
			private _percentage = _side call ARWA_get_tier_progress;

			if (_tier == ARWA_max_tier) exitWith {
				"";
			};

			format[" %1%2", _percentage, "%"];
		};

		ARWA_print_faction_stats = {
			params ["_side", "_color"];

			if(!(_side in ARWA_all_sides)) exitWith { ""; };

			format[
				"<t color='%1' align='right' size='1'>T%2%3 %4</t>",
				_color,
				[_side] call ARWA_get_tier,
				[_side] call ARWA_print_percentage,
				[_side] call ARWA_print_strength
				];
		};

		ARWA_print_strength = {
			params ["_side"];
			0 max (ceil ([_side] call ARWA_get_strength));
		};

		ARWA_print_rank = {

			private _rank = (player getVariable ARWA_KEY_rank) max 0;

			if(_rank < ARWA_max_rank) then {
				private _kills = (player getVariable [ARWA_KEY_kills, 0]) max 0;
				private _percentage = floor(((_kills mod ARWA_kills_per_rank) / ARWA_kills_per_rank) * 100);
				format["<t color='#000000' align='right' size='1'>%1 (%2%3)</t>", ARWA_ranks select _rank, _percentage, "%"];
			} else {
				format["<t color='#000000' align='right' size='1'>%1</t>", ARWA_ranks select _rank];
			};
		};

		ARWA_print_manpower = {
			format["<t color='#8e8a00' align='right' size='1'>Manpower %1</t>", player getVariable ARWA_KEY_manpower];
		};

		[] spawn {
			waitUntil {!isNull findDisplay 46};
			disableSerialization;

			private _ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
			_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH * 0.5, safeZoneW, safeZoneH * 0.15];
			_ctrl ctrlCommit 0;

			while {true} do {

				_ctrl ctrlSetStructuredText parseText format[
					"%1<br />%2<br />%3<br />%4<br />%5",
					[] call ARWA_print_rank,
					[] call ARWA_print_manpower,
					[west, '#000f72'] call ARWA_print_faction_stats,
					[east, '#720000'] call ARWA_print_faction_stats,
					[independent, '#097200'] call ARWA_print_faction_stats
					];
			sleep 2;
			};
		};

	};

};
