with uiNamespace do {
	[] spawn {
		waitUntil {!isNull findDisplay 46};
		disableSerialization;

		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
		_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH * 0.5, safeZoneW, safeZoneH * 0.08];
		_ctrl ctrlCommit 0;

		while {true} do {
			_ctrl ctrlSetStructuredText parseText format[
				"<t color='#000f72' align='right' size='1'>T%7%10 (+%2) %1</t><br /><t color='#720000' align='right' size='1'>T%8%11 (+%4) %3</t><br /><t color='#097200' align='right' size='1'>T%9%12 (+%6) %5</t>",
        floor (missionNamespace getVariable "WEST_strength"),
        missionNamespace getVariable "WEST_sector_income",
        floor (missionNamespace getVariable "EAST_strength"),
        missionNamespace getVariable "EAST_sector_income",
        floor (missionNamespace getVariable "GUER_strength"),
        missionNamespace getVariable "GUER_sector_income",
		missionNamespace getVariable "WEST_tier",
		missionNamespace getVariable "EAST_tier",
		missionNamespace getVariable "GUER_tier",
		format[" %1%2", missionNamespace getVariable "WEST_percentage", "%"],
		format[" %1%2", missionNamespace getVariable "EAST_percentage", "%"],
		format[" %1%2", missionNamespace getVariable "GUER_percentage", "%"]];
      sleep 10;
		};
	};

};
