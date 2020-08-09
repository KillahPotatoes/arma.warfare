ARWA_mission_size = worldSize;

ARWA_calculate_mission_size = {
	private _hqs = (allMissionObjects ARWA_ammo_box) select {
		private _ammo_box = _x;
		private _ammo_box_name = vehicleVarName _ammo_box;
		private _arr = _ammo_box_name splitString "_";
		private _type = _arr select 0;

		_type isEqualTo "HQ";
	};

	ARWA_mission_size = (((getPos (_hqs select 0)) distance2D (getPos (_hqs select 1))) + ((getPos (_hqs select 0)) distance2D (getPos (_hqs select 2))) + ((getPos (_hqs select 1)) distance2D (getPos (_hqs select 2)))) / 3;
};

