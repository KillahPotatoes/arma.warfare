ARWA_backup_recharge_time = 300;
ARWA_air_support_recharge_time = 300;
ARWA_last_backup_called = time;
ARWA_last_air_support_called = time;


ARWA_player_request_backup = {
  	player addAction [[localize "ARWA_STR_REQUEST_BACKUP", 0] call ARWA_add_action_text, {

		  	// requesting backup at coordinates : Vis til all

			// HQ responds enten "ingen ledig backup nå", evt si hva som kommer


			}, nil, ARWA_request_backup_actions, false, true, "",
    '[player] call ARWA_is_leader'
    ];
};

ARWA_player_request_air_backup = {
  	player addAction [[localize "RWA_STR_REQUEST_AIR_BACKUP", 0] call ARWA_add_action_text, {

		  	// requesting backup at coordinates : Vis til all

			// HQ responds enten "ingen ledig backup nå", evt



			}, nil, ARWA_request_backup_actions, false, true, "",
    '[player] call ARWA_is_leader'
    ];
};

ARWA_wait_x_minutes_before_trying_again = {
	params ["_timer", "_msg"];
	private _time_left = _timer - time;
	private _wait_minutes = ((_time_left - (_time_left mod 60)) / 60) + 1;
	systemChat format[localize _msg, _wait_minutes];
};