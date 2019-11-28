
ARWA_get_custom_infantry_options = {
	private _loadouts = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];

	private _loadout_names = _loadouts select { typeName _x isEqualTo "STRING"; };
	_loadout_names apply { [_x, 0]; };
};

ARWA_apply_loadout = {
	params ["_loadout_name", "_unit"];

	private _loadouts = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];

	private _index = _loadouts find _loadout_name;

	private _loadout = _loadouts select (_index + 1);

	private _uniform_with_inventory = _loadout select 0;
	private _vest_with_inventory = _loadout select 1;
	private _backpack_with_inventory = _loadout select 2;
	private _head_gear = _loadout select 3;
	private _face_gear = _loadout select 4;
	private _designator = _loadout select 5;
	private _primary_weapon_with_attachments = _loadout select 6;
	private _secondary_weapon_with_attachments = _loadout select 7;
	private _small_weapon_with_attachments = _loadout select 8;
	private _additional_gear = _loadout select 9;

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