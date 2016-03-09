private['_capturePosition','_ZCP_currentCapper','_ZCP_name'];

_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;

[_capturePosition, 'WeaponBox'] spawn ZCP_fnc_spawnCrate;

['PersonalNotification',["ZCP",[format[[11] call ZCP_fnc_translate]], 'ZCP_Capped'], _ZCP_currentCapper] call ZCP_fnc_showNotification;

diag_log text format ["[ZCP]: %1 won %2, received a weaponbox.",name _ZCP_currentCapper,_ZCP_name];

_this set[3, "Reputation"];
_this call ZCP_fnc_giveReward;
