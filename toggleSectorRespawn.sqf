// _module and _owner passed via parameters from module
params ["_module", "_owner", "_previousSide", "_side", "_index"];
_name = _module getVariable ["name", "Sector"];

if (_owner isEqualTo sideUnknown) then {
    (_module getVariable ["currentRespawnPosition", [sideUnknown, 0]]) params ["_side", "_index"];
    _respawnRemove = [_side, _index] call bis_fnc_removeRespawnPosition;
    _module setVariable ["currentRespawnPosition", nil, true];
} else {
    _respawnReturn = [_owner, _module, _name] call BIS_fnc_addRespawnPosition;
    _module setVariable ["currentRespawnPosition", _respawnReturn, true];

    // spawns some defence
    _chanceOfGuarded = random 100;
    _radius = 25;

    if(_chanceOfGuarded < 70) then {

      _positionForSoldiers = (getPos _module) getPos [_radius * sqrt random 1, random 360];
      _numberOfSoldiers = floor random [3,5,10];
      _soldierGroup = [_positionForSoldiers, _owner, _numberOfSoldiers] call BIS_fnc_spawnGroup;
      _soldierGroup setBehaviour "AWARE";
      _soldierGroup enableDynamicSimulation true;

      /*for "_x" from 1 to 4 do {
        _wp = _soldierGroup addWaypoint [getPos _module, 10, _x];
        _wp setWaypointType "CYCLE";
      };*/

      if(_chanceOfGuarded < 30) then {

        _orientationOfMortar = random 360;
        _numberOfMortars = (floor random 2) + 1;
        _mortarType = "";

        if(_owner isEqualTo East) then {
          _mortarType = "O_Mortar_01_F";
        };

        if(_owner isEqualTo West) then {
          _mortarType = "B_Mortar_01_F";
        };

        if(_owner isEqualTo Independent) then {
          _mortarType = "I_Mortar_01_F";
        };

        for "_i" from 1 to _numberOfMortars do {
            _positionForMortar = (getPos _module) getPos [_radius * sqrt random 1, random 360];
            [_positionForMortar, _orientationOfMortar, _mortarType, _owner] call BIS_fnc_spawnVehicle;
        };
      };
    };


};
