[] call compileFinal preprocessFileLineNumbers "scripts\common\string.sqf";

Get = {
	_str = _this select 0;
	_side = _this select 1;

	missionNamespace getVariable [format[_str, _side], nil];
};

CanUseAmmoBox = {
  _trg = _this select 0;
  _player = _this select 1;
  
  _isNotSectorBox = isNil {_trg getVariable ["sector", nil]};
  _isPlayerOwned = false;
   
  _sector = _trg getVariable ["sector", nil];
   
  if(!(isNil "_sector")) then {
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