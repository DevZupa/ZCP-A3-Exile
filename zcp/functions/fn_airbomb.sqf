private ['_objects','_flag','_ammo'];
_objects = _this;
_flag = _objects select 0;
_ammo = "Bomb_03_F";
for "_i" from 1 to 8 do {
	private ['_bomb'];
	_bomb = _ammo createvehicle ([getPos _flag select 0,getPos _flag select 1, 20]);
	_bomb setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
};

uiSleep 2;
// cleanup base after it is destroyed.
_objects call ZCP_fnc_cleanupBase;
