chanceOfHelicopter = 5;
chanceOfHeavyVehicle = 10;
chanceOfLightVehicle =  15;

sector_size = 200;

artilleryWest = ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"];
artilleryEast = ["O_MBT_02_arty_F"];
artilleryIndependent = ["CUP_I_M270_HE_AAF", "CUP_I_M270_DPICM_AAF"];

heavy_vehicles_west = ["rhsusf_m1a2sep1tuskiiwd_usarmy", "rhsusf_m1a1aim_tuski_wd", "rhsusf_m1a1aimwd_usarmy"];
heavy_vehicles_independent = ["rhsgref_cdf_t80b_tv", "rhsgref_cdf_t72bb_tv", "rhsgref_cdf_t72ba_tv"];
heavy_vehicles_east = ["rhs_t80bv", "rhs_t90a_tv", "rhs_t72bd_tv"];

light_vehicles_west = ["Fennek_gmg_wd", "Fennek_hmg_wd"];
light_vehicles_independent = ["rhsgref_cdf_reg_uaz_dshkm", "rhsgref_cdf_reg_uaz_ags", "rhssaf_m1025_olive_m2"];
light_vehicles_east = ["rhs_tigr_sts_msv", "rhsgref_BRDM2_ATGM_msv", "rhsgref_BRDM2_HQ_msv"];

helicoptersWest = ["RHS_AH64D_wd", "RHS_AH64D_wd_CS", "RHS_AH64D_wd_AA"];
helicoptersIndependent = ["CUP_I_Mi24_D_AAF", "CUP_I_AH1Z_Dynamic_AAF", "CUP_I_Mi24_Mk3_FAB_AAF"];
helicoptersEast = ["O_Heli_Light_02_dynamicLoadout_F", "CUP_O_Ka60_GL_Hex_CSAT", "O_Heli_Attack_02_dynamicLoadout_F"];

mortarWest = ["B_Mortar_01_F"];
mortarIndependent = ["I_Mortar_01_F"];
mortarEast = ["O_Mortar_01_F"];

warfare_color_west = "ColorWEST";																			// Friendly sector marker color.
warfare_color_east = "ColorEAST";																				// Enemy sector marker color.
warfare_color_ind = "ColorGUER";																			// Enemy sector marker color (activated).
warfare_color_inactive = "ColorGrey";

warfare_sector_size = 200;

EAST_preset = createGroup sideLogic;
EAST_preset setVariable ["mortars", mortarEast];
EAST_preset setVariable ["helicopters", helicoptersEast];
EAST_preset setVariable ["heavy_vehicles", helicoptersEast];
EAST_preset setVariable ["light_vehicles", light_vehicles_east];

WEST_preset = createGroup sideLogic;
WEST_preset setVariable ["mortars", mortarWest];
WEST_preset setVariable ["helicopters", helicoptersWest];
WEST_preset setVariable ["heavy_vehicles", heavy_vehicles_west];
WEST_preset setVariable ["light_vehicles", light_vehicles_west];

GUER_preset = createGroup sideLogic;
GUER_preset setVariable ["mortars", mortarIndependent];
GUER_preset setVariable ["helicopters", helicoptersIndependent];
GUER_preset setVariable ["heavy_vehicles", heavy_vehicles_independent];
GUER_preset setVariable ["light_vehicles", light_vehicles_independent];

GetPreset = {
	_side = _this select 0;
	missionNamespace getVariable format["%1_preset", _side];
};
