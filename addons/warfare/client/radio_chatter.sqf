
ARWA_report_casualities = {
	params ["_group", "_deaths", "_distance", "_direction", "_location"];
	sleep random 5;

	if(!isNull _group) then {
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_one_casualty, _distance, _direction, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_heavy_casualties, _deaths, _distance, _direction, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_multiple_casualties, _deaths, _distance, _direction, _location];
		};
	};

};

ARWA_system_chat = {
	params ["_values"];
	sleep random 3;

	private _msg = [_values] call ARWA_localize_and_format;
	systemChat _msg;
};


ARWA_group_report_client = {
	params ["_group", "_values"];
	sleep random 3;

	private _msg = [_values] call ARWA_localize_and_format;
	(leader _group) sideChat _msg;
};

ARWA_HQ_report_client = {
	params ["_side", "_values"];
	sleep random 3;

	if(isNil "_side") exitWith {};

	private _msg = [_values] call ARWA_localize_and_format;
	[_side, "HQ"] sideChat _msg;
};

ARWA_HQ_report_client_all = {
	params ["_values"];
	sleep random 3;

	private _msg = [_values] call ARWA_localize_and_format;
	[playerSide, "HQ"] sideChat _msg;
};

ARWA_localize_and_format = {
	params ["_values"];

	private _localized_str = localize (_values select 0);
	_values set [0,_localized_str];

	format _values;
};

ARWA_one_casualty = [
	"ARWA_STR_ONE_CASUALITY_VAR1",
	"ARWA_STR_ONE_CASUALITY_VAR2",
	"ARWA_STR_ONE_CASUALITY_VAR3",
	"ARWA_STR_ONE_CASUALITY_VAR4"
];

ARWA_multiple_casualties = [
	"ARWA_STR_MULTIPLE_CASUALITIES_VAR1",
	"ARWA_STR_MULTIPLE_CASUALITIES_VAR2",
	"ARWA_STR_MULTIPLE_CASUALITIES_VAR3"
];

ARWA_heavy_casualties = [
	"ARWA_STR_HEAVY_CASUALITIES_VAR1",
	"ARWA_STR_HEAVY_CASUALITIES_VAR2",
	"ARWA_STR_HEAVY_CASUALITIES_VAR3"
];

ARWA_report_casualities_in_sector = {
	params ["_group", "_deaths", "_location"];
	sleep random 10;

	if(!isNull _group) then {
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_one_casualty_in_sector, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_heavy_casualties_in_sector, _deaths, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[localize selectRandom ARWA_multiple_casualties_in_sector, _deaths, _location];
		};
	};

};

ARWA_one_casualty_in_sector = [
	"ARWA_STR_ONE_CASUALITY_IN_SECTOR_VAR1",
	"ARWA_STR_ONE_CASUALITY_IN_SECTOR_VAR2",
	"ARWA_STR_ONE_CASUALITY_IN_SECTOR_VAR3",
	"ARWA_STR_ONE_CASUALITY_IN_SECTOR_VAR4"
];

ARWA_multiple_casualties_in_sector = [
	"ARWA_STR_MULTIPLE_CASUALITIES_IN_SECTOR_VAR1",
	"ARWA_STR_MULTIPLE_CASUALITIES_IN_SECTOR_VAR2",
	"ARWA_STR_MULTIPLE_CASUALITIES_IN_SECTOR_VAR3"
];

ARWA_heavy_casualties_in_sector = [
	"ARWA_STR_HEAVY_CASUALITIES_IN_SECTOR_VAR1",
	"ARWA_STR_HEAVY_CASUALITIES_IN_SECTOR_VAR2",
	"ARWA_STR_HEAVY_CASUALITIES_IN_SECTOR_VAR3"
];