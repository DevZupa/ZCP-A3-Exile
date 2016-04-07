private['_groupAI','_spawnAIPos','_difficulty','_solierType','_unitAI','_posAI'];

_groupAI = _this select 0;
_spawnAIPos = _this select 1;
_difficulty = _this select 2;
_solierType = _this select 3;

_difficulty =
	switch (toLower _difficulty) do
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
		    _difficulty;
		};
	};

_posAI = [_spawnAIPos, 0, 20, 1, 0, 9999, 0] call BIS_fnc_findSafePos;
_unitAI = _groupAI createUnit ['O_G_Soldier_F', _posAI, [], 0,"FORM"];

[_unitAI] joinSilent _groupAI;
_unitAI allowFleeing 0;

// Remove existing gear
{_unitAI removeWeaponGlobal _x;} 	forEach (weapons _unitAI);
{_unitAI unlinkItem _x;} 			forEach (assignedItems _unitAI);
{_unitAI removeItem _x;} 			forEach (items _unitAI);
removeAllItemsWithMagazines 	_unitAI;
removeHeadgear 					_unitAI;
removeUniform 					_unitAI;
removeVest 						_unitAI;
removeBackpackGlobal 			_unitAI;

if (_class == "unarmed") then
{
	_class = "assault";
	_unarmed = true;
}
else
{
	if (_class in DMS_ai_SupportedRandomClasses) then
	{
		_class = (missionNamespace getVariable [format["DMS_%1_AI",_class], DMS_random_AI]) call BIS_fnc_selectRandom;
	};
};

// Give default items
if !(DMS_ai_default_items isEqualTo []) then
{
	{
		// "Why doesn't linkItem work with any of these? Because fuck you, that's why" - BIS
		if (_x in ["Binocular","Rangefinder","Laserdesignator","Laserdesignator_02","Laserdesignator_03"]) then
		{
			_unitAI addWeapon _x;
		}
		else
		{
			_unitAI linkItem _x;
		};
	} forEach DMS_ai_default_items;
};

if !(_class in DMS_ai_SupportedClasses) exitWith
	{
		diag_log format ["DMS ERROR :: DMS_SpawnAISoldier called with unsupported _class: %1 | _this: %2",_class,_this];
		deleteVehicle _unitAI;
	};


	// Equipment (Stuff that goes in the toolbelt slots)
	{
		if (_x in ["Binocular","Rangefinder","Laserdesignator","Laserdesignator_02","Laserdesignator_03"]) then
		{
			_unitAI addWeapon _x;
		}
		else
		{
			_unitAI linkItem _x;
		};
	} forEach (missionNamespace getVariable [format ["DMS_%1_equipment",_class],[]]);


	// Items (Loot stuff that goes in uniform/vest/backpack)
	{_unitAI addItem _x;} forEach (missionNamespace getVariable [format ["DMS_%1_items",_class],[]]);


	// Clothes
	_unitAI addHeadgear 		((missionNamespace getVariable [format ["DMS_%1_helmets",_class],DMS_assault_helmets]) call BIS_fnc_selectRandom);
	_unitAI forceAddUniform 	((missionNamespace getVariable [format ["DMS_%1_clothes",_class],DMS_assault_clothes]) call BIS_fnc_selectRandom);
	_unitAI addVest 			((missionNamespace getVariable [format ["DMS_%1_vests",_class],DMS_assault_vests]) call BIS_fnc_selectRandom);
	_unitAI addBackpack 		((missionNamespace getVariable [format ["DMS_%1_backpacks",_class],DMS_assault_backpacks]) call BIS_fnc_selectRandom);

	// Make AI effective at night
	_nighttime = (sunOrMoon != 1);
	if (_nighttime) then
	{
		_unitAI linkItem "NVGoggles";
	};

	if (!_unarmed) then
	{
		_weapon = (missionNamespace getVariable [format ["DMS_%1_weps",_class],DMS_assault_weps]) call BIS_fnc_selectRandom;
		[_unitAI, _weapon, 6 + floor(random 3)] call BIS_fnc_addWeapon;
		_unitAI selectWeapon _weapon;


		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_optic_chance",_class],0])) then
		{
			_unitAI addPrimaryWeaponItem ((missionNamespace getVariable [format ["DMS_%1_optics",_class],DMS_assault_optics]) call BIS_fnc_selectRandom);
		};

		if (_nighttime && {(random 100) <= DMS_ai_nighttime_accessory_chance}) then
		{
			_unitAI addPrimaryWeaponItem (["acc_pointer_IR","acc_flashlight"] call BIS_fnc_selectRandom);
		};

		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_bipod_chance",_class],0])) then
		{
			_unitAI addPrimaryWeaponItem (DMS_ai_BipodList call BIS_fnc_selectRandom);
		};

		if((random 100) <= (missionNamespace getVariable [format["DMS_%1_suppressor_chance",_class],0])) then
		{
			_suppressor = _weapon call DMS_fnc_FindSuppressor;
			if(_suppressor != "") then
			{
				_unitAI addPrimaryWeaponItem _suppressor;
			};
		};

		// In case spawn position is water
		if (DMS_ai_enable_water_equipment && {surfaceIsWater _pos}) then
		{
			removeHeadgear _unitAI;
			removeAllWeapons _unitAI;
			_unitAI forceAddUniform "U_O_Wetsuit";
			_unitAI addVest "V_RebreatherIA";
			_unitAI addGoggles "G_Diving";
			[_unitAI, "arifle_SDAR_F", 4 + floor(random 3), "20Rnd_556x45_UW_mag"] call BIS_fnc_addWeapon;
		};

		_pistols = missionNamespace getVariable [format ["DMS_%1_pistols",_class],[]];
		if !(_pistols isEqualTo []) then
		{
			_pistol = _pistols call BIS_fnc_selectRandom;
			[_unitAI, _pistol, 2 + floor(random 2)] call BIS_fnc_addWeapon;
		};

		// Infinite Ammo
		// This will NOT work if AI unit is offloaded to client
		_unitAI addeventhandler ["Fired", {(vehicle (_this select 0)) setvehicleammo 1;}];
	};

{
	_unitAI setSkill _x;
} forEach (missionNamespace getVariable [format["DMS_ai_skill_%1",_difficulty],[]]);


// Soldier killed event handler
_unitAI addMPEventHandler ["MPKilled",'if (isServer) then {_this call DMS_fnc_OnKilled;};'];

{
	_unitAI enableAI _x;
} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];

if (_difficulty=="hardcore") then
{
	// Make him a little bit harder ;)
	{
		_unitAI disableAI _x;
	} forEach ["SUPPRESSION", "AIMINGERROR"];
};

_unit setCustomAimCoef (missionNamespace getVariable [format["DMS_AI_AimCoef_%1",_difficulty], 0.7]);
_unit enableStamina (missionNamespace getVariable [format["DMS_AI_EnableStamina_%1",_difficulty], true]);
