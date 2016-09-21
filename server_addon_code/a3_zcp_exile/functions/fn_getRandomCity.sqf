private _ZCP_GRC_isInVallidTown = true;
private _ZCP_GRC_town = [];

if(count ZCP_Towns > 0) then
{
    while
        {
            _ZCP_GRC_isInVallidTown
        }
    do
        {
            _ZCP_GRC_isInVallidTown = false;

            _ZCP_GRC_town = ZCP_Towns call BIS_fnc_selectRandom;

            // _ZCP_GRC_town = [ location, radius, name, (optional) basearray];

            diag_log text format['[ZCP]: Trying town: %1',  _ZCP_GRC_town select 2];

            private _ZCP_GRC_position = _ZCP_GRC_town select 0;

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
