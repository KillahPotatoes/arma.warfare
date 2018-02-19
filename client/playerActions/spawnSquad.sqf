ShowRequestSquadAction = {
  player addAction ["Request squad", {
    _group = group player;
    _group_count = {alive _x} count units _group;

    _numberOfSoldiers = 8 - _group_count;

    _pos = [getPos player, 0, 15, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    _soldierGroup = [_pos, side player, _numberOfSoldiers] call BIS_fnc_spawnGroup;
    
    {[_x] joinSilent _group} count units _soldierGroup;

    _soldierGroup deleteGroupWhenEmpty true;
		[_group] remoteExec ["add_battle_group", 2];
  }, nil, 1.5, true, true, "",
  '[cursorTarget, player] call can_use_ammo_box'
  ];
};


