// Presets

west_infantry_tier_0 = [
	["B_soldier_F", 0],
	["B_soldier_AR_F", 0],
	["B_HeavyGunner_F", 0],
	["B_Soldier_GL_F", 0],
	["B_soldier_exp_F", 0],
	["B_medic_F", 0],
	["B_Sharpshooter_F", 0],
	["B_engineer_F", 0],
	["B_Soldier_AT_F", 0],
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
	["O_engineer_F", 0],
	["O_Soldier_AT_F", 0],
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
	["I_engineer_F", 0],
	["I_Soldier_AT_F", 0],
	["I_Soldier_AA_F", 0]
];

// ARTILLERY

west_static = ["B_Mortar_01_F"];
guer_static = ["I_Mortar_01_F"];
east_static = ["O_Mortar_01_F"];

// WEST VEHICLES

west_vehicle_transport = [
	["B_MRAP_01_F", 10], // Hunter
	["B_LSV_01_unarmed_F", 10] // Prowler
];

west_vehicle_tier_2 = [
	["B_APC_Tracked_01_AA_F", 30], // IFV-6a Cheetah
	["B_APC_Wheeled_01_cannon_F", 30], // AMV-7 Marshall
	["B_MBT_01_TUSK_F", 30], // M2A4 Slammer UP 
	["B_APC_Wheeled_03_cannon_F", 30], // AFV-4 Gorgon
	["B_MBT_01_cannon_F", 30] // M2A1 Slammer
	//["B_MBT_01_arty_F", 30], // M4 Scorcher 
	//["B_MBT_01_mlrs_F", 30] // M5 Sandstorm MLRS
];

west_vehicle_tier_1 = [
	["B_LSV_01_armed_F", 20], // Prowler
	["B_MRAP_01_gmg_F", 20], // Hunter GMG
	["B_MRAP_01_hmg_F", 20] // Hunter HMG
];

west_vehicle_tier_0 = [
	["B_MRAP_01_F", 10], // Hunter
	["B_LSV_01_unarmed_F", 10] // Prowler
];

// GUER VEHICLES

guer_vehicle_transport = [
	["I_MRAP_03_F", 10] // Strider
];

guer_vehicle_tier_2 = [
	["I_MBT_03_cannon_F", 30], // MBT-52 Kuma 1
	["I_APC_tracked_03_cannon_F", 30], // FV-720 Mora
	["I_APC_Wheeled_03_cannon_F", 30] // AFV-4 Gorgon
];

guer_vehicle_tier_1 = [
	["I_MRAP_03_gmg_F", 20], // Strider GMG
	["I_MRAP_03_hmg_F", 20] // Strider HMG
];

guer_vehicle_tier_0 = [
	["I_MRAP_03_F", 10] // Strider
];

// EAST VEHICLES

east_vehicle_transport = [
	["O_MRAP_02_F", 10], // Ifrit
	["O_LSV_02_unarmed_F", 10] // Qilin
];

east_vehicle_tier_2 = [
	["O_MBT_02_command_F", 40], // T-100 Varsuk
	["O_MBT_04_cannon_F", 30], // T-100 Varsuk
	["O_MBT_02_cannon_F", 30], // T-100 Varsuk
	["O_APC_Tracked_02_cannon_F", 30], // BTR-K Kamysh
	["O_APC_Tracked_02_AA_F", 30] // ZSU-39 Tigris
	//["O_MBT_02_arty_F", 30] // 2S9 Sochor
];

east_vehicle_tier_1 = [
	["O_LSV_02_armed_F", 20], // Qilin Armed
	["O_MRAP_02_gmg_F", 20], // Ifrit GMG
	["O_MRAP_02_hmg_F", 20] // Ifrit HMG
];

east_vehicle_tier_0 = [
	["O_MRAP_02_F", 10], // Ifrit
	["O_LSV_02_unarmed_F", 10] // Qilin
];

// WEST HELICOPTERS

west_helicopter_transport = [
	["B_Heli_Light_01_F", 10], // MH-9 Hummingbird
	["B_Heli_Transport_03_unarmed_F", 10], // CH-67 Huron
	["B_Heli_Transport_01_F", 10] // UH-80 Ghost Hawk
];

west_helicopter_tier_2 = [
	["B_Heli_Attack_01_F", 40] // AH-99 Blackfoot	
];

west_helicopter_tier_1 = [
	
];

west_helicopter_tier_0 = [
	["B_Heli_Light_01_armed_F", 30] // AH-9 Pawnee with rockets
];

// EAST HELICOPTERS

east_helicopter_transport = [
	["O_Heli_Light_02_dynamicLoadout_F", 10], // PO-30 Orca
	["O_Heli_Transport_04_bench_F", 10] // Mi-290 Taru (Bench)
];

east_helicopter_tier_2 = [
	["O_Heli_Attack_02_F", 40] // Mi-48 Kajman with rockets
];

east_helicopter_tier_1 = [
	["O_Heli_Attack_02_dynamicLoadout_F", 30] // Mi-48 Kajman with gatling
];

east_helicopter_tier_0 = [
	["O_Heli_Light_02_F", 20] // PO-30 Orca
];

// GUER HELICOPTERS

guer_helicopter_transport = [
	["I_Heli_Transport_02_F", 10], // CH-49 Mohawk
	["I_Heli_light_03_unarmed_F", 10] // WY-55 Hellcat (Unarmed)
];

guer_helicopter_tier_2 = [
	
];

guer_helicopter_tier_1 = [
	["I_Heli_light_03_F", 20] // WY-55 Hellcat with rockets
];

guer_helicopter_tier_0 = [
	["I_Heli_light_03_dynamicLoadout_F", 20] // WY-55 Hellcat with gatling
];


