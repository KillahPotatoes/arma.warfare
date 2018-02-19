vehicle_clean_up =  {
	while {true} do {
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

		sleep 300;
	};
};


