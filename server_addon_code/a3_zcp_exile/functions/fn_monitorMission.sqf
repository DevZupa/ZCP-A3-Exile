// start the loop while people are inside.

private['_ZCP_MM_mission','_ZCP_MM_recreateTrigger','_ZCP_MM_AI_Groups',
"_ZCP_MM_continueLoop","_ZCP_MM_name",'_ZCP_MM_nextWaveTimer','_ZCP_MM_currentWaveIndex',
"_ZCP_MM_proximityList","_ZCP_MM_baseObjects", "_ZCP_MM_originalThis","_ZCP_MM_missionCapTime","_ZCP_MM_isCapping",
"_ZCP_MM_contestEndTime","_ZCP_MM_contestTotalTime","_ZCP_MM_proximityMessageList","_ZCP_MM_isContested","_ZCP_MM_capperName",
"_ZCP_MM_currentCapper","_ZCP_MM_previousCapper","_ZCP_MM_currentGroup","_ZCP_MM_wasContested","_ZCP_MM_finishText","_ZCP_MM_markers",
"_ZCP_MM_contestStartTime","_ZCP_MM_capIndex","_ZCP_MM_capturePosition","_ZCP_MM_Halfway","_ZCP_MM_oneMin","_ZCP_MM_capStartTime",
"_ZCP_MM_baseRadius","_ZCP_MM_circle","_ZCP_MM_totalWaves",'_ZCP_MM_useWaves','_ZCP_MM_waveData','_ZCP_MM_nextWave','_ZCP_MM_AI_NewGroups',
'_ZCP_MM_rewardObjects','_ZCP_MM_city_sizeX','_ZCP_MM_city_sizeY','_ZCP_MM_isCity','_ZCP_MM_city','_ZCP_MM_cityName'
];

params[
    "_ZCP_MM_missionIndex"
];

_ZCP_MM_mission = ZCP_MissionTriggerData select _ZCP_MM_missionIndex;
_ZCP_MM_originalThis = _ZCP_MM_mission select 0;
_ZCP_MM_name = _ZCP_MM_originalThis select 0;
_ZCP_MM_capIndex = _ZCP_MM_originalThis select 4;

_ZCP_MM_baseObjects = _ZCP_MM_mission select 1;
_ZCP_MM_capturePosition = _ZCP_MM_mission select 2;
_ZCP_MM_baseRadius = _ZCP_MM_mission select 3;
_ZCP_MM_markers = _ZCP_MM_mission select 4;
_ZCP_MM_circle = _ZCP_MM_mission select 5;
_ZCP_MM_AI_Groups = _ZCP_MM_mission select 6;
_ZCP_MM_rewardObjects = _ZCP_MM_mission select 7;
_ZCP_MM_city_sizeX = _ZCP_MM_mission select 8;
_ZCP_MM_city_sizeY = _ZCP_MM_mission select 9;
_ZCP_MM_city = _ZCP_MM_mission select 10;

_ZCP_MM_isCity = _ZCP_MM_originalThis select 26;

// TO debug mission vars:
//{
//    diag_log format['Misssion: %1 : %2', _forEachIndex, _x];
//}forEach _ZCP_MM_mission;

_ZCP_MM_cityName = "";

if(_ZCP_MM_isCity) then
{
    _ZCP_MM_cityName = _ZCP_MM_city select 2;

    if(ZCP_CONFIG_UseCityName) then {
        _ZCP_MM_name = _ZCP_MM_cityName;
    };
};

_ZCP_MM_missionCapTime = _ZCP_MM_originalThis select 11;

