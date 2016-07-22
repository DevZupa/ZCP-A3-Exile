private["_ZCP_SC_box","_ZCP_SC_type","_ZCP_SC_pos", "_ZCP_SC_boxType","_ZCP_SC_loot"];
_ZCP_SC_pos = _this select 0;
_ZCP_SC_type = _this select 1;

switch (_ZCP_SC_type) do {
    case 'BuildBox': {
      _ZCP_SC_boxType = ZCP_BuildingBox;
    };
    case 'WeaponBox': {
      _ZCP_SC_boxType = ZCP_WeaponBox;
    };
    case 'SurvivalBox': {
      _ZCP_SC_boxType = ZCP_SurvivalBox;
    };
    default {
      _ZCP_SC_boxType = ZCP_WeaponBox;
    };
};

_ZCP_SC_box = _ZCP_SC_boxType createVehicle [0,0,150];
_ZCP_SC_box allowDamage false;
_ZCP_SC_box setDir random 360;
_ZCP_SC_box setPos [_ZCP_SC_pos select 0,_ZCP_SC_pos select 1,150];
_ZCP_SC_box call ZCP_fnc_paraDrop;

clearWeaponCargoGlobal _ZCP_SC_box;
clearMagazineCargoGlobal _ZCP_SC_box;
clearBackpackCargoGlobal _ZCP_SC_box;
clearItemCargoGlobal _ZCP_SC_box;

// You can add extra types here by coping a 'case' and it's content and giving it a unique name

switch (_ZCP_SC_type) do {
    case 'BuildBox': {
      [
        _ZCP_SC_box,
        [
          1 + floor random 3,		// Weapons
          [10 + (floor random 15),DMS_BoxBuildingSupplies],		// Items
          1 + floor random 3 		// Backpacks
        ],
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
    case 'WeaponBox': {
      _ZCP_SC_loot = [
        6 + (floor random 5),		// Weapons
        4 + (floor random 4) ,		// Items
        1 + (floor random 2) 		// Backpacks
      ];
      [
        _ZCP_SC_box,
        _ZCP_SC_loot,
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
      case 'SniperWeaponBox': {
          [
             _ZCP_SC_box,
            "Sniper",
            ZCP_DMS_RareLootChance
          ]call ZCP_fnc_fillCrate;
        };
    case 'BigWeaponBox': {
          _ZCP_SC_loot = [
            10 + (floor random 10),		// Weapons
            4 + (floor random 4) ,		// Items
            2 + (floor random 2) 		// Backpacks
          ];
          [
            _ZCP_SC_box,
            _ZCP_SC_loot,
            ZCP_DMS_RareLootChance
          ]call ZCP_fnc_fillCrate;
        };
    case 'SurvivalBox': {
      _ZCP_SC_loot = [
        1,		// Weapons
        [10 + (floor random 10), ZCP_DMS_BoxSurvivalSupplies ],		// Items
        1		// Backpacks
      ];
      [
        _ZCP_SC_box,
        _ZCP_SC_loot,
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
    default {
      [_ZCP_SC_box,'WeaponBox'] call ZCP_fnc_fillBox;
    };
};



["ec_audacity.sqf","ec_bravery.sqf","ec_courage.sqf", "ec_defiance.sqf","ec_endurance.sqf","ec_fortitude.sqf","m3e_exoBase1.sqf","m3e_exoBase2.sqf","m3e_exoBase3.sqf"]