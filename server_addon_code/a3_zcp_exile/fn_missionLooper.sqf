/*
	Zupa's Capture Points
	loops the cap actions.
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

private["_ZCP_randomMission"];
uiSleep 10;
while {ZCP_MissionCounter < ZCP_MaxMissions} do
{
	_ZCP_randomMission = nil;
	while{ isNil "_ZCP_randomMission" } do
	{
		_ZCP_randomMission = ZCP_CapPoints call BIS_fnc_selectRandom;
		if((ZCP_Data select (_ZCP_randomMission select 4))select 0)then{
			_ZCP_randomMission = nil;
		};
	};
	(ZCP_Data select (_ZCP_randomMission select 4)) set[0,true];
	diag_log text format ["[ZCP]: No %1 initiated.",_ZCP_randomMission select 1];
	_ZCP_randomMission spawn ZCP_fnc_start;
	ZCP_MissionCounter = ZCP_MissionCounter + 1;
};
