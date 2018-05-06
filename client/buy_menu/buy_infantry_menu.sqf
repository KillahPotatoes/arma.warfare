create_soldier = {
	params ["_group", "_class_name"];
	_class_name createUnit[getPos player, _group, "", ([player] call get_rank_skill)];
};

buy_infantry = {
	params ["_class_name", "_price"];

		if (_price call check_if_can_afford) exitWith {

			_group = group player;
			_group_count = {alive _x} count units _group;
			_numberOfSoldiers = squad_size - _group_count;

			if (_numberOfSoldiers > 0) exitWith {
				[_group, _class_name] call create_soldier;
				_price call widthdraw_cash;
				[_group] remoteExec ["add_battle_group", 2];
			};

			systemChat "You have the maximum allowed amount of people";		
		};

		systemChat "You cannot afford that soldier";		
};

infantry_list_options = {
	params ["_type", "_priority"];

	private _options = missionNamespace getVariable format["%1_buy_%2", side player, _type];

	{
		private _name = _x select 0;
		private _class_name = _x select 1;
		private _price = _x select 2;
		private _req_tier = _x select 3;

		if ((side player) call get_tier >= _req_tier) then {
			buy_options pushBack (player addAction [format[" %2 - %1$", _price, _name], {	
				private _params = _this select 3;
				private _type = _params select 0;
				private _class_name = _params select 1;
				private _price = _params select 2;

				[] call remove_all_options;
							
				[_class_name, _price] call buy_infantry;
				

			}, [_type, _class_name, _price], (_priority - 1), false, false, "", 
			'[player] call is_player_close_to_hq || {[cursorTarget, player] call can_use_ammo_box}']);
		};
	
	} forEach _options;
};

create_infantry_buy_menu = {
	params ["_title", "_type", "_priority"];

	player addAction [_title, {
		private _params = _this select 3;

		private _type = _params select 0;
		private _priority = _params select 1;
		[] call remove_all_options;
		[_type, _priority] call infantry_list_options;


	}, [_type, _priority], _priority, false, false, "", 
	'([player] call is_player_close_to_hq || {[cursorTarget, player] call can_use_ammo_box}) && [player] call is_leader'];	
};