_ZCP_MM_useWaves = _ZCP_MM_originalThis select 17;
_ZCP_MM_waveData = [];
_ZCP_MM_nextWave = [];
_ZCP_MM_nextWaveTimer = 99999999999;
_ZCP_MM_currentWaveIndex = -1;
if (_ZCP_MM_useWaves) then {
  _ZCP_MM_waveData = _ZCP_MM_originalThis select 18;
  _ZCP_MM_totalWaves = count _ZCP_MM_waveData;
  if(_ZCP_MM_totalWaves > 0) then {
    _ZCP_MM_currentWaveIndex = 0;
    _ZCP_MM_nextWave = _ZCP_MM_waveData select _ZCP_MM_currentWaveIndex;
    _ZCP_MM_nextWaveTimer = ((_ZCP_MM_nextWave select 0) / 100) * _ZCP_MM_missionCapTime;
  };
};

_ZCP_MM_currentCapper = objNull;
_ZCP_MM_previousCapper = objNull;
_ZCP_MM_currentGroup = grpNull;
_ZCP_MM_wasContested = false;
_ZCP_MM_continueLoop = true;
_ZCP_MM_Halfway = false;
_ZCP_MM_oneMin = false;
_ZCP_MM_isCapping = false;

_ZCP_MM_capStartTime = 0;
_ZCP_MM_contestStartTime = 0;
_ZCP_MM_contestEndTime = 0;
_ZCP_MM_contestTotalTime = 0;

_ZCP_MM_recreateTrigger = false;
_ZCP_MM_isContested = false;
_ZCP_MM_capperName = '';
_ZCP_MM_finishText = '';

_ZCP_MM_proximityList = [];
_ZCP_MM_proximityMessageList = [];

