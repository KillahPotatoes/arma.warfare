is_friendly_soldier = {
	params ["_cursorTarget", "_player"];

	(side cursorTarget) isEqualTo (side _player) && _cursorTarget isKindOf "Man" && ((getPos _cursorTarget) distance (getPos _player) < 25);	
};

empty_squad = {
	params ["_player"];

	{ alive _x } count units (group _player) == 1;
};

join_squad = {  
  player addAction ["Join squad", {    
		private _group = group cursorTarget;
		private _player_group = group player;	
		[player] join _group;

		private _new_count = { alive _x } count units _group;
		_group setVariable [soldier_count, _new_count];		

		deleteGroup _player_group;
    }, cursorTarget, 1.5, true, true, "",
    '[cursorTarget, player] call is_friendly_soldier && (player call empty_squad)'
    ];
};


leave_squad = {  
  	player addAction ["Leave squad", {
		private _current_group = group player;
		[player] join grpNull;

		private _new_count = { alive _x } count units _current_group;
		_current_group setVariable [soldier_count, _new_count];	
    }, nil, 1.5, true, true, "",
    '!(player call empty_squad)'
    ];
};
