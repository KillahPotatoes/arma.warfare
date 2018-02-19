CalculateIncomeBasedOnSectors = {
      _side = _this select 0;

      _sectorCount = [_side] call SectorCount;

      _factionStrength = [_side] call GetFactionStrength;
      _newFactionStrength = _factionStrength + _sectorCount  / 30;

      [_side, _newFactionStrength] call SetFactionStrength;
      [_side, _sectorCount] call SetFactionSectorIncome;
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
