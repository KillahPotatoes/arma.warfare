clean_up =  {
	while {true} do {
		[] call broken_vehicles;
		[] call empty_groups;
		sleep 300;
	};
};

broken_vehicles = {
	{
		_veh = _x;
		if(_veh isKindOf "Tank" || _veh isKindOf "Car" || _veh isKindOf "Air") then {		
			if({_x distance _veh < 100} count allPlayers == 0) then {
				if(!canMove _veh && alive _veh) then {
					_veh setDammage 1;             
				};
			}; 					
		};		
	} count vehicles;
};

empty_groups = {
	systemChat "Deleting groups";
	{ 
		if (!(isGroupDeletedWhenEmpty _x)) then {
			_x deleteGroupWhenEmpty true;
		}; 
 	} forEach allGroups;
};
