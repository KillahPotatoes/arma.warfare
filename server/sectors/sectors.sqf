add_sector_box = {
	params ["_sector"];

	_pos = _sector getVariable pos;	 
	_ammo_box = ammo_box createVehicle (_pos);	
	_sector setVariable [box, _ammo_box];
	_ammo_box setVariable [owned_by, civilian, true];	
	_ammo_box setVariable [manpower, 0, true];

	_ammo_box call add_arsenal_action;
	_ammo_box call add_take_manpower_action;
	_ammo_box call add_store_manpower_action;
	// _ammo_box call add_take_intel_action;
	[_ammo_box, "Get infantry", infantry, 130] call create_menu;
};

initialize_sectors = {
	private _sectors = [];
	{
		_type = getMarkerType _x;

		if (_type isEqualTo "hd_objective") then {
			_split_string = [_x, 7] call split_string;
			_first_string = _split_string select 0;
			_second_string = _split_string select 1;					
			
			_sector = createGroup sideLogic;
			_sector setVariable [pos, getMarkerPos _x];
			_sector setVariable [marker, _x];
			_sector setVariable [owned_by, civilian];
			_sector setVariable [sector_name, _second_string];

			[_sector] call draw_sector;
			_sectors pushback _sector;	
			
			_ammo_box = [_sector] call add_sector_box;	

			[_sector] spawn initialize_sector_control;

			true;
		};
	} count allMapMarkers;

	missionNamespace setVariable ["sectors", _sectors];
	missionNamespace setVariable ["west_sectors", []];
	missionNamespace setVariable ["east_sectors", []];
	missionNamespace setVariable ["guer_sectors", []];
};


get_safe_sectors = {
	params ["_side", "_distance"];
	
	private _safe_sectors = [];

	{	
		private _pos = _x getVariable pos;

		if(!([_pos, _side, _distance] call any_enemies_in_area)) then {
			_safe_sectors pushBack _x;
		};
	} forEach (_side call get_owned_sectors);

	_safe_sectors;
};

get_unsafe_sectors = {
	params ["_side", "_distance"];
	
	private _safe_sectors = [_side, _distance] call get_safe_sectors;
	
	(_side call get_owned_sectors) - _safe_sectors;
};

add_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["%1_sectors", _side];
	_sectors pushBack _sector;
};

remove_sector = {
	params ["_side", "_sector"];
	private _sectors = missionNamespace getVariable format["%1_sectors", _side];
	private _index = _sectors find (_sector); 
	_sectors deleteAt (_index);		
};

get_owned_sectors = {
	params ["_side"];
	missionNamespace getVariable format["%1_sectors", _side];
};

get_other_sectors = {
	params ["_side"];
	sectors - (_side call get_owned_sectors);
};

find_closest_sector = {
	params ["_sectors", "_pos"];

	_current_sector = _sectors select 0;
	_shortest_distance = 99999;

	{
		_sector_pos = _x getVariable pos;
		_distance = _pos distance _sector_pos;

		if (_shortest_distance > _distance) then {
			_shortest_distance = _distance;
			_current_sector = _x;
		};

	} forEach _sectors;

	_current_sector;
};

find_closest_friendly_sector = {
	params ["_side", "_pos"];
	
	private _sectors = [_side] call get_owned_sectors;	
	[_sectors, _pos] call find_closest_sector;
};

find_random_other_sector = {
	params ["_side"];

	_sectors = [_side] call get_other_sectors;	

	selectRandom _sectors;
};

find_enemy_sectors = {
	params ["_side"];

	private _enemy = factions - [_side];

	private _sectors = [];
	_sectors = _sectors + ([_enemy select 0] call get_owned_sectors);
	_sectors = _sectors + ([_enemy select 1] call get_owned_sectors);
	
	_sectors;
};

count_enemy_sectors = {
	params ["_side"];

	count ([_side] call find_enemy_sectors);
};