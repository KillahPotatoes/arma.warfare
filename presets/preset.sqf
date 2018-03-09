// Global variables

sector_size = 200; // sector size
starting_strength  = 50;
unit_cap = 30;
defender_cap = 5;
squad_cap = 12;
patrol_cap = 3;
initial_skill = 0.5;
vehicle_chance = 20;
cash_per_minute = 10;
squad_size = 8;
factions = [west, east, independent];
show_all = false;

guer_faction_name = "The resistance";
west_faction_name = "Nato";
east_faction_name = "China";

ammo_box = "B_CargoNet_01_ammo_F";
mine = "APERSBoundingMine";

tier_1_gunship_respawn_time = [600, 900, 1200];
tier_2_gunship_respawn_time = [540, 840, 1140];
tier_3_gunship_respawn_time = [480, 780, 1080];

// Presets
west_heavy_vehicles = ["rhsusf_m1a2sep1tuskiiwd_usarmy", "rhsusf_m1a1aim_tuski_wd", "rhsusf_m1a1aimwd_usarmy"];
guer_heavy_vehicles = ["rhsgref_cdf_t80b_tv", "rhsgref_cdf_t72bb_tv", "rhsgref_cdf_t72ba_tv"];
east_heavy_vehicles = ["rhs_t80bv", "rhs_t90a_tv", "rhs_t72bd_tv"];

west_medium_vehicles = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F"];
guer_medium_vehicles = ["rhsgref_cdf_reg_uaz_dshkm", "rhsgref_cdf_reg_uaz_ags", "rhssaf_m1025_olive_m2"];
east_medium_vehicles = ["rhs_tigr_sts_msv", "rhsgref_BRDM2_ATGM_msv", "rhsgref_BRDM2_HQ_msv"];

west_light_vehicles = ["B_LSV_01_unarmed_F", "B_MRAP_01_F"];
guer_light_vehicles = ["I_G_offroad_01_F"];
east_light_vehicles = ["O_LSV_02_unarmed_F"];

west_gunships = ["RHS_AH64D_wd", "RHS_AH64D_wd_CS", "RHS_AH64D_wd_AA"];
guer_gunships = ["rhsgref_cdf_Mi35", "rhsgref_cdf_Mi24D"];
east_gunships = ["O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Attack_02_dynamicLoadout_F"];

west_transport_helis = ["RHS_UH60M2"];
guer_transport_helis = ["I_Heli_light_03_unarmed_F"];
east_transport_helis = ["O_Heli_Light_02_unarmed_F"];

west_squad = [
	"B_soldier_F",
	"B_soldier_AR_F",
	"B_HeavyGunner_F",	
	"B_Soldier_GL_F", 
	"B_soldier_exp_F",
	"B_medic_F",	
	"B_Sharpshooter_F", 
	"B_engineer_F",
	"B_soldier_AA_F",
	"B_soldier_AT_F"
];

east_squad = [
	"O_soldier_F",
	"O_soldier_AR_F",
	"O_HeavyGunner_F",	
	"O_Soldier_GL_F", 
	"O_soldier_exp_F",
	"O_medic_F",	
	"O_Sharpshooter_F", 
	"O_engineer_F",
	"O_soldier_AA_F",
	"O_soldier_AT_F"
];

guer_squad = [
	"I_soldier_F",
	"I_soldier_AR_F",
	"I_HeavyGunner_F",	
	"I_Soldier_GL_F", 
	"I_soldier_exp_F",
	"I_medic_F",	
	"I_Sharpshooter_F", 
	"I_engineer_F",
	"I_soldier_AA_F",
	"I_soldier_AT_F"
];


east_infantry = [
	east_squad
];

west_infantry = [
	west_squad
];

guer_infantry = [
	guer_squad
];

west_mortars = ["B_Mortar_01_F"];
guer_mortars = ["I_Mortar_01_F"];
east_mortars = ["O_Mortar_01_F"];

west_buy_vehicle = [
	["Hunter", "B_MRAP_01_F", 100, 0], 
	["Prowler", "B_LSV_01_unarmed_F", 100, 0], 
	["Prowler", "B_LSV_01_armed_F", 150, 1], 
	["Hunter GMG", "B_MRAP_01_gmg_F", 200, 1], 
	["Hunter HMG", "B_MRAP_01_hmg_F", 300, 1], 
	["Tanks 1",	"rhsusf_m1a2sep1tuskiiwd_usarmy", 500, 2], 
	["Tanks 1",	"rhsusf_m1a1aim_tuski_wd", 750, 2], 
	["Tanks 1",	"rhsusf_m1a1aimwd_usarmy", 1000, 2]
];

