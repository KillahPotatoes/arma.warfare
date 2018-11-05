clean_up =  {
	while {true} do {
		//_t5 = diag_tickTime;
		
		[] spawn broken_vehicles;
		[] spawn clean_up_dead;
		[] call status;

		//[_t5, "clean_up"] spawn report_time;		
		
		sleep 300;
	};
};

broken_vehicles = {
	{
		_veh = _x;
		if(_veh isKindOf "Tank" || _veh isKindOf "Car" || _veh isKindOf "Air") then {		
			if({_x distance _veh < 100} count allPlayers == 0) then {
				if(!canMove _veh && alive _veh) then {
					[_veh] spawn kill_vehicle;    
				};
			}; 					
		};		
	} foreach vehicles;
};

kill_vehicle = {
	params ["_veh"];

	sleep random 60;     
	_veh setDammage 1;  
};

status = {
    _dead = count allDead;
    _vehicles = count vehicles;
    _groups = count allGroups;
    _units = count allUnits;

    diag_log format["Dead: %1, Vehicles: %2, Groups: %3, Units: %4", _dead, _vehicles, _groups, _units];
};

clean_up_dead = {
	{
		private _obj = _x;
		if({_x distance _obj < 200} count allPlayers == 0) then {
			deleteVehicle _obj;
		};		
	} forEach allDead;	
};

clean_up_vehicles = {
	{
		if(_x isKindOf "Tank" || _x isKindOf "Car" || _x isKindOf "Air") then {
			deleteVehicle _x;
		};
	} forEach vehicles;	
};

clean_up_groups = {
	
	{
		deleteGroup _x;
	} forEach allGroups;
};

clean_up_units = {
	{
		if(!(dynamicSimulationEnabled _x)) then {
			deleteVehicle _x;
		};
	} forEach allUnits;	
};

clean_up_dynamic_units = {
	{
		if((dynamicSimulationEnabled _x)) then {
			deleteVehicle _x;
		};
	} forEach allUnits;	
};

clean_all = {
	[] call clean_up_dynamic_units;
	[] call clean_up_units;
	[] call clean_up_vehicles;
	[] call clean_up_groups;
	[] call clean_up_dead;
};