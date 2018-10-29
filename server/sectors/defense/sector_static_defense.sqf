spawn_static = {
	params ["_sector", "_type", "_static_group"];
	private _side = _sector getVariable owned_by;

	private _orientation = random 360;	
	private _sector_pos = _sector getVariable pos;
	private _pos = [_sector_pos, 5, 25, 7, 0.25, 0, 0,[_sector_pos, _sector_pos]] call BIS_fnc_findSafePos;
				
	if(!(_pos isEqualTo _sector_pos)) exitWith {
		private _static = [_pos, _orientation, _type, _side] call BIS_fnc_spawnVehicle;
		private _group = _static select 2;
		_group deleteGroupWhenEmpty true;
		_group enableDynamicSimulation false; 
		_group setVariable [defense, true];

		private _veh = _static select 0;
		_veh addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];

		if(!(isNil "_static_group")) then {
			{[_x] joinSilent _static_group} forEach units _group;
			deleteGroup _group;
		};

		_veh;
	};	
};