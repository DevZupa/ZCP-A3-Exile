params[
 '_ZCP_CDS_dummyGroup',
 '_ZCP_CDS_spawnAIPos',
 '_ZCP_CDS_difficulty',
 '_ZCP_CDS_soldierClass',
 '_ZCP_CDS_radius'
];

private _ZCP_CDS_unarmed = false;

_ZCP_CDS_difficulty =
	switch (toLower _ZCP_CDS_difficulty) do
	{
		case "random":
		{
			DMS_ai_skill_random call BIS_fnc_selectRandom;
		};

		case "randomdifficult":
		{
			DMS_ai_skill_randomDifficult call BIS_fnc_selectRandom;
		};

		case "randomeasy":
		{
			DMS_ai_skill_randomEasy call BIS_fnc_selectRandom;
		};

		case "randomintermediate":
		{
			DMS_ai_skill_randomIntermediate call BIS_fnc_selectRandom;
		};

		default
		{
		    _ZCP_CDS_difficulty;
		};
	};

private _ZCP_CDS_posAI = _ZCP_CDS_spawnAIPos findEmptyPosition [0, _ZCP_CDS_radius, ZCP_CONFIG_AI_soldierClass];

_ZCP_CDS_unitAI = _ZCP_CDS_dummyGroup createUnit [ZCP_CONFIG_AI_soldierClass, _ZCP_CDS_posAI, [], 0,"FORM"];
_ZCP_CDS_unitAI allowFleeing 0;
_ZCP_CDS_unitAI allowDamage false;

_ZCP_CDS_unitAI disableAI "AUTOTARGET";
_ZCP_CDS_unitAI disableAI "TARGET";
_ZCP_CDS_unitAI disableAI "MOVE";

// Remove existing gear
{_ZCP_CDS_unitAI removeWeaponGlobal _x;} 	forEach (weapons _ZCP_CDS_unitAI);
{_ZCP_CDS_unitAI unlinkItem _x;} 			forEach (assignedItems _ZCP_CDS_unitAI);
{_ZCP_CDS_unitAI removeItem _x;} 			forEach (items _ZCP_CDS_unitAI);
removeAllItemsWithMagazines 	_ZCP_CDS_unitAI;
removeHeadgear 					_ZCP_CDS_unitAI;
removeUniform 					_ZCP_CDS_unitAI;
removeVest 						_ZCP_CDS_unitAI;
removeBackpackGlobal 			_ZCP_CDS_unitAI;

if (_ZCP_CDS_soldierClass == "unarmed") then
{
	_ZCP_CDS_soldierClass = "assault";
	_ZCP_CDS_unarmed = true;
}
else
{
	if (_ZCP_CDS_soldierClass in DMS_ai_SupportedRandomClasses) then
	{
		_ZCP_CDS_soldierClass = (missionNamespace getVariable [format["DMS_%1_AI",_ZCP_CDS_soldierClass], DMS_random_AI]) call BIS_fnc_selectRandom;
	};
};

// Give default items
if !(DMS_ai_default_items isEqualTo []) then
{
	{
		// "Why doesn't linkItem work with any of these? Because fuck you, that's why" - BIS
		if (_x in ["Binocular","Rangefinder","Laserdesignator","Laserdesignator_02","Laserdesignator_03"]) then
		{
			_ZCP_CDS_unitAI addWeapon _x;
		}
		else
		{
			_ZCP_CDS_unitAI linkItem _x;
		};
	} forEach DMS_ai_default_items;
};

