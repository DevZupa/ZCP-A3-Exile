/**
*   Creates a wave of ai attacking the zcp from 2 locations
*
*
*/
private['_unitsPerGroup','_amountOfGroups','_distanceFromZCP','_useGroundSpawn',
'_useRandomGroupLocations','_spawnAIPos','_capturePosition','_waveData'
];

switch (ZCP_AI_Type) do {
  case ('DMS'): {
    _waveData = _this select 0;
    _unitsPerGroup = _waveData select 1;
    _amountOfGroups = _waveData select 2;
    _distanceFromZCP = _waveData select 3;

    _useRandomGroupLocations = _waveData select 4;

    _capturePosition = _this select 1;

    _spawnAIPos = [_capturePosition, (_distanceFromZCP - 50), (_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;

    for "_i" from 1 to _amountOfGroups do {
      private['_attackWP','_groupOfAI'];
      if(_useRandomGroupLocations) then {
        _spawnAIPos = [_capturePosition, (_distanceFromZCP - 50), (_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;
      };

      _spawnAIPos set [2, 0];

      _groupOfAI = [_spawnAIPos, _unitsPerGroup, "moderate", "random", EAST] call ZCP_fnc_createDMSGroup;

      uiSleep 2;

      [_groupOfAI, _capturePosition] call ZCP_fnc_createWaypoint;
    };
  };
  case ('FUMS'): {
    diag_log format['[ZCP]: Calling FUMS AI for Wave.'];
    _headlessClients = entities "HeadlessClient_F";

    FuMS_ZCP_Handler = ['Wave',_this];

    {
      diag_log format['[ZCP]: Sending request to client %1', owner _x];
      (owner _x) publicVariableClient "FuMS_ZCP_Handler";
    }count _headlessClients;
  };
  default {
        diag_log format ['[ZCP]: No ai system chosen'];
  };
};
