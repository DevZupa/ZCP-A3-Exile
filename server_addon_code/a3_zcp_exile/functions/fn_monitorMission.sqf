// start the loop while people are inside.

private['_mission', '_trigger', '_index','_ZCP_recreateTrigger',
"_currentCapper","_ZCP_continue","_currentGroup","_ZCP_name",
"_ZCP_lastOwnerChange","_proximityList","_ZCP_baseObjects",
"_ZCP_currentCapper","_ZCP_previousCapper","_ZCP_currentGroup","_ZCP_wasContested","_finishText","_markers","_ZCP_base",
"_ZCP_ContestStartTime","_ZCP_index","_capturePosition","_changedReward","_ZCP_Halfway","_ZCP_min",
"_ZCP_baseRadius","_circle","_openRadius","_totalWaves",'_useWaves','_waveData','_nextWave','_nextWaveTimer','_currentWaveIndex'
];


_index = _this select 0;
_mission = ZCP_MissionTriggerData select _index;
_originalThis = _mission select 0;
_ZCP_name = _originalThis select 0;
_ZCP_index = _originalThis select 4;
_ZCP_baseObjects = _mission select 1;
_capturePosition = _mission select 2;
_ZCP_baseRadius = _mission select 3;
_markers = _mission select 4;
_circle = _mission select 5;

_missionCapTime = _originalThis select 12;

_useWaves = _originalThis select 13;
_waveData = [];
_nextWave = [];
_nextWaveTimer = 99999999999;
_currentWaveIndex = -1;
if (_useWaves) then {
  _waveData = _originalThis select 14;
  _totalWaves = count _waveData;
  if(_totalWaves > 0) then {
    _currentWaveIndex = 0;
    _nextWave = _waveData select _currentWaveIndex;
    _nextWaveTimer = ((_nextWave select 0) / 100) * _missionCapTime;
  };
};

_ZCP_currentCapper = objNull;
_ZCP_previousCapper = objNull;
_ZCP_currentGroup = objNull;
_ZCP_ContestStartTime = 0;
_ZCP_wasContested = false;
_ZCP_continue = true;
_ZCP_Halfway = false;
_ZCP_min = false;
_ZCP_isCapping = false;

_ZCP_CapStartTime = 0;
_ZCP_ContestStartTime = 0;
_ZCP_ContestEndTime = 0;
_ZCP_ContestTotalTime = 0;

_ZCP_recreateTrigger = false;


