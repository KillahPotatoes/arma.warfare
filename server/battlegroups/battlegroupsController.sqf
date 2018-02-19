[] call compileFinal preprocessFileLineNumbers "battlegroups\battlegroups.sqf";
[] call compileFinal preprocessFileLineNumbers "battlegroups\spawnBattlegroups.sqf";
[] spawn compileFinal preprocessFileLineNumbers "battlegroups\battlegroupAi.sqf";