[] spawn compileFinal preprocessFileLineNumbers "scripts\common\common.sqf";
[] spawn compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] spawn compileFinal preprocessFileLineNumbers "sectors\sectors.sqf";
[] spawn compileFinal preprocessFileLineNumbers "battlegroups\spawnBattlegroups.sqf";

//[] spawn compileFinal preprocessFileLineNumbers "showCuratorPoints.sqf";
[] spawn compileFinal preprocessFileLineNumbers "RYD_FFE\FFE.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\helicopterSpawn.sqf";
[] spawn compileFinal preprocessFileLineNumbers "scripts\AIReviveScript.sqf";

missionNamespace setVariable ["IndependentManPower", 100, true];
missionNamespace setVariable ["EastManPower", 100, true];
missionNamespace setVariable ["WestManPower", 100, true];

missionNamespace setVariable ["EastActiveManPower", 0, true];
missionNamespace setVariable ["WestActiveManPower", 0, true];
missionNamespace setVariable ["IndependentActiveManPower", 0, true];

missionNamespace setVariable ["IndependentManPowerIncome", 0, true];
missionNamespace setVariable ["EastManPowerIncome", 0, true];
missionNamespace setVariable ["WestManPowerIncome", 0, true];

//[] spawn compileFinal preprocessFileLineNumbers "scripts\killTicker.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "scripts\addKillTickerEventToAllUnits.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "scripts\generateSectorIncome.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "Mines\alias_mines.sqf";
//[] spawn compileFinal preprocessFileLineNumbers "artillerySpawn.sqf";