
report_casualities = {
	params ["_group", "_deaths", "_distance", "_direction", "_location"];
	sleep random 5;

	if(!isNull _group) then {
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[selectRandom oneCasualty, _distance, _direction, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[selectRandom heavyCasualties, _deaths, _distance, _direction, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[selectRandom multipleCasualties, _deaths, _distance, _direction, _location];
		};	
	};
	
};

report_heli_taxi_status = {
	params ["_group", "_msg"];
	(leader _group) sideChat _msg;
};

client_report_next_waypoint = {
	params ["_group", "_msg"];
	sleep random 5;
	(leader _group) sideChat _msg;
};

client_report_incoming_support = {
	params ["_side", "_msg"];
	[_side, "HQ"] sideChat _msg;
};

client_report_lost_support = {
	params ["_side", "_msg"];
	[_side, "HQ"] sideChat _msg;
};

oneCasualty = [
	"We lost a soldier %1m %2 of %3", 
	"We have one down %1m %2 of %3", 
	"We are one less at %1m %2 of %3", 
	"We lost one %1m %2 of %3"
];

multipleCasualties = [
	"We are taking casualties. %1 down %2m %3 of %4", 
	"We just lost %1 soldiers %2m %3 of %4",  
	"We lost %1 guys %2m %3 of %4"
];

heavyCasualties = [
	"We need backup! Just lost %1 soldiers %2m %3 of %4",
	"We are taking heavy casualties %2m %3 of %4. %1 guys down!",
	"Send backup. %1 just got killed %2m %3 of %4"
];

report_casualities_in_sector = {
	params ["_group", "_deaths", "_location"];
	sleep random 10;

	if(!isNull _group) then {	
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[selectRandom oneCasualtyInSector, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[selectRandom heavyCasualtiesInSector, _deaths, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[selectRandom multipleCasualtiesInSector, _deaths, _location];
		};	
	};
	
};

oneCasualtyInSector = [
	"We lost a soldier at %1", 
	"We have one down at %1", 
	"We are one less at %1", 
	"We lost one at %1"
];

multipleCasualtiesInSector = [
	"We are taking casualties. %1 down at %2", 
	"We just lost %1 soldiers at %2", 
	"We lost %1 guys at %2"
];

heavyCasualtiesInSector = [
	"We need backup! Just lost %1 at %2",
	"We are taking heavy casualties at %2",
	"Send backup. %1 just got killed at %2"
];