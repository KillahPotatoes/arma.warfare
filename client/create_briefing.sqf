create_briefing = {
	player createDiaryRecord ["Diary", [
		"END GAME", 
		"Win Condition:<br />
You win when all enemy sides have 0 in manpower and no players alive.<br /><br />
Lose condition:<br />
You lose when your faction´s manpower is 0 and you die (no respawn possible)<br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"FACTION STATS", 
		"On the right side of the screen you will see:<br /><br />
T0 0% 500<br /><br />
repeated three times in blue, red, green representing the stats for each faction.<br /><br />
T0 = Tier 0 (higher tier gives the faction access to heavier vehicles)<br /><br />
0% = progress towards next tier (based on number of kills)<br /><br />
500 = manpower (deminished with losses. Losing player retrieved vehicles gives extra penalty)<br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"MANPOWER", 
		"Manpower is lost when you lose soldiers and manpower is generated at held sectors. Manpower can be collected at sectors and brough back to HQ to increase the factions manpower.<br /><br />
A sector will produce manpower only when held by a faction.<br /><br />
If a faction without players captures a sector from a faction with players that manpower will be removed from that sector and added to the capturing faction´s manpower.<br /><br />
If a faction with players captures a sector the manpower will remain in the sector and have to be brought back to HQ manually.<br /><br />
A sector with players in it will produce manpower faster<br /><br />"
		]
	];
	
	player createDiaryRecord ["Diary", [
		"HQ", 
		"Your startbase consists of an ammobox, ammo container, repair container and a medical container, spawn point for a heli and for a vehicle.<br /><br />
Players can get helicopters, vehicles and infantry at the ammobox. Which vehicles and helicopters depend on the Tier.<br /><br />
Manpower can be submitted to the faction manpower at the HQ ammobox<br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"TRANSPORT", 
		"Players can order vehicle or helicopter transport from anywhere on the map. <br /><br />
There is a small time penalty between each time a transport can be ordered. This will be longer if the transport is destroyed and cannot return to HQ.<br /><br />
TIP: You can put manpower and (wounded) squad members in the transport and send it back to HQ. The squad members will then be removed without penalty and the manpower added to the faction manpower.<br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"SECTORS", 
		"Sectors can be captured when a faction is holding the center of a sector and no enemies are within the sector area.<br /><br />
Players can collect manpower from sectors and get infantry at the ammobox located in the center of the sector. <br /><br />
Defense will spawn in a sector once it is captured."
		]
	];

	player createDiaryRecord ["Diary", [
		"RANK", 
"You will get a rank based on number of kills since last death, this rank will make your teammates have a higher skill and players with higher rank will increase manpower generation a bit more per level of rank if near sector center."
		]
	];	
};