private ['_objects','_flag','_ammo', '_capturePosition', '_ZCP_baseRadius'];
_objects = _this select 0;
_capturePosition = _this select 1;
_ZCP_baseRadius = _this select 2;

_ammo = "Bomb_03_F";
for "_i" from 1 to 3 do {
	private ['_bomb','_bomb2'];
	_bomb = _ammo createvehicle ([(_capturePosition select 0) + 20,(_capturePosition select 1) + ((2 - _i) * 10), 20]);
	_bomb2 = _ammo createvehicle ([(_capturePosition select 0) - 20,(_capturePosition select 1) + ((2 - _i) * 10), 20]);
	_bomb setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
	_bomb2 setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
};

uiSleep 2;

_objects call ZCP_fnc_cleanupBase;
[_capturePosition, _ZCP_baseRadius] call ZCP_fnc_deleteRuins;
[_capturePosition, _ZCP_baseRadius] call ZCP_fnc_deleteLoot;
