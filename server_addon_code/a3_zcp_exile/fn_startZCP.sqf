/*
	Zupa's Capture Points
	Initiates the cap actions.
	Capture points and earn money.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/
private['_middle'];

if (!isServer) exitWith
{
	for "_i" from 0 to 99 do
	{
		diag_log text format["[ZCP]: Not a server"];
	};
};

ZCP_MapCenterPos =  [8500,8500];
ZCP_MapRadius = 8500;

// Some custom maps don't have the proper safePos config entries.
// If you are using one and you have an issue with mission spawns, please create an issue on GitHub or post a comment in the DMS thread.
switch (toLower worldName) do
{
	case "altis":										// [16000,16000] w/ radius of 16000 works well for Altis
	{
		ZCP_MapCenterPos 	= [16000,16000];
		ZCP_MapRadius 		= 16000;
	};
	case "bornholm":									// Thanks to thirdhero for testing this info
	{
		ZCP_MapCenterPos 	= [11265,11265];
		ZCP_MapRadius 		= 12000;
	};
	case "esseker":										// Thanks to Flowrider for this info
	{
		ZCP_MapCenterPos 	= [6275,6350];
		ZCP_MapRadius 		= 5000;
	};
	case "taviana";										// Thanks to JamieKG for this info
	case "tavi":
	{
		ZCP_MapCenterPos 	= [12800,12800];
		ZCP_MapRadius 		= 12800;
	};
	case "namalsk":
	{
		ZCP_MapCenterPos 	= [6000,4000];
		ZCP_MapRadius 		= 6000;
	};
	default 											// Use "worldSize" to determine map center/radius (not always very nice).
	{
		private "_middle";
		_middle = worldSize/2;
		ZCP_MapCenterPos 	= [_middle,_middle];
		ZCP_MapRadius 		= _middle;
	};
};

ZCP_MapCenterPos set [2,0];

diag_log text format ["[ZCP]: Initiate Zupa's Capture Points"];
call ZCP_fnc_config;

if ( isNil 'ZCP_ConfigLoaded' ) exitWith {
	for "_i" from 0 to 99 do
	{
		diag_log text format["[ZCP]: Typo or missing symbol in config file!"];
	};
};

call ZCP_fnc_initCPData;

diag_log text format ["[ZCP]: World: %1 | Center: %2 | Radius: %3", worldName, ZCP_MapCenterPos, ZCP_MapRadius];
diag_log text format ["[ZCP]: Capture Points is fully running."];
diag_log text format ["[ZCP]: Waiting %1s for first mission.", ZCP_ServerStartWaitTime];
uiSleep ZCP_ServerStartWaitTime;
[] spawn ZCP_fnc_missionLooper;

if(ZCP_MaxMissionsRelativeToPlayers) then {
    // exile will execute every 10 or x minuts the missionlooper ( to spawn more cappoints when there are more players ( or less cappoints ))
    [ZCP_SecondsCheckPlayers, {[] spawn ZCP_fnc_missionLooper;}, true, true] call ExileServer_system_thread_addTask;
};