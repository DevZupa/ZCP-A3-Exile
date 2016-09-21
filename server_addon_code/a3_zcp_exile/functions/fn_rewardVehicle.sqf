params [
    '_ZCP_RV_Data',
    '_ZCP_RV_preVechicle'
];

private _ZCP_RV_currentCapper = _ZCP_RV_Data select 0;
private _ZCP_RV_name = _ZCP_RV_Data select 1;
private _ZCP_RV_capturePosition = _ZCP_RV_Data select 2;
private _ZCP_RV_captureRadius = _ZCP_RV_Data select 4;

private _ZCP_RV_vehicleName = "";

if(_ZCP_RV_preVechicle isEqualTo objNull) then {
    private _ZCP_RV_vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
    private _ZCP_RV_cfg  = (configFile >>  "CfgVehicles" >>  _ZCP_RV_vehicleClass);
    _ZCP_RV_vehicleName = if (isText(_ZCP_RV_cfg >> "displayName")) then {
        getText(_ZCP_RV_cfg >> "displayName")
       }
    else {
        _ZCP_RV_vehicleClass
    };

    private _ZCP_RV_vehicle = _ZCP_RV_vehicleClass createVehicle [0,0,150];

    clearWeaponCargoGlobal _ZCP_RV_vehicle;
    clearMagazineCargoGlobal _ZCP_RV_vehicle;
    clearBackpackCargoGlobal _ZCP_RV_vehicle;
    clearItemCargoGlobal _ZCP_RV_vehicle;

    if (_ZCP_RV_vehicleClass isKindOf "I_UGV_01_F") then
    {
    	createVehicleCrew _ZCP_RV_vehicle;
    };
    if (getNumber (configFile >> "CfgSettings" >> "VehicleSpawn" >> "nightVision") isEqualTo 0) then
    {
    	_ZCP_RV_vehicle disableNVGEquipment true;
    };
    if (getNumber (configFile >> "CfgSettings" >> "VehicleSpawn" >> "thermalVision") isEqualTo 0) then
    {
    	_ZCP_RV_vehicle disableTIEquipment true;
    };

    _ZCP_RV_vehicle setDir random 360;
    _ZCP_RV_vehicle setPos [(_ZCP_RV_capturePosition select 0) + _ZCP_RV_captureRadius ,(_ZCP_RV_capturePosition select 1) + _ZCP_RV_captureRadius, 150];
    _ZCP_RV_vehicle call ZCP_fnc_paraDrop;


} else {

    clearWeaponCargoGlobal _ZCP_RV_preVechicle;
    clearMagazineCargoGlobal _ZCP_RV_preVechicle;
    clearBackpackCargoGlobal _ZCP_RV_preVechicle;
    clearItemCargoGlobal _ZCP_RV_preVechicle;
    _ZCP_RV_preVechicle allowDamage true;
    _ZCP_RV_preVechicle lock false;

     private _smoke = "smokeShellPurple" createVehicle getPosATL _ZCP_RV_preVechicle;
    _smoke setPosATL (getPosATL _ZCP_RV_preVechicle);
    _smoke attachTo [_ZCP_RV_preVechicle,[0,0,0]];

    _ZCP_RV_vehicleName = name _ZCP_RV_preVechicle;
};

diag_log text format ["[ZCP]: %1 received a %3 for %2.",name _ZCP_RV_currentCapper,_ZCP_RV_name, _ZCP_RV_vehicleName];


