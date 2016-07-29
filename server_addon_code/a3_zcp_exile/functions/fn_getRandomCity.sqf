params [
    '_ZCP_GRC_whitelist',
    '_ZCP_GRC_blacklist'
];


private _ZCP_GRC_possibleTowns = [];
private _ZCP_GRC_isInVallidTown = true;
private _ZCP_GRC_town = [];

if( count _ZCP_GRC_whitelist == 0) then
{
    {
        private _town = _x select 0;
        if(	!(text _town in _ZCP_GRC_blacklist)) then
         {
            _nil = _ZCP_GRC_possibleTowns pushBack _x;
         }
    }count ZCP_TownsCalculated;
}
else
{
    {
        if(	(text _town in _ZCP_GRC_whitelist)) then
         {
            _nil = _ZCP_GRC_possibleTowns pushBack _x;
         }
    }count ZCP_TownsCalculated;
};

diag_log text format['[ZCP]: Possible Towns: %1', _ZCP_GRC_possibleTowns];

if(count _ZCP_GRC_possibleTowns > 0) then
{
    while
        {
        _ZCP_GRC_isInVallidTown
        }
    do
        {
            _ZCP_GRC_isInVallidTown = false;

            _ZCP_GRC_town = _ZCP_GRC_possibleTowns call BIS_fnc_selectRandom;

            diag_log text format['[ZCP]: Trying town: %1', text _ZCP_GRC_town];

            private _ZCP_GRC_position = _ZCP_GRC_town select 1;

            _ZCP_GRC_position set [2, 0];

            if(([_ZCP_GRC_position, ZCP_CONFIG_CityDistanceToTerritory] call ExileClient_util_world_isTerritoryInRange)) then { _ZCP_GRC_isInVallidTown = true; };

            // is position in range of a trader zone?
            if(([_ZCP_GRC_position, ZCP_CONFIG_CityDistanceToTrader] call ExileClient_util_world_isTraderZoneInRange)) then { _ZCP_GRC_isInVallidTown = true; };

            // is position in range of a spawn zone?
            if(([_ZCP_GRC_position, ZCP_CONFIG_CityDistanceToSpawn] call ExileClient_util_world_isSpawnZoneInRange)) then { _ZCP_GRC_isInVallidTown = true; };

            // is position in range of a player?
            if(([_ZCP_GRC_position, ZCP_CONFIG_CityDistanceToPlayer] call ExileClient_util_world_isAlivePlayerInRange)) then { _ZCP_GRC_isInVallidTown = true; };

            // is position is close to other AI:
            if( count (_ZCP_GRC_position nearEntities ["O_recon_F", ZCP_CONFIG_CityDistanceToAI])  > 0 ) then { _ZCP_GRC_isInVallidTown = true; };

            sleep 1;

        };
};

_ZCP_GRC_town
