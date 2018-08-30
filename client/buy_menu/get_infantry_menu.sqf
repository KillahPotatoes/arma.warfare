create_soldier = {
	params ["_group", "_class_name"];
	_class_name createUnit[getPos player, _group, "", ([] call get_rank_skill)];
};

get_infantry = {
	params ["_class_name"];
		_group = group player;
		_group_count = {alive _x} count units _group;
		_numberOfSoldiers = squad_size - _group_count;

		if (_numberOfSoldiers > 0) exitWith {
			[_group, _class_name] call create_soldier;			
			[_group] remoteExec ["add_battle_group", 2];
		};

		systemChat "You have the maximum allowed amount of people";		
		
};

infantry_list_options = {
	params ["_priority"];

	private _options = missionNamespace getVariable format["%1_infantry", side player];

	{
		private _class_name = _x select 0;
		private _req_tier = _x select 1;

		private _name = _class_name call get_vehicle_display_name;

		if ((side player) call get_tier >= _req_tier) then {
			buy_options pushBack (player addAction [format[" %1", _name], {	
				private _params = _this select 3;
				private _type = _params select 0;
				private _class_name = _params select 1;				

				[] call remove_all_options;
							
				[_class_name] call buy_infantry;
				

			}, [_type, _class_name], (_priority - 1), false, false, "", 
			'[player] call is_player_close_to_hq || {[cursorTarget, player] call can_use_ammo_box}']);
		};
	
	} forEach _options;
};

create_infantry_menu = {
	params ["_title", "_priority"];

	player addAction [_title, {
		private _params = _this select 3;

		private _priority = _params select 0;
		[] call remove_all_options;
		[_priority] call infantry_list_options;

	}, [_priority], _priority, false, false, "", 
	'([player] call is_player_close_to_hq || {[cursorTarget, player] call can_use_ammo_box}) && [player] call is_leader'];	
};
