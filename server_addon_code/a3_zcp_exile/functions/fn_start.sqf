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

private["_currentCapper","_ZCP_continue","_ZCP_flag","_currentGroup","_ZCP_S_capPointName","_ZCP_S_baseFile","_ZCP_baseClasses",
"_ZCP_lastOwnerChange","_proximityList","_ZCP_S_baseObjects","_theFlagPos","_theFlagX","_theFlagY","_XChange","_YChange",
"_ZCP_currentCapper","_ZCP_previousCapper","_ZCP_currentGroup","_ZCP_wasContested","_finishText","_ZCP_S_markers","_ZCP_S_base",
"_ZCP_ContestStartTime","_ZCP_S_capPointIndex","_ZCP_S_capturePosition","_ZCP_S_randomTime","_changedReward","_ZCP_Halfway","_ZCP_min","_ZCP_S_baseType",
"_ZCP_S_terrainGradient","_ZCP_S_baseRadius","_ZCP_S_circle","_ZCP_S_openRadius","_ZCP_S_baseConfig","_ZCP_S_missionCapTime"
,"_ZCP_S_StaticConfig",'_ZCP_S_ai'
];

_ZCP_S_randomTime = (floor random  ZCP_MaxWaitTime) + ZCP_MinWaitTime;

_ZCP_S_capturePosition = [0,0,0];
_ZCP_S_capPointName = _this select 0;
_ZCP_S_capPointIndex = _this select 4;
_ZCP_S_missionCapTime = _this select 11;

if(!((ZCP_Data select _ZCP_S_capPointIndex) select 3)) then {
	uiSleep _ZCP_S_randomTime;
} else {
	_ZCP_S_firstRandomTime = floor random 60;
	uiSleep _ZCP_S_firstRandomTime;
};

diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];
waitUntil { uiSleep 60; count( playableUnits ) > ( ZCP_Minimum_Online_Players - 1 ) };
diag_log text format ["[ZCP]: %1 players reached, starting %2.",ZCP_Minimum_Online_Players, _ZCP_S_capPointName];

_ZCP_S_baseFile = '';
_ZCP_S_baseRadius = 0;
_ZCP_S_baseType = '';
_ZCP_S_terrainGradient = 20;
_ZCP_S_openRadius = 60;

_ZCP_S_base = [];
_ZCP_S_ai = [];

_ZCP_S_baseConfig = _this select 7;

if (typeName _ZCP_S_baseConfig == "ARRAY") then {
    _ZCP_S_baseConfig = _ZCP_S_baseConfig call BIS_fnc_selectRandom;
};

if (_ZCP_S_baseConfig == 'Random') then {
    _ZCP_S_base = ZCP_CapBases call BIS_fnc_selectRandom;
    _ZCP_S_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_S_base select 0];
    _ZCP_S_baseRadius = _ZCP_S_base select 1;
    _ZCP_S_baseType = _ZCP_S_base select 2; // m3e or xcam or ...
    _ZCP_S_terrainGradient = _ZCP_S_base select 3;
    _ZCP_S_openRadius = _ZCP_S_base select 4;
} else {
    _ZCP_S_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_S_baseConfig];
    _ZCP_S_baseRadius = _this select 8;
    {
        if (_x select 0 == _ZCP_S_baseConfig) then {
            _ZCP_S_base = _x;
        };
    }forEach ZCP_CapBases;

    _ZCP_S_baseType = _ZCP_S_base select 2; // m3e or xcam or ...

    if(_ZCP_S_baseRadius == -1) then {
        _ZCP_S_baseRadius = _ZCP_S_base select 1;
    };

    _ZCP_S_terrainGradient = _this select 9;

    if(_ZCP_S_terrainGradient == -1) then {
         _ZCP_S_terrainGradient = _ZCP_S_base select 3;
    };

    _ZCP_S_openRadius = _this select 10;

    if(_ZCP_S_openRadius == -1) then {
         _ZCP_S_openRadius = _ZCP_S_base select 4;
    };
};


if(_this select 6)then{ // is static location config
    _ZCP_S_StaticConfig = _this select 1;

    if( !(typeName (_ZCP_S_StaticConfig select 0) == 'ARRAY')) then {
        _ZCP_S_StaticConfig = [_ZCP_S_StaticConfig];
    };

	_ZCP_S_capturePosition = _ZCP_S_StaticConfig call BIS_fnc_selectRandom;
	diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_S_capPointName,_ZCP_S_capturePosition];
}else{
	_ZCP_S_capturePosition = [_ZCP_S_openRadius, _ZCP_S_terrainGradient] call ZCP_fnc_findPosition;

	diag_log text format ["[ZCP]: %1 :Spawning dynamic on %2",_ZCP_S_capPointName,_ZCP_S_capturePosition];
};

(ZCP_Data select _ZCP_S_capPointIndex) set[2,_ZCP_S_capturePosition];

diag_log text format['ZCP - Debug: %1',(ZCP_Data select _ZCP_S_capPointIndex) select 2 ];

_ZCP_S_baseObjects = [];
switch (_ZCP_S_baseType) do {
  case ('m3e'): {
		_ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createM3eBase;
  };
	case ('xcam'): {
	  _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createXcamBase;
	};
	case ('EdenConverted'): {
	  _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createEdenConvertedBase;
	};
	case ('m3eEden'): {
      _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createM3eEdenBase;
    };
};

_ZCP_S_circle = [];

if(ZCP_createVirtualCircle) then {
	_ZCP_S_circle = [_ZCP_S_capturePosition, _ZCP_S_baseRadius ] call ZCP_fnc_createVirtualCircle;
};

private _ZCP_S_rewardObjects = [];

if(_this select 25) then {
	_ZCP_S_rewardObjects = [_this select 2 , _ZCP_S_capturePosition, _ZCP_S_baseRadius ] call ZCP_fnc_preCreateRewards;
} else {
    {
        _nil = _ZCP_S_rewardObjects pushBack objNull;
    }count (_this select 2);
};

if(_this select 5) then {
	_ZCP_S_ai = [_ZCP_S_capturePosition, _ZCP_S_baseRadius, _this select 12, _this select 13, _this select 19, _this select 20, _this select 23 ] call ZCP_fnc_spawnAI;
};

if(count _ZCP_S_baseObjects != 0)then{

	['Notification', ["ZCP",[format[[0] call ZCP_fnc_translate, _ZCP_S_capPointName, (_ZCP_S_missionCapTime / 60)]],"ZCP_Init"]] call ZCP_fnc_showNotification;

	_ZCP_S_markers = [_this, _ZCP_S_baseRadius, [], _ZCP_S_capturePosition] call ZCP_fnc_createMarker;

	diag_log _ZCP_S_rewardObjects;
	// creat trigger
	ZCP_MissionTriggerData set [_ZCP_S_capPointIndex, [_this, _ZCP_S_baseObjects, _ZCP_S_capturePosition, _ZCP_S_baseRadius, _ZCP_S_markers, _ZCP_S_circle, _ZCP_S_ai, _ZCP_S_rewardObjects]];
	[_ZCP_S_capPointIndex, _ZCP_S_capturePosition, _ZCP_S_baseRadius] call ZCP_fnc_createTrigger;

}else{
	diag_log text format["[ZCP]: No correct Basefile found for %1", _ZCP_S_capPointName];
};
