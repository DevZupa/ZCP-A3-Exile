params
[
    "_ZCP_RPT_currentCapper",
    "_ZCP_RPT_capName"
];


private _ZCP_RPT_awardToGive = ZCP_MinPoptabReward;
if(ZCP_RewardRelativeToPlayersOnline) then {
    _ZCP_RPT_awardToGive = _ZCP_RPT_awardToGive + (ZCP_PoptabReward) * (count allPlayers);
};

private _ZCP_RPT_playerMoney = (_ZCP_RPT_currentCapper getVariable ["ExileMoney", 0]) + _ZCP_RPT_awardToGive;

_ZCP_RPT_currentCapper setVariable ["ExileMoney", _ZCP_RPT_playerMoney, true];

// Poptabs should be automatically saved periodically
//format["setAccountMoney:%1:%2", _ZCP_RPT_playerMoney, (getPlayerUID _ZCP_RPT_currentCapper)] call ExileServer_system_database_query_fireAndForget;


// send notification
[
    _ZCP_RPT_currentCapper,
    "toastRequest",
    ["SuccessTitleAndText", ["ZCP Poptabs Reward", _ZCP_RPT_awardToGive]];
] call ExileServer_system_network_send_to;

diag_log format ["[ZCP]: %1 received %3 poptabs for %2.",name _ZCP_RPT_currentCapper,_ZCP_RPT_capName, _ZCP_RPT_awardToGive];
