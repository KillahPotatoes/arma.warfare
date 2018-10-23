not_in_vehicle = {
	params ["_player"];
	_player isEqualTo (vehicle _player);
};

can_use_ammo_box = {
  params ["_trg", "_player"];

  if(isNil "_trg") exitWith {
    false;
  };

  _owner = _trg getVariable owned_by;
  
  (typeOf _trg) in [ammo_box]
  && _owner isEqualTo side _player
  && (_trg distance _player) < 5
  && isTouchingGround _player
  && alive _player
  && lifeState _player != "incapacitated";
};

is_ammo_box = {
  params ["_trg", "_player"];
  
  if(isNil "_trg") exitWith {
    false;
  };

  (typeOf _trg) in [ammo_box]
  && _trg distance _player < 5
  && isTouchingGround _player
  && alive _player
  && lifeState _player != "incapacitated";
};

is_close_to_hq = {
  params ["_side"];

  private _respawn_marker = [_side, respawn_ground] call get_prefixed_name;
	private _pos = getMarkerPos _respawn_marker;

	(getPos player) distance _pos < 25; 
};

is_player_close_to_hq = {
	params ["_player"];

  [side _player] call is_close_to_hq;
};

is_leader = {
	params ["_player"];

  isPlayer (leader (group _player));   
};

is_close_to_enemy_hq = {
	params ["_player"];

  _enemy = factions - [side _player];
  _isClose = true;

  {
    _isClose = _isClose && (_x call is_close_to_hq);
  } forEach _enemy;

  _isClose;	
};