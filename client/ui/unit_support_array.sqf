
ARWA_show_unit_support_array = {

	with uiNamespace do {
		[] spawn {
			waitUntil {!isNull findDisplay 46};
			disableSerialization;

			private _ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
			_ctrl ctrlSetPosition [safeZoneX - safeZoneW * 0.9, safeZoneY+ safeZoneH * 0.7, safeZoneW, safeZoneH];

			_ctrl ctrlCommit 0;

			while {true} do {
				private _support_soldiers=  missionNamespace getVariable "ARWA_support_soldiers";
				private _string = _support_soldiers joinString "<br />";
				_ctrl ctrlSetStructuredText parseText format["<t color='#8e8a00' align='right' size='1'>%1</t>", _string];
			sleep 2;
			};
		};

	};

};
