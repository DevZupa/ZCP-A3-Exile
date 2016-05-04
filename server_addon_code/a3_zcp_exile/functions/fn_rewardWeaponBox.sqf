private['_ZCP_RWB_capturePosition','_ZCP_RWB_currentCapper','_ZCP_RWB_capName','_ZCP_RWB_captureRadius'];

_ZCP_RWB_currentCapper = _this select 0;
_ZCP_RWB_capName = _this select 1;
_ZCP_RWB_capturePosition = _this select 2;
_ZCP_RWB_captureRadius = _this select 4;

_ZCP_RWB_capturePosition set[0, (_ZCP_RWB_capturePosition select 0) + _ZCP_RWB_captureRadius];
_ZCP_RWB_capturePosition set[1, (_ZCP_RWB_capturePosition select 1) + _ZCP_RWB_captureRadius];

[_ZCP_RWB_capturePosition, 'WeaponBox'] spawn ZCP_fnc_spawnCrate;

diag_log text format ["[ZCP]: %1 received a weaponbox for %2.",name _ZCP_RWB_currentCapper,_ZCP_RWB_capName];

