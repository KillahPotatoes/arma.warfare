

CreateArtillery = {
  _artilleryTypes = _this select 0;
  _side = _this select 1;
  _marker = _this select 2;

  while {true} do {

      _artType = selectRandom _artilleryTypes;
      _pos = [_marker, 100, 300, 5, 0, 20, 0] call BIS_fnc_findSafePos;
      _art = [_pos, 180, _artType, _side] call BIS_fnc_spawnVehicle;
      _artName = _art select 0;

      _artName addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];
      _artName disableAI "MOVE";
      _artName disableAI "AIMINGERROR";
      _artName disableAI "SUPPRESSION";

      waitUntil {
        !alive _artName;
      };
      sleep floor random [300,600,900];
  };
};

[artilleryWest, West, westStart] spawn CreateArtillery;
[artilleryEast, East, eastStart] spawn CreateArtillery;
[artilleryIndependent, Independent, independentStart] spawn CreateArtillery;