if !(_ZCP_CDS_soldierClass in DMS_ai_SupportedClasses) exitWith
	{
		diag_log text format ["DMS ERROR :: DMS_SpawnAISoldier called with unsupported _ZCP_CDS_soldierClass: %1 | _this: %2",_ZCP_CDS_soldierClass,_this];
		deleteVehicle _ZCP_CDS_unitAI;
	};


	// Equipment (Stuff that goes in the toolbelt slots)
	{
		if (_x in ["Binocular","Rangefinder","Laserdesignator","Laserdesignator_02","Laserdesignator_03"]) then
		{
			_ZCP_CDS_unitAI addWeapon _x;
		}
		else
		{
			_ZCP_CDS_unitAI linkItem _x;
		};
	} forEach (missionNamespace getVariable [format ["DMS_%1_equipment",_ZCP_CDS_soldierClass],[]]);
	
	// Clothes
	_ZCP_CDS_unitAI addHeadgear 		((missionNamespace getVariable [format ["DMS_%1_helmets",_ZCP_CDS_soldierClass],DMS_assault_helmets]) call BIS_fnc_selectRandom);
	_ZCP_CDS_unitAI forceAddUniform 	((missionNamespace getVariable [format ["DMS_%1_clothes",_ZCP_CDS_soldierClass],DMS_assault_clothes]) call BIS_fnc_selectRandom);
	_ZCP_CDS_unitAI addVest 			((missionNamespace getVariable [format ["DMS_%1_vests",_ZCP_CDS_soldierClass],DMS_assault_vests]) call BIS_fnc_selectRandom);
	_ZCP_CDS_unitAI addBackpack 		((missionNamespace getVariable [format ["DMS_%1_backpacks",_ZCP_CDS_soldierClass],DMS_assault_backpacks]) call BIS_fnc_selectRandom);

	// Make AI effective at night
	_nighttime = (sunOrMoon != 1);
	if (_nighttime) then
	{
		_ZCP_CDS_unitAI linkItem "NVGoggles";
	};
	
	// Items (Loot stuff that goes in uniform/vest/backpack)
	{_ZCP_CDS_unitAI addItem _x;} forEach (missionNamespace getVariable [format ["DMS_%1_items",_ZCP_CDS_soldierClass],[]]);

	if (!_ZCP_CDS_unarmed) then
	{
		_ZCP_CDS_weapon = (missionNamespace getVariable [format ["DMS_%1_weps",_ZCP_CDS_soldierClass],DMS_assault_weps]) call BIS_fnc_selectRandom;
		[_ZCP_CDS_unitAI, _ZCP_CDS_weapon, 6 + floor(random 3)] call BIS_fnc_addWeapon;
		_ZCP_CDS_unitAI selectWeapon _ZCP_CDS_weapon;


		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_optic_chance",_ZCP_CDS_soldierClass],0])) then
		{
			_ZCP_CDS_unitAI addPrimaryWeaponItem ((missionNamespace getVariable [format ["DMS_%1_optics",_ZCP_CDS_soldierClass],DMS_assault_optics]) call BIS_fnc_selectRandom);
		};

		if (_nighttime && {(random 100) <= DMS_ai_nighttime_accessory_chance}) then
		{
			_ZCP_CDS_unitAI addPrimaryWeaponItem (["acc_pointer_IR","acc_flashlight"] call BIS_fnc_selectRandom);
		};

		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_bipod_chance",_ZCP_CDS_soldierClass],0])) then
		{
			_ZCP_CDS_unitAI addPrimaryWeaponItem (DMS_ai_BipodList call BIS_fnc_selectRandom);
		};

		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_suppressor_chance",_ZCP_CDS_soldierClass],0])) then
		{
			_ZCP_CDS_suppressor = _ZCP_CDS_weapon call DMS_fnc_FindSuppressor;
			if(_ZCP_CDS_suppressor != "") then
			{
				_ZCP_CDS_unitAI addPrimaryWeaponItem _ZCP_CDS_suppressor;
			};
		};

		/*// In case spawn position is water
		if (DMS_ai_enable_water_equipment && {surfaceIsWater _pos}) then
		{
			removeHeadgear _ZCP_CDS_unitAI;
			removeAllWeapons _ZCP_CDS_unitAI;
			_ZCP_CDS_unitAI forceAddUniform "U_O_Wetsuit";
			_ZCP_CDS_unitAI addVest "V_RebreatherIA";
			_ZCP_CDS_unitAI addGoggles "G_Diving";
			[_ZCP_CDS_unitAI, "arifle_SDAR_F", 4 + floor(random 3), "20Rnd_556x45_UW_mag"] call BIS_fnc_addWeapon;
		};*/

		_ZCP_CDS_pistols = missionNamespace getVariable [format ["DMS_%1_pistols",_ZCP_CDS_soldierClass],[]];
		if !(_ZCP_CDS_pistols isEqualTo []) then
		{
			_ZCP_CDS_pistol = _ZCP_CDS_pistols call BIS_fnc_selectRandom;
			[_ZCP_CDS_unitAI, _ZCP_CDS_pistol, 2 + floor(random 2)] call BIS_fnc_addWeapon;
		};

		// Infinite Ammo
		// This will NOT work if AI unit is offloaded to client
		_ZCP_CDS_unitAI addeventhandler ["Fired", {(vehicle (_this select 0)) setvehicleammo 1;}];
	};

{
	_ZCP_CDS_unitAI setSkill _x;
} forEach (missionNamespace getVariable [format["DMS_ai_skill_%1",_ZCP_CDS_difficulty],[]]);


// Soldier killed event handler
_ZCP_CDS_unitAI addMPEventHandler ["MPKilled",'if (isServer) then {_this call DMS_fnc_OnKilled;};'];

{
	_ZCP_CDS_unitAI enableAI _x;
} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];

if (_ZCP_CDS_difficulty=="hardcore") then
{
	// Make him a little bit harder ;)
	{
		_ZCP_CDS_unitAI disableAI _x;
	} forEach ["SUPPRESSION", "AIMINGERROR"];
};

_ZCP_CDS_unitAI setCustomAimCoef (missionNamespace getVariable [format["DMS_AI_AimCoef_%1",_ZCP_CDS_difficulty], 0.7]);
_ZCP_CDS_unitAI enableStamina (missionNamespace getVariable [format["DMS_AI_EnableStamina_%1",_ZCP_CDS_difficulty], true]);

_ZCP_CDS_unitAI addRating 10000;

_ZCP_CDS_unitAI setVariable ["DMS_AISpawnTime", time];
_ZCP_CDS_unitAI setVariable ["DMS_AI_Side", "bandit"];
_ZCP_CDS_unitAI setVariable ["DMS_AI_Type", "Soldier"];
_ZCP_CDS_unitAI setVariable ["DMS_AISpawnPos",_ZCP_CDS_spawnAIPos];
_ZCP_CDS_unitAI setVariable ["DMS_LastAIDistanceCheck",time];

// Set money/respect variables
_ZCP_CDS_unitAI setVariable
[
	"DMS_AI_Money",
	DMS_bandit_Soldier_MoneyGain
];
_ZCP_CDS_unitAI setVariable
[
	"DMS_AI_Respect",
	DMS_bandit_Soldier_RepGain
];

// Money on the AI's body.
_ZCP_CDS_unitAI setVariable
[
	"ExileMoney",
	floor (random ZCP_CONFIG_MaxRandomAIMoney),
	true
];

uiSleep 0.1;


_ZCP_CDS_unitAI
