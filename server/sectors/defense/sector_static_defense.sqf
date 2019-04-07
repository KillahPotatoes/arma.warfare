spawn_static = {
	params ["_pos", "_side"];

	private _orientation = random 360;	
	private _type = selectRandom (missionNamespace getVariable format["%1_static_artillery", _side]);
	private _static_pos = [_pos, 5, 25, 7, 0.25, 0, 0,[_pos, _pos]] call BIS_fnc_findSafePos;
				
	if(!(_static_pos isEqualTo _pos)) exitWith {
		private _static = [_static_pos, _orientation, _type, _side] call spawn_vehicle;
		private _group = _static select 2;
		_group deleteGroupWhenEmpty true;
		_group enableDynamicSimulation false; 
		_group setVariable [defense, true];
		[_group] call remove_nvg_and_add_flash_light;

		private _name = _static select 0;
		_name addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];

		_static;
	};	
};

remove_static = {
	params ["_static"];	
	private _group = _static select 2;

	{
		_x setDamage 1;
	} forEach units _group;

	deleteVehicle (_static select 0);	
};

static_alive = {
	params ["_static"];
	
	private _group = _static select 2;
	private _veh = _static select 0;

	(({alive _x} count units _group) > 0 && (damage _veh < 1));	
};


