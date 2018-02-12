player addAction ["Request squad", {
    _group = group player;
    _group_count = {alive _x} count units _group;

    _numberOfSoldiers = 8 - _group_count;

    _pos = [getPos player, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _soldierGroup = [_pos, side player, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    
    {[_x] joinSilent _group} forEach units _soldierGroup;

    _soldierGroup deleteGroupWhenEmpty true;
		[_group] remoteExec ["AddBattleGroups", 2];
  }, nil, 1.5, true, true, "",
  '
	_show = false;
	_trg = cursorTarget;
	if ( (typeOf _trg) in ["B_CargoNet_01_ammo_F"]
    && {alive _x} count units group player < 8
    && _trg distance player < 3
    && isTouchingGround player
    && alive player
    && lifeState player != "incapacitated"
    && leader player == player) then {
		_show = true;
	};
	_show
'
  ];
