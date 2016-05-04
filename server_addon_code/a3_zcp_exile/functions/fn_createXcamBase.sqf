private['_ZCP_CXB_theFlagPos','_ZCP_CXB_theFlagX','_ZCP_CXB_theFlagY','_ZCP_CXB_xChange','_ZCP_CXB_yChange','_ZCP_CXB_baseObjects','_ZCP_CXB_baseClasses','_ZCP_CXB_capturePosition'];
_ZCP_CXB_baseObjects = [];
_ZCP_CXB_baseClasses = call compile preprocessFileLineNumbers (_this select 0);
_ZCP_CXB_capturePosition = _this select 1;
_ZCP_CXB_theFlagPos =  call compile ((_ZCP_CXB_baseClasses select 0) select 1);
_ZCP_CXB_theFlagX = _ZCP_CXB_theFlagPos select 0;
_ZCP_CXB_theFlagY = _ZCP_CXB_theFlagPos select 1;
_ZCP_CXB_xChange = _ZCP_CXB_capturePosition select 0;
_ZCP_CXB_yChange = _ZCP_CXB_capturePosition select 1;

{
  private['_ZCP_CXB_newPos', '_ZCP_CXB_pos', '_ZCP_CXB_obj', '_ZCP_CXB_objData'];
  _ZCP_CXB_objData = _x;
	_ZCP_CXB_obj = createVehicle [(_ZCP_CXB_objData select 0), [0,0,0], [], 0, "CAN_COLLIDE"];
	if((_ZCP_CXB_objData select 4) == 0) then {_ZCP_CXB_obj enableSimulation false};
	if((_ZCP_CXB_objData select 8) == 0) then {_ZCP_CXB_obj allowDamage false};
	_ZCP_CXB_obj setDir (_ZCP_CXB_objData select 2);
	_ZCP_CXB_pos = call compile (_ZCP_CXB_objData select 1);
	_ZCP_CXB_newPos = [((_ZCP_CXB_pos select 0) - _ZCP_CXB_theFlagX + _ZCP_CXB_xChange), ((_ZCP_CXB_pos select 1) - _ZCP_CXB_theFlagY + _ZCP_CXB_yChange),(_ZCP_CXB_pos select 2)];
	if((_ZCP_CXB_objData select 3) == -100) then
	{
		_ZCP_CXB_obj setPosATL _ZCP_CXB_newPos;
		if((_ZCP_CXB_objData select 5) == 0) then {_ZCP_CXB_obj setVectorUp [0,0,1]} else {_ZCP_CXB_obj setVectorUp (surfacenormal (getPosATL _ZCP_CXB_obj))};
	}
	else
	{
		_ZCP_CXB_obj setPosWorld _ZCP_CXB_newPos;
		[_ZCP_CXB_obj,((_ZCP_CXB_objData select 7) select 0),((_ZCP_CXB_objData select 7) select 1)] call BIS_fnc_setPitchBank;
	};
	if(count(_ZCP_CXB_objData select 6) > 0) then {
        {
            call _x;
        } forEach (_ZCP_CXB_objData select 6);
	};

  _nil = _ZCP_CXB_baseObjects pushBack _ZCP_CXB_obj;
} count _ZCP_CXB_baseClasses;

_ZCP_CXB_baseObjects
