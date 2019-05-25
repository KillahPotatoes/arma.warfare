ARWA_all_sides = [west, east, independent];
ARWA_max_tier = 2;

ARWA_ammo_box = "B_CargoNet_01_ammo_F";
ARWA_manpower_box = "Land_Ammobox_rounds_F";

ARWA_anti_vehicle_mines = ["SLAMDirectionalMine", "ATMine"];
ARWA_anti_personel_mines = ["APERSBoundingMine", "APERSMine", "APERSTripMine"];

ARWA_nvgoogles_guer = "NVGoggles_INDEP";
ARWA_nvgoogles_west = "NVGoggles";
ARWA_nvgoogles_east = "NVGoggles_OPFOR";

ARWA_west_uav_terminal_class_name = "B_UavTerminal";
ARWA_east_uav_terminal_class_name = "O_UavTerminal";
ARWA_guer_uav_terminal_class_name = "I_UavTerminal";

ARWA_west_uavs = [
	["B_UAV_02_F", 30],
	["B_UAV_02_CAS_F", 30],
	["B_UAV_05_F", 30]
];

ARWA_east_uavs = [
	["O_UAV_02_F", 30],
	["O_UAV_02_CAS_F", 30],
	["O_T_UAV_04_CAS_F", 30]
];

ARWA_guer_uavs = [
	["I_UAV_02_F", 30],
	["I_UAV_02_CAS_F", 30]
];

ARWA_west_sympathizers = [
	["B_G_Soldier_TL_F", 0],
	["B_G_Soldier_M_F", 0],
	["B_G_Soldier_AR_F", 0],
	["B_G_Soldier_A_F", 0],
	["B_G_Soldier_SL_F", 0],
	["B_G_Soldier_F", 0],
	["B_G_engineer_F", 0],
	["B_G_medic_F", 0],
	["B_G_Sharpshooter_F", 0]

];

ARWA_east_sympathizers = [
	["O_G_Soldier_TL_F", 0],
	["O_G_Soldier_M_F", 0],
	["O_G_Soldier_AR_F", 0],
	["O_G_Soldier_A_F", 0],
	["O_G_Soldier_SL_F", 0],
	["O_G_Soldier_F", 0],
	["O_G_engineer_F", 0],
	["O_G_medic_F", 0],
	["O_G_Sharpshooter_F", 0]
];

ARWA_guer_sympathizers = [
	["I_G_Soldier_TL_F", 0],
	["I_G_Soldier_M_F", 0],
	["I_G_Soldier_AR_F", 0],
	["I_G_Soldier_A_F", 0],
	["I_G_Soldier_SL_F", 0],
	["I_G_Soldier_F", 0],
	["I_G_engineer_F", 0],
	["I_G_medic_F", 0],
	["I_G_Sharpshooter_F", 0]
];

ARWA_west_infantry_tier_0 = [
	["B_soldier_F", 0],
	["B_soldier_AR_F", 0],
	["B_HeavyGunner_F", 0],
	["B_Soldier_GL_F", 0],
	["B_soldier_exp_F", 0],
	["B_medic_F", 0],
	["B_Sharpshooter_F", 0],
	["B_engineer_F", 0]
];

ARWA_west_infantry_tier_1 = [
	["B_Soldier_AT_F", 0]
];

ARWA_west_infantry_tier_2 = [
	["B_Soldier_AA_F", 0]
];

ARWA_east_infantry_tier_0 = [
	["O_soldier_F", 0],
	["O_soldier_AR_F", 0],
	["O_HeavyGunner_F", 0],
	["O_Soldier_GL_F", 0],
	["O_soldier_exp_F", 0],
	["O_medic_F", 0],
	["O_Sharpshooter_F", 0],
	["O_engineer_F", 0]
];

ARWA_east_infantry_tier_1 = [
	["O_Soldier_AT_F", 0]
];

ARWA_east_infantry_tier_2 = [
	["O_Soldier_AA_F", 0]
];

ARWA_guer_infantry_tier_0 = [
	["I_soldier_F", 0],
	["I_soldier_AR_F", 0],
	["I_HeavyGunner_F", 0],
	["I_Soldier_GL_F", 0],
	["I_soldier_exp_F", 0],
	["I_medic_F", 0],
	["I_Sharpshooter_F", 0],
	["I_engineer_F", 0]
];

ARWA_guer_infantry_tier_1 = [
	["I_Soldier_AT_F", 0]
];

ARWA_guer_infantry_tier_2 = [
	["I_Soldier_AA_F", 0]
];

// BASE Static

ARWA_west_mortar = [["B_Mortar_01_F", 0]];
ARWA_west_artillery = [["B_MBT_01_arty_F", 10]];
ARWA_west_rockets = [["B_MBT_01_mlrs_F", 20]];

ARWA_west_static_artillery_tier_0 = ARWA_west_mortar;
ARWA_west_static_artillery_tier_1 = ARWA_west_artillery;
ARWA_west_static_artillery_tier_2 = ARWA_west_rockets;

ARWA_guer_mortar = [["I_Mortar_01_F", 0]];
ARWA_guer_artillery = [];
ARWA_guer_rockets = [["I_Truck_02_MRL_F", 20]];

ARWA_guer_static_artillery_tier_0 = ARWA_guer_mortar;
ARWA_guer_static_artillery_tier_1 = ARWA_guer_artillery;
ARWA_guer_static_artillery_tier_2 = ARWA_guer_rockets;

