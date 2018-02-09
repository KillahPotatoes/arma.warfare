AttackEnemySector = {
	_battle_group = _this select 0;
	_side = side _battle_group;
	_other_sector_count = [_side] call OtherSectorCount;

	if (_other_sector_count > 0) then {
		_leader_pos = getPos (leader _battle_group);

		_target_sector = [_side, _leader_pos] call FindClosestOtherSector;

		_wp1 = _battle_group addWaypoint [getPos _target_sector, 0];
		_wp1 setWaypointType "SAD";
		_battle_group setBehaviour "AWARE";
		_battle_group enableDynamicSimulation false;

		_battle_group setVariable ["target", _target_sector];
	} else {
		// defend?
	};

	_target_sector;
};

while {true} do {
	{		
		if (!(player isEqualTo leader _x)) then {
			_side = side _x; 

			_target_sector = _x getVariable ["target", "not_set"];

			if (_target_sector isEqualTo "not_set") then {
				_new_target = [_x] call AttackEnemySector;
				systemChat format["%1 moving to %2", _x, _new_target];
			
			} else {
				_current_owner = _target_sector getVariable "faction";
		
				if (_side isEqualTo _current_owner || _side == nil) then {

					_new_target = [_x] call AttackEnemySector; 

					systemChat format["%1 moving to %2", _x, _new_target];
				};
			};
		}; 
		
	} forEach allGroups;
	sleep 10;
};
