/*
	Zupa's Capture Points
	Mission starter of ZCP
	Capture points and earn money over time.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/

private["_currentCapper","_ZCP_continue","_ZCP_flag","_currentGroup","_ZCP_name","_ZCP_baseFile","_ZCP_baseClasses",
"_ZCP_lastOwnerChange","_proximityList","_ZCP_baseObjects","_theFlagPos","_theFlagX","_theFlagY","_XChange","_YChange",
"_ZCP_currentCapper","_ZCP_previousCapper","_ZCP_currentGroup","_ZCP_wasContested","_finishText","_markers","_ZCP_base",
"_ZCP_ContestStartTime","_ZCP_index","_capturePosition","_randomTime","_changedReward","_ZCP_Halfway","_ZCP_min","_baseType",
"_terrainGradient","_ZCP_baseRadius","_circle"
];

_randomTime = (floor random  ZCP_MaxWaitTime) + ZCP_MinWaitTime;

_capturePosition = [0,0,0];
_ZCP_name = _this select 0;
_ZCP_index = _this select 4;

uiSleep _randomTime;

diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];
waitUntil { uiSleep 60; count( playableUnits ) > ( ZCP_Minimum_Online_Players - 1 ) };
diag_log text format ["[ZCP]: %1 players reached, starting %2.",ZCP_Minimum_Online_Players, _ZCP_name];

_capturePosition = [0,0,0];
_ZCP_name = _this select 0;
_ZCP_index = _this select 4;

_ZCP_baseFile = '';
_ZCP_baseRadius = 0;
_baseType = '';
_terrainGradient = 20;

if (_this select 7 == 'Random') then {
	_ZCP_base = ZCP_CapBases call BIS_fnc_selectRandom;
	_ZCP_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_base select 0];
	_ZCP_baseRadius = _ZCP_base select 1;
	_baseType = _ZCP_base select 2; // m3e or xcam
	_terrainGradient = _ZCP_base select 3;
} else {
	_ZCP_baseFile = format["x\addons\ZCP\capbases\%1", _this select 7];
	_ZCP_baseRadius = _this select 8;
	_baseType = _this select 9; // m3e or xcam
	_terrainGradient = _this select 10;
};

if(_this select 6)then{
	_capturePosition = _this select 1;
	diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_name,_capturePosition];
}else{
	_capturePosition = [_ZCP_baseRadius, _terrainGradient] call ZCP_fnc_findPosition;
	diag_log text format ["[ZCP]: %1 :Spawning dynamic on %2",_ZCP_name,_capturePosition];
};

(ZCP_Data select _ZCP_index) set[2,_capturePosition];

_ZCP_baseObjects = [];
switch (_baseType) do {
  case ('m3e'): {
		_ZCP_baseObjects = [_ZCP_baseFile, _capturePosition] call ZCP_fnc_createM3eBase;
  };
	case ('xcam'): {
	  _ZCP_baseObjects = [_ZCP_baseFile, _capturePosition] call ZCP_fnc_createXcamBase;
	};
	case ('EdenConverted'): {
	  _ZCP_baseObjects = [_ZCP_baseFile, _capturePosition] call ZCP_fnc_createEdenConvertedBase;
	};
};

_circle = [];

if(ZCP_createVirtualCircle) then {
	_circle = [_capturePosition, _ZCP_baseRadius ] call ZCP_fnc_createVirtualCircle;
};

_this set [1,_capturePosition];

if(_this select 5) then {
	[_capturePosition, _ZCP_baseRadius] call ZCP_fnc_spawnAI;
};

if(count _ZCP_baseObjects != 0)then{

	ZCP_Bases set [_ZCP_index , _ZCP_baseObjects];

	['Notification', ["ZCP",[format[[0] call ZCP_fnc_translate, _ZCP_name, (ZCP_CapTime / 60)]],"ZCP_Init"]] call ZCP_fnc_showNotification;

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

	_ZCP_needReset = false;

	_markers = [_this, _ZCP_baseRadius, []] call ZCP_fnc_createMarker;

	while{_ZCP_continue}do{
			_proximityList = [];
			{
				if(isPlayer _x && alive _x && (_x distance2D _capturePosition) <= _ZCP_baseRadius)then{
					_nil =  _proximityList pushBack _x;
				};
			}count (_capturePosition nearEntities["CAManBase", _ZCP_baseRadius * 2]);

			_proximityListMessage = _capturePosition nearEntities["CAManBase",_ZCP_baseRadius * 4];

			if(count(_proximityList) == 0) then{

				// no one inside so reset everything
				if(_ZCP_needReset) then {
					(ZCP_Data select _ZCP_index) set[1,0];
					_markers = [_this, _ZCP_baseRadius, _markers] call ZCP_fnc_createMarker;
					[_circle, 'none'] call ZCP_fnc_changeCircleColor;
					_ZCP_isCapping = false;
					_ZCP_currentCapper = objNull;
					_ZCP_previousCapper = objNull;
					_ZCP_currentGroup = grpNull;
					_ZCP_wasContested = false;
					_ZCP_Halfway = false;
					_ZCP_min = false;
					_ZCP_CapStartTime = 0;
					_ZCP_needReset = false;
					_ZCP_isContested = false;
					_ZCP_wasContested = false;
				}
			}else{
				// people inside so capping! maybe contested??
				if(!_ZCP_isCapping) then {
					(ZCP_Data select _ZCP_index) set[1,1]; // to set marker to capping
				};

				_ZCP_isCapping = true;
				_ZCP_needReset = true;
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

					_markers = [_this, _ZCP_baseRadius, _markers] call ZCP_fnc_createMarker;
					[_circle, 'capping'] call ZCP_fnc_changeCircleColor;

					['Notification', ["ZCP",[format[[1] call ZCP_fnc_translate, _ZCP_name, _capperName,(ZCP_CapTime / 60)]],'ZCP_Capping']] call ZCP_fnc_showNotification;

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
					_markers = [_this, _ZCP_baseRadius, _markers] call ZCP_fnc_createMarker;
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
					_markers = [_this, _ZCP_baseRadius, _markers] call ZCP_fnc_createMarker;
					[_circle, 'capping'] call ZCP_fnc_changeCircleColor;
					{
						['PersonalNotification', ["ZCP",[format[[14] call ZCP_fnc_translate]],'ZCP_Capping'], _x] call ZCP_fnc_showNotification;
					} count _proximityListMessage;
					_ZCP_wasContested = false;
				};

				// TSM Wonned #Kappa
				if( !_ZCP_isContested && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime >  ZCP_CapTime ) ) then {
						_ZCP_continue = false;
						//Capper Won, loop will break
						[_this, _ZCP_baseRadius, _markers] call ZCP_fnc_createWinMarker;
				};

				// only when not contested
				if (!_ZCP_isContested) then {
					(ZCP_Data select _ZCP_index) set[1,1]; // to set marker to capped
					[_circle, 'capping'] call ZCP_fnc_changeCircleColor;
					// 50% mark
					if(!_ZCP_Halfway && _ZCP_CapStartTime != 0 && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime) >  (ZCP_CapTime / 2))then{
						_capperName = '';
						if(ZCP_UseSpecificNamesForCappers) then {
							_capperName = name _ZCP_currentCapper;
						} else {
							_capperName = [2] call ZCP_fnc_translate;
						};

						['Notification', ["ZCP",[format[[3] call ZCP_fnc_translate ,_ZCP_name,_capperName,(ZCP_CapTime / 2 / 60),"%"]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
						_ZCP_Halfway = true;
					};

					// 1 min mark
					if(!_ZCP_min && _ZCP_CapStartTime != 0 && (diag_tickTime - _ZCP_ContestTotalTime - _ZCP_CapStartTime) >  (ZCP_CapTime - 60))then{
						_capperName = '';
						if(ZCP_UseSpecificNamesForCappers) then {
							_capperName = name _ZCP_currentCapper;
						} else {
							_capperName = [2] call ZCP_fnc_translate;
						};

						['Notification', ["ZCP",[format[[4] call ZCP_fnc_translate, _ZCP_name, _capperName]], 'ZCP_Capping']] call ZCP_fnc_showNotification;
						_ZCP_min = true;
					};
				} else {
					_ZCP_wasContested = true;
				};

				_ZCP_previousCapper = _ZCP_currentCapper;
			};
		uiSleep 1;
	};

  _finishText = '';

	if(ZCP_CleanupBase)then{
				if(ZCP_CleanupBaseWithAIBomber)then{
					_finishText = format [[6] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
				}else{
					_finishText = format [[7] call ZCP_fnc_translate,ZCP_BaseCleanupDelay];
				};
	};

	['Notification', ["ZCP",[format[[5] call ZCP_fnc_translate,_ZCP_name,_finishText]], 'ZCP_Capped']] call ZCP_fnc_showNotification;
	[_ZCP_currentCapper,_ZCP_name,_capturePosition,_this select 2, _ZCP_baseRadius] call ZCP_fnc_giveReward;
	(ZCP_Data select _ZCP_index) set[0,false];
	(ZCP_Data select _ZCP_index) set[1,0];
	(ZCP_Data select _ZCP_index) set[2,[-99999,0,0]];
	ZCP_MissionCounter = ZCP_MissionCounter - 1;
	diag_log format["[ZCP]: %1 will be cleaned up in %2s and ended.",_ZCP_name, ZCP_BaseCleanupDelay];
	[] spawn ZCP_fnc_missionLooper;
	if(ZCP_createVirtualCircle) then {
		_circle call ZCP_fnc_cleanupBase;
	};
	if(ZCP_CleanupBase)then{
        uiSleep ZCP_BaseCleanupDelay;
        if(ZCP_CleanupBaseWithAIBomber)then{
            _ZCP_baseObjects call ZCP_fnc_airstrike;
        }else{
            _ZCP_baseObjects call ZCP_fnc_cleanupBase;
        };
	};
}else{
	diag_log format["[ZCP]: No correct Basefile found for %1", _ZCP_name];
};