while{_ZCP_continue}do{
    _proximityList = [];
    {
      if(isPlayer _x && alive _x && (_x distance2D _capturePosition) <= _ZCP_baseRadius)then{
        _nil =  _proximityList pushBack _x;
      };
    }count (_capturePosition nearEntities["CAManBase", _ZCP_baseRadius * 2]);

    _proximityListMessage = _capturePosition nearEntities["CAManBase",_ZCP_baseRadius * 4];

    if(count(_proximityList) == 0) then{

        (ZCP_Data select _ZCP_index) set[1,0];

        _markers = [_originalThis, _ZCP_baseRadius, _markers, _capturePosition] call ZCP_fnc_createMarker;

        [_circle, 'none'] call ZCP_fnc_changeCircleColor;

        ZCP_MissionTriggerData set [_ZCP_index, [_originalThis, _ZCP_baseObjects, _capturePosition, _ZCP_baseRadius, _markers, _circle]];
      	[_ZCP_index, _capturePosition, _ZCP_baseRadius] call ZCP_fnc_createTrigger;

        _ZCP_recreateTrigger = true;
        _ZCP_continue = false;

    }else{
      // people inside so capping! maybe contested??
      if(!_ZCP_isCapping) then {
        (ZCP_Data select _ZCP_index) set[1,1]; // to set marker to capping
      };

      _ZCP_isCapping = true;

      if(_ZCP_previousCapper in _proximityList && alive _ZCP_previousCapper)then{
        _ZCP_currentCapper = _ZCP_previousCapper;
      } else {
        _ZCP_wasContested = false;
        _ZCP_isContested = false;
        _ZCP_Halfway = false;
        _ZCP_min = false;
        _ZCP_currentCapper = _proximityList select 0;
        _ZCP_CapStartTime = diag_tickTime;
        _ZCP_ContestStartTime = 0;
        _ZCP_ContestEndTime = 0;
        _ZCP_ContestTotalTime = 0;

        (ZCP_Data select _ZCP_index) set[1,1];

        _capperName = '';
        if(ZCP_UseSpecificNamesForCappers) then {
          _capperName = name _ZCP_currentCapper;
        } else {
          _capperName = [2] call ZCP_fnc_translate;
        };

        _markers = [_originalThis, _ZCP_baseRadius, _markers, _capturePosition] call ZCP_fnc_createMarker;
        [_circle, 'capping'] call ZCP_fnc_changeCircleColor;

        ['Notification', ["ZCP",[format[[1] call ZCP_fnc_translate, _ZCP_name, _capperName,(_missionCapTime / 60)]],'ZCP_Capping']] call ZCP_fnc_showNotification;

      };

      // to set the market to contested.
      _ZCP_currentGroup = group _ZCP_currentCapper;
      _ZCP_isContested = false;
      {
        if( _x != _ZCP_currentCapper)then{
          if( _ZCP_currentGroup ==  grpNull || group _x != _ZCP_currentGroup)then{
            (ZCP_Data select _ZCP_index) set[1,2];
            _ZCP_isContested = true;
          };
        };
      }count _proximityList;
      // marker stop

      // Set contest start timer
      if(!_ZCP_wasContested && _ZCP_isContested)then{
        _ZCP_ContestStartTime = diag_tickTime;
        _ZCP_wasContested = true;
        (ZCP_Data select _ZCP_index) set[1,2]; // to set marker to contested
        _markers = [_originalThis, _ZCP_baseRadius, _markers, _capturePosition] call ZCP_fnc_createMarker;
        [_circle, 'contested'] call ZCP_fnc_changeCircleColor;
        {
          ['PersonalNotification', ["ZCP",[format[[13] call ZCP_fnc_translate]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
        } count _proximityListMessage;
      };

      // set contest end timer
      if(!_ZCP_isContested && _ZCP_wasContested) then {
        _ZCP_ContestEndTime = diag_tickTime;
        _ZCP_ContestTotalTime = _ZCP_ContestTotalTime + (_ZCP_ContestEndTime - _ZCP_ContestStartTime);
        (ZCP_Data select _ZCP_index) set[1,1]; // to set marker to capping
        _markers = [_originalThis, _ZCP_baseRadius, _markers, _capturePosition] call ZCP_fnc_createMarker;
        [_circle, 'capping'] call ZCP_fnc_changeCircleColor;
        {
          ['PersonalNotification', ["ZCP",[format[[14] call ZCP_fnc_translate]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
        } count _proximityListMessage;
        _ZCP_wasContested = false;
      };

      // TSM Wonned #Kappa
      if( !_ZCP_isContested && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime >  _missionCapTime ) ) then {
          _ZCP_continue = false;
          //Capper Won, loop will break
          [_originalThis, _ZCP_baseRadius, _markers, _capturePosition] call ZCP_fnc_createWinMarker;
      };

      // only when not contested
      if (!_ZCP_isContested) then {
        (ZCP_Data select _ZCP_index) set[1,1]; // to set marker to capped
        [_circle, 'capping'] call ZCP_fnc_changeCircleColor;
        // 50% mark
        if(!_ZCP_Halfway && _ZCP_CapStartTime != 0 && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime) >  (_missionCapTime / 2))then{
          _capperName = '';
          if(ZCP_UseSpecificNamesForCappers) then {
            _capperName = name _ZCP_currentCapper;
          } else {
            _capperName = [2] call ZCP_fnc_translate;
          };

          ['Notification', ["ZCP",[format[[3] call ZCP_fnc_translate ,_ZCP_name,_capperName,(_missionCapTime / 2 / 60),"%"]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
          _ZCP_Halfway = true;
        };

        // 1 min mark
        if(!_ZCP_min && _ZCP_CapStartTime != 0 && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime) >  (_missionCapTime - 60))then{
          _capperName = '';
          if(ZCP_UseSpecificNamesForCappers) then {
            _capperName = name _ZCP_currentCapper;
          } else {
            _capperName = [2] call ZCP_fnc_translate;
          };

          ['Notification', ["ZCP",[format[[4] call ZCP_fnc_translate, _ZCP_name, _capperName]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
          _ZCP_min = true;
        };

        // wave check

        if( (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime) >  _nextWaveTimer ) then {
          [_nextWave, _capturePosition] spawn ZCP_fnc_waveAI;
          _currentWaveIndex = _currentWaveIndex + 1;
          if(_currentWaveIndex < _totalWaves) then {
            _nextWave = _waveData select _currentWaveIndex;
            _nextWaveTimer = ((_nextWave select 0) / 100) * _missionCapTime;
          } else {
            _nextWaveTimer = _missionCapTime * 2; // never gets to this.
          };
          diag_log format['[ZCP]: Timer changed to %1', _nextWaveTimer];
        };

      } else {
        _ZCP_wasContested = true;
      };

      _ZCP_previousCapper = _ZCP_currentCapper;
    };
  uiSleep 1;
};

if(!_ZCP_recreateTrigger) then {
  _finishText = '';

  if(ZCP_CleanupBase)then{
        if(ZCP_CleanupBaseWithAIBomber)then{
          _finishText = format [[6] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
        }else{
          _finishText = format [[7] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
        };
  };

  ['Notification', ["ZCP",[format[[5] call ZCP_fnc_translate,_ZCP_name,_finishText]], 'ZCP_Capped']] call ZCP_fnc_showNotification;
  [_ZCP_currentCapper,_ZCP_name,_capturePosition,_originalThis select 2, _ZCP_baseRadius] call ZCP_fnc_giveReward;
  (ZCP_Data select _ZCP_index) set[0,false];
  (ZCP_Data select _ZCP_index) set[1,0];
  (ZCP_Data select _ZCP_index) set[2,[-99999,0,0]];
  (ZCP_Data select _ZCP_index) set[3,false];
  ZCP_MissionTriggerData set [_ZCP_index, []];
  ZCP_MissionCounter = ZCP_MissionCounter - 1;
  diag_log format["[ZCP]: %1 will be cleaned up in %2s and ended.",_ZCP_name, ZCP_BaseCleanupDelay];
  [] spawn ZCP_fnc_missionLooper;
  if(ZCP_createVirtualCircle) then {
    _circle call ZCP_fnc_cleanupBase;
  };
  if(ZCP_CleanupBase)then{
        uiSleep ZCP_BaseCleanupDelay;
        if(ZCP_CleanupBaseWithAIBomber)then{
            [_ZCP_baseObjects, _capturePosition, _ZCP_baseRadius] call ZCP_fnc_airstrike;
        }else{
            _ZCP_baseObjects call ZCP_fnc_cleanupBase;
            [_capturePosition, _ZCP_baseRadius] call ZCP_fnc_deleteRuins;
            [_capturePosition, _ZCP_baseRadius] call ZCP_fnc_deleteLoot;
        };
  };
};
