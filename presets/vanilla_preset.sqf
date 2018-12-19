ammo_box = "B_CargoNet_01_ammo_F";

anti_vehicle_mines = ["SLAMDirectionalMine", "ATMine"];		
anti_personel_mines = ["APERSBoundingMine", "APERSMine", "APERSTripMine"];

nvgoogles_guer = "NVGoggles_INDEP";
nvgoogles_west = "NVGoggles";
nvgoogles_east = "NVGoggles_OPFOR";

west_infantry_tier_0 = [
	["B_soldier_F", 0],
	["B_soldier_AR_F", 0],
	["B_HeavyGunner_F", 0],
	["B_Soldier_GL_F", 0],
	["B_soldier_exp_F", 0],
	["B_medic_F", 0],
	["B_Sharpshooter_F", 0],
	["B_engineer_F", 0]
];

west_infantry_tier_1 = [
	["B_Soldier_AT_F", 0]
];

west_infantry_tier_2 = [
	["B_Soldier_AA_F", 0]
];

east_infantry_tier_0 = [
	["O_soldier_F", 0],
	["O_soldier_AR_F", 0],
	["O_HeavyGunner_F", 0],
	["O_Soldier_GL_F", 0],
	["O_soldier_exp_F", 0],
	["O_medic_F", 0],
	["O_Sharpshooter_F", 0],
	["O_engineer_F", 0]
];

east_infantry_tier_1 = [
	["O_Soldier_AT_F", 0]
];

east_infantry_tier_2 = [
	["O_Soldier_AA_F", 0]
];

guer_infantry_tier_0 = [
	["I_soldier_F", 0],
	["I_soldier_AR_F", 0],
	["I_HeavyGunner_F", 0],
	["I_Soldier_GL_F", 0],
	["I_soldier_exp_F", 0],
	["I_medic_F", 0],
	["I_Sharpshooter_F", 0],
	["I_engineer_F", 0]
];

guer_infantry_tier_1 = [	
	["I_Soldier_AT_F", 0]
];

guer_infantry_tier_2 = [
	["I_Soldier_AA_F", 0]
];

// BASE Static

west_static_artillery = ["B_Mortar_01_F"];
guer_static_artillery = ["I_Mortar_01_F"];
east_static_artillery = ["O_Mortar_01_F"];

// WEST VEHICLES

west_vehicle_transport = [
	["B_MRAP_01_F", 10], 
	["B_LSV_01_unarmed_F", 10], 
	["B_Truck_01_covered_F", 10]
];

west_vehicle_tier_2 = [
	["B_APC_Tracked_01_AA_F", 30],
	["B_APC_Wheeled_01_cannon_F", 30],
	["B_MBT_01_TUSK_F", 30], 
	["B_MBT_01_cannon_F", 30], 
	["B_AFV_Wheeled_01_up_cannon_F", 30], 
	["B_AFV_Wheeled_01_cannon_F", 30] 
];

west_vehicle_tier_1 = [
	["B_MRAP_01_gmg_F", 20], 
	["B_MRAP_01_hmg_F", 20], 
	["B_APC_Tracked_01_rcws_F", 20] 
];

west_vehicle_tier_0 = [
	["B_LSV_01_AT_F", 10], 
	["B_LSV_01_armed_F", 10] 
];

// GUER VEHICLES

guer_vehicle_transport = [
	["I_MRAP_03_F", 10], 
	["I_Truck_02_covered_F", 10], 
	["I_G_Offroad_01_F", 10] 
];

guer_vehicle_tier_2 = [
	["I_MBT_03_cannon_F", 30], 
	["I_APC_tracked_03_cannon_F", 30], 
	["I_APC_Wheeled_03_cannon_F", 30] 
];

guer_vehicle_tier_1 = [
	["I_MRAP_03_gmg_F", 20], 
	["I_MRAP_03_hmg_F", 20], 
	["I_LT_01_cannon_F", 20], 
	["I_LT_01_AT_F", 20], 
	["I_LT_01_AA_F", 20] 
];

guer_vehicle_tier_0 = [
	["I_G_Offroad_01_AT_F", 10], 
	["I_G_Offroad_01_armed_F", 10] 
];

// EAST VEHICLES

east_vehicle_transport = [
	["O_MRAP_02_F", 10], 
	["O_LSV_02_unarmed_F", 10], 
	["O_Truck_03_covered_F", 10] 
];

east_vehicle_tier_2 = [
	["O_MBT_04_command_F", 40], // TODO
	["O_MBT_04_cannon_F", 30], 
	["O_MBT_02_cannon_F", 30], 
	["O_APC_Tracked_02_cannon_F", 30], 
	["O_APC_Tracked_02_AA_F", 30] 
];

east_vehicle_tier_1 = [
	["O_APC_Wheeled_02_rcws_v2_F", 20], 
	["O_MRAP_02_gmg_F", 20], 
	["O_MRAP_02_hmg_F", 20] 
];

east_vehicle_tier_0 = [
	["O_LSV_02_armed_F", 10], 
	["O_LSV_02_AT_F", 10] 
];

// WEST HELICOPTERS

west_helicopter_transport = [
	["B_Heli_Light_01_F", 10], 
	["B_Heli_Transport_03_unarmed_F", 10], 
	["B_Heli_Transport_01_F", 10] 
];

west_helicopter_tier_2 = [
	["B_Heli_Attack_01_F", 40] 
];

west_helicopter_tier_1 = [
	
];

west_helicopter_tier_0 = [
	["B_Heli_Light_01_armed_F", 30] 
];

// EAST HELICOPTERS

east_helicopter_transport = [
	["O_Heli_Light_02_dynamicLoadout_F", 10], 
	["O_Heli_Transport_04_bench_F", 10] 
];

east_helicopter_tier_2 = [
	["O_Heli_Attack_02_F", 40] 
];

east_helicopter_tier_1 = [
	["O_Heli_Attack_02_dynamicLoadout_F", 30] 
];

east_helicopter_tier_0 = [
	["O_Heli_Light_02_F", 20] 
];

// GUER HELICOPTERS

guer_helicopter_transport = [
	["I_Heli_Transport_02_F", 10], 
	["I_Heli_light_03_unarmed_F", 10] 
];

guer_helicopter_tier_2 = [
	
];

guer_helicopter_tier_1 = [
	["I_Heli_light_03_F", 20] 
];

guer_helicopter_tier_0 = [
	["I_Heli_light_03_dynamicLoadout_F", 20] 
];


