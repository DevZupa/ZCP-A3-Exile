params[
  '_ZCP_CMB_baseFile',
  '_ZCP_CMB_capturePosition'
];

private _ZCP_CMB_baseObjects = [];

private _ZCP_CMB_baseClasses = call compile preprocessFileLineNumbers _ZCP_CMB_baseFile;

{
	private _ZCP_CMB_obj = (_x select 0) createVehicle [0,0,0];
	_ZCP_CMB_obj setPosASL _x select 1;
	_ZCP_CMB_obj setVectorDirAndUp (_x select 2);
	_ZCP_CMB_obj enableSimulationGlobal ((_x select 3) select 0);
	_ZCP_CMB_obj allowDamage true;
  _nil = _ZCP_CMB_baseObjects pushBack _ZCP_CMB_baseObjects;
} forEach _ZCP_CMB_baseClasses;

_ZCP_CMB_baseObjects
