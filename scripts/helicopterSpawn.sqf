
spawnHelicopter = {
  _side = _this select 0;
  _marker = _this select 1;

  _helicopters = ([_side] call GetPreset) getVariable "helicopters";

  while {true} do {
        _enemy_sector_count = [_side] call EnemySectorCount;
        while {_enemy_sector_count > 0} do {              

         SystemChat format["%1 has %2 targets", _side, _enemy_sector_count];    
            
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

[West, airUnitSpawnWest] spawn spawnHelicopter;
[independent, airUnitSpawnIndependent] spawn spawnHelicopter;
[east, airUnitSpawnEast] spawn spawnHelicopter;
