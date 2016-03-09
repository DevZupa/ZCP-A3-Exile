private['_capturePosition','_ZCP_currentCapper','_ZCP_name',"_vehicle","_vehicleClass","_cfg","_name"];

_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;

if(ZCP_DisableVehicleReward)then{
  [_ZCP_currentCapper,_ZCP_name,_capturePosition,"Random"] call ZCP_fnc_giveReward;
}else{
  _vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
  _cfg  = (configFile >>  "CfgVehicles" >>  _vehicleClass);
    _name = if (isText(_cfg >> "displayName")) then {
        getText(_cfg >> "displayName")
       }
    else {
        _vehicleClass
    };

  _vehicle = _vehicleClass createVehicle [0,0,150];
  clearWeaponCargoGlobal _vehicle;
  clearMagazineCargoGlobal _vehicle;
  clearBackpackCargoGlobal _vehicle;
  clearItemCargoGlobal _vehicle;
  _vehicle setDir random 360;
  _vehicle setPos [_capturePosition select 0,_capturePosition select 1,150];
  _vehicle call ZCP_fnc_paraDrop;

  ['PersonalNotification', ["ZCP",[format[[11] call ZCP_fnc_translate]], 'ZCP_Capped'], _ZCP_currentCapper] call ZCP_fnc_showNotification;

  diag_log text format ["[ZCP]: %1 won %2, received a %3.",name _ZCP_currentCapper,_ZCP_name, _vehicleClass];

  _this set[3, "Reputation"];
  _this call ZCP_fnc_giveReward;
};
