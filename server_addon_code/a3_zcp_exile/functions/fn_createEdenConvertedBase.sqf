private ["_ZCP_CECB_baseObjects","_ZCP_CECB_theFlagPos","_ZCP_CECB_theFlagX","_ZCP_CECB_theFlagY","_ZCP_CECB_xChange","_ZCP_CECB_yChange","_ZCP_CECB_capturePosition", "_ZCP_CECB_baseClasses"];
_ZCP_CECB_baseObjects = [];

_ZCP_CECB_baseClasses = call compile preprocessFileLineNumbers (_this select 0);

_ZCP_CECB_capturePosition = _this select 1;
_ZCP_CECB_theFlagPos = _ZCP_CECB_baseClasses select 0;
_ZCP_CECB_theFlagX = _ZCP_CECB_theFlagPos select 1;
_ZCP_CECB_theFlagY = _ZCP_CECB_theFlagPos select 2;
_ZCP_CECB_xChange = _ZCP_CECB_capturePosition select 0;
_ZCP_CECB_yChange = _ZCP_CECB_capturePosition select 1;

{
	private ["_ZCP_CECB_obj","_ZCP_CECB_pos","_nil","_ZCP_CECB_newPos","_ZCP_CECB_objName"];
	_ZCP_CECB_objName = format["Land_%1", _x select 0];
	systemChat _ZCP_CECB_objName;
	_ZCP_CECB_obj = createVehicle [_ZCP_CECB_objName, [0,0,0], [], 0, "CAN_COLLIDE"];
	_ZCP_CECB_pos = [_x select 1, _x select 2, 0 ];
	_ZCP_CECB_newPos = [((_ZCP_CECB_pos select 0) - _ZCP_CECB_theFlagX + _ZCP_CECB_xChange), ((_ZCP_CECB_pos select 1) - _ZCP_CECB_theFlagY + _ZCP_CECB_yChange),(_ZCP_CECB_pos select 2)];
	_ZCP_CECB_obj setDir (_x select 3);
	_ZCP_CECB_obj setPos _ZCP_CECB_newPos;
	_nil = _ZCP_CECB_baseObjects pushBack _ZCP_CECB_obj;
}count (_ZCP_CECB_baseClasses);

_ZCP_CECB_baseObjects