ARWA_east_mortar = [["O_Mortar_01_F", 0]];
ARWA_east_artillery = [["O_MBT_02_arty_F", 10]];
ARWA_east_rockets = [];

ARWA_east_static_artillery_tier_0 = ARWA_east_mortar;
ARWA_east_static_artillery_tier_1 = ARWA_east_artillery;
ARWA_east_static_artillery_tier_2 = ARWA_east_rockets;

// WEST VEHICLES

ARWA_west_vehicle_transport = [
	["B_MRAP_01_F", 10],
	["B_LSV_01_unarmed_F", 10],
	["B_Truck_01_ammo_F", 10],
	["B_Truck_01_fuel_F", 10],
	["B_Truck_01_repair_F", 10],
	["B_Truck_01_medical_F", 10],
	["B_Truck_01_covered_F", 10]
];

ARWA_west_vehicle_tier_2 = [
	["B_APC_Tracked_01_AA_F", 30],
	["B_APC_Wheeled_01_cannon_F", 30],
	["B_MBT_01_TUSK_F", 30],
	["B_MBT_01_cannon_F", 30],
	["B_AFV_Wheeled_01_up_cannon_F", 30],
	["B_AFV_Wheeled_01_cannon_F", 30],
	["B_APC_Tracked_01_rcws_F", 20]
];

ARWA_west_vehicle_tier_1 = [
	["B_MRAP_01_gmg_F", 20],
	["B_MRAP_01_hmg_F", 20]
];

ARWA_west_vehicle_tier_0 = [
	["B_LSV_01_AT_F", 10],
	["B_LSV_01_armed_F", 10]
];

// GUER VEHICLES

ARWA_guer_vehicle_transport = [
	["I_MRAP_03_F", 10],
	["I_Truck_02_covered_F", 10],
	["I_Truck_02_ammo_F", 10],
	["I_Truck_02_fuel_F", 10],
	["I_Truck_02_box_F", 10],
	["I_Truck_02_medical_F", 10],
	["I_G_Offroad_01_F", 10]
];

ARWA_guer_vehicle_tier_2 = [
	["I_MBT_03_cannon_F", 30],
	["I_APC_tracked_03_cannon_F", 30],
	["I_APC_Wheeled_03_cannon_F", 30]
];

ARWA_guer_vehicle_tier_1 = [
	["I_MRAP_03_gmg_F", 20],
	["I_MRAP_03_hmg_F", 20],
	["I_LT_01_cannon_F", 20],
	["I_LT_01_AT_F", 20],
	["I_LT_01_AA_F", 20]
];

ARWA_guer_vehicle_tier_0 = [
	["I_G_Offroad_01_AT_F", 10],
	["I_G_Offroad_01_armed_F", 10]
];

// EAST VEHICLES

ARWA_east_vehicle_transport = [
	["O_MRAP_02_F", 10],
	["O_LSV_02_unarmed_F", 10],
	["O_Truck_03_ammo_F", 10],
	["O_Truck_03_fuel_F", 10],
	["O_Truck_03_repair_F", 10],
	["O_Truck_03_medical_F", 10],
	["O_Truck_03_covered_F", 10]
];

ARWA_east_vehicle_tier_2 = [
	["O_MBT_04_command_F", 40], // TODO
	["O_MBT_04_cannon_F", 30],
	["O_MBT_02_cannon_F", 30],
	["O_APC_Tracked_02_cannon_F", 30],
	["O_APC_Tracked_02_AA_F", 30],
	["O_APC_Wheeled_02_rcws_v2_F", 20]
];

ARWA_east_vehicle_tier_1 = [
	["O_MRAP_02_gmg_F", 20],
	["O_MRAP_02_hmg_F", 20]
];

ARWA_east_vehicle_tier_0 = [
	["O_LSV_02_armed_F", 10],
	["O_LSV_02_AT_F", 10]
];

// WEST HELICOPTERS

ARWA_west_helicopter_transport = [
	["B_Heli_Light_01_F", 10],
	["B_Heli_Transport_03_unarmed_F", 10],
	["B_Heli_Transport_01_F", 10]
];

ARWA_west_helicopter_tier_2 = [
	["B_Heli_Attack_01_F", 40]
];

ARWA_west_helicopter_tier_1 = [

];

ARWA_west_helicopter_tier_0 = [
	["B_Heli_Light_01_armed_F", 30]
];

// EAST HELICOPTERS

ARWA_east_helicopter_transport = [
	["O_Heli_Light_02_dynamicLoadout_F", 10],
	["O_Heli_Transport_04_bench_F", 10]
];

ARWA_east_helicopter_tier_2 = [
	["O_Heli_Attack_02_F", 40]
];

ARWA_east_helicopter_tier_1 = [
	["O_Heli_Attack_02_dynamicLoadout_F", 30]
];

ARWA_east_helicopter_tier_0 = [
	["O_Heli_Light_02_F", 20]
];

// GUER HELICOPTERS

ARWA_guer_helicopter_transport = [
	["I_Heli_Transport_02_F", 10],
	["I_Heli_light_03_unarmed_F", 10]
];

ARWA_guer_helicopter_tier_2 = [

];

ARWA_guer_helicopter_tier_1 = [
	["I_Heli_light_03_F", 20]
];

ARWA_guer_helicopter_tier_0 = [
	["I_Heli_light_03_dynamicLoadout_F", 20]
];
