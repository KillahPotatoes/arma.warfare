killTicker = {
	_this addMPEventHandler ['MPKilled',{
		_unit = _this select 0;

		_newKill = [_unit,_killer];
		_newKill call register_kill;
		}
	];

};

register_kill = {
	_victim = _this select 0;
	if(side group _victim isEqualTo Independent && !(isplayer _victim)) then {
		  _manPower = missionNamespace getVariable "IndependentManPower";
			_manPower = _manPower - 1;
			missionNamespace setVariable ["IndependentManPower", _manPower, true];
	};

	if(side group _victim isEqualTo West && !(isplayer _victim)) then {
		  _manPower = missionNamespace getVariable "WestManPower";
			_manPower = _manPower - 1;
			missionNamespace setVariable ["WestManPower", _manPower, true];
	};

	if(side group _victim isEqualTo East && !(isplayer _victim)) then {
		  _manPower = missionNamespace getVariable "EastManPower";
			_manPower = _manPower - 1;
			missionNamespace setVariable ["EastManPower", _manPower, true];
	};
};
