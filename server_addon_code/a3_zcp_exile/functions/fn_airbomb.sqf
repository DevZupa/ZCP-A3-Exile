private ['_ZCP_AB_baseObjects','_ZCP_AB_capturePosition','_ZCP_AB_bombClass','_ZCP_AB_baseRadius','_ZCP_AB_allObject'];
_ZCP_AB_baseObjects = _this select 0;
_ZCP_AB_capturePosition = _this select 1;
_ZCP_AB_baseRadius = _this select 2;
_ZCP_AB_bombClass = "Bomb_03_F";

_ZCP_AB_allObject = [];

if (!ZCP_BomberCanDestroyMapBuildings) then {
_ZCP_AB_allObject = _ZCP_AB_capturePosition nearObjects (_ZCP_AB_baseRadius + 50 );
_ZCP_AB_allObject = _ZCP_AB_allObject - nearestObjects [_ZCP_AB_capturePosition,["Man", "Air", "Car", "Motorcycle", "Tank"], (_ZCP_AB_baseRadius + 50)];
    {
        _x allowDamage false;
    }count _ZCP_AB_allObject;
};

for "_i" from 1 to 3 do {
	private ['_ZCP_AB_bomb1','_ZCP_AB_bomb2'];
	_ZCP_AB_bomb1 = _ZCP_AB_bombClass createVehicle ([(_ZCP_AB_capturePosition select 0) + 20,(_ZCP_AB_capturePosition select 1) + ((2 - _i) * 10), 20]);
	_ZCP_AB_bomb2 = _ZCP_AB_bombClass createVehicle ([(_ZCP_AB_capturePosition select 0) - 20,(_ZCP_AB_capturePosition select 1) + ((2 - _i) * 10), 20]);
	_ZCP_AB_bomb1 setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
	_ZCP_AB_bomb2 setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
};

uiSleep 2;
// cleanup most of the base after it is destroyed. some rubble is left behind.
_ZCP_AB_baseObjects call ZCP_fnc_cleanupBase;
[_ZCP_AB_capturePosition, _ZCP_AB_baseRadius] call ZCP_fnc_deleteRuins;
[_ZCP_AB_capturePosition, _ZCP_AB_baseRadius] call ZCP_fnc_deleteLoot;

uiSleep 20;

if (!ZCP_BomberCanDestroyMapBuildings) then {
    {
        if( !isNull _x) then {
            _x allowDamage true;
        };
    }count _ZCP_AB_allObject;
};
