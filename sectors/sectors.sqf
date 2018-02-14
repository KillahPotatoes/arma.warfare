sectors = [];
west_sectors = [];
ind_sectors = [];
east_sectors = [];

GetEnemySectors = {
	_faction = _this select 0;

	_sectors = [];

	if(_faction isEqualTo WEST) then {
		_sectors = ind_sectors + east_sectors;
	};

	if(_faction isEqualTo EAST) then {
		_sectors = ind_sectors + west_sectors;
	};

	if(_faction isEqualTo independent) then {
		_sectors = west_sectors + east_sectors;
	};

	_sectors;
};

GetOwnedSectors = {
	_faction = _this select 0;

	_sectors = [];

	if(_faction isEqualTo WEST) then {
		_sectors = west_sectors;
	};

	if(_faction isEqualTo EAST) then {
		_sectors =  east_sectors;
	};

	if(_faction isEqualTo independent) then {
		_sectors = ind_sectors;
	};

	_sectors;
};

SectorCount = {
	_faction = _this select 0;

	_c = 0;

	if(_faction isEqualTo WEST) then {
		_c = count west_sectors;
	};

	if(_faction isEqualTo EAST) then {
		_c = count east_sectors;
	};

	if(_faction isEqualTo independent) then {
		_c = count ind_sectors;
	};

	_c;
};

EnemySectorCount = {
	_faction = _this select 0;

	_c = 0;

	if(_faction isEqualTo WEST) then {
		_c = count ind_sectors + count west_sectors;
	};

	if(_faction isEqualTo EAST) then {
		_c = count ind_sectors + count west_sectors;
	};

	if(_faction isEqualTo independent) then {
		_c = count east_sectors + count west_sectors;
	};

	_c;
};

OtherSectorCount = {
	_faction = _this select 0;
	_owned_sectors_count = [_faction] call SectorCount;

	count sectors - _owned_sectors_count;
};

GetOtherSectors = {
	_faction = _this select 0;
	_owned_sectors = [_faction] call GetOwnedSectors;

	sectors - _owned_sectors;
};

FindClosestOtherSector = {
	_side = _this select 0;
	_pos = _this select 1;
	_enemySectors = [_side] call GetOtherSectors;	

	_current_target_sector = _enemySectors select 0;
	_current_shortest_distance = 99999;

	{
		_sector_pos = _x getVariable "pos";
		_distance = _leader_pos distance _sector_pos;

		if (_current_shortest_distance > _distance) then {
			_current_shortest_distance = _distance;
			_current_target_sector = _x;
		};

	} forEach _enemySectors;

	_current_target_sector;
};

FindClosestOwnedSector = {
	_side = _this select 0;
	_pos = _this select 1;
	_ownedSectors = [_side] call GetOwnedSectors;	

	_current_target_sector = _ownedSectors select 0;
	_current_shortest_distance = 99999;

	{
		_sector_pos = _x getVariable "pos";
		_distance = _leader_pos distance _sector_pos;

		if (_current_shortest_distance > _distance) then {
			_current_shortest_distance = _distance;
			_current_target_sector = _x;
		};

	} forEach _enemySectors;

	_current_target_sector;
};