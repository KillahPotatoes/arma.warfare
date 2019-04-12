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

		{
			_x setSkill ["spotDistance", 0];
			_x setSkill ["spotTime", 0];
		} forEach units _group;

		private _veh = _static select 0;
		[_veh] spawn add_rearm_delay;

		_static;
	};
};

add_rearm_delay = {
	params ["_veh"];

	_veh setVariable["fired_barrage", false];
	_veh addeventhandler ["fired", {
		private _veh = _this select 0;
		private _fired_barrage = _veh getVariable ["fired_barrage", false];
		if(!_fired_barrage) then {
			_veh setVariable["fired_barrage", true];
			sleep 900;
			(_this select 0) setvehicleammo 1;
			_veh setVariable["fired_barrage", false];
		};
	}];
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
