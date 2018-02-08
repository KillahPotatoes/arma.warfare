
spawnHelicopter = {
  _helicopters = _this select 0;
  _side = _this select 1;
  _marker = _this select 2;

  while {true} do {
        _enemySectors = [_side] call GetEnemySectors;
        while {count(_enemySectors) > 0} do {              

         SystemChat format["%1 has %2 targets", _side, count(_enemySectors)];    
            
          _heliType = selectRandom _helicopters;
          _heli = [getPos _marker, 180, _heliType, _side] call BIS_fnc_spawnVehicle;
          _heliName = _heli select 0;

          SystemChat format["%1 has spawned a %2", _side, _heliName];

          while{alive _heliName} do {
            _enemySectors = [_side] call GetEnemySectors;
            if(count(_enemySectors) > 0) then {
              _sector = selectRandom _enemySectors;              
              _heliGroup = _heli select 2;
              _wp1 = _heliGroup addWaypoint [getPos _sector, 50];
              _wp1 setWaypointType "SAD";
            };
            sleep floor random [120,210,300];
          };
          sleep floor random [120,210,300];
        };
        sleep floor random [120,210,300];
  };
};

[helicoptersWest, West, airUnitSpawnWest] spawn spawnHelicopter;
[helicoptersIndependent, independent, airUnitSpawnIndependent] spawn spawnHelicopter;
[helicoptersEast, east, airUnitSpawnEast] spawn spawnHelicopter;
