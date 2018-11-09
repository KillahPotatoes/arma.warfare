delete_all_waypoints = {
	params ["_group"];

	while {(count (waypoints _group)) > 0} do
	{
		deleteWaypoint [_group, 0];
	};
};

group_ai = {
	while {true} do {
		{		
			private _group = _x;
			private _side = side _group; 

			if (!(isPlayer leader _group) && _side in factions && _group getVariable "active") then { // TODO check if in group && (leader or injured) to avoid getting new checkpoints while waiting for revive
				private _isAir = (vehicle leader _group) isKindOf "Air";
				
				if (_isAir) exitWith {
					[_group, _side] spawn air_group_ai;
				};

				[_group, _side] spawn ground_group_ai;
			};
		} forEach ([] call get_all_battle_groups);

		sleep random 10;
	};
};
