CanUseAmmoBox = {
  _trg = _this select 0;
  _player = _this select 1;  
  _owner = _trg getVariable "owner";	
  
  (typeOf _trg) in ["B_CargoNet_01_ammo_F"]
  && _owner isEqualTo side player
  && _trg distance _player < 5
  && isTouchingGround _player
  && alive _player
  && lifeState _player != "incapacitated"
  && leader _player == _player;
};

[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\spawnSquad.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\redeploy.sqf";

RefreshActionList = {
	_sectors = _this select 0;

	removeAllActions player;

	[] call ShowRequestSquadAction;
	[] call ShowArsenalAction;
	[] call AddHeloAction;
	[] call AddRedeployToHqAction;
	[_sectors] call AddRedeployToSectorsActions;

};