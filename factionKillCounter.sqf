with uiNamespace do {

	[] spawn {
		waitUntil {!isNull findDisplay 46};
		disableSerialization;

		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
		_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH * 0.5, safeZoneW, safeZoneH * 0.08];
		_ctrl ctrlCommit 0;

		while {true} do {
			_ctrl ctrlSetStructuredText parseText format[
				"<t color='#000f72' align='right' size='1'>(+%2) %1</t><br /><t color='#720000' align='right' size='1'>(+%4) %3</t><br /><t color='#097200' align='right' size='1'>(+%6) %5</t>",
        floor (missionNamespace getVariable "WestManPower"),
        missionNamespace getVariable "WestManPowerIncome",
        floor (missionNamespace getVariable "EastManPower"),
        missionNamespace getVariable "EastManPowerIncome",
        floor (missionNamespace getVariable "IndependentManPower"),
        missionNamespace getVariable "IndependentManPowerIncome"
			];
      sleep 10;
		};
	};

};
