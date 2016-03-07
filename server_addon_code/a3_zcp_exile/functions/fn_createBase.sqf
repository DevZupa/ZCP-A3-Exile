private ["_ZCP_baseObjects"];
_ZCP_baseObjects = [];
//["Land_HBarrier_Big_F",[3255.96,8714.8,0],312.727,[[-0.734592,0.678509,0],[0,0,1]],false],
{
	private ["_obj","_pos","_nil","_newPos"];
	_obj = createVehicle [_x select 0, [0,0,0], [], 0, "CAN_COLLIDE"];
	_pos = _x select 1;
	_newPos = [((_pos select 0) - _theFlagX + _XChange), ((_pos select 1) - _theFlagY + _YChange),(_pos select 2)];
	//if (_x select 4) then { // put this back if u want to force the structure into specific positions
	if (true) then {
		_obj setDir (_x select 2);
		_obj setPos _newPos;
	} else {
		_obj setPosATL _newPos;
		_obj setVectorDirAndUp (_x select 3);
	};
	_nil = _ZCP_baseObjects pushBack _obj;
	uiSleep 0.1;

}count _this;

_ZCP_baseObjects
