/*
	ZCP_fnc_fillCrate

	Original credit goes to WAI: https://github.com/nerdalertdk/WICKED-AI
	Edited by eraser1

	Usage:
	[
		_crate,						// OBJECT: The crate object
		_lootValues,				// ARRAY, STRING, or NUMBER: String or number refers to a crate case in config.cfg; array determines random crate weapons/items/backpacks
		_rareLootChance				// (OPTIONAL) NUMBER: Manually define the percentage chance of spawning some rare items.
	] call ZCP_fnc_fillCrate;

	If the "_lootValues" parameter is a number or a string, the function will look for a value defined as "ZCP_DMS_CrateCase_*", where the "*" is replaced by the "_lootValues" parameter. EG: ZCP_DMS_CrateCase_Sniper.

	Otherwise, the "_lootValues" parameter must be defined as:
		[
			_weapons,
			_items,
			_backpacks
		]

	Each loot argument can be an explicitly defined array of weapons with a number to spawn, or simply a number and weapons defined in the config.sqf are used.
	For example, if you want to configure the list from which weapons, items, and backpacks are selected, it should be of the form:
	[
		[
			_number_of_weapons,
			[
				"wepClassname1",
				"wepClassname2",
				...
				"wepClassnameN"
			]
		],
		[
			_number_of_items,
			[
				"itemClassname1",
				"itemClassname2",
				...
				"itemClassnameN"
			]
		],
		[
			_number_of_backpacks,
			[
				"backpackClassname1",
				"backpackClassname2",
				...
				"backpackClassnameN"
			]
		]
	]

	For example, _weapons could simply be a number, in which case the given number of weapons are selected from "ZCP_DMS_boxWeapons",
	or an array as [_wepCount,_weps], where _wepCount is the number of weapons, and _weps is an array of weapons from which the guns are randomly selected.

	OR:
		[
			_customLootFunctionParams,
			_customLootFunction
		]
		In this case, "_customLootFunctionParams" is passed to "_customLootFunction", and the custom loot function must return the loot in the form:
		[
			[
				weapon1,
				weapon2,
				[weapon_that_appears_twice,2],
				...
				weaponN
			],
			[
				item1,
				item2,
				[item_that_appears_5_times,5],
				...
				itemN
			],
			[
				backpack1,
				backpack2,
				[backpack_that_appears_3_times,3],
				...
				backpackN
			]
		]
*/

private ["_crate","_lootValues","_wepCount","_weps","_itemCount","_items","_backpackCount","_backpacks","_weapon","_ammo","_item","_backpack","_crateValues","_rareLootChance","_marker"];

if (!(params
[
	["_crate",objNull,[objNull]],
	["_lootValues","",[0,"",[]],[2,3]]
])
||
{isNull _crate})
exitWith
{
	diag_log text format ["DMS ERROR :: Calling ZCP_fnc_fillCrate with invalid parameters: %1",_this];
};

_crate hideObjectGlobal false;

if ((_lootValues isEqualType []) && {!((_lootValues select 1) isEqualType {})}) then
{
	// Weapons
	if ((_lootValues select 0) isEqualType []) then
	{
		_wepCount	= (_lootValues select 0) select 0;
		_weps	= (_lootValues select 0) select 1;
	}
	else
	{
		_wepCount	= _lootValues select 0;
		_weps	= ZCP_DMS_boxWeapons;
	};


	// Items
	if ((_lootValues select 1) isEqualType []) then
	{
		_itemCount	= (_lootValues select 1) select 0;
		_items	= (_lootValues select 1) select 1;
	}
	else
	{
		_itemCount	= _lootValues select 1;
		_items	= ZCP_DMS_boxItems;
	};


	// Backpacks
	if ((_lootValues select 2) isEqualType []) then
	{
		_backpackCount	= (_lootValues select 2) select 0;
		_backpacks = (_lootValues select 2) select 1;
	}
	else
	{
		_backpackCount = _lootValues select 2;
		_backpacks = ZCP_DMS_boxBackpacks;
	};


	if (ZCP_DMS_DEBUG) then
	{
		(format["FillCrate :: Filling %4 with %1 guns, %2 items and %3 backpacks",_wepCount,_itemCount,_backpackCount,_crate]) call ZCP_DMS_fnc_DebugLog;
	};


	if ((_wepCount>0) && {count _weps>0}) then
	{
		// Add weapons + mags
		for "_i" from 1 to _wepCount do
		{
			_weapon = _weps call BIS_fnc_selectRandom;
			_ammo = _weapon call ZCP_fnc_selectMagazine;
			if (_weapon isEqualType "") then
			{
				_weapon = [_weapon,1];
			};
			_crate addWeaponCargoGlobal _weapon;
			if !(_ammo in ["Exile_Magazine_Swing","Exile_Magazine_Boing","Exile_Magazine_Swoosh"]) then
			{
				_crate addItemCargoGlobal [_ammo, (ZCP_DMS_MinimumMagCount + floor(random ZCP_DMS_MagRange))];
			};
		};
	};


	if ((_itemCount > 0) && {count _items>0}) then
	{
		// Add items
		for "_i" from 1 to _itemCount do
		{
			_item = _items call BIS_fnc_selectRandom;
			if (_item isEqualType "") then
			{
				_item = [_item,1];
			};
			_crate addItemCargoGlobal _item;
		};
	};


	if ((_backpackCount > 0) && {count _backpacks>0}) then
	{
		// Add backpacks
		for "_i" from 1 to _backpackCount do
		{
			_backpack = _backpacks call BIS_fnc_selectRandom;
			if (_backpack isEqualType "") then
			{
				_backpack = [_backpack,1];
			};
			_crate addBackpackCargoGlobal _backpack;
		};
	};
}
else
{
	_crateValues =
		if (_lootValues isEqualType []) then
		{
			(_lootValues select 0) call (_lootValues select 1)
		}
		else
		{
			missionNamespace getVariable (format ["ZCP_DMS_CrateCase_%1",_lootValues])
		};

	if !((_crateValues params
	[
		["_weps", [], [[]]],
		["_items", [], [[]]],
		["_backpacks", [], [[]]]
	]))
	exitWith
	{
		diag_log text format ["DMS ERROR :: Invalid ""_crateValues"" (%1) generated from _lootValues: %2",_crateValues,_lootValues];
	};

	// Weapons
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate addWeaponCargoGlobal _x;
	} forEach _weps;

	// Items/Mags
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate addItemCargoGlobal _x;
	} forEach _items;

	// Backpacks
	{
		if (_x isEqualType "") then
		{
			_x = [_x,1];
		};
		_crate addBackpackCargoGlobal _x;
	} forEach _backpacks;


	if (ZCP_DMS_DEBUG) then
	{
		(format["FillCrate :: Filled crate %1 (at %5) with weapons |%2|, items |%3|, and backpacks |%4|",_crate, _weps, _items, _backpacks, getPosATL _crate]) call ZCP_DMS_fnc_DebugLog;
	};
};


if(ZCP_DMS_RareLoot && {count ZCP_DMS_RareLootList>0}) then
{
	_rareLootChance =
		if ((count _this)>2) then
		{
			_this param [2,ZCP_DMS_RareLootChance,[0]]
		}
		else
		{
			ZCP_DMS_RareLootChance
		};

	// (Maybe) Add rare loot
	if(random 100 < _rareLootChance) then
	{
		_item = ZCP_DMS_RareLootList call BIS_fnc_selectRandom;
		if (_item isEqualType "") then
		{
			_item = [_item,1];
		};
		_crate addItemCargoGlobal _item;
	};
};
