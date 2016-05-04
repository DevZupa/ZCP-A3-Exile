private['_capturePosition','_ZCP_currentCapper','_ZCP_name','_captureRadius'];

_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;
_captureRadius = _this select 4;

_capturePosition set[0, (_capturePosition select 0) + _captureRadius];
_capturePosition set[1, (_capturePosition select 1) + _captureRadius];

[_capturePosition,'BuildBox'] spawn ZCP_fnc_spawnCrate;

diag_log format ["[ZCP]: %1 received a buildbox for %2.",name _ZCP_currentCapper,_ZCP_name];
