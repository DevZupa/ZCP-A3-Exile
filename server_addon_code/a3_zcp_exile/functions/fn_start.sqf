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

private _ZCP_S_capPointName = _this select 0;
private _ZCP_S_capPointIndex = _this select 4;
private _ZCP_S_missionCapTime = _this select 11;
private _ZCP_S_baseConfig = _this select 7;
private _ZCP_S_preCreateRewards = _this select 25;
private _ZCP_S_rewards = _this select 2;
private _ZCP_S_spawnDefenderAI = _this select 5;
private _ZCP_S_isStatic = _this select 6;
private _ZCP_S_isCity = _this select 26;
private _ZCP_S_spawnCityBase = _this select 27;

private _ZCP_S_randomTime = (floor random  ZCP_MaxWaitTime) + ZCP_MinWaitTime;
private _ZCP_S_capturePosition = [0,0,0];
private _ZCP_S_baseFile = '';
private _ZCP_S_baseRadius = 0;
private _ZCP_S_baseType = '';
private _ZCP_S_terrainGradient = 20;
private _ZCP_S_openRadius = 60;
private _ZCP_S_base = [];
private _ZCP_S_ai = [];
private _ZCP_S_city = [];
private _ZCP_S_city_sizeX = 0;
private _ZCP_S_city_sizeY = 0;
private _ZCP_S_baseObjects = [];
private _ZCP_S_cityName = '';


private _ZCP_S_locationFound = true;

if( ZCP_TotalMissionCounter <= ZCP_CalculatedMaxMissions ) then
{
	private _ZCP_S_firstRandomTime = floor random 60;
	uiSleep _ZCP_S_firstRandomTime;
}
else
{
   uiSleep _ZCP_S_randomTime;
};

diag_log text format ["[ZCP]: Waiting for %1 players to be online.",ZCP_Minimum_Online_Players];
waitUntil { uiSleep 60; count( allPlayers ) > ( ZCP_Minimum_Online_Players - 1 ) };
diag_log text format ["[ZCP]: %1 players reached, starting %2.",ZCP_Minimum_Online_Players, _ZCP_S_capPointName];

// Location if
if (_ZCP_S_isCity) then
{
    _ZCP_S_city = call ZCP_fnc_getRandomCity;

    _ZCP_S_cityName =  _ZCP_S_city select 2;

		if( count _ZCP_S_city > 0) then
			{
				_ZCP_S_city_sizeX = _ZCP_S_city select 1;
				_ZCP_S_city_sizeY = _ZCP_S_city select 1;

				_ZCP_S_capturePosition = _ZCP_S_city select 0;
				_ZCP_S_capturePosition set [2,0];

				diag_log text format ["[ZCP]: %1 :Spawning city on %2 -> %3 with x %4, y %5",_ZCP_S_capPointName,_ZCP_S_capturePosition, _ZCP_S_cityName, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY];
			} else {
				_ZCP_S_locationFound = false;
			};
}
else
{
    if(_ZCP_S_isStatic) then
    { // is static location config
        private _ZCP_S_StaticConfig = _this select 1;

        if( !(typeName (_ZCP_S_StaticConfig select 0) == 'ARRAY')) then {
            _ZCP_S_StaticConfig = [_ZCP_S_StaticConfig];
        };

        _ZCP_S_capturePosition = _ZCP_S_StaticConfig call BIS_fnc_selectRandom;
        diag_log text format ["[ZCP]: %1 :Spawning static on %2",_ZCP_S_capPointName,_ZCP_S_capturePosition];
    }
    else
    {
        _ZCP_S_capturePosition = [_ZCP_S_openRadius, _ZCP_S_terrainGradient] call ZCP_fnc_findPosition;

        diag_log text format ["[ZCP]: %1 :Spawning dynamic on %2",_ZCP_S_capPointName,_ZCP_S_capturePosition];
    };
};

if(!_ZCP_S_locationFound) exitWith
	{
			diag_log text format["[ZCP]: No correct location found for %1.", _ZCP_S_capPointName];
			[_ZCP_S_capPointIndex] call ZCP_fnc_endMission;
	};

(ZCP_Data select _ZCP_S_capPointIndex) set[2,_ZCP_S_capturePosition];

