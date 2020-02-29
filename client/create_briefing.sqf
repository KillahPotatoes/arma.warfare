ARWA_create_briefing = {
	player createDiaryRecord ["Diary", [
		"DISCORD",
		"Join the discussion at Discord<br /><br />https://discord.gg/bpPUU48"
		]
	];

	player createDiaryRecord ["Diary", [
			"TIPS & TRICKS",
			"TIP 1: You can store manpower in the transport your ordered and send it back to HQ. The manpower will be added to the faction manpower when the transport despawns<br /><br />
TIP 2: Keep the manpower in frontline sectors low. The only way AI factions can increase their manpower is by taking over a player held sector with manpower in it<br /><br />
TIP 3: If you carry manpower on you, you can store it in a sector. Maybe you didn't have time to go back to HQ and just want to move some manpower points to a safer sector<br /><br />
TIP 4: Sector defenders does not have night vision (Budget cuts, duh), so when trying to take over a sector or trying to do a manpower raid (next tip) night might favor you<br /><br />
TIP 5: For a quick manpower boost, target one of the enemy sector far behind enemy lines. These have often been held quite a while and often have a lot of manpower in them because AI factions does not collect manpower from sectors. But reinforcements might be quick to respond, so a quick in and out might be a better option than trying to hold the sector<br /><br />
TIP 6: If a player acquired vehicle is destroyed a manpower penalty is enforced. Bring your vehicle back to HQ and use the 'Return vehicle' action instead<br /><br />
TIP 7: A player respawn carries a big manpower penalty. Always have your battle buddy nearby so you can revive each other<br /><br />
TIP 8: If putting squad members in the ordered transport and sending it back to HQ the squad members will despawn without any penalty<br /><br />
TIP 9: Need to rearm or change your loadout? Order a transport. You are allowed to access the Arsenal once per transport<br /><br />
TIP 10: Try getting behind enemy lines and put some mines on important roads. Infantry spawns in the sectors, but vehicles always spawns in HQ<br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"END GAME",
		"Win Condition:<br />
You win when all enemy sides have 0 in manpower and you hold all the sectors. <br /><br />
If a side has no sectors after an hour has passed their manpower will drain quickly."
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
A sector with players in it will produce manpower faster based on that players rank<br /><br />
Vehicle penalties does not apply to AI vehicles (player factions or AI faction), so don't worry about your AI commander getting his gunships shot down.<br /><br />
If a player or vehicle that carries manpower is killed/destroyed there will be spawned a box that contains that manpower. The location and amount of manpower dropped will be visible on the map for everyone. The manpower will deteriorate after some time until it reaches zero and the box disappears.<br /><br />
If a player is killed the manpower penalty amount will spawn in a ammobox where he was killed in the same way as if manpower was dropped"
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
		Transports can be loaded with manpower and sent to HQ to have manpower added to faction strength. <br /><br />
		Squadmembers can be loaded in transport and sent to HQ in order to dispose of squadmembers without getting any penalty. <br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"INTEL & SECTOR RAIDS",
		"Getting to a sector ammobox before the enemy has lost the sector will give an option to access the enemy network.<br /><br />
		Depending on how much time there is left before the enemy loses the sector you will be able to see enemy movement on the map for a given time. <br /><br />
		You will also get additional manpower taken directly from the collected manpower of the faction holding the sector <br /><br />"
		]
	];

	player createDiaryRecord ["Diary", [
		"SECTORS",
		"Sectors can be captured when a faction is holding the center of a sector and no enemies are within the sector area.<br /><br />
Players can collect manpower from sectors and get infantry at the ammobox located in the center of the sector. <br /><br />
If a player manages to get to the ammobox before the enemy has lost the sector he can steal their intel which means that their movements will be visible on the map for 5 minutes.<br /><br />
Defense and artillery will spawn in a sector once it is captured."
		]
	];

	player createDiaryRecord ["Diary", [
		"RANK",
"Your rank will be calculated based on your kills and the kills of your squadmates if you are their leader. Loosing teammates when squadleader will affect your rank negatively.<br /><br />
Higher rank will allow you to have more soldiers in your squad, <br />increase the AI skill of your squad, <br />and increase the manpower generation boost while in a sector"
		]
	];
};
