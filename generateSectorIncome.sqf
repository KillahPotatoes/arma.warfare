
while {true} do {
      _numberOfWestSectors = [west] call BIS_fnc_moduleSector;
      _numberOfEastSectors = [east] call BIS_fnc_moduleSector;
      _numberOfIndependentSectors = [independent] call BIS_fnc_moduleSector;

      _IndependentManPowerIncome = _numberOfIndependentSectors;
      _IndependentManPower = missionNamespace getVariable "IndependentManPower";
      _IndependentManPower = _IndependentManPower + _numberOfIndependentSectors  / 30;
      missionNamespace setVariable ["IndependentManPower", _IndependentManPower, true];
      missionNamespace setVariable ["IndependentManPowerIncome", _IndependentManPowerIncome, true];

      _WestManPowerIncome = _numberOfWestSectors;
      _WestManPower = missionNamespace getVariable "WestManPower";
      _WestManPower = _WestManPower + _numberOfWestSectors  / 30;
      missionNamespace setVariable ["WestManPower", _WestManPower, true];
      missionNamespace setVariable ["WestManPowerIncome", _WestManPowerIncome, true];

      _EastManPowerIncome = _numberOfEastSectors;
      _EastManPower = missionNamespace getVariable "EastManPower";
      _EastManPower = _EastManPower + _numberOfEastSectors / 30;
      missionNamespace setVariable ["EastManPower", _EastManPower, true];
      missionNamespace setVariable ["EastManPowerIncome", _EastManPowerIncome, true];

      sleep 2;
};
