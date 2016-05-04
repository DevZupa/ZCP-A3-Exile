private['_ZCP_RBB_capturePosition','_ZCP_RBB_currentCapper','_ZCP_RBB_capName','_ZCP_RBB_captureRadius'];

_ZCP_RBB_currentCapper = _this select 0;
_ZCP_RBB_capName = _this select 1;
_ZCP_RBB_capturePosition = _this select 2;
_ZCP_RBB_captureRadius = _this select 4;

_ZCP_RBB_capturePosition set[0, (_ZCP_RBB_capturePosition select 0) + _ZCP_RBB_captureRadius];
_ZCP_RBB_capturePosition set[1, (_ZCP_RBB_capturePosition select 1) + _ZCP_RBB_captureRadius];

[_ZCP_RBB_capturePosition,'BuildBox'] spawn ZCP_fnc_spawnCrate;

diag_log format ["[ZCP]: %1 received a buildbox for %2.",name _ZCP_RBB_currentCapper,_ZCP_RBB_capName];
