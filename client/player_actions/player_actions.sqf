not_in_vehicle = {
	params ["_player"];
	_player isEqualTo (vehicle _player);
};

is_leader = {
	params ["_player"];

  isPlayer (leader (group _player));   
};

