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
"_terrainGradient","_ZCP_baseRadius","_circle","_openRadius"
];

_randomTime = (floor random  ZCP_MaxWaitTime) + ZCP_MinWaitTime;

_capturePosition = [0,0,0];
_ZCP_name = _this select 0;
_ZCP_index = _this select 4;

if(!((ZCP_Data select _ZCP_index) select 3)) then {
	uiSleep _randomTime;
};

diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];
waitUntil { uiSleep 60; count( playableUnits ) > ( ZCP_Minimum_Online_Players - 1 ) };
diag_log text format ["[ZCP]: %1 players reached, starting %2.",ZCP_Minimum_Online_Players, _ZCP_name];

_ZCP_baseFile = '';
_ZCP_baseRadius = 0;
_baseType = '';
_terrainGradient = 20;
_openRadius = 60;

if (_this select 7 == 'Random') then {
	_ZCP_base = ZCP_CapBases call BIS_fnc_selectRandom;
	_ZCP_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_base select 0];
	_ZCP_baseRadius = _ZCP_base select 1;
	_baseType = _ZCP_base select 2; // m3e or xcam
	_terrainGradient = _ZCP_base select 3;
	_openRadius = _ZCP_base select 4;
} else {
	_ZCP_baseFile = format["x\addons\ZCP\capbases\%1", _this select 7];
	_ZCP_baseRadius = _this select 8;
	_baseType = _this select 9; // m3e or xcam
	_terrainGradient = _this select 10;
	_openRadius = _this select 11;
};

if(_this select 6)then{
	_capturePosition = _this select 1;
	diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_name,_capturePosition];
}else{
	_capturePosition = [_openRadius, _terrainGradient] call ZCP_fnc_findPosition;
	diag_log text format ["[ZCP]: %1 :Spawning dynamic on %2",_ZCP_name,_capturePosition];
};

(ZCP_Data select _ZCP_index) set[2,_capturePosition];

diag_log format['ZCP - Debug: %1',(ZCP_Data select _ZCP_index) select 2 ];

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

if(_this select 5) then {
	[_capturePosition, _ZCP_baseRadius] call ZCP_fnc_spawnAI;
};

if(count _ZCP_baseObjects != 0)then{

	['Notification', ["ZCP",[format[[0] call ZCP_fnc_translate, _ZCP_name, (ZCP_CapTime / 60)]],"ZCP_Init"]] call ZCP_fnc_showNotification;

	_markers = [_this, _ZCP_baseRadius, [], _capturePosition] call ZCP_fnc_createMarker;
	// creat trigger
	ZCP_MissionTriggerData set [_ZCP_index, [_this, _ZCP_baseObjects, _capturePosition, _ZCP_baseRadius, _markers, _circle]];
	[_ZCP_index, _capturePosition, _ZCP_baseRadius] call ZCP_fnc_createTrigger;

}else{
	diag_log format["[ZCP]: No correct Basefile found for %1", _ZCP_name];
};
