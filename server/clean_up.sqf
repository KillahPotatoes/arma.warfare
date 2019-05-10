ARWA_clean_up =  {
	while {true} do {
		//_t5 = diag_tickTime;

		[] spawn ARWA_broken_vehicles;
		[] spawn ARWA_clean_up_dead;
		[] call ARWA_status;

		//if(count allPlayers == 0) then {
		//	ARWA_cease_fire = true;
		//} else {
		//	ARWA_cease_fire = false;
		//};

		//[_t5, "ARWA_clean_up"] spawn ARWA_report_time;

		sleep 300;
	};
};

ARWA_broken_vehicles = {
	{
		_veh = _x;
		if(_veh isKindOf "Tank" || _veh isKindOf "Car" || _veh isKindOf "Air") then {
			if({_x distance _veh < 100} count allPlayers == 0) then {
				if(!canMove _veh && alive _veh) then {
					[_veh] spawn ARWA_kill_vehicle;
				};
			};
		};
	} foreach vehicles;
};

ARWA_kill_vehicle = {
	params ["_veh"];

	sleep random 60;
	_veh setDamage 1;
};

ARWA_status = {
    _dead = count allDead;
    _vehicles = count vehicles;
    _groups = count allGroups;
    _units = count allUnits;

    diag_log format["Dead: %1, Vehicles: %2, Groups: %3, Units: %4", _dead, _vehicles, _groups, _units];
};

ARWA_clean_up_dead = {
	{
		private _obj = _x;
		if({_x distance _obj < 200} count allPlayers == 0) then {
			deleteVehicle _obj;
		};
	} forEach allDead;
};

ARWA_clean_up_vehicles = {
	{
		if(_x isKindOf "Tank" || _x isKindOf "Car" || _x isKindOf "Air") then {
			deleteVehicle _x;
		};
	} forEach vehicles;
};

ARWA_clean_up_groups = {

	{
		deleteGroup _x;
	} forEach allGroups;
};

ARWA_clean_up_units = {
	{
		if(!(dynamicSimulationEnabled _x)) then {
			deleteVehicle _x;
		};
	} forEach allUnits;
};

ARWA_clean_up_dynamic_units = {
	{
		if((dynamicSimulationEnabled _x)) then {
			deleteVehicle _x;
		};
	} forEach allUnits;
};

ARWA_clean_all = {
	[] call ARWA_clean_up_dynamic_units;
	[] call ARWA_clean_up_units;
	[] call ARWA_clean_up_vehicles;
	[] call ARWA_clean_up_groups;
	[] call ARWA_clean_up_dead;
};