

capture_sector = {
	params ["_sector", "_side"];

	[_sector, _side] call change_sector_ownership;

	_msg = format["%1 has captured %2", _side, _sector getVariable sector_name];
	_msg remoteExec ["hint"]; 
};

lose_sector = {
	params ["_sector", "_side"];

	[_sector, civilian] call change_sector_ownership;

	_msg = format["%1 has lost %2", _side, _sector getVariable sector_name];
	_msg remoteExec ["hint"]; 
};

change_sector_ownership = {
	params ["_sector", "_new_owner"];

	_old_owner = _sector getVariable owned_by;
	_sector setVariable [owned_by, _new_owner, true];
	_sector call draw_sector;

	_ammo_box = _sector getVariable box;		
	_ammo_box setVariable [owned_by, _new_owner, true];

	if (!(_old_owner isEqualTo civilian)) then {
		_sector call remove_respawn_position;	
		[_old_owner, _sector] call remove_sector;
	};

	if(!(_new_owner isEqualTo civilian)) then {
		[_sector] call add_respawn_position;
		[_sector] call spawn_sector_defense;
		[_new_owner, _sector] call add_sector;
	};

	[_new_owner, _sector] call reset_sector_cash;
};

check_if_sector_is_attacked = {
	params ["_side", "_sector", "_friendly_units_center", "_enemy_units_center", "_enemy_units_nearby"];

	if (_friendly_units_center) exitWith {
		private _sector_owner = _sector getVariable owned_by;

		if(_side isEqualTo _sector_owner && _enemy_units_center) exitWith {
			[_sector, _side] call lose_sector;
		};

		if(!(_side isEqualTo _sector_owner) && !_enemy_units_nearby) exitWith {
			[_sector, _side] call capture_sector;
		};
	};
};

initialize_sector_control = {
	while {true} do {	
		{
			private _sector = _x;
			private _pos = _sector getVariable pos;

			private _east_inner_pres = [_pos , EAST] call any_units_in_sector_center;
			private _west_inner_pres = [_pos, WEST] call any_units_in_sector_center;
			private _guer_inner_pres = [_pos, RESISTANCE] call any_units_in_sector_center;

			if (_east_inner_pres || _west_inner_pres || _guer_inner_pres) then {

				private _east_pres = [_pos , EAST] call any_units_in_sector;
				private _west_pres = [_pos, WEST] call any_units_in_sector;
				private _guer_pres = [_pos, RESISTANCE] call any_units_in_sector;

				[west, _sector, _west_inner_pres, _guer_inner_pres || _east_inner_pres, _east_pres || _guer_pres] call check_if_sector_is_attacked;
				[east, _sector, _east_inner_pres, _guer_inner_pres || _west_inner_pres, _west_pres || _guer_pres] call check_if_sector_is_attacked;
				[independent, _sector, _guer_inner_pres, _west_inner_pres || _east_inner_pres, _east_pres || _west_pres] call check_if_sector_is_attacked;			
			};

		} forEach sectors;
	};
};

