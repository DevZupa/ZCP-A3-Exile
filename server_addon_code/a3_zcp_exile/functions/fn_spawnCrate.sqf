params
[
	"_ZCP_SC_pos",
	"_ZCP_SC_type",
	"_ZCP_SC_preBox"
];

private _ZCP_SC_box = _ZCP_SC_preBox;

if(_ZCP_SC_box isEqualTo objNull) then {
    private _ZCP_SC_boxType = ZCP_WeaponBox;
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
    };

    _ZCP_SC_box = _ZCP_SC_boxType createVehicle [0,0,150];
    _ZCP_SC_box allowDamage false;
    _ZCP_SC_box setDir random 360;
    _ZCP_SC_box setPos [_ZCP_SC_pos select 0,_ZCP_SC_pos select 1,150];

    clearWeaponCargoGlobal _ZCP_SC_box;
    clearMagazineCargoGlobal _ZCP_SC_box;
    clearBackpackCargoGlobal _ZCP_SC_box;
    clearItemCargoGlobal _ZCP_SC_box;

    _ZCP_SC_box call ZCP_fnc_paraDrop;
} else {
    private _smoke = "smokeShellPurple" createVehicle getPosATL _ZCP_SC_box;
    _smoke setPosATL (getPosATL _ZCP_SC_box);
    _smoke attachTo [_ZCP_SC_box,[0,0,0]];
};

// You can add extra types here by copying a 'case' and it's content and giving it a unique name

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
      private _ZCP_SC_loot = [
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
          private _ZCP_SC_loot = [
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
      private _ZCP_SC_loot = [
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
      [_ZCP_SC_box, 'WeaponBox', _ZCP_SC_preBox] call ZCP_fnc_fillCrate;
    };
};
