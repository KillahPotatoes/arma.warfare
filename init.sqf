[] call compileFinal preprocessFileLineNumbers "presets\preset.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\global_variable_names.sqf";
[] spawn compileFinal preprocessFileLineNumbers "client\ui\factionKillCounter.sqf";

[] call compileFinal preprocessFileLineNumbers "client\playerActions\playerActions.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\spawnSquad.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "client\playerActions\redeploy.sqf";

