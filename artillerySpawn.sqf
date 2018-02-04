_artilleryWest = ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"];
_artilleryEast = ["O_MBT_02_arty_F"];
_artilleryIndependent = ["CUP_I_M270_HE_AAF", "CUP_I_M270_DPICM_AAF"];

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

[_artilleryWest, West, westStart] spawn CreateArtillery;
[_artilleryEast, East, eastStart] spawn CreateArtillery;
[_artilleryIndependent, Independent, independentStart] spawn CreateArtillery;
