private['_theFlagPos','_theFlagX','_theFlagY','_XChange','_YChange','_ZCP_baseObjects','_ZCP_baseClasses'];
_ZCP_baseObjects = [];
_ZCP_baseClasses = call compile preprocessFileLineNumbers (_this select 0);
_capturePosition = _this select 1;
_theFlagPos =  call compile ((_ZCP_baseClasses select 0) select 1);
_theFlagX = _theFlagPos select 0;
_theFlagY = _theFlagPos select 1;
_XChange = _capturePosition select 0;
_YChange = _capturePosition select 1;

{
  private['_newPos', '_pos', '_obj', '_dat'];
  _dat = _x;
	_obj = createVehicle [(_dat select 0), [0,0,0], [], 0, "CAN_COLLIDE"];
	if((_dat select 4) == 0) then {_obj enableSimulation false};
	if((_dat select 8) == 0) then {_obj allowDamage false};
	_obj setdir (_dat select 2);
	_pos = call compile (_dat select 1);
	_newPos = [((_pos select 0) - _theFlagX + _XChange), ((_pos select 1) - _theFlagY + _YChange),(_pos select 2)];
	if((_dat select 3) == -100) then
	{
		_obj setposATL _newPos;
		if((_dat select 5) == 0) then {_obj setVectorUp [0,0,1]} else {_obj setVectorUp (surfacenormal (getPosATL _obj))};
	}
	else
	{
		_obj setposworld _newPos;
		[_obj,((_dat select 7) select 0),((_dat select 7) select 1)] call BIS_fnc_setPitchBank;
	};
	if(count (_dat select 6) > 0) then {{call _x} foreach (_dat select 6)};

  _nil = _ZCP_baseObjects pushBack _obj;
} count _ZCP_baseClasses;

_ZCP_baseObjects
