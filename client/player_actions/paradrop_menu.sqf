ARWA_paradrop_action = {
	private _actionId = player addAction [[localize "ARWA_STR_RETURN_INTERCEPTOR", 0] call ARWA_add_action_text, {
		params ["_target", "_caller", "_actionId", "_arguments"];

		[] call ARWA_pick_paradrop_location;


	}, [], ARWA_paradrop_actions, false, true, "", '[player] call ARWA_is_leader'];

};

ARWA_pick_paradrop_location = {

	openMap true;
	onMapSingleClick {
		onMapSingleClick {}; // To remove the code triggered on map click so you cannot click twice
		openMap false;

		private _nearby_units = units (group player) select { player distance _x < 100; };

		[_pos, _nearby_units, playerSide] spawn ARWA_do_paradrop;
	};
	waitUntil {
		!visibleMap;
	};
	onMapSingleClick {}; // Remove the code in map click even if you didnt trigger onMapSingleClick
};
