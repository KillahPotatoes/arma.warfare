if (!isDedicated && hasInterface) then {
	waitUntil { alive player };  
  [] spawn compileFinal preprocessFileLineNumbers "sectors\drawSector.sqf";
  [] spawn compileFinal preprocessFileLineNumbers "scripts\factionKillCounter.sqf";
}
