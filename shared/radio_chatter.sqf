
report_casualities = {
	params ["_group"];
	sleep random 10;

	if(!isNull _group) then {
		_prev_count = _group getVariable soldier_count;
		_curr_count = {alive _x} count units _group;	
		_deaths = _prev_count - _curr_count;
		_group setVariable [soldier_count , _curr_count];
		_gridPos = mapGridPosition leader _group;
		
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[selectRandom oneCasualty, _gridPos];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[selectRandom heavyCasualties, _deaths, _gridPos];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[selectRandom multipleCasualties, _deaths, _gridPos];
		};	
	};
	
};

oneCasualty = [
	"We lost a soldier at %1", 
	"We have one down at %1", 
	"We are one less at %1", 
	"We lost one at %1"
];

multipleCasualties = [
	"We are taking casualties. %1 down at %2", 
	"We just lost %1 soldiers at %2", 
	"We lost %1 guys at %2"
];

heavyCasualties = [
	"We need backup! Just lost %1 at %2",
	"We are taking heavy casualties at %2",
	"Send backup. %1 just got killed at %2"
];

report_defensive_casualities = {
	params ["_group"];
	sleep random 10;

	if(!isNull _group) then {
		_prev_count = _group getVariable soldier_count;
		_curr_count = {alive _x} count units _group;	
		_deaths = _prev_count - _curr_count;
		_group setVariable [soldier_count , _curr_count];
		_location = _group getVariable "location";
				
		if(_deaths == 1) exitWith {
			(leader _group) sideChat format[selectRandom oneCasualty, _location];
		};

		if(_deaths > 3) exitWith {
			(leader _group) sideChat format[selectRandom heavyCasualties, _deaths, _location];
		};

		if(_deaths > 1) exitWith {
			(leader _group) sideChat format[selectRandom multipleCasualties, _deaths, _location];
		};	
	};
	
};

oneCasualty = [
	"We lost a soldier at %1", 
	"We have one down at %1", 
	"We are one less at %1", 
	"We lost one at %1"
];

multipleCasualties = [
	"We are taking casualties. %1 down at %2", 
	"We just lost %1 soldiers at %2", 
	"We lost %1 guys at %2"
];

heavyCasualties = [
	"We need backup! Just lost %1 at %2",
	"We are taking heavy casualties at %2",
	"Send backup. %1 just got killed at %2"
];