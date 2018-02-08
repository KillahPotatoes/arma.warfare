missionNamespace setVariable ["IndependentManPower", 100, true];
missionNamespace setVariable ["EastManPower", 100, true];
missionNamespace setVariable ["WestManPower", 100, true];

missionNamespace setVariable ["EastActiveManPower", 0, true];
missionNamespace setVariable ["WestActiveManPower", 0, true];
missionNamespace setVariable ["IndependentActiveManPower", 0, true];

missionNamespace setVariable ["IndependentManPowerIncome", 0, true];
missionNamespace setVariable ["EastManPowerIncome", 0, true];
missionNamespace setVariable ["WestManPowerIncome", 0, true];

sectors = [];
west_sectors = [];
ind_sectors = [];
east_sectors = [];

GetEnemySectors = {
	_faction = _this select 0;

	_sectors = [];

	if(_faction isEqualTo WEST) then {
		_sectors = ind_sectors + east_sectors;
	};

	if(_faction isEqualTo EAST) then {
		_sectors = ind_sectors + west_sectors;
	};

	if(_faction isEqualTo independent) then {
		_sectors = west_sectors + east_sectors;
	};

	_sectors;
};