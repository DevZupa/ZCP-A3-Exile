private ["_ZCP_CMB_baseObjects","_ZCP_CMB_theFlagPos","_ZCP_CMB_theFlagX","_ZCP_CMB_theFlagY","_ZCP_CMB_xChange","_ZCP_CMB_yChange","_ZCP_CMB_capturePosition", "_ZCP_CMB_baseClasses"];
_ZCP_CMB_baseObjects = [];

_ZCP_CMB_baseClasses = call compile preprocessFileLineNumbers (_this select 0);

_ZCP_CMB_capturePosition = _this select 1;
_ZCP_CMB_theFlagPos = (_ZCP_CMB_baseClasses select 0) select 1;
_ZCP_CMB_theFlagX = _ZCP_CMB_theFlagPos select 0;
_ZCP_CMB_theFlagY = _ZCP_CMB_theFlagPos select 1;
_ZCP_CMB_xChange = _ZCP_CMB_capturePosition select 0;
_ZCP_CMB_yChange = _ZCP_CMB_capturePosition select 1;

{
    private ["_ZCP_CMB_obj","_ZCP_CMB_pos","_nil","_ZCP_CMB_newPos"];
	_ZCP_CMB_obj = (_x select 0) createVehicle [0,0,0];

	_ZCP_CMB_pos = _x select 1;
  _ZCP_CMB_newPos = [((_ZCP_CMB_pos select 0) - _ZCP_CMB_theFlagX + _ZCP_CMB_xChange), ((_ZCP_CMB_pos select 1) - _ZCP_CMB_theFlagY + _ZCP_CMB_yChange),(_ZCP_CMB_pos select 2)];

	_ZCP_CMB_obj setPosASL _ZCP_CMB_newPos;
	_ZCP_CMB_obj setVectorDirAndUp (_x select 2);
	_ZCP_CMB_obj enableSimulationGlobal ((_x select 3) select 0);
	_ZCP_CMB_obj allowDamage true;
} forEach _ZCP_CMB_baseClasses;

_ZCP_CMB_baseObjects
