# arma.warfare

This is a sector control mission for Arma 3 with emphasize on easy setup for new missions, combined arms gameplay and automatic difficulty scaling.

## Features

### Start base (HQ)
Your startbase consists of an ammobox, with the actions 'Request squad', 'Arsenal' and 'Helo Insertion'.

Your base will also work as a spawnpoint for AI:

Tier 0: Infantry will spawn regulary

Tier 1: Infantry and light vehicles will spawn regulary

Tier 2: Infantry, light vehicles and heavy vehicles will spawn regulary


Empy vehicles for player use will also spawn:

Tier 0 or higher: A transport helicopter will spawn in base

Tier 1 or higher: A light vehichle will spawn in base

Tier 2 or higher: A heavy vehichle will spawn in base

Tier 3 or higher: A gunship will spawn in base


There will always only exist one of each vehicle type available for the player per side. If any of these are destroyed they will
respawn in the base after a certain time

### AI

The AI that spawns in sectors will remain in sectors and protect them.

The Ai that spawns in the starting base will move towards uncaptured sectors to capture them. They will also report enemy activity 
to the mortar positions in captured sectors.

##### Ai Gunship
AI gunship will spawn with random intervals. How often is determined by tier.

##### Ai skills
Ai skills will increase when strength deminishes 

### Sectors

Sectors have a radius of 200 m. To capture it a friendly unit have to be within 25 m of the center, and no enemies within 200m of the radius.
If units belonging to several factions come within 25 m of the center the sector will become neutral (grey)

A captured sector give +1 every 30 second to faction strength.

Every sector will have an ammobox. If the sector belongs to your side you will have 'Request squad', 'Arsenal', 'Helo insertion' and 'Redeploy to HQ' actions available.

All sectors will have a random number of mines scattered around them, so be careful

#### Sector defense
Once a sector is taken, 5 soldiers will spawn and one mortar position. These will remain in the sector to defend it.

### Actions

#### Request squad
Gives you a random squad of 8. If you already have squad mates, it will reinforce your squad so you are a squad of 8 again. 

#### Redeploy to HQ
Send you back to your HQ. Your squad won't be teleported

#### Helo insertion
Spawn 2000 m over the ground at any point chosen by clicking on the map. Any teammates nearby will drop with you. 

### Strength

Strength is increased by holding sectors by 2 points per minute per sector.
Strength is deminished by one point per soldier killed.

If a player is killed the strength is deminished by one fifth. (Better stay alive) 

Strength determines manpower. Your number  of active AI soldiers capturing new sectors are the lesser of 30 or your faction strength. 

### Tier

Tier determines what kind of units AI spawn and what kind of vehicles you have available in the base.
Each side advance through tiers per X enemy kills. 

#### Tier 0
Ai only spawn infantry. 
Transport helicopter available in base.
Ai Gunship spawns rarely.

#### Tier 1
Ai spawn Infantry and light vehicles.
Transport helicopter and light vehicle available in base.
Ai Gunship spawns a bit more frequently than in tier 0;

#### Tier 2
Ai spawn Infantry, light vehicles and heavy vehicles.
Transport helicopter, light vehicle and heavy vehicle available in base.
Ai Gunship spawns a bit more frequently than in tier 1;

#### Tier 3
Ai spawn Infantry, light vehicles and heavy vehicles.
Transport helicopter, light vehicle, heavy vehicle and gunship available in base.
Ai Gunship spawns a bit more frequently than in tier 2;

### Endgame

##### win Condition
You win when all enemy sides have 0 in strength, 0 in income and no players alive.

##### Lose condition
You lose when strength is 0 and you die (no respawn possible)

## Planned features

###### Different infantry for different tiers
###### Redeploy to captured sectors 





