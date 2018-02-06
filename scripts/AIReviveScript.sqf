ReviveScript = {
	_this addEventHandler ['HandleDamage',{
      _woundedUnit = _this select 0;
      _damageTaken = _this select 2;

		  [_woundedUnit,_damageTaken] call OnDamageTaken;
		}
	];
};

OnDamageTaken = {
    _woundedUnit =  _this select 0;
    _damageTaken =  _this select 1;

      if (_damageTaken > 0.85 && _damageTaken < 1) then {
        _woundedUnit setUnconscious true;
        if (!isNull objectParent _woundedUnit) then {
          _woundedUnit setPos getpos vehicle _woundedUnit
        };
        _woundedUnit spawn DoRevive;
      };
};

DoRevive = {
    _woundedUnit = _this;
    _timerUnc = diag_tickTime;

    waitUntil {
      sleep 0.5;
      lifeState _woundedUnit == "incapacitated" or diag_tickTime > _timerUnc + 2;
    };

    if (lifeState _woundedUnit == "incapacitated"
    && !(_woundedUnit getVariable ["treat",false])) then {
      _woundedUnit setVariable ["treat",true];

      _woundedUnit setCaptive true;
      _medic = _woundedUnit call GetNearbyMedic;

      if(!isNull _medic) then {
        [_medic, _woundedUnit] call CreateMedic;
        [_medic, _woundedUnit] spawn GoRevive;
      };
    };
};

GoRevive = {
  _medic =  _this select 0;
  _woundedUnit = _this select 1;

  _timerTreat = diag_tickTime;
  vehicle _medic disableCollisionWith _woundedUnit;

  uisleep 1;

  waitUntil {
    sleep 0.5;
    unitReady vehicle _medic
    or !alive _woundedUnit or diag_tickTime > _timerTreat + 30
    or  (unitReady vehicle _medic && canmove vehicle _medic
    && !isnull objectParent _medic)
  };

  // The person dies
  if ((diag_tickTime > _timerTreat + 30) or !alive _woundedUnit) then {
    if (alive _woundedUnit && !isPlayer _woundedUnit) then {
      _woundedUnit setUnconscious false;
      _woundedUnit setDamage 1
    };

    _medic call MedicRelease;
    _woundedUnit setVariable ["treat",false];
    sleep 10;
    _woundedUnit setCaptive false;
  } else {

    doStop _medic;
    if (!isnull objectParent _medic) then {
      unassignVehicle _medic;
      doGetOut _medic;
    };
    _medic doMove getpos _woundedUnit;
    group _medic setSpeedMode "FULL";
    Sleep 1;

    waitUntil {
      sleep 0.5;
      unitReady _medic
      or !alive _woundedUnit or diag_tickTime > _timerTreat + 30
    };

    if (alive _woundedUnit && diag_tickTime < _timerTreat + 30) then {
      _azimuth = _medic getDir _woundedUnit;
      _medic setDir _azimuth;

      call {
        if (!isPlayer _woundedUnit) exitWith {
          call {
            if (unitPos _medic == "DOWN") exitWith {
              _medic playMove "ainvppnemstpslaywrfldnon_medicother";
            };
            _medic playMove "ainvpknlmstpslaywrfldnon_medicother";
          };
          Sleep 4;
          _woundedUnit setUnconscious false;
          _woundedUnit setDamage 0;
        };
        _medic action ["HealSoldier", _woundedUnit];
        sleep 4;
        [_woundedUnit,{
          _woundedUnit = _this;
          BIS_oldLifeState == "HEALTY";
          _woundedUnit setVariable ["#rev_state",0];
          _woundedUnit setVariable ["#rev_blood",1];
          _woundedUnit setVariable ["bis_revive_incapacitated",false];
          _woundedUnit setVariable ["#rev",0];
          _woundedUnit setVariable ["#revl",-1],
          {inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "NextAction"];
          _woundedUnit setUnconscious false;
          _woundedUnit setDamage 0;
        }] remoteExec ["call",_woundedUnit];
      };
      _woundedUnit setVariable ["treat",false];
      _medic call MedicRelease;
      if (!isnil {_medic getVariable "veh"}) then {
        _medic assignAsDriver (_medic getVariable "veh");
      };
      sleep 10;
      vehicle _medic enableCollisionWith _woundedUnit;
      _woundedUnit setCaptive false;
    };
  };
};

MedicRelease = {
  _medic = _this;
  _medic setVariable ["MGImedic",false];
  [_medic] joinSilent (_medic getVariable ["grp",grpNull]);
  _medic doFollow leader _medic;
  _medic setSpeedMode (speedMode group _medic);
  {_medic enableAI _x} count ["target","autotarget","autocombat","suppression"];
  _medic allowFleeing (1 - (_medic getVariable ["flee",0.5]));
};

CreateMedic = {
  _medic =  _this select 0;
  _woundedUnit = _this select 1;

  _medic setVariable ["MGImedic",true];
  _medic setVariable ["flee",_medic skill "courage"];
  _medic setVariable ["grp", group _medic];
  [_medic] joinSilent grpNull;
  {_medic disableAI _x} count ["target","autotarget","autocombat","suppression"];
  group _medic setBehaviour "AWARE";
  _medic allowFleeing 0;

  _offset = [[0,0],[15, _woundedUnit getRelDir _medic]] select (
    !isNull objectParent _medic
  );

  if (!isnull objectParent _medic) then {
    _medic setVariable ["veh",vehicle _medic];
    if (assignedDriver vehicle _medic != _medic) then {
      unassignVehicle _medic;
      doGetOut _medic;
    };
  };

  _medic doMove (_woundedUnit getpos _offset);
  sleep 1;

  if (isnull objectParent _medic) then {
    group _medic setSpeedMode "FULL"
  } else {
    group _medic setSpeedMode "LIMITED"
  };
};

GetNearbyMedic = {
    _woundedUnit =  _this;

    _units = allUnits select {
      _x distance _woundedUnit < 100
      && _woundedUnit getVariable "orgSide" == side _x
      && _x isKindOf "CAManBase"
      && alive _x
      && !isPlayer _x
      && lifeState _x != "incapacitated"
      && !(_x getVariable ["MGImedic",false])
    };

    sleep 3;
    if (count _units > 0) then {
      _units = _units apply {[_x distance _woundedUnit, _x]};
      _units sort true;
      _medic = _units select 0 select 1;
      _medic;
    } else {
      if (alive _woundedUnit && !isPlayer _woundedUnit) then {
        _woundedUnit setUnconscious false;
        _woundedUnit setDamage 1;
      };
      objNull;
    };
};

while {true} do {
    sleep 2;
    {
        if !(_x getVariable ["reviveEventAdded",false]) then {
            _x spawn ReviveScript;
            _x setVariable ["reviveEventAdded",true];
            _x setVariable ["orgSide",side _x];
        };
    } foreach allPlayers;
};
