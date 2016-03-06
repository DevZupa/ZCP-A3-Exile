private["_result","_position","_hasdebug","_xLeft","_xRight","_yTop","_yBottom"];
_result 		= false;
_position 		= _this;
_hasdebug 		= false;
_xLeft 			= 0;
_xRight 		= 0;
_yTop 			= 0;
_yBottom 		= 0;
call {
	if(worldName == "Takistan") 			exitWith { _hasdebug = true; _xLeft = 200; _xRight = 12600; _yTop = 12600; _yBottom = 200; };
	if(worldName == "Shapur_BA") 			exitWith { _hasdebug = true; _xLeft = 200; _xRight = 1900; _yTop = 1900; _yBottom = 200; };
	if(worldName == "Zargabad") 			exitWith { _hasdebug = true; _xLeft = 200; _xRight = 7963; _yTop = 8091; _yBottom = 200; };
	if(worldName == "ProvingGrounds_PMC")	exitWith { _hasdebug = true; _xLeft = 200; _xRight = 1900; _yTop = 1900; _yBottom = 200; };
	if(worldName == "Chernarus") 			exitWith { _hasdebug = true; _xLeft = 1000; _xRight = 13350; _yTop = 13350; _yBottom = 1000; };
	if(worldName == "sauerland") 			exitWith { _hasdebug = true; _xLeft = 1000; _xRight = 24400; _yTop = 24500; _yBottom = 1200; };
};
if(_hasdebug) then {
	if (_position select 0 < _xLeft) 	exitWith { _result = true; };
	if (_position select 0 > _xRight)	exitWith { _result = true; };
	if (_position select 1 > _yTop)		exitWith { _result = true; };
	if (_position select 1 < _yBottom)	exitWith { _result = true; };
};
_result