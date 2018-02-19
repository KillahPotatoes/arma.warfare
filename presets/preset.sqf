// Global variables

sector_size = 200; // sector size
starting_strength  = 50;
unit_cap = 30;
defender_cap = 5;
initial_skill = 0.5;
tier_2_vehicle_chance = 10;
tier_1_vehicle_chance = 40;
tier_1 = 30;
tier_2 = 60;
tier_3 = 90;
factions = [west, east, independent];

ammo_box = "B_CargoNet_01_ammo_F";
mine = "APERSBoundingMine";

tier_0_gunship_respawn_time = [600, 900, 1200];
tier_1_gunship_respawn_time = [540, 840, 1140];
tier_2_gunship_respawn_time = [480, 780, 1080];
tier_3_gunship_respawn_time = [420, 720, 1020];


// Presets
west_heavy_vehicles = ["rhsusf_m1a2sep1tuskiiwd_usarmy", "rhsusf_m1a1aim_tuski_wd", "rhsusf_m1a1aimwd_usarmy"];
guer_heavy_vehicles = ["rhsgref_cdf_t80b_tv", "rhsgref_cdf_t72bb_tv", "rhsgref_cdf_t72ba_tv"];
east_heavy_vehicles = ["rhs_t80bv", "rhs_t90a_tv", "rhs_t72bd_tv"];

west_light_vehicles = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F"];
guer_light_vehicles = ["rhsgref_cdf_reg_uaz_dshkm", "rhsgref_cdf_reg_uaz_ags", "rhssaf_m1025_olive_m2"];
east_light_vehicles = ["rhs_tigr_sts_msv", "rhsgref_BRDM2_ATGM_msv", "rhsgref_BRDM2_HQ_msv"];

west_gunships = ["RHS_AH64D_wd", "RHS_AH64D_wd_CS", "RHS_AH64D_wd_AA"];
guer_gunships = ["rhsgref_cdf_Mi35", "rhsgref_cdf_Mi24D", "rhsgref_cdf_Mi24D_early"];
east_gunships = ["O_Heli_Light_02_dynamicLoadout_F", "O_Heli_Attack_02_dynamicLoadout_F"];

west_transport_helis = ["RHS_UH60M2"];
guer_transport_helis = ["I_Heli_light_03_unarmed_F"];
east_transport_helis = ["O_Heli_Light_02_unarmed_F"];

west_mortars = ["B_Mortar_01_F"];
guer_mortars = ["I_Mortar_01_F"];
east_mortars = ["O_Mortar_01_F"];
