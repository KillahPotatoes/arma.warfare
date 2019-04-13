ammo_box = "B_CargoNet_01_ammo_F";
manpower_box = "Land_Ammobox_rounds_F";

anti_vehicle_mines = ["SLAMDirectionalMine", "ATMine"];		
anti_personel_mines = ["APERSBoundingMine", "APERSMine", "APERSTripMine"];

nvgoogles_guer = "NVGoggles_INDEP";
nvgoogles_west = "NVGoggles";
nvgoogles_east = "NVGoggles_OPFOR";

west_sympathizers = [
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

east_sympathizers = [
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

guer_sympathizers = [
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
	["rhs_vdv_mflora_rifleman", 0],
	["rhs_vdv_mflora_sergeant", 0],
	["rhs_vdv_mflora_machinegunner", 0],
	["rhs_vdv_mflora_grenadier", 0],
	["rhs_vdv_mflora_efreitor", 0],	
	["rhs_vdv_mflora_grenadier_rpg", 0],
	["rhs_vdv_mflora_strelok_rpg_assist", 0],
	["rhs_vdv_mflora_junior_sergeant", 0],
	["rhs_vdv_mflora_machinegunner_assistant", 0],
	["rhs_vdv_mflora_marksman", 0],
	["rhs_vdv_mflora_medic", 0],
	["rhs_vdv_mflora_LAT", 0],
	["rhs_vdv_mflora_RShG2", 0],
	["rhs_vdv_mflora_engineer", 0],
	["rhs_vdv_mflora_at", 0],
	["rhs_vdv_mflora_aa", 0]
];

guer_infantry_tier_0 = [
	["rhsgref_nat_pmil_grenadier_rpg", 0],
	["rhsgref_nat_pmil_grenadier", 0],
	["rhsgref_nat_pmil_commander", 0],
	["rhsgref_nat_pmil_hunter", 0],
	["rhsgref_nat_pmil_machinegunner", 0],
	["rhsgref_nat_pmil_medic", 0],
	["rhsgref_nat_pmil_saboteur", 0],
	["rhsgref_nat_pmil_scout", 0],
	["rhsgref_nat_pmil_rifleman_akm", 0],
	["rhsgref_nat_pmil_rifleman", 0],
	["rhsgref_nat_pmil_rifleman_aksu", 0],
	["rhsgref_nat_pmil_specialist_aa", 0]
];

// ARTILLERY

west_static_artillery = ["RHS_M119_WD", "B_Mortar_01_F"];
guer_static_artillery = ["I_Mortar_01_F", "rhsgref_nat_d30"];
east_static_artillery = ["O_Mortar_01_F", "rhs_D30_msv"];

// WEST VEHICLES

west_vehicle_transport = [
	["B_MRAP_01_F", 10], // Hunter
	["B_LSV_01_unarmed_F", 10] // Prowler
];

west_vehicle_tier_2 = [
	["rhsusf_m1a1aimwd_usarmy", 30],
	["rhsusf_m1a1aim_tuski_wd", 30],
	["rhsusf_m1a2sep1wd_usarmy", 30],
	["rhsusf_m1a2sep1tuskiwd_usarmy", 30],
	["rhsusf_m1a2sep1tuskiiwd_usarmy", 30],
	["rhsgref_cdf_b_zsu234", 30]
];

west_vehicle_tier_1 = [
	["rhsusf_M1117_W", 20], // Prowler
	["rhsusf_M1220_M153_M2_usarmy_wd", 20], // Prowler
	["rhsusf_M1220_M2_usarmy_wd", 20], // Prowler
	["rhsusf_M1220_MK19_usarmy_wd", 20], // Prowler
	["rhsusf_M1230_M2_usarmy_wd", 20], // Prowler
	["rhsusf_M1230_MK19_usarmy_wd", 20], // Prowler
	["rhsusf_M1232_M2_usarmy_wd", 20], // Prowler
	["rhsusf_M1232_MK19_usarmy_wd", 20], // Prowler
	["rhsusf_M1237_M2_usarmy_wd", 20], // Prowler
	["rhsusf_M1237_MK19_usarmy_wd", 20], // Prowler
	["RHS_M2A2_wd", 20], // Prowler
	["RHS_M2A2_BUSKI_WD", 20], // Prowler
	["RHS_M2A3_wd", 20], // Prowler
	["RHS_M2A3_BUSKIII_wd", 20], // Prowler
	["RHS_M6_wd", 20] // Prowler
];

west_vehicle_tier_0 = [
	["rhsusf_m1043_w_m2", 10], // Hunter
	["rhsusf_m1043_w_mk19", 10], // Hunter
	["rhsusf_m1045_w", 10] // Hunter
];

// GUER VEHICLES

guer_vehicle_transport = [
	["I_MRAP_03_F", 10] // Strider
];

guer_vehicle_tier_2 = [
	["rhsgref_ins_g_t72ba", 30], // MBT-52 Kuma 1
	["rhsgref_ins_g_t72bb", 30], // MBT-52 Kuma 1
	["rhsgref_ins_g_t72bc", 30], // MBT-52 Kuma 1
	["rhsgref_ins_g_zsu234", 30] // MBT-52 Kuma 1
];

guer_vehicle_tier_1 = [
	["rhsgref_BRDM2_ins_g", 20], // Strider GMG
	["rhsgref_BRDM2_ATGM_ins_g", 20], // Strider GMG
	["rhsgref_BRDM2_HQ_ins_g", 20], // Strider GMG
	["rhsgref_ins_g_bmp2e", 20], // Strider GMG
	["rhsgref_ins_g_bmp1", 20], // Strider GMG
	["rhsgref_ins_g_bmp1p", 20], // Strider GMG
	["rhsgref_ins_g_bmp2", 20], // Strider GMG
	["rhsgref_ins_g_bmp1", 20], // Strider GMG
	["rhsgref_ins_g_bmp1d", 20], // Strider GMG
	["rhsgref_ins_g_bmp1k", 20], // Strider GMG
	["rhsgref_ins_g_bmp1p", 20], // Strider GMG
	["rhsgref_ins_g_bmp2", 20], // Strider GMG
	["rhsgref_ins_g_bmp2d", 20], // Strider GMG
	["rhsgref_ins_g_bmp2k", 20] // Strider GMG
];

guer_vehicle_tier_0 = [
	["rhsgref_ins_g_uaz_ags", 10], // Strider
	["rhsgref_ins_g_uaz_dshkm_chdkz", 10], // Strider
	["rhsgref_ins_g_uaz_open", 10], // Strider
	["rhsgref_ins_g_uaz_spg9", 10] // Strider
];

// EAST VEHICLES

east_vehicle_transport = [
	["O_MRAP_02_F", 10], // Ifrit
	["O_LSV_02_unarmed_F", 10] // Qilin
];

east_vehicle_tier_2 = [
	["rhs_t72ba_tv", 30], // T-100 Varsuk
	["rhs_t72bb_tv", 30], // T-100 Varsuk
	["rhs_t72bc_tv", 30], // T-100 Varsuk
	["rhs_t72bd_tv", 30], // T-100 Varsuk
	["rhs_t72be_tv", 30], // T-100 Varsuk
	["rhs_t80", 30], // T-100 Varsuk
	["rhs_t80a", 30], // T-100 Varsuk
	["rhs_t80b", 30], // T-100 Varsuk
	["rhs_t80bk", 30], // T-100 Varsuk
	["rhs_t80bv", 30], // T-100 Varsuk
	["rhs_t80bvk", 30], // T-100 Varsuk
	["rhs_t80u", 30], // T-100 Varsuk
	["rhs_t80u45m", 30], // T-100 Varsuk
	["rhs_t80ue1", 30], // T-100 Varsuk
	["rhs_t80uk", 30], // T-100 Varsuk
	["rhs_t80um", 30], // T-100 Varsuk
	["rhs_t90a_tv", 30], // T-100 Varsuk
	["rhs_t90_tv", 30], // T-100 Varsuk
	["rhs_zsu234_aa", 30] // T-100 Varsuk
];

east_vehicle_tier_1 = [
	["rhs_bmd1", 20], // Qilin Armed
	["rhs_bmd1k", 20], // Qilin Armed
	["rhs_bmd1p", 20], // Qilin Armed
	["rhs_bmd1pk", 20], // Qilin Armed
	["rhs_bmd1r", 20], // Qilin Armed
	["rhs_bmd2", 20], // Qilin Armed
	["rhs_bmd2k", 20], // Qilin Armed
	["rhs_bmd2m", 20], // Qilin Armed
	["rhs_bmd4_vdv", 20], // Qilin Armed
	["rhs_bmd4m_vdv", 20], // Qilin Armed
	["rhs_bmd4ma_vdv", 20], // Qilin Armed
	["rhs_bmp1_vdv", 20], // Qilin Armed
	["rhs_bmp1d_vdv", 20], // Qilin Armed
	["rhs_bmp1k_vdv", 20], // Qilin Armed
	["rhs_bmp1p_vdv", 20], // Qilin Armed
	["rhs_bmp2_vdv", 20], // Qilin Armed
	["rhs_bmp2e_vdv", 20], // Qilin Armed
	["rhs_bmp2d_vdv", 20], // Qilin Armed
	["rhs_bmp2k_vdv", 20], // Qilin Armed
	["rhs_bmp1k_vdv", 20], // Qilin Armed
	["rhs_prp3_vdv", 20], // Qilin Armed
	["rhsgref_BRDM2_vdv", 20], // Qilin Armed
	["rhsgref_BRDM2_ATGM_vdv", 20], // Qilin Armed
	["rhsgref_BRDM2_HQ_vdv", 20] // Qilin Armed
];

east_vehicle_tier_0 = [
	["rhs_tigr_sts_vdv", 10], // Ifrit
	["rhs_uaz_open_MSV_01", 10] // Ifrit
];

// WEST HELICOPTERS

west_helicopter_transport = [
	["RHS_UH60M2", 10], // MH-9 Hummingbird
	["RHS_CH_47F", 10] // CH-67 Huron
];

west_helicopter_tier_2 = [
	["B_Heli_Attack_01_F", 40], // AH-99 Blackfoot
	["RHS_AH64D_wd", 50], // AH64D
	["RHS_AH64D_wd_CS", 50], // AH64D CS
	["RHS_AH64D_wd_AA", 50] // AH64D AA	
];

west_helicopter_tier_1 = [
	["RHS_MELB_MH6M", 30]
];

west_helicopter_tier_0 = [
	["RHS_UH60M", 10] // MH-9 Hummingbird
];

// EAST HELICOPTERS

east_helicopter_transport = [
	["O_Heli_Light_02_dynamicLoadout_F", 10], // PO-30 Orca
	["O_Heli_Transport_04_bench_F", 10] // Mi-290 Taru (Bench)
];

east_helicopter_tier_2 = [
	["O_Heli_Attack_02_F", 40], // Mi-48 Kajman with rockets
	["RHS_Mi8MTV3_heavy_vvs", 40], // Mi-8MTV-3
	["rhs_mi28n_vvs", 40], // Mi-28N
	["RHS_Ka52_vvsc", 40] // Ka-52
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
	["rhsgref_cdf_Mi24D", 40], // Mi-24D
	["rhsgref_cdf_reg_Mi17Sh", 40] // Mi-8AMTSh
];

guer_helicopter_tier_1 = [
	["I_Heli_light_03_F", 20] // WY-55 Hellcat with rockets
];

guer_helicopter_tier_0 = [
	["I_Heli_light_03_dynamicLoadout_F", 20] // WY-55 Hellcat with gatling
];

