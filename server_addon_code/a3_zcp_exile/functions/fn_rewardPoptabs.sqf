private['_ZCP_RPT_awardToGive','_ZCP_RPT_playerMoney','_ZCP_RPT_currentCapper','_ZCP_RPT_capName'];

_ZCP_RPT_currentCapper = _this select 0;
_ZCP_RPT_capName = _this select 1;

_ZCP_RPT_awardToGive = ZCP_MinPoptabReward;
if(ZCP_RewardRelativeToPlayersOnline) then {
    _ZCP_RPT_awardToGive = _ZCP_RPT_awardToGive + (ZCP_PoptabReward) * (count playableUnits);
};
_ZCP_RPT_playerMoney = _ZCP_RPT_currentCapper getVariable ["ExileMoney", 0];
_ZCP_RPT_playerMoney = _ZCP_RPT_playerMoney + _ZCP_RPT_awardToGive;

_ZCP_RPT_currentCapper setVariable ["ExileMoney", _ZCP_RPT_playerMoney];
_ZCP_RPT_currentCapper setVariable['PLAYER_STATS_VAR', [_ZCP_RPT_playerMoney, _ZCP_RPT_currentCapper getVariable ['ExileScore', 0]],true];

format["setAccountMoney:%1:%2", _ZCP_RPT_playerMoney, (getPlayerUID _ZCP_RPT_currentCapper)] call ExileServer_system_database_query_fireAndForget;

['Money',[_ZCP_RPT_currentCapper, "moneyReceivedRequest", [str _ZCP_RPT_playerMoney, format ["ZCP Poptabs reward"]]]] call ZCP_fnc_showNotification;

diag_log format ["[ZCP]: %1 received %3 poptabs for %2.",name _ZCP_RPT_currentCapper,_ZCP_RPT_capName, _ZCP_RPT_awardToGive];