while{_ZCP_MM_continueLoop}do{
    _ZCP_MM_proximityList = [];
    _ZCP_MM_proximityMessageList = [];
    {
      if(isPlayer _x && alive _x && (_x distance2D _ZCP_MM_capturePosition) <= _ZCP_MM_baseRadius)then{
        _nil =  _ZCP_MM_proximityList pushBack _x;
      };
    }count (_ZCP_MM_capturePosition nearEntities["CAManBase", _ZCP_MM_baseRadius * 2]);

     {
          if(isPlayer _x && alive _x )then{
            _nil =  _ZCP_MM_proximityMessageList pushBack _x;
          };
      }count (_ZCP_MM_capturePosition nearEntities["CAManBase", _ZCP_MM_baseRadius * 4]);

    if(count(_ZCP_MM_proximityList) == 0) then {

        (ZCP_Data select _ZCP_MM_capIndex) set[1,0];

        _ZCP_MM_markers = [_ZCP_MM_originalThis, _ZCP_MM_baseRadius, _ZCP_MM_markers, _ZCP_MM_capturePosition, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY, _ZCP_MM_cityName] call ZCP_fnc_createMarker;

        [_ZCP_MM_circle, 'none'] call ZCP_fnc_changeCircleColor;

        _ZCP_MM_recreateTrigger = true;
        _ZCP_MM_continueLoop = false;

    } else {
      // people inside so capping! maybe contested??
      if(!_ZCP_MM_isCapping) then {
        (ZCP_Data select _ZCP_MM_capIndex) set[1,1]; // to set marker to capping
      };

      _ZCP_MM_isCapping = true;

      if(_ZCP_MM_previousCapper in _ZCP_MM_proximityList && alive _ZCP_MM_previousCapper) then
        {
        _ZCP_MM_currentCapper = _ZCP_MM_previousCapper;
        }
      else
        {
          private _ZCP_stillGroupMembersAlive = false;
          private _ZCP_newGroupCapper = objNull;
          {
              if( (group _x) isEqualTo _ZCP_MM_currentGroup ) then
                {
                  _ZCP_stillGroupMembersAlive = true;
                  _ZCP_newGroupCapper = _x;
                }
          }count _ZCP_MM_proximityList;

          if( !(_ZCP_MM_currentGroup == grpNull) &&  _ZCP_stillGroupMembersAlive) then
            {
              _ZCP_MM_currentCapper = _ZCP_newGroupCapper;
              ['PersonalNotification', ["ZCP",[format[[17] call ZCP_fnc_translate]],'ZCP_Capping'],  _ZCP_MM_currentCapper] call ZCP_fnc_showNotification;

                _ZCP_MM_capperName = '';
                if(ZCP_UseSpecificNamesForCappers) then {
                  _ZCP_MM_capperName = name _ZCP_MM_currentCapper;
                } else {
                  _ZCP_MM_capperName = [2] call ZCP_fnc_translate;
                };
            }
          else
            {
              _ZCP_MM_wasContested = false;
              _ZCP_MM_isContested = false;
              _ZCP_MM_Halfway = false;
              _ZCP_MM_oneMin = false;
              _ZCP_MM_currentCapper = _ZCP_MM_proximityList select 0;
              _ZCP_MM_capStartTime = diag_tickTime;
              _ZCP_MM_contestStartTime = 0;
              _ZCP_MM_contestEndTime = 0;
              _ZCP_MM_contestTotalTime = 0;

               _ZCP_MM_capperName = '';
                if(ZCP_UseSpecificNamesForCappers) then {
                  _ZCP_MM_capperName = name _ZCP_MM_currentCapper;
                } else {
                  _ZCP_MM_capperName = [2] call ZCP_fnc_translate;
                };


              ['Notification', ["ZCP",[format[[1] call ZCP_fnc_translate, _ZCP_MM_name, _ZCP_MM_capperName,(_ZCP_MM_missionCapTime / 60)]],'ZCP_Capping']] call ZCP_fnc_showNotification;
            };

          (ZCP_Data select _ZCP_MM_capIndex) set[1,1];

          _ZCP_MM_markers = [_ZCP_MM_originalThis, _ZCP_MM_baseRadius, _ZCP_MM_markers, _ZCP_MM_capturePosition, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY, _ZCP_MM_cityName] call ZCP_fnc_createMarker;
          [_ZCP_MM_circle, 'capping'] call ZCP_fnc_changeCircleColor;

        };

      // to set the market to contested.
      _ZCP_MM_currentGroup = group _ZCP_MM_currentCapper;
      _ZCP_MM_isContested = false;
      {
        if( _x != _ZCP_MM_currentCapper)then
          {
            if( _ZCP_MM_currentGroup == grpNull || group _x != _ZCP_MM_currentGroup )then
              {
                (ZCP_Data select _ZCP_MM_capIndex) set[1,2];
                _ZCP_MM_isContested = true;
              };
          };
      }count _ZCP_MM_proximityList;
      // marker stop

      // Set contest start timer
      if(!_ZCP_MM_wasContested && _ZCP_MM_isContested)then{
        _ZCP_MM_contestStartTime = diag_tickTime;
        _ZCP_MM_wasContested = true;
        (ZCP_Data select _ZCP_MM_capIndex) set[1,2]; // to set marker to contested
        _ZCP_MM_markers = [_ZCP_MM_originalThis, _ZCP_MM_baseRadius, _ZCP_MM_markers, _ZCP_MM_capturePosition, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY, _ZCP_MM_cityName] call ZCP_fnc_createMarker;
        [_ZCP_MM_circle, 'contested'] call ZCP_fnc_changeCircleColor;
        {
          ['PersonalNotification', ["ZCP",[format[[13] call ZCP_fnc_translate]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
        } count _ZCP_MM_proximityMessageList;
      };

      // set contest end timer
      if(!_ZCP_MM_isContested && _ZCP_MM_wasContested) then {
        _ZCP_MM_contestEndTime = diag_tickTime;
        _ZCP_MM_contestTotalTime = _ZCP_MM_contestTotalTime + (_ZCP_MM_contestEndTime - _ZCP_MM_contestStartTime);
        (ZCP_Data select _ZCP_MM_capIndex) set[1,1]; // to set marker to capping
        _ZCP_MM_markers = [_ZCP_MM_originalThis, _ZCP_MM_baseRadius, _ZCP_MM_markers, _ZCP_MM_capturePosition, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY, _ZCP_MM_cityName] call ZCP_fnc_createMarker;
        [_ZCP_MM_circle, 'capping'] call ZCP_fnc_changeCircleColor;
        {
          ['PersonalNotification', ["ZCP",[format[[14] call ZCP_fnc_translate]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
        } count _ZCP_MM_proximityMessageList;
        _ZCP_MM_wasContested = false;
      };

      // TSM Wonned #Kappa
      if( !_ZCP_MM_isContested && (diag_tickTime - _ZCP_MM_contestTotalTime - _ZCP_MM_capStartTime >  _ZCP_MM_missionCapTime ) ) then {
          _ZCP_MM_continueLoop = false;
          //Capper Won, loop will break
          [_ZCP_MM_originalThis, _ZCP_MM_markers, _ZCP_MM_capturePosition] call ZCP_fnc_createWinMarker;
      };

      // only when not contested
      if (!_ZCP_MM_isContested) then {
        (ZCP_Data select _ZCP_MM_capIndex) set[1,1]; // to set marker to capped
        [_ZCP_MM_circle, 'capping'] call ZCP_fnc_changeCircleColor;
        // 50% mark
        if(!_ZCP_MM_Halfway && _ZCP_MM_capStartTime != 0 && (diag_tickTime - _ZCP_MM_contestTotalTime - _ZCP_MM_capStartTime) >  (_ZCP_MM_missionCapTime / 2))then{
          _ZCP_MM_capperName = '';
          if(ZCP_UseSpecificNamesForCappers) then {
            _ZCP_MM_capperName = name _ZCP_MM_currentCapper;
          } else {
            _ZCP_MM_capperName = [2] call ZCP_fnc_translate;
          };

          ['Notification', ["ZCP",[format[[3] call ZCP_fnc_translate ,_ZCP_MM_name,_ZCP_MM_capperName,(_ZCP_MM_missionCapTime / 2 / 60),"%"]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
          _ZCP_MM_Halfway = true;
        };

        // 1 min mark
        if(!_ZCP_MM_oneMin && _ZCP_MM_capStartTime != 0 && (diag_tickTime - _ZCP_MM_contestTotalTime - _ZCP_MM_capStartTime) >  (_ZCP_MM_missionCapTime - 60))then{
          _ZCP_MM_capperName = '';
          if(ZCP_UseSpecificNamesForCappers) then {
            _ZCP_MM_capperName = name _ZCP_MM_currentCapper;
          } else {
            _ZCP_MM_capperName = [2] call ZCP_fnc_translate;
          };

          ['Notification', ["ZCP",[format[[4] call ZCP_fnc_translate, _ZCP_MM_name, _ZCP_MM_capperName]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
          _ZCP_MM_oneMin = true;
        };

        // wave check

        if( (diag_tickTime - _ZCP_MM_contestTotalTime - _ZCP_MM_capStartTime) >  _ZCP_MM_nextWaveTimer ) then {
          _ZCP_MM_AI_NewGroups = [_ZCP_MM_nextWave, _ZCP_MM_capturePosition, _ZCP_MM_originalThis select 21, _ZCP_MM_originalThis select 22, _ZCP_MM_originalThis select 24] call ZCP_fnc_waveAI;
          _ZCP_MM_AI_Groups = _ZCP_MM_AI_Groups + _ZCP_MM_AI_NewGroups;
          _ZCP_MM_currentWaveIndex = _ZCP_MM_currentWaveIndex + 1;
          if (ZCP_MessagePlayersBeforeWaves && ZCP_AI_Type != 'NONE') then {
              {
                ['PersonalNotification', ["ZCP",[format[[15] call ZCP_fnc_translate, _ZCP_MM_name]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
              } count _ZCP_MM_proximityMessageList;
          };
          if(_ZCP_MM_currentWaveIndex < _ZCP_MM_totalWaves) then {
            _ZCP_MM_nextWave = _ZCP_MM_waveData select _ZCP_MM_currentWaveIndex;
            _ZCP_MM_nextWaveTimer = ((_ZCP_MM_nextWave select 0) / 100) * _ZCP_MM_missionCapTime;
          } else {
            _ZCP_MM_nextWaveTimer = _ZCP_MM_missionCapTime * 10;
          };
        };

      } else {
        _ZCP_MM_wasContested = true;
      };

      _ZCP_MM_previousCapper = _ZCP_MM_currentCapper;
    };
  uiSleep 1;
};

if(_ZCP_MM_recreateTrigger) then {
    ZCP_MissionTriggerData set [_ZCP_MM_capIndex, [_ZCP_MM_originalThis, _ZCP_MM_baseObjects, _ZCP_MM_capturePosition, _ZCP_MM_baseRadius, _ZCP_MM_markers, _ZCP_MM_circle, _ZCP_MM_AI_Groups,_ZCP_MM_rewardObjects, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY, _ZCP_MM_city]];
  	[_ZCP_MM_capIndex, _ZCP_MM_capturePosition, _ZCP_MM_baseRadius, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY] call ZCP_fnc_createTrigger;
} else {
  _ZCP_MM_finishText = '';

  if(ZCP_CleanupBase)then{
        if(ZCP_CleanupBaseWithAIBomber)then{
          _ZCP_MM_finishText = format [[6] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
        }else{
          _ZCP_MM_finishText = format [[7] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
        };
  };

  ['Notification', ["ZCP",[format[[5] call ZCP_fnc_translate,_ZCP_MM_name,_ZCP_MM_finishText]], 'ZCP_Capped']] call ZCP_fnc_showNotification;
  [_ZCP_MM_currentCapper,_ZCP_MM_name,_ZCP_MM_capturePosition,_ZCP_MM_originalThis select 2, _ZCP_MM_baseRadius, _ZCP_MM_rewardObjects] call ZCP_fnc_giveReward;

  ['PersonalNotification', ["ZCP",[format[[11] call ZCP_fnc_translate]], 'ZCP_Init'], _ZCP_MM_currentCapper] call ZCP_fnc_showNotification;

  if (_ZCP_MM_originalThis select 14) then {
    [_ZCP_MM_capturePosition, _ZCP_MM_baseRadius, _ZCP_MM_originalThis select 15, _ZCP_MM_originalThis select 16, _ZCP_MM_city_sizeX, _ZCP_MM_city_sizeY] spawn ZCP_fnc_createSmokeScreen;
  };

  if(ZCP_AI_killAIAfterMissionCompletionTimer > -1) then {
    _ZCP_MM_AI_Groups spawn ZCP_fnc_cleanupAI;
  };

  [_ZCP_MM_capIndex] call ZCP_fnc_endMission;

  diag_log text format["[ZCP]: %1 will be cleaned up in %2s and ended.",_ZCP_MM_name, ZCP_BaseCleanupDelay];
  [] spawn ZCP_fnc_missionLooper;
  if (ZCP_createVirtualCircle) then {
    _ZCP_MM_circle call ZCP_fnc_cleanupBase;
  };
  if (ZCP_CleanupBase) then {
        uiSleep ZCP_BaseCleanupDelay;
        if (ZCP_CleanupBaseWithAIBomber) then {
            [_ZCP_MM_baseObjects, _ZCP_MM_capturePosition, _ZCP_MM_baseRadius] call ZCP_fnc_airstrike;
        } else {
            _ZCP_MM_baseObjects call ZCP_fnc_cleanupBase;
            [_ZCP_MM_capturePosition, _ZCP_MM_baseRadius] call ZCP_fnc_deleteRuins;
            [_ZCP_MM_capturePosition, _ZCP_MM_baseRadius] call ZCP_fnc_deleteLoot;
        };
  };
};
