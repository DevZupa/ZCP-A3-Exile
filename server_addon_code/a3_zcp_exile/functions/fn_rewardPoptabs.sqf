private['_awardToGive','_playerMoney','_capturePosition','_ZCP_currentCapper','_ZCP_name'];

_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;

_awardToGive = ZCP_MinPoptabReward;
if(ZCP_RewardRelativeToPlayersOnline) then {
    _awardToGive = _awardToGive + (ZCP_PoptabReward) * (count playableUnits);
};
_playerMoney = _ZCP_currentCapper getVariable ["ExileMoney", 0];
_playerMoney = _playerMoney + _awardToGive;

_ZCP_currentCapper setVariable ["ExileMoney", _playerMoney];
_ZCP_currentCapper setVariable['PLAYER_STATS_VAR', [_playerMoney, _ZCP_currentCapper getVariable ['ExileScore', 0]],true];

format["setAccountMoney:%1:%2", _playerMoney, (getPlayerUID _ZCP_currentCapper)] call ExileServer_system_database_query_fireAndForget;

['PersonalNotification', ["ZCP",[format[[12] call ZCP_fnc_translate]], 'ZCP_Capped'], _ZCP_currentCapper] call ZCP_fnc_showNotification;

['Money',[_ZCP_currentCapper, "moneyReceivedRequest", [str _playerMoney, format ["ZCP Poptabs reward"]]]] call ZCP_fnc_showNotification;

if(ZCP_giveSurvivalBoxWithPoptabsReward) then {
  _this set [3, "SurvivalBox"];
  _this set [4, true];
  _this call ZCP_fnc_giveReward;
  diag_log format ["[ZCP]: %1 won %2, received %3 Poptabs and a Survivalbox.",name _ZCP_currentCapper,_ZCP_name,_awardToGive];
} else {
  diag_log format ["[ZCP]: %1 won %2, received %3 Poptabs.",name _ZCP_currentCapper,_ZCP_name,_awardToGive];
};



_this set[3, "Reputation"];
_this call ZCP_fnc_giveReward;
