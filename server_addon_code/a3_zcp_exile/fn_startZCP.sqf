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


if !(isServer) exitWith
{
	for "_i" from 0 to 99 do
	{
		diag_log "[ZCP]: Not a server";
	};
};

diag_log text format ["[ZCP]: Giving server some time to boot."];

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
call ZCP_fnc_initCPData;

diag_log text format ["[ZCP]: World: %1 | Center: %2 | Radius: %3", toLower worldName, ZCP_MapCenterPos, ZCP_MapRadius];

ZCP_RandomReward = [];

{
	for "_i" from 0 to ((_x select 1) - 1) do {
		_nil = ZCP_RandomReward pushBack (_x select 0);
	};
}count ZCP_RewardWeightForRandomChoice;

diag_log text format ["[ZCP]: Capture Points is fully running."];
uiSleep ZCP_ServerStartWaitTime;
[] spawn ZCP_fnc_missionLooper;
