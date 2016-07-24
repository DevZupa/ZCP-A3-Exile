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

private["_ZCP_ML_randomMission","_ZCP_ML_maxMissions","_ZCP_ML_players"];

_ZCP_ML_maxMissions = ZCP_MaxMissions;

if (ZCP_MaxMissionsRelativeToPlayers) then {
    _ZCP_ML_maxMissions = 1;
    _ZCP_ML_players = count allPlayers;
    {
        if (_x select 0 < _ZCP_ML_players) then {
            _ZCP_ML_maxMissions = _x select 1;
        };
    }forEach ZCP_RelativeMaxMissions ;
    diag_log text format['ZCP:%1 online, will spawn %2 missions in total.', _ZCP_ML_players, _ZCP_ML_maxMissions];
};

while {ZCP_MissionCounter < _ZCP_ML_maxMissions} do
{
	_ZCP_ML_randomMission = nil;
	while{ isNil "_ZCP_ML_randomMission" } do
	{
		_ZCP_ML_randomMission = ZCP_CapPoints call BIS_fnc_selectRandom;
		if((ZCP_Data select (_ZCP_ML_randomMission select 4))select 0)then{
			_ZCP_ML_randomMission = nil;
		};
	};
	(ZCP_Data select (_ZCP_ML_randomMission select 4)) set[0,true];
	diag_log text format ["[ZCP]: %1 initiated.",_ZCP_ML_randomMission select 3];
	_ZCP_ML_randomMission spawn ZCP_fnc_start;
	ZCP_MissionCounter = ZCP_MissionCounter + 1;
};


