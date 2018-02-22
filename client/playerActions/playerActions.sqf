can_use_ammo_box = {
  params ["_trg", "_player"];

  _owner = _trg getVariable owned_by;
  
  (typeOf _trg) in [ammo_box]
  && _owner isEqualTo side player
  && _trg distance _player < 5
  && isTouchingGround _player
  && alive _player
  && lifeState _player != "incapacitated"
  && leader _player == _player;
};

is_ammobox = {
  params ["_trg", "_player"];
  
  (typeOf _trg) in [ammo_box]
  && _trg distance _player < 5
  && isTouchingGround _player
  && alive _player
  && lifeState _player != "incapacitated";
};