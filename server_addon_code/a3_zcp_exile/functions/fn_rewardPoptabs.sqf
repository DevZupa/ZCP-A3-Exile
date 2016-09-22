params
[
    "_ZCP_RPT_currentCapper",
    "_ZCP_RPT_capName"
];

private _ZCP_RPT_awardToGive = ZCP_MinPoptabReward;

if(ZCP_RewardRelativeToPlayersOnline) then
  {
    _ZCP_RPT_awardToGive = _ZCP_RPT_awardToGive + (ZCP_PoptabReward) * (count allPlayers);
  };

private _ZCP_RPT_playerMoney = (_ZCP_RPT_currentCapper getVariable ["ExileMoney", 0]) + _ZCP_RPT_awardToGive;

_ZCP_RPT_currentCapper setVariable ["ExileMoney", _ZCP_RPT_playerMoney, true];

// Poptabs should be automatically saved periodically
format["setPlayerMoney:%1:%2", _ZCP_RPT_playerMoney, (getPlayerUID _ZCP_RPT_currentCapper)] call ExileServer_system_database_query_fireAndForget;

['PersonalNotification', ["ZCP",[format[[17] call ZCP_fnc_translate, _ZCP_RPT_awardToGive]],'ZCP_Capping'], _ZCP_RPT_currentCapper] call ZCP_fnc_showNotification;

diag_log text format ["[ZCP]: %1 received %3 poptabs for %2.",name _ZCP_RPT_currentCapper,_ZCP_RPT_capName, _ZCP_RPT_awardToGive];
