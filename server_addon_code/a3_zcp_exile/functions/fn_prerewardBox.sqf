params[
    '_ZCP_RV_capturePosition',
    '_ZCP_RV_captureRadius',
    '_ZCP_RV_boxType'
];

private _ZCP_RV_boxTypeClass = ZCP_WeaponBox;

switch (_ZCP_RV_boxType) do {
    case 'BuildBox': {
      _ZCP_RV_boxTypeClass = ZCP_BuildingBox;
    };
    case 'SurvivalBox': {
      _ZCP_RV_boxTypeClass = ZCP_SurvivalBox;
    };
};

private _ZCP_RV_posVehicle = _ZCP_RV_capturePosition findEmptyPosition [0, _ZCP_RV_captureRadius , _ZCP_RV_boxTypeClass];

private _ZCP_RV_box = _ZCP_RV_boxTypeClass createVehicle _ZCP_RV_posVehicle;
_ZCP_RV_box allowDamage false;
_ZCP_RV_box setDir random 360;

clearWeaponCargoGlobal _ZCP_RV_box;
clearMagazineCargoGlobal _ZCP_RV_box;
clearBackpackCargoGlobal _ZCP_RV_box;
clearItemCargoGlobal _ZCP_RV_box;

_ZCP_RV_box