// Objects if
if (_ZCP_S_isCity) then
{
    if(_ZCP_S_spawnCityBase && (count _ZCP_S_city > 3)) then {

        private _ZCP_S_basesForCity = _ZCP_S_city select 3;

        if(typeName _ZCP_S_basesForCity == "STRING" ) then {
            _ZCP_S_base = _ZCP_S_basesForCity;
        } else {
            _ZCP_S_base =  _ZCP_S_basesForCity call BIS_fnc_selectRandom;
        };

        _ZCP_S_baseFile = format["x\addons\ZCP\city\%1", _ZCP_S_base];
        _ZCP_S_baseType = 'selfSpawn';
    };


	_ZCP_S_baseRadius = floor (( _ZCP_S_city_sizeX + _ZCP_S_city_sizeY ) / 2);
}
else
{
    if (typeName _ZCP_S_baseConfig == "ARRAY") then
    {
        _ZCP_S_baseConfig = _ZCP_S_baseConfig call BIS_fnc_selectRandom;
    };

    if (_ZCP_S_baseConfig == 'Random') then
    {
        _ZCP_S_base = ZCP_CapBases call BIS_fnc_selectRandom;
        _ZCP_S_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_S_base select 0];
        _ZCP_S_baseRadius = _ZCP_S_base select 1;
        _ZCP_S_baseType = _ZCP_S_base select 2; // m3e or xcam or ...
        _ZCP_S_terrainGradient = _ZCP_S_base select 3;
        _ZCP_S_openRadius = _ZCP_S_base select 4;
    }
    else
    {
        _ZCP_S_baseFile = format["x\addons\ZCP\capbases\%1", _ZCP_S_baseConfig];
        _ZCP_S_baseRadius = _this select 8;
        {
            if (_x select 0 == _ZCP_S_baseConfig) then {
                _ZCP_S_base = _x;
            };
        }forEach ZCP_CapBases;

        _ZCP_S_baseType = _ZCP_S_base select 2; // m3e or xcam or ...

        if(_ZCP_S_baseRadius == -1) then
        {
            _ZCP_S_baseRadius = _ZCP_S_base select 1;
        };

        _ZCP_S_terrainGradient = _this select 9;

        if(_ZCP_S_terrainGradient == -1) then
        {
             _ZCP_S_terrainGradient = _ZCP_S_base select 3;
        };

        _ZCP_S_openRadius = _this select 10;

        if(_ZCP_S_openRadius == -1) then
        {
             _ZCP_S_openRadius = _ZCP_S_base select 4;
        };
    };
};



// diag_log text format['ZCP - Debug: %1',(ZCP_Data select _ZCP_S_capPointIndex) select 2 ];


switch (_ZCP_S_baseType) do
{
    case ('m3e'):
    {
        _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createM3eBase;
    };
    case ('xcam'):
    {
        _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createXcamBase;
    };
    case ('EdenConverted'):
    {
        _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createEdenConvertedBase;
    };
    case ('m3eEden'):
    {
        _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createM3eEdenBase;
    };
    case ('m3eEdenCity'):
    {
        _ZCP_S_baseObjects = [_ZCP_S_baseFile, _ZCP_S_capturePosition] call ZCP_fnc_createM3eEdenCity;
    };
    case ('selfSpawn'):
    {
        _ZCP_S_baseObjects = call compile preprocessFileLineNumbers _ZCP_S_baseFile;
    };
};

// Add the flag manually if city
if (_ZCP_S_isCity) then
	{
			_nil = _ZCP_S_baseObjects pushBack (createVehicle ['Flag_Green_F', _ZCP_S_capturePosition, [], 0, 'CAN_COLLIDE']);
	};

private _ZCP_S_circle = [];

if(ZCP_createVirtualCircle) then
{
	// diag_log text format ["[ZCP]: %1 radius :Spawning city on %2 -> %3 with x %4, y %5",_ZCP_S_baseRadius,_ZCP_S_capturePosition, _ZCP_S_cityName, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY];

	_ZCP_S_circle = [_ZCP_S_capturePosition, _ZCP_S_baseRadius, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY ] call ZCP_fnc_createVirtualCircle;
};

private _ZCP_S_rewardObjects = [];

if(_ZCP_S_preCreateRewards) then
{
	_ZCP_S_rewardObjects = [_ZCP_S_rewards , _ZCP_S_capturePosition, _ZCP_S_baseRadius, _ZCP_S_isCity ] call ZCP_fnc_preCreateRewards;
} else
{
    {
        _nil = _ZCP_S_rewardObjects pushBack objNull;
    }count (_ZCP_S_rewards);
};

if(_ZCP_S_spawnDefenderAI) then
{
	_ZCP_S_ai = [_ZCP_S_capturePosition, _ZCP_S_baseRadius, _this select 12, _this select 13, _this select 19, _this select 20, _this select 23 ] call ZCP_fnc_spawnAI;
};


if(count _ZCP_S_baseObjects != 0) then
{
    if(_ZCP_S_isCity) then {
        ['Notification', ["ZCP",[format[[18] call ZCP_fnc_translate, _ZCP_S_cityName, (_ZCP_S_missionCapTime / 60)]],"ZCP_Init"]] call ZCP_fnc_showNotification;
    }else{
        ['Notification', ["ZCP",[format[[0] call ZCP_fnc_translate, _ZCP_S_capPointName, (_ZCP_S_missionCapTime / 60)]],"ZCP_Init"]] call ZCP_fnc_showNotification;
    };

	private _ZCP_S_markers = [_this, _ZCP_S_baseRadius, [], _ZCP_S_capturePosition, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY, _ZCP_S_cityName] call ZCP_fnc_createMarker;

	ZCP_MissionTriggerData set [_ZCP_S_capPointIndex, [_this, _ZCP_S_baseObjects, _ZCP_S_capturePosition, _ZCP_S_baseRadius, _ZCP_S_markers, _ZCP_S_circle, _ZCP_S_ai, _ZCP_S_rewardObjects, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY, _ZCP_S_city]];
	[_ZCP_S_capPointIndex, _ZCP_S_capturePosition, _ZCP_S_baseRadius, _ZCP_S_city_sizeX, _ZCP_S_city_sizeY] call ZCP_fnc_createTrigger;

}
else
{
	diag_log text format["[ZCP]: No correct Basefile found for %1.", _ZCP_S_capPointName];
	[_ZCP_S_capPointIndex] call ZCP_fnc_endMission;
};
