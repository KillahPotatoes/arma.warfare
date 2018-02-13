SpawnHeli = {
	_side = _this select 0;

	_heli_pad =  ["%1_heli_spawn", _side] call Get;

	_heli_array = ([_side] call GetPreset) getVariable "helicopters"; 

	_pos = getPos _heli_pad;

	_isEmpty = !(_pos isFlatEmpty  [3, -1, -1, -1, -1, false, _heli_pad] isEqualTo []);

	if (_isEmpty) then {
		_heli = selectRandom _heli_array;
		_veh = _heli createVehicle _pos;

		_dir = getDir _heli_pad;
		_veh setDir _dir;

		missionNamespace setVariable [format["%1_base_heli", _side], _veh];		
	} else {
		systemChat "Something is obstructing the helipad";
	};
};

initializeBase = {
	_side = _this select 0;

	_heli_pad = ["%1_heli_spawn", _side] call Get;

	if (!(isNil "_heli_pad")) then {
		[_side] spawn BaseHeli;
	};
};

BaseHeli = {
	_side = _this select 0;
	_tier = ["%1_tier", _side] call Get;

	while {true} do {
		if (_tier == 3) then {
			_veh = ["%1_base_heli", _side] call Get;

			if(isNil "_veh") then {
				[_side] call SpawnHeli;
			} else {
				if(!alive _veh) exitWith {
					systemChat "Heli is dead";
					
					[_side] call SpawnHeli;
				};

				systemChat "Heli is alive";

				if(!canMove _veh) exitWith {
					systemChat "Heli is not working";
					sleep 60;
					_veh setDamage 1;
				};
			};
		};

	 	sleep 60;
	};
};

[WEST] call initializeBase;
[EAST] call initializeBase;
[independent] call initializeBase;


