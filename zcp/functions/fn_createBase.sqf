private ["_ZCP_baseObjects"];
_ZCP_baseObjects = [];
{ 
	private ["_obj","_pos","_nil","_newPos"];
	_obj = createVehicle [_x select 0, [0,0,0], [], 0, "CAN_COLLIDE"];
	_pos = _x select 1;
	_newPos = [((_pos select 0) - _theFlagX + _XChange), ((_pos select 1) - _theFlagY + _YChange),(_pos select 2)];
	if (_x select 4) then {
		_obj setDir (_x select 2);		
		_obj setPos _newPos; 
	} else {
		_obj setPosATL _newPos; 
		_obj setVectorDirAndUp (_x select 3);
	};
	_nil = _ZCP_baseObjects pushBack _obj;
		
}count _this;

_ZCP_baseObjects