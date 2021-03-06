ARWA_request_transport = {
	params ["_class_name", "_penalty"];

	openMap true;
	[_class_name, _penalty] onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _class_name = _this select 0;
		private _penalty = _this select 1;

		[_pos, _class_name, _penalty] spawn ARWA_order_transport;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};

ARWA_add_support_units = {
	params ["_veh"];
	private _units = [];
	private _group = group player;

	{
		private _unit = [_group, _x, [0,0,0]] call ARWA_create_soldier;

		_units append [_unit];
	} count ARWA_support_soldiers_class_names;

	{
		private _default_class_name = ((missionNamespace getVariable format["ARWA_%1_infantry_tier_0", playerSide]) select 0) select 0;
		private _unit = [_group, _default_class_name, [0,0,0]] call ARWA_create_soldier;
		[_x, _unit] spawn ARWA_apply_loadout;

		_units append [_unit];
	} count ARWA_support_soldiers_loadouts;

	ARWA_support_soldiers_loadouts = [];
	ARWA_support_soldiers_class_names = [];
	ARWA_support_soldiers = [];

	{
		_x moveInCargo _veh;
		_x assignTeam "BLUE";
	} forEach _units;
};

ARWA_order_transport = {
	params ["_pos", "_class_name", "_penalty"];

	private _arr = [playerSide, _class_name, _penalty] call ARWA_spawn_transport;
	private _veh = _arr select 0;
	private _group = _arr select 2;
	private _name = (typeOf _veh) call ARWA_get_vehicle_display_name;

	[_veh] call ARWA_add_support_units;


	[_veh, _group] spawn ARWA_cancel_on_player_death;

	private _driver = driver _veh;
	[_driver] spawn ARWA_force_driver_to_stay_in_vehicle;
	[_driver] spawn ARWA_remote_control_driver;

	[_veh] spawn ARWA_show_active_transport_menu;
	[_veh] spawn ARWA_check_status;

	[_group, _veh, _pos, "ARWA_STR_TRANSPORT_ON_ITS_WAY"] spawn ARWA_move_transport_to_pick_up;
};

ARWA_force_driver_to_stay_in_vehicle = {
	params ["_driver"];
	private _veh = vehicle _driver;

	while { alive _driver } do
	{
   		waituntil { vehicle _driver == _driver};
     	_driver moveInDriver _veh;
	};
};

ARWA_remote_control_driver = {
	params ["_driver"];

	waitUntil { !alive _driver || !([player] call ARWA_is_alive) };
	objNull remoteControl _driver;
	player switchCamera cameraView;
};

ARWA_spawn_transport = {
	params ["_side", "_class_name", "_penalty"];

	private _arr = if(_class_name isKindOf "Air") then {
	    [_side, _class_name, _penalty, ARWA_transport_helicopter_spawn_height] call ARWA_spawn_helicopter;
	} else {
		[_side, _class_name, _penalty] call ARWA_spawn_transport_vehicle;
	};

	private _group = _arr select 2;
	private _veh = _arr select 0;
	_veh lockDriver true;

	_veh call ARWA_add_rearm_arsenal_action;
	ARWA_transport_present = true;

	_veh setVariable [ARWA_KEY_transport, true];
	_veh setVariable [ARWA_penalty, _penalty, true];

	_group setBehaviour "CARELESS";
	_group deleteGroupWhenEmpty true;
	_arr;
};

ARWA_add_rearm_arsenal_action = {
  params ["_box"];

  _box addAction [[localize "ARWA_STR_REARM_ARSENAL", 0] call ARWA_add_action_text, {
	  params ["_target", "_caller", "_actionId", "_arguments"];

	  private _box = _arguments select 0;
      ["Open",true] spawn BIS_fnc_arsenal;
	  _box setVariable [ARWA_KEY_can_rearm, false];

    }, [_box], ARWA_rearm_arsenal, true, false, "",
    '[_target, _this] call ARWA_owned_by && [_this] call ARWA_not_in_vehicle && [_target] call ARWA_can_rearm', 10];
};

ARWA_can_rearm = {
	params ["_target"];

	_target getVariable [ARWA_KEY_can_rearm, true];
};