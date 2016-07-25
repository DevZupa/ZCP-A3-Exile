params [
    '_ZCP_GRC_whitelist',
    '_ZCP_GRC_blacklist'
];


private _ZCP_GRC_possibleTowns = [];

if( count _ZCP_GRC_whitelist == 0) then {
    _ZCP_GRC_possibleTowns = +ZCP_Towns;
    _ZCP_GRC_possibleTowns = _ZCP_GRC_possibleTowns - _ZCP_GRC_blacklist;
}
else
{
    _ZCP_GRC_possibleTowns = _ZCP_GRC_whitelist;
};

private _ZCP_GRC_isVallidTown = false;

private _ZCP_GRC_town = '';

while {_ZCP_GRC_isVallidTown} do
{
    _ZCP_GRC_isVallidTown = true;

    _ZCP_GRC_town = _ZCP_GRC_possibleTowns call BIS_fnc_selectRandom;

    if(([_ZCP_FP_position, ZCP_CONFIG_CityDistanceToTerritory] call ExileClient_util_world_isTerritoryInRange)) then { _ZCP_GRC_isVallidTown = false; };

    // is position in range of a trader zone?
    if(([_ZCP_FP_position, ZCP_CONFIG_CityDistanceToTrader] call ExileClient_util_world_isTraderZoneInRange)) then { _ZCP_GRC_isVallidTown = false; };

    // is position in range of a spawn zone?
    if(([_ZCP_FP_position, ZCP_CONFIG_CityDistanceToSpawn] call ExileClient_util_world_isSpawnZoneInRange)) then { _ZCP_GRC_isVallidTown = false; };

    // is position in range of a player?
    if(([_ZCP_FP_position, ZCP_CONFIG_CityDistanceToPlayer] call ExileClient_util_world_isAlivePlayerInRange)) then { _ZCP_GRC_isVallidTown = false; };

    sleep 1;
}