
spawnHelicopter = {
  _helicopters = _this select 0;
  _enemies = _this select 1;
  _side = _this select 2;
  _marker = _this select 3;

  while {true} do {
        _numberOfEnemySectors = _enemies call BIS_fnc_moduleSector;

        while {_numberOfEnemySectors > 0} do {
          _heliType = selectRandom _helicopters;
          _heli = [getPos _marker, 180, _heliType, _side] call BIS_fnc_spawnVehicle;
          _heliName = _heli select 0;

          while{alive _heliName} do {
            _sectors = [true] call BIS_fnc_moduleSector;
            _enemySectors = [];
            {
              if((_x getVariable "owner") != _side && (_x getVariable "owner") != sideUnknown) then {
                _enemySectors pushBack _x;
              }
            } forEach _sectors;

            if(count(_enemySectors) > 0) then {
              _sector = selectRandom _enemySectors;
              _name = _sector getVariable "name";
              _heliGroup = _heli select 2;
              _wp1 = _heliGroup addWaypoint [getPos _sector, 50];
              _wp1 setWaypointType "SAD";
            };
            sleep floor random [120,210,300];
          };
          sleep floor random [120,210,300];
        };
        sleep 120;
  };
};

[_helicoptersWest, [east, independent], West, airUnitSpawnWest] spawn spawnHelicopter;
[_helicoptersIndependent, [east, West], independent, airUnitSpawnIndependent] spawn spawnHelicopter;
[_helicoptersEast, [West, independent], east, airUnitSpawnEast] spawn spawnHelicopter;
