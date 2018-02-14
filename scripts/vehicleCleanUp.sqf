CleanUpUnmovableVehicles =  {
	while {true} do {
		{
			_veh = _x;
			if(_veh isKindOf "Tank" || _veh isKindOf "Car") then {
				

				if({_x distance _veh < 100} count allPlayers == 0) then {
		
				}; 
						
				if(!canMove _veh && alive _veh) then {
					_veh setDammage 1;             
				};
			};
		
		} forEach vehicles;

		sleep 300;
	};
};

[] spawn CleanUpUnmovableVehicles;

