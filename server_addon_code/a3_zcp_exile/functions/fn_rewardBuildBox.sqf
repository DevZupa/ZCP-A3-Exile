private['_capturePosition','_ZCP_currentCapper','_ZCP_name','_captureRadius'];

_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;
_captureRadius = _this select 4;

_capturePosition set[0, (_capturePosition select 0) + _captureRadius];
_capturePosition set[1, (_capturePosition select 1) + _captureRadius];

[_capturePosition,'BuildBox'] spawn ZCP_fnc_spawnCrate;

PV_ZCP_zupastic = ["ZCP",[format[[11] call ZCP_fnc_translate]], 'ZCP_Capped'];
owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic";

diag_log format ["[ZCP]: %1 won %2, received a buildbox.",name _ZCP_currentCapper,_ZCP_name];

_this set[3, "Reputation"];
_this call ZCP_fnc_giveReward;
