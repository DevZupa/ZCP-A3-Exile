/*
*   Creates a wave of ai attacking the zcp from 2 locations
*/
private['_ZCP_WA_unitsPerGroup','_ZCP_WA_amountOfGroups','_ZCP_WA_distanceFromZCP','_useGroundSpawn','_ZCP_WA_maxLaunchers',
'_ZCP_WA_useRandomGroupLocations','_ZCP_WA_spawnAIPos','_ZCP_WA_capturePosition','_ZCP_WA_waveData','_ZCP_WA_minLaunchers',
'_ZCP_WA_groups'
];

_ZCP_WA_groups = [];

switch (ZCP_AI_Type) do {
  case ('DMS'): {
    _ZCP_WA_waveData = _this select 0;
    _ZCP_WA_unitsPerGroup = _ZCP_WA_waveData select 1;
    _ZCP_WA_amountOfGroups = _ZCP_WA_waveData select 2;
    _ZCP_WA_distanceFromZCP = _ZCP_WA_waveData select 3;

    _ZCP_WA_useRandomGroupLocations = _ZCP_WA_waveData select 4;

    _ZCP_WA_minLaunchers = _this select 2;
    _ZCP_WA_maxLaunchers = _this select 3;

    _ZCP_WA_capturePosition = _this select 1;

    _ZCP_WA_spawnAIPos = [_ZCP_WA_capturePosition, (_ZCP_WA_distanceFromZCP - 50), (_ZCP_WA_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;

    for "_i" from 1 to _ZCP_WA_amountOfGroups do {
      private['_ZCP_WA_groupOfAI'];
      if(_ZCP_WA_useRandomGroupLocations) then {
        _ZCP_WA_spawnAIPos = [_ZCP_WA_capturePosition, (_ZCP_WA_distanceFromZCP - 50), (_ZCP_WA_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;
      };

      _ZCP_WA_spawnAIPos set [2, 0];

      _ZCP_WA_groupOfAI = [_ZCP_WA_spawnAIPos, _ZCP_WA_unitsPerGroup, "moderate", "random", EAST, _ZCP_WA_minLaunchers, _ZCP_WA_maxLaunchers] call ZCP_fnc_createDMSGroup;

      _ZCP_WA_groupOfAI setFormation "WEDGE";
      _ZCP_WA_groupOfAI setBehaviour "COMBAT";
      _ZCP_WA_groupOfAI setCombatMode "RED";

      [_ZCP_WA_groupOfAI, _ZCP_WA_capturePosition] call ZCP_fnc_createWaypoint;

       _ZCP_WA_groups pushBack _ZCP_WA_groupOfAI;
    };
  };
  case ('FUMS'): {
    diag_log format['[ZCP]: Calling FUMS AI for Wave.'];
    _ZCP_WA_headlessClients = entities "HeadlessClient_F";

    FuMS_ZCP_Handler = ['Wave',_this];

    {
      diag_log format['[ZCP]: Sending request to client %1', owner _x];
      (owner _x) publicVariableClient "FuMS_ZCP_Handler";
    }count _ZCP_WA_headlessClients;
  };
  default {
    diag_log format ['[ZCP]: No ai system chosen'];
  };
};

_ZCP_WA_groups