private['_ZCP_RSV_capturePosition','_ZCP_RSV_currentCapper','_ZCP_RSV_capName','_ZCP_RSV_captureRadius'];

_ZCP_RSV_currentCapper = _this select 0;
_ZCP_RSV_capName = _this select 1;
_ZCP_RSV_capturePosition = _this select 2;
_ZCP_RSV_captureRadius = _this select 4;

_ZCP_RSV_capturePosition set[0, (_ZCP_RSV_capturePosition select 0) + _ZCP_RSV_captureRadius];
_ZCP_RSV_capturePosition set[1, (_ZCP_RSV_capturePosition select 1) + _ZCP_RSV_captureRadius];

[_ZCP_RSV_capturePosition,'SurvivalBox'] spawn ZCP_fnc_spawnCrate;

diag_log format ["[ZCP]: %1 received a survival box for %2.",name _ZCP_RSV_currentCapper,_ZCP_RSV_capName];