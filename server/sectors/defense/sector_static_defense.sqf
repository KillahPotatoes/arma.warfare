spawn_static = {
	params ["_sector"];
	private _side = _sector getVariable owned_by;

	private _orientation = random 360;	
	private _type = selectRandom (missionNamespace getVariable format["%1_static", _side]);
	private _sector_pos = _sector getVariable pos;
	private _pos = [_sector_pos, 5, 25, 7, 0.25, 0, 0,[_sector_pos, _sector_pos]] call BIS_fnc_findSafePos;
				
	if(!(_pos isEqualTo _sector_pos)) exitWith {
		private _static = [_pos, _orientation, _type, _side] call BIS_fnc_spawnVehicle;
		private _group = _static select 2;
		_group deleteGroupWhenEmpty true;
		_group enableDynamicSimulation false; 
		_group setVariable [defense, true];

		private _name = _static select 0;
		_name addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];

		_static;
	};	
};

should_spawn_static = {
	params ["_sector", "_sector_owner"];

	private _static = _sector getVariable static;	

	if(isNil "_static") exitWith {
		true;
	};

	private _group = _static select 2;

	if(side _group isEqualTo _sector_owner && ({alive _x} count units _group) > 0) exitWith {
		false;
	};

	true;
};

should_remove_static = {
	params ["_sector", "_sector_owner"];

	private _static = _sector getVariable static;	
	if(isNil "_static") exitWith {
		false;
	};

	private _group = _static select 2;
	if(!(side _group isEqualTo _sector_owner) || ({alive _x} count units _group) == 0) exitWith {
		true;
	};

	false;
};

spawn_static_pos = {
	params ["_sector"];

	if([_sector, _side] call should_remove_static) then {
		private _static = _sector getVariable static;
		deleteVehicle (_static select 0);
	};

	if([_sector, _side] call should_spawn_static) then {
		_new_static = _sector call spawn_static;	

		if (!(isNil "_new_static")) then {
			_sector setVariable [static, _new_static];	
		};
	};
};


