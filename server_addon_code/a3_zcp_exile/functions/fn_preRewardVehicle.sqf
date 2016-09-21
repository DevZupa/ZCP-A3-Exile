params[
    '_ZCP_RV_capturePosition',
    '_ZCP_RV_captureRadius',
    '_ZCP_RV_isCity'
];

private _ZCP_RV_vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
private _ZCP_RV_posVehicle = [];

if(_ZCP_RV_isCity) then
  {
     _ZCP_RV_posVehicle = _ZCP_RV_capturePosition findEmptyPosition [0, (_ZCP_RV_captureRadius * 2), _ZCP_RV_vehicleClass];

     if(count _ZCP_RV_posVehicle < 1) then
       {
         _ZCP_RV_posVehicle = _ZCP_RV_capturePosition findEmptyPosition [0, (_ZCP_RV_captureRadius * 3), _ZCP_RV_vehicleClass];
       };
  }
else
  {
     _ZCP_RV_posVehicle = _ZCP_RV_capturePosition findEmptyPosition [_ZCP_RV_captureRadius, _ZCP_RV_captureRadius * 2, _ZCP_RV_vehicleClass];
  };

if(count _ZCP_RV_posVehicle < 1) exitWith
  {
    // No safe pos found. SO return nullObject -> This will trigger a parachute vehicle.
    objNull
  };

private _ZCP_RV_vehicle = _ZCP_RV_vehicleClass createVehicle _ZCP_RV_posVehicle;

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
_ZCP_RV_vehicle setPos _ZCP_RV_posVehicle;
_ZCP_RV_vehicle lock true;
_ZCP_RV_vehicle allowDamage false;

_ZCP_RV_vehicle setVariable ["ExileMoney",0,true];
_ZCP_RV_vehicle setVariable ["ExileIsPersistent", false];
_ZCP_RV_vehicle setVariable ["ExileIsSimulationMonitored", false];

_ZCP_RV_vehicle
