
ARWA_get_custom_infantry_options = {
	private _loadouts = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];

	private _loadout_names = _loadouts select { typeName _x isEqualTo "STRING"; };
	_loadout_names apply { [_x, 0]; };
};

ARWA_apply_loadout = {
	params ["_loadout_name", "_unit"];

	private _loadouts = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
	private _loadout = (_loadouts find _loadout_name) +1;

	_loadout params [
		"_uniform_with_inventory",
		"_vest_with_inventory",
		"_backpack_with_inventory",
		"_head_gear",
		"_face_gear",
		"_designator",
		"_primary_weapon_with_attachments",
		"_secondary_weapon_with_attachments",
		"_small_weapon_with_attachments",
		"_additional_gear"
	];

	comment "Remove existing items";
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	_unit forceAddUniform (_uniform_with_inventory select 0);
	{
		_unit addItemToUniform _x;
	} foreach  (_uniform_with_inventory select 1);

	_unit addVest (_vest_with_inventory select 0);
	{
		_unit addItemToVest _x;
	} foreach  (_vest_with_inventory select 1);

	_unit addBackpack (_backpack_with_inventory select 0);
	{
		_unit addItemToBackpack _x;
	} foreach  (_backpack_with_inventory select 1);

	_unit addHeadgear _head_gear;
	_unit addGoggles _face_gear;

	_unit addWeapon (_primary_weapon_with_attachments select 0);
	{
		_unit addPrimaryWeaponItem _x;
	} foreach (_primary_weapon_with_attachments select 1);
	_unit addMagazine _primary_weapon_with_attachments select 3;

	_unit addWeapon (_secondary_weapon_with_attachments select 0);
	{
		_unit addSecondaryWeaponItem _x;
	} foreach (_secondary_weapon_with_attachments select 1);
	_unit addMagazine _secondary_weapon_with_attachments select 3;

	_unit addWeapon (_small_weapon_with_attachments select 0);
	{
		_unit addHandgunItem _x;
	} foreach (_small_weapon_with_attachments select 1);
	_unit addMagazine _small_weapon_with_attachments select 3;

	{
		_unit linkItem _x;
	} foreach _additional_gear;
};