SpawnBaseVehicle = {
	_side = _this select 0;
	_parking_spot = _this select 1;
	_veh_array = _this select 2;
	_type = _this select 3;

	_pos = getPos _parking_spot;

	_isEmpty = !(_pos isFlatEmpty  [3, -1, -1, -1, -1, false, _parking_spot] isEqualTo []);

	if (_isEmpty) then {
		_veh_type = selectRandom _veh_array;
		_veh = _veh_type createVehicle _pos;

		_dir = getDir _parking_spot;
		_veh setDir _dir;

		missionNamespace setVariable [format["%1_base_%2", _side, _type], _veh];		
	} else {
		systemChat format["Something is obstructing the %1 respawn area", _type];
	};
};

initializeBase = {
	_side = _this select 0;

	_heli_pad_b = ["%1_helipad_battle", _side] call Get;

	if (!(isNil "_heli_pad_b")) then {
		_heli_array_b = ([_side] call GetPreset) getVariable "helicopters"; 
		[_side, _heli_array_b, _heli_pad_b, 3, "heli_b"] spawn BaseVehicle;
	};

	_heli_pad_t = ["%1_helipad_transport", _side] call Get;

	if (!(isNil "_heli_pad_t")) then {
		_heli_array_t = missionNamespace getVariable format["%1_transport_heli", _side];
		[_side, _heli_array_t, _heli_pad_t, 0, "heli_t"] spawn BaseVehicle;
	};

	_vehicle_h = ["%1_vehicle_heavy_parking", _side] call Get;

	if (!(isNil "_vehicle_h")) then {
		_heavy_vehicles = missionNamespace getVariable format["%1_heavy_vehicles", _side];
		[_side, _heavy_vehicles, _vehicle_h, 2, "heavy_v"] spawn BaseVehicle;
	};

	_vehicle_l = ["%1_vehicle_light_parking", _side] call Get;
	systemChat "Is here";
	if (!(isNil "_vehicle_l")) then {
		_light_vehicles = missionNamespace getVariable format["%1_light_vehicles", _side];
		[_side, _light_vehicles, _vehicle_l, 1, "light_v"] spawn BaseVehicle;
	};
};

BaseVehicle = {
	_side = _this select 0;
	_veh_array = _this select 1;
	_parking_spot = _this select 2;
	_req_tier = _this select 3;
	_type = _this select 4;

	while {true} do {
		_tier = ["%1_tier", _side] call Get;
		
		if (_tier >= _req_tier) then {
			_veh = missionNamespace getVariable [format["%1_base_%2", _side, _type], nil];

			if(isNil "_veh") then {
				[_side, _parking_spot, _veh_array, _type] call SpawnBaseVehicle;
			} else {
				if(!alive _veh) exitWith {
					
					[_side, _parking_spot, _veh_array, _type] call SpawnBaseVehicle;
				};

				if(!canMove _veh) exitWith {
					sleep 60;
					_veh setDamage 1;
				};
			};
		};

	 	sleep 10;
	};
};

[WEST] call initializeBase;
[EAST] call initializeBase;
[independent] call initializeBase;


