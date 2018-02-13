sector_size = 200;

artilleryWest = ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"];
artilleryEast = ["O_MBT_02_arty_F"];
artilleryIndependent = ["CUP_I_M270_HE_AAF", "CUP_I_M270_DPICM_AAF"];

west_heavy_vehicles = ["rhsusf_m1a2sep1tuskiiwd_usarmy", "rhsusf_m1a1aim_tuski_wd", "rhsusf_m1a1aimwd_usarmy"];
guer_heavy_vehicles = ["rhsgref_cdf_t80b_tv", "rhsgref_cdf_t72bb_tv", "rhsgref_cdf_t72ba_tv"];
east_heavy_vehicles = ["rhs_t80bv", "rhs_t90a_tv", "rhs_t72bd_tv"];

west_light_vehicles = ["Fennek_gmg_wd", "Fennek_hmg_wd"];
guer_light_vehicles = ["rhsgref_cdf_reg_uaz_dshkm", "rhsgref_cdf_reg_uaz_ags", "rhssaf_m1025_olive_m2"];
east_light_vehicles = ["rhs_tigr_sts_msv", "rhsgref_BRDM2_ATGM_msv", "rhsgref_BRDM2_HQ_msv"];

helicoptersWest = ["RHS_AH64D_wd", "RHS_AH64D_wd_CS", "RHS_AH64D_wd_AA"];
helicoptersIndependent = ["CUP_I_Mi24_D_AAF", "CUP_I_AH1Z_Dynamic_AAF", "CUP_I_Mi24_Mk3_FAB_AAF"];
helicoptersEast = ["O_Heli_Light_02_dynamicLoadout_F", "CUP_O_Ka60_GL_Hex_CSAT", "O_Heli_Attack_02_dynamicLoadout_F"];

west_transport_heli = ["RHS_UH60M2"];
guer_transport_heli = ["I_Heli_light_03_unarmed_F"];
east_transport_heli = ["O_Heli_Light_02_unarmed_F"];

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
EAST_preset setVariable ["heavy_vehicles", east_heavy_vehicles];
EAST_preset setVariable ["light_vehicles", east_light_vehicles];

WEST_preset = createGroup sideLogic;
WEST_preset setVariable ["mortars", mortarWest];
WEST_preset setVariable ["helicopters", helicoptersWest];
WEST_preset setVariable ["heavy_vehicles", west_heavy_vehicles];
WEST_preset setVariable ["light_vehicles", west_light_vehicles];

GUER_preset = createGroup sideLogic;
GUER_preset setVariable ["mortars", mortarIndependent];
GUER_preset setVariable ["helicopters", helicoptersIndependent];
GUER_preset setVariable ["heavy_vehicles", guer_heavy_vehicles];
GUER_preset setVariable ["light_vehicles", guer_light_vehicles];

GetPreset = {
	_side = _this select 0;
	missionNamespace getVariable format["%1_preset", _side];
};
