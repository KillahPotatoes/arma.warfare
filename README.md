This mission is currently running on one of the KP public servers
Name: KP Public arma.warfare Server
IP/Port: 195.201.56.254:2332
Needed Mods: CBA A3, KP Ranks

https://discord.gg/bpPUU48

This is a sector control mission with emphasize on easy setup for new missions and combined arms gameplay. 

This mission tries to create a chaotic battlefield where you as a soldier can take on different roles and try to tip the margins in your favor.

There are 4 player slots on each side so you can play this PVP but PVE works great too. 

### FACTION STATS

On the right side of the screen you will see

T0 0% 500

repeated three times in blue, red, green representing the stats for each faction.

T0 = Tier 0 (higher tier gives the faction access to heavier vehicles)

0% = progress towards next tier (based on number of kills)

500 = manpower (deminished with losses. Losing player retrieved vehicles gives extra penalty)

### MANPOWER

Manpower is lost when you lose soldiers and manpower is generated at held sectors. Manpower can be collected at sectors and brough back to HQ to increase the factions manpower.

A sector will produce manpower only when held by a faction.

If a faction without players captures a sector from a faction with players that manpower will be removed from that sector and added to the capturing faction´s manpower.

If a faction with players captures a sector the manpower will remain in the sector and have to be brought back to HQ manually.

### HQ

Your startbase consists of an ammobox, ammo container, repair container and a medical container, spawn point for a heli and for a vehicle.

Players can get helicopters, vehicles and infantry at the ammobox. Which vehicles and helicopters depend on the Tier.

Manpower can be submitted to the faction manpower at the HQ ammobox

### TRANSPORT

Players can order vehicle or helicopter transport from anywhere on the map. 
There is a small time penalty between each time a transport can be ordered. This will be longer if the transport is destroyed and cannot return to HQ.

TIP: You can put manpower and (wounded) squad members in the transport and send it back to HQ. The squad members will then be removed without penalty and the manpower added to the faction manpower.

### RANK

You will get a rank based on number of kills since last death, this rank will make your teammates have a higher skill:

SECTORS

Sectors can be captured when a faction is holding the center of a sector and no enemies are within the sector area.

Players can collect manpower from sectors and get infantry at the ammobox located in the center of the sector. 

Defense will spawn in a sector once it is captured.

### END GAME

Win Condition

You win when all enemy sides have 0 in manpower and  no players alive.

Lose condition

You lose when your faction´s manpower is 0 and you die (no respawn possible)

### MISSION SETUP

Placing sectors:
Place markers with the naming convention 'sector_\<name\>'.
An ammobox will spawn in its center så make sure its empty.

#### Starting base:

Copy the starting base from the template mission, it should include:

1 grasscutter:
\<prefix>_vehicle
  
This is where bought vehicles for players will spawn  

1 helipad
<prefix>_helicopter  

This is where bought helicopters for players will spawn  

2 respawn points
<prefix>_respawn_ground
<prefix>_respawn_air

Place the '<prefix>_respawn_air' in the outskirts of the map on the same side of the base. Ai helicopters will spawn from here.
Place the '<prefix>_respawn_ground' on an open area. In the center the ammobox and players will spawn. Around it the ai will spawn. 

### PREFIXES

Use delta, charlie and alpha. On mission start each faction will be assigned on of these prefixes by random.

### GITHUB: 

Code and sample mission available here:

https://github.com/KillahPotatoes/arma.warfare







