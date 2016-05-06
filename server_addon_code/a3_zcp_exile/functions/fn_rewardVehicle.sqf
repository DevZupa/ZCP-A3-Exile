private['_ZCP_RV_capturePosition','_ZCP_RV_currentCapper','_ZCP_RV_name',"_ZCP_RV_vehicle","_ZCP_RV_vehicleClass",
"_ZCP_RV_cfg","_ZCP_RV_vehicleName","_ZCP_RV_captureRadius","_ZCP_RV_newThis"];

_ZCP_RV_currentCapper = _this select 0;
_ZCP_RV_name = _this select 1;
_ZCP_RV_capturePosition = _this select 2;
_ZCP_RV_captureRadius = _this select 4;

if (ZCP_DisableVehicleReward) then {
    _ZCP_RV_newThis = +_this;
    _ZCP_RV_newThis set[3, ["Random"]];
    _ZCP_RV_newThis call ZCP_fnc_giveReward;
} else {
  _ZCP_RV_vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
  _ZCP_RV_cfg  = (configFile >>  "CfgVehicles" >>  _ZCP_RV_vehicleClass);
    _ZCP_RV_vehicleName = if (isText(_ZCP_RV_cfg >> "displayName")) then {
        getText(_ZCP_RV_cfg >> "displayName")
       }
    else {
        _ZCP_RV_vehicleClass
    };

  _ZCP_RV_vehicle = _ZCP_RV_vehicleClass createVehicle [0,0,150];
  clearWeaponCargoGlobal _ZCP_RV_vehicle;
  clearMagazineCargoGlobal _ZCP_RV_vehicle;
  clearBackpackCargoGlobal _ZCP_RV_vehicle;
  clearItemCargoGlobal _ZCP_RV_vehicle;
  _ZCP_RV_vehicle setDir random 360;
  _ZCP_RV_vehicle setPos [(_ZCP_RV_capturePosition select 0) + _ZCP_RV_captureRadius ,(_ZCP_RV_capturePosition select 1) + _ZCP_RV_captureRadius, 150];
  _ZCP_RV_vehicle call ZCP_fnc_paraDrop;

  diag_log text format ["[ZCP]: %1 received a %3 for %2.",name _ZCP_RV_currentCapper,_ZCP_RV_name, _ZCP_RV_vehicleName];
};