guer_buy_vehicle = [
	["Strider", "I_MRAP_03_F", 100, 0], 
	["Strider GMG", "I_MRAP_03_gmg_F", 200, 1], 
	["Strider HMG", "I_MRAP_03_hmg_F", 300, 1], 
	["MBT-52 Kuma 1", "I_MBT_03_cannon_F", 1000, 2]
];

east_buy_vehicle = [
	["Ifrit", "O_MRAP_02_F", 100, 0], 
	["Qilin", "O_LSV_02_unarmed_F", 100, 0], 
	["Qilin Armed", "O_LSV_02_armed_F", 150, 1], 
	["Ifrit GMG", "O_MRAP_02_gmg_F", 200, 1], 
	["Ifrit HMG", "O_MRAP_02_hmg_F", 300, 1], 
	["T-100 Varsuk",	"O_MBT_02_cannon_F", 1000, 2] 
];

west_buy_helicopter = [
	["MH-9 Hummingbird", "B_Heli_Light_01_F", 200, 0], 
	["UH60M2",	"RHS_UH60M2", 300, 0], 
	["CH-67 Huron",	"B_Heli_Transport_03_unarmed_F", 400, 0], 
	["AH-9 Pawnee",	"B_Heli_Light_01_dynamicLoadout_F", 300, 1], 	
	["AH64D 1",	"RHS_AH64D_wd", 800, 3], 
	["AH64D CS", "RHS_AH64D_wd_CS", 1000, 3],
	["AH64D AA", "RHS_AH64D_wd_AA", 1200, 3]
];

east_buy_helicopter = [
	["Mi-290 Taru",	"O_Heli_Transport_04_bench_F", 400, 0], 
	["PO-30 Orca",	"O_Heli_Light_02_dynamicLoadout_F", 300, 1], 	
	["Mi-48 Kajman", "O_Heli_Attack_02_dynamicLoadout_F", 1200, 3]
];

guer_buy_helicopter = [
	["CH-49 Mohawk", "I_Heli_Transport_02_F", 400, 0], 
	["WY-55 Hellcat", "I_Heli_Light_03_dynamicLoadout_F", 300, 1], 	
	["Mi35",	"rhsgref_cdf_Mi35", 800, 3], 
	["Mi24D", "rhsgref_cdf_Mi24D", 1000, 3]
];


west_buy_infantry = [
	["Rifleman", "B_soldier_F", 20, 0],
	["Autorifle man", "B_soldier_AR_F", 30, 0],
	["Heavy Gunner", "B_HeavyGunner_F", 40, 0],	
	["Grenadier",	"B_Soldier_GL_F", 50, 0], 
	["Demolition", "B_soldier_exp_F", 50, 0],
	["Medic", "B_medic_F", 60, 0],	
	["Sharpshooter", "B_Sharpshooter_F", 60, 0], 
	["Engineer", "B_engineer_F", 80, 0],
	["AA soldier", "B_soldier_AA_F", 100, 0],
	["AT soldier", "B_soldier_AT_F", 100, 0]
];

east_buy_infantry = [
	["Rifleman", "O_soldier_F", 20, 0],
	["Autorifle man", "O_soldier_AR_F", 30, 0],
	["Heavy Gunner", "O_HeavyGunner_F", 40, 0],	
	["Grenadier",	"O_Soldier_GL_F", 50, 0], 
	["Demolition", "O_soldier_exp_F", 50, 0],
	["Medic", "O_medic_F", 60, 0],	
	["Sharpshooter", "O_Sharpshooter_F", 60, 0], 
	["Engineer", "O_engineer_F", 80, 0],
	["AA soldier", "O_soldier_AA_F", 100, 0],
	["AT soldier", "O_soldier_AT_F", 100, 0]
];

guer_buy_infantry = [
	["Rifleman", "I_soldier_F", 20, 0],
	["Autorifle man", "I_soldier_AR_F", 30, 0],
	["Heavy Gunner", "I_HeavyGunner_F", 40, 0],	
	["Grenadier",	"I_Soldier_GL_F", 50, 0], 
	["Demolition", "I_soldier_exp_F", 50, 0],
	["Medic", "I_medic_F", 60, 0],	
	["Sharpshooter", "I_Sharpshooter_F", 60, 0], 
	["Engineer", "I_engineer_F", 80, 0],
	["AA soldier", "I_soldier_AA_F", 100, 0],
	["AT soldier", "I_soldier_AT_F", 100, 0]
];