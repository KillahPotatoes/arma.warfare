# arma.warfare

This is a sector control mission for Arma 3 with emphasize on easy setup for new missions, combined arms gameplay and automatic difficulty scaling.

There are 4 player slots on each side so you can play this PVP but PVE works great too. 

## Features

### Faction stats

On the right side of the screen you will see

#### T0 0% 500

repeated three times in blue, red, green representing the stats for each faction.

T0 = Tier 0

0% = progress towards next tier

500 = current strength of the faction

### manpower

Manpower is lost when you lose soldiers and manpower is generated at held sectors. Manpower can be collected at sectors and brough back to HQ to increase the factions manpower.

A sector will produce manpower once captured. If an enemy captures your sector you will lose whatever manpower was in that sector.

## Player vehicles

The player can get vehicles in HQ. These are free but will give a penalty if lost. If brough back to HQ the player can return the vehicle with no penalty.

### Start base (HQ)
Your startbase consists of an ammobox, ammo container, repair container and a medical container.

Your base will work as a spawnpoint for AI, but once sectors are captured infantry will preferably spawn there, while vehicles always will spawn in the start base.

Based on tier different vehicles and helicopters can also be bought in the start base. Infantry can be bought both in the startbase and in sectors.

You can also perform a halo insertion from the start base.
Spawn 2000 m over the ground at any point chosen by clicking on the map. Any teammates nearby will drop with you. 

### Heli taxi

If you are the leader of your group you can order a heli taxi. A heli will come land, and upon entering you will take control of the helicopter. 

When you are done with the heli taxi you can ask it to leave. 

There will be a time penalty between each time you can use the helicopter, and if its shot down there will be a longer penalty and also a manpower penalty.

### Rank

You will get a rank based on number of kills since last death, this rank will make your teammates have a higher skill:

0-5 kills: Private, skill 0.5 (default rank, default skill)
5.-10 kills: Sergant: skill : 0.6
10-15 kills: Lieutenant: skill: 0.7
15-20 kills: Captain: skill: 0.8;
20-25 kills: Major: skill: 0.9;
25+ kills: Colonel: 1

### AI

AI will consist of both sector defenders and attacking battlegroups. When a sector is captured a group will spawn and defend that sector. Battlegroups will spawn in the sectors and in the startbase. These will move towards uncaptured sectors and attack them.

AI will use heli insertions, and helo insertions besides just spawning squads and vehicle groups in HQ and sectors.

##### Ai squads

You can join AI squads by walking up to one team member and chose join squad.

##### Ai Gunship
AI gunship will spawn with random intervals. How often is determined by tier.

### Sectors

Sectors have a radius of 200 m. To capture it a friendly unit have to be within 25 m of the center, and no enemies within 200m.
If units belonging to several factions come within 25 m of the center the sector will become neutral (grey)

Every sector will have an ammobox where you can buy infantry and access the arsenal.

All sectors will have a random number of mines scattered around them, so be careful

#### Sector defense
Once a sector is taken, a group of soldiers and a artillery position will spawn. These will remain in the sector to defend it and give artillery support.


### Tier

Tier determines what kind of units AI spawn and what kind of vehicles you have available in the base.
Each side advance through tiers per X enemy kills. 

### Endgame

##### win Condition
You win when all enemy sides have 0 in strength, 0 in income and no players alive.

##### Lose condition
You lose when strength is 0 and you die (no respawn possible)

## Mission setup

##### Placing sectors
Place markers with the naming convention 'sector_\<name\>'.
An ammobox will spawn in its center så make sure its empty.

#### Starting base

Copy the starting base from the template mission, it should include:

##### 1 grasscutters:
###### \<prefix\>_vehicle
  
This is where bought vehicles for players will spawn  

##### 1 helipads
###### \<prefix\>_helicopter  

This is where bought helicopters for players will spawn  

##### 2 respawn points
###### \<prefix\>_respawn_ground
###### \<prefix\>_respawn_air

Place the '\<prefix\>_respawn_air' in the outskirts of the map on the same side of the base. Ai helicopters will spawn from here.
Place the '\<prefix\>_respawn_ground' on an open area. In the center the ammobox and players will spawn. Around it the ai will spawn. 

##### Prefix

Use delta, charlie and alpha. On mission start each faction will be assigned on of these prefixes by random.







