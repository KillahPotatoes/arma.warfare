while {true} do {
    sleep 2;
    {
        if !(_x getVariable ["killTickerEventAdded",false]) then {
            _x spawn killTicker;
            _x setVariable ["killTickerEventAdded",true]
        };
    } foreach allUnits;
};
