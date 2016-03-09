private["_box","_type","_pos"];
_pos = _this select 0;
_type = _this select 1;

_box = "Box_IND_AmmoVeh_F" createVehicle [0,0,150];
_box allowDamage false;
_box setDir random 360;
_box setPos [_pos select 0,_pos select 1,150];
_box call ZCP_fnc_paraDrop;

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;
clearItemCargoGlobal _box;
switch (_type) do {
    case 'BuildBox': {
      [
        _box,
        [
          1 + floor random 3,		// Weapons
          [10 + (floor random 15),DMS_BoxBuildingSupplies],		// Items
          1 + floor random 3 		// Backpacks
        ],
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
    case 'WeaponBox': {
      private["_loot","_random"];
      _loot = [
        6 + (floor random 10),		// Weapons
        4 + (floor random 4) ,		// Items
        1 + (floor random 2) 		// Backpacks
      ];
      [
        _box,
        _loot,
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
    case 'SurvivalBox': {
      private["_loot","_random"];
      _loot = [
        1,		// Weapons
        [10 + (floor random 10), ZCP_DMS_BoxSurvivalSupplies ],		// Items
        1		// Backpacks
      ];
      [
        _box,
        _loot,
        ZCP_DMS_RareLootChance
      ]call ZCP_fnc_fillCrate;
    };
    default {
      [_box,'WeaponBox'] call ZCP_fnc_fillBox;
    };
};
