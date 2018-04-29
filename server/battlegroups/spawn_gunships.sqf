spawn_gunship_groups = {
	[West] spawn spawn_gunships;
	[East] spawn spawn_gunships;
	[independent] spawn spawn_gunships;
};

spawn_gunships = {
	params ["_side"];
	
	while {true} do {
		//_t1 = diag_tickTime;

		private _tier = [_side] call get_tier;	

		if(_tier > 0) then {
			sleep random (missionNamespace getVariable format["tier_%1_gunship_respawn_time", _tier]);
			if ([_side] call get_unused_strength > 0) then {

				private _gunship = _side call get_gunship;

				if (!isNil format["%1_gunship", _side]) then {	
					(_gunship select 0) setDamage 1;					
				}; 
				
				_gunship = [_side] call spawn_gunship_group;
				[_gunship select 2] call add_battle_group;

				waitUntil {!canMove (_gunship select 0)};
			};				
		};

		//[_t1, "spawn_gunship"] spawn report_time;
		sleep 10;		
	};
};

spawn_gunship_group = {
	params ["_side"];
	
	private _gunship = selectRandom (_side call get_gunship_types); 
	private _gunship_name = _gunship call get_vehicle_display_name;

	[_side, format["Sending a %1 your way. ETA 2 minutes!", _gunship_name]] call HQ_report;
	sleep 120;

    private _veh = [_side, _gunship] call spawn_helicopter;

	[_side, format["%1 has arrived. See you soon!", _gunship_name]] call HQ_report;

	[_side, _veh] call set_gunship;
	_veh;
};

set_gunship = {
	params ["_side", "_gunship"];
	missionNamespace setVariable [format["%1_gunship", _side], _gunship];
};

get_gunship = {
	params ["_side"];
	missionNamespace getVariable format["%1_gunship", _side];
};

get_gunship_types = {
	params ["_side"];
	missionNamespace getVariable format["%1_gunships", _side]; 
};