CalculateIncomeBasedOnSectors = {
      _side = _this select 0;

      _sectorCount = [_side] call SectorCount;

      _factionStrength = [_side] call GetFactionStrength;
      _initial_faction_strength = [_side] call GetInitialFactionStrength;
      _newFactionStrength = _factionStrength + _sectorCount  / 30;

      _strength_diff = _newFactionStrength - _initial_faction_strength; 
      
      [_side, _newFactionStrength] call SetFactionStrength;
      [_side, _sectorCount] call SetFactionSectorIncome;

      if(_strength_diff > tier_three) exitWith {
            systemChat format["%1 advanced to tier 3"];
      };
      
      if(_strength_diff > tier_two) exitWith {
            systemChat format["%1 advanced to tier 2"];           
      };
      
       if(_strength_diff > tier_one) exitWith {
            systemChat format["%1 advanced to tier 1"];
      };
};

CalculateIncome = {
      while {true} do {
            [west] call CalculateIncomeBasedOnSectors;
            [east] call CalculateIncomeBasedOnSectors;
            [independent] call CalculateIncomeBasedOnSectors;
            sleep 2;
      };
};

[] spawn CalculateIncome;
