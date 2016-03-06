private ['_objects','_flag','_ammo'];
_objects = _this;
_flag = _objects select 0;
_ammo = "Bomb_03_F";
for "_i" from 1 to 4 do {
	private ['_bomb','_bomb2'];
	_bomb = _ammo createvehicle ([(getPos _flag select 0) + 20,(getPos _flag select 1) + ((3 - _i) * 10), 20]);
	_bomb2 = _ammo createvehicle ([(getPos _flag select 0) - 20,(getPos _flag select 1) + ((3 - _i) * 10), 20]);
	_bomb setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
	_bomb2 setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
};

uiSleep 2;
// cleanup most of the base after it is destroyed. some rubble is left behind.
_objects call ZCP_fnc_cleanupBase;
