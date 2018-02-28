spawn_defensive_squad = {
	params ["_sector"];

	_side = _sector getVariable owned_by;
	_safe_pos = [_sector getVariable pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
	private _number_of_soldiers = defender_cap call calc_number_of_soldiers;
    private _group = [_safe_pos, _side, _number_of_soldiers, true] call spawn_infantry;
	
    _group setBehaviour "AWARE";
	_group;
};

spawn_mortar = {
	params ["_sector"];
	private _side = _sector getVariable owned_by;

	private _orientation = random 360;	
	private _type = selectRandom (missionNamespace getVariable format["%1_mortars", _side]);
	private _pos = [_sector getVariable pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;
				
	private _mortar = [_pos, _orientation, _type, _side] call BIS_fnc_spawnVehicle;
	private _group = _mortar select 2;
	_group deleteGroupWhenEmpty true;
	_group enableDynamicSimulation false; 

	private _name = _mortar select 0;
	_name addeventhandler ["fired", {(_this select 0) setvehicleammo 1}];

	_mortar;
};

should_spawn_mortar = {
	params ["_sector", "_sector_owner"];

	private _mortar = _sector getVariable mortar;
	if(isNil "_mortar") exitWith {
		true;
	};

	private _group = _mortar select 2;
	if(side _group isEqualTo _sector_owner && ({alive _x} count units _group) > 0) exitWith {
		false;
	};
};

should_remove_mortar = {
	params ["_sector", "_sector_owner"];

	private _mortar = _sector getVariable mortar;
	if(isNil "_mortar") exitWith {
		false;
	};

	private _group = _mortar select 2;
	if(!(side _group isEqualTo _sector_owner) || ({alive _x} count units _group) == 0) exitWith {
		true;
	};
};

spawn_mortar_pos = {
	params ["_sector"];

	if([_sector, _side] call should_remove_mortar) then {
		private _mortar = _sector getVariable mortar;
		deleteVehicle (_mortar select 0);
	};

	if([_sector, _side] call should_spawn_mortar) then {
		_new_mortar = _sector call spawn_mortar;	
		_sector setVariable [mortar, _new_mortar];	
	};
};

calc_number_of_soldiers = {
	params ["_soldier_cap"];
	floor random [_soldier_cap / 2, _soldier_cap / 1.5, _soldier_cap];
};

spawn_reinforcments = {
	params ["_sector", "_defenders", "_side"];
	
    private _group_count = {alive _x} count units _defenders;

	private _new_soldiers = 0 max ((defender_cap call calc_number_of_soldiers) - _group_count);

    private _pos = [_sector getVariable pos, 0, 25, 5, 0, 0, 0] call BIS_fnc_findSafePos;	
    private _group = [_pos, _side, _new_soldiers, true] call spawn_infantry;
    	
    {[_x] joinSilent _defenders} forEach units _group;
	deleteGroup _group;
	_defenders;
};

spawn_sector_squad = {
	params ["_sector"];
	private _side = _sector getVariable owned_by;
	private _sector_defense = _sector getVariable sector_def;

	if(isNil "_sector_defense") exitWith {
		_defensive_squad = [_sector] call spawn_defensive_squad;	
		_sector setVariable [sector_def, _defensive_squad];
		_defensive_squad call add_defensive_group;
	}; 	

	if (side _sector_defense isEqualTo _side) exitWith {
		_defensive_squad = [_sector, _sector_defense, _side] call spawn_reinforcments;
		_defensive_squad call add_defensive_group;
	};

	if(!(side _sector_defense isEqualTo _side)) exitWith {
		if({alive _x} count units _sector_defense > 0) then {
			_sector_defense call remove_defensive_group;
			_sector_defense call add_battle_group;
		};

		_defensive_squad = [_sector] call spawn_defensive_squad;	
		_sector setVariable [sector_def, _defensive_squad];
	};
};

spawn_sector_defense = {
	params ["_sector"];
	_sector call spawn_sector_squad;
	_sector call spawn_mortar_pos;
	//_sector call spawn_patrol_squad;
};