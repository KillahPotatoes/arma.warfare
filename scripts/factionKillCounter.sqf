with uiNamespace do {

	PrintPercentage = {
		_side = _this select 0;

		_tier = missionNamespace getVariable format["%1_tier", _side];
		_percentage = missionNamespace getVariable format["%1_percentage", _side];

		if (_tier == 3) exitWith {
			"";
		}; 

		format[" %1%2", _percentage, "%"];
	};

	PrintStrength = {
		_side = _this select 0;
		_strength = floor (missionNamespace getVariable format["%1_strength", _side]);

		if (_strength < 0) exitWith {
			0;
		}; 

		_strength;
	};

	[] spawn {
		waitUntil {!isNull findDisplay 46};
		disableSerialization;

		_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
		_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH * 0.5, safeZoneW, safeZoneH * 0.08];
		_ctrl ctrlCommit 0;

		while {true} do {
			_ctrl ctrlSetStructuredText parseText format[
				"<t color='#000f72' align='right' size='1'>T%7%10 (+%2) %1</t><br /><t color='#720000' align='right' size='1'>T%8%11 (+%4) %3</t><br /><t color='#097200' align='right' size='1'>T%9%12 (+%6) %5</t>",
        [WEST] call PrintStrength,
        missionNamespace getVariable "WEST_sector_income",
        [EAST] call PrintStrength,
        missionNamespace getVariable "EAST_sector_income",
        [independent] call PrintStrength,
        missionNamespace getVariable "GUER_sector_income",
		missionNamespace getVariable "WEST_tier",
		missionNamespace getVariable "EAST_tier",
		missionNamespace getVariable "GUER_tier",
		[WEST] call PrintPercentage,
		[EAST] call PrintPercentage,
		[independent] call PrintPercentage];
      sleep 10;
		};
	};

};
