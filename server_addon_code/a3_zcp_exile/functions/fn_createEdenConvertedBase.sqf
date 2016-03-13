private ["_ZCP_baseObjects","_theFlagPos","_theFlagX","_theFlagY","_XChange","_YChange","_capturePosition", "_ZCP_baseClasses"];
_ZCP_baseObjects = [];

_ZCP_baseClasses = call compile preprocessFileLineNumbers (_this select 0);

_capturePosition = _this select 1;
_theFlagPos = _ZCP_baseClasses select 0;
_theFlagX = _theFlagPos select 1;
_theFlagY = _theFlagPos select 2;
_XChange = _capturePosition select 0;
_YChange = _capturePosition select 1;

{
	private ["_obj","_pos","_nil","_newPos","_objName"];
	_objName = format["Land_%1", _x select 0];
	systemChat _objName;
	_obj = createVehicle [_objName, [0,0,0], [], 0, "CAN_COLLIDE"];
	_pos = [_x select 1, _x select 2, 0 ];
	_newPos = [((_pos select 0) - _theFlagX + _XChange), ((_pos select 1) - _theFlagY + _YChange),(_pos select 2)];
	_obj setDir (_x select 3);
	_obj setPos _newPos;
	_nil = _ZCP_baseObjects pushBack _obj;
}count (_ZCP_baseClasses);

_ZCP_baseObjects
