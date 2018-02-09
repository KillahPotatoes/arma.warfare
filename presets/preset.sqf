artilleryWest = ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"];
artilleryEast = ["O_MBT_02_arty_F"];
artilleryIndependent = ["CUP_I_M270_HE_AAF", "CUP_I_M270_DPICM_AAF"];

helicoptersWest = ["RHS_AH64D_wd", "RHS_AH64D_wd_CS", "RHS_AH64D_wd_GS"];
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
EAST_preset setVariable ["Mortar", mortarEast];
EAST_preset setVariable ["Helicopters", helicoptersEast];

WEST_preset = createGroup sideLogic;
WEST_preset setVariable ["Mortar", mortarWest];
WEST_preset setVariable ["Helicopters", helicoptersWest];

GUER_preset = createGroup sideLogic;
GUER_preset setVariable ["Mortar", mortarIndependent];
GUER_preset setVariable ["Helicopters", helicoptersIndependent];

GetPreset = {
	_side = _this select 0;
	missionNamespace getVariable format["%1_preset", _side];
};
