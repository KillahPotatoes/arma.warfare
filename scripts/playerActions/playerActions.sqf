CanUseAmmoBox = {
  _trg = _this select 0;
  _player = _this select 1;
  
  _sector = _trg getVariable ["sector", nil];	

  _isNotSectorBox = isNil "_sector";
  _isPlayerOwned = false;
   
  if(!(_isNotSectorBox)) then {
    _isPlayerOwned = (_sector getVariable ["faction", nil]) isEqualTo (side _player);
  };

  (typeOf _trg) in ["B_CargoNet_01_ammo_F"]
  && (_isNotSectorBox || _isPlayerOwned)
  && _trg distance player < 3
  && isTouchingGround player
  && alive player
  && lifeState player != "incapacitated"
  && leader player == player;
};

[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\spawnSquad.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\redeploy.sqf";

RefreshActionList = {
	_sectors = _this select 0;

	removeAllActions player;

	[_sectors] call AddRedeployToSectorsActions;
	[] call ShowRequestSquadAction;
	[] call ShowArsenalAction;
	[] call AddRedeployToHqAction;
	[] call AddHeloAction;
};