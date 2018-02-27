# arma.warfare

This is a sector control mission for Arma 3 with emphasize on easy setup for new missions, combined arms gameplay and automatic difficulty scaling.

There are 4 player slots on each side so you can play this PVP but PVE works great too. 

## Features

### Faction stats

On the right side of the screen you will see

#### T0 0% (+0) 50

repeated three times in blue, red, green representing the stats for each faction.

T0 = Tier 0

0% = progress towards next tier

(+0) = sectors held. Each sector gives 2 points per minute

50 = current strength of the faction. If strength is >30 the AI unit cap will be 30, but if <30 the unit cap will be equal strength

### Cash

Cash is generated at held sectors. You can grab the cash from the ammobox at each sector and use it to buy infantry, helis and vehicles.
What is available for you to buy depends on the tier you are in.

Infantry can be bought at each sector while vehicles and helicopters can only be bought at the startingbase. 
You can also store money at your base. This is the only place where they will be safe. If you die you lose all cash you have on you, 
and if a sector is captured all money that are there will be lost.

You can grab money from sectors that are not yours, so money raids on enemy sectors that have been held for a long time is a good strategy.

### Start base (HQ)
Your startbase consists of an ammobox, ammo container, repair container and a medical container.

Your base will work as a spawnpoint for AI, but once sectors are captured infantry will preferably spawn there, while vehicles always will spawn in the start base.

Based on tier different vehicles and helicopters can also be bought in the start base. Infantry can be bought both in the startbase and in sectors.

You can also perform a halo insertion from the start base.
Spawn 2000 m over the ground at any point chosen by clicking on the map. Any teammates nearby will drop with you. 


### AI

AI will consist of both sector defenders and attacking battlegroups. When a sector is captured a group will spawn and defend that sector. Battlegroups will spawn in the sectors and in the startbase. These will move towards uncaptured sectors and attack them.

##### Ai Gunship
AI gunship will spawn with random intervals. How often is determined by tier.

##### Ai skills
Ai skills will increase when strength deminishes 

### Sectors

Sectors have a radius of 200 m. To capture it a friendly unit have to be within 25 m of the center, and no enemies within 200m.
If units belonging to several factions come within 25 m of the center the sector will become neutral (grey)

A captured sector will increase strength over time.

Every sector will have an ammobox where you can buy infantry and access the arsenal.

All sectors will have a random number of mines scattered around them, so be careful

#### Sector defense
Once a sector is taken, a group of soldiers and a mortar position will spawn. These will remain in the sector to defend it and give artillery support.

### Strength

Strength is increased based on sectors held, and dimished when losing soldiers.
If a player is killed there is a big penalty on strength, so better stay alive. 

Strength determines manpower. Your number  of active AI soldiers capturing new sectors are the lesser of 30 or your faction strength. 

### Tier

Tier determines what kind of units AI spawn and what kind of vehicles you have available in the base.
Each side advance through tiers per X enemy kills. 

#### Tier 0
Ai only spawn infantry. 
Ai Gunship spawns rarely.

Transport vehicles and helicopters can be bought.

#### Tier 1
Ai spawn Infantry and light vehicles.
Ai Gunship spawns a bit more frequently than in tier 0;

Armed vehicles and helicopters can be bought.

#### Tier 2
Ai spawn Infantry, light vehicles and heavy vehicles.
Ai Gunship spawns a bit more frequently than in tier 1;

Armed heavy vehicles can be bought.

#### Tier 3
Ai spawn Infantry, light vehicles and heavy vehicles.
Ai Gunship spawns a bit more frequently than in tier 2;

Gunships can be bought.

### Endgame

##### win Condition
You win when all enemy sides have 0 in strength, 0 in income and no players alive.

##### Lose condition
You lose when strength is 0 and you die (no respawn possible)

## Mission setup

The missions is best played on a 3x3 km area with about 5-7 sectors.

##### Placing sectors
Place markers with the naming convention 'sector_\<name\>'.
An ammobox will spawn in its center så make sure its empty.

#### Starting base

Copy the starting base from the template mission, it should include:

##### 1 grasscutters:
###### \<prefix\>_vehicle_parking  
  
This is where bought vehicles for players will spawn  

##### 1 helipads
###### \<prefix\>_heli  

This is where bought helicopters for players will spawn  

##### 2 respawn points
###### \<prefix\>_ground_respawn
###### \<prefix\>_air_respawn

Place the '\<prefix\>_air_respawn' in the outskirts of the map on the same side of the base. Ai helicopters will spawn from here.
Place the '\<prefix\>_ground_respawn' on an open area. In the center the ammobox and players will spawn. Around it the ai will spawn. 

##### Prefix

Use delta, charlie and alpha. On mission start each faction will be assigned on of these prefixes by random.

## Planned features

##### Different infantry for different tiers
##### Redeploy to captured sectors 





