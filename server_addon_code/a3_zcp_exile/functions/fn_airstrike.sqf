/*
	Zupa's Capture Points
	Airstrike on base to innitiate cleanup
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
private ['_ZCP_AS_baseObjects','_center','_ZCP_AS_positionOrigin','_ZCP_AS_positionTarget','_ZCP_AS_unitPilot','_ZCP_AS_capturePosition'
,'_ZCP_AS_unitGroup','_ZCP_AS_ang','_ZCP_AS_plane','_ZCP_AS_wayPoint2','_ZCP_AS_wayPoint3','_ZCP_AS_baseRadius','_ZCP_AS_planeType'
];

_ZCP_AS_baseObjects = _this select 0;
_ZCP_AS_positionTarget = _this select 1;
_ZCP_AS_capturePosition = _this select 1;
_ZCP_AS_baseRadius = _this select 2;

_ZCP_AS_positionOrigin = [random (ZCP_MapRadius * 2), random (ZCP_MapRadius * 2), 500];

if (round (random 1) > 0) then {
	_ZCP_AS_positionOrigin set [0, 10];
} else {
	_ZCP_AS_positionOrigin set [1, 10];
};

_ZCP_AS_positionTarget set [2, ZCP_FlyHeight];

_ZCP_AS_ang = [_ZCP_AS_positionOrigin,_ZCP_AS_positionTarget] call BIS_fnc_dirTo;

_ZCP_AS_unitGroup	= createGroup west;
_ZCP_AS_unitGroup setBehaviour "SAFE";
_ZCP_AS_unitGroup setCombatMode "BLUE";
_ZCP_AS_unitGroup allowFleeing 0;

_ZCP_AS_planeType = ZCP_CleanupAIVehicleClasses call BIS_fnc_selectRandom;

_ZCP_AS_plane = createVehicle [_ZCP_AS_planeType, _ZCP_AS_positionOrigin, [], 0, "FLY"];
_ZCP_AS_plane setVariable ["ExileIsPersistent", false];
_ZCP_AS_plane setFuel 1;
_ZCP_AS_plane call ExileServer_system_simulationMonitor_addVehicle;

_ZCP_AS_plane setPosASL [getPosATL _ZCP_AS_plane select 0, getPosATL _ZCP_AS_plane select 1, ZCP_FlyHeight + 300];
_ZCP_AS_plane setDir _ZCP_AS_ang;
[_ZCP_AS_plane,_ZCP_AS_ang] call ZCP_fnc_fly;

_ZCP_AS_unitPilot = _ZCP_AS_unitGroup createUnit ["i_g_soldier_unarmed_f",[(_ZCP_AS_positionOrigin select 0) + 30,(_ZCP_AS_positionOrigin select 1)+30,0],[],1, "Form"];
_ZCP_AS_unitPilot setRank "Private";
{
	_ZCP_AS_unitPilot enableAI _x;
}forEach ["MOVE","ANIM"];
{
	_ZCP_AS_unitPilot disableAI _x;
}forEach ["FSM","AUTOTARGET","AUTOCOMBAT","SUPPRESSION"];
_ZCP_AS_unitPilot allowDammage false;

[_ZCP_AS_unitPilot] joinSilent _ZCP_AS_unitGroup;

removeAllWeapons  _ZCP_AS_unitPilot;
removeAllAssignedItems _ZCP_AS_unitPilot;
removeBackpack _ZCP_AS_unitPilot;
removeVest _ZCP_AS_unitPilot;
removeUniform _ZCP_AS_unitPilot;

_ZCP_AS_unitPilot moveInDriver _ZCP_AS_plane;

{
	_ZCP_AS_plane enableAI _x;
}forEach ["MOVE","ANIM"];
{
	_ZCP_AS_plane disableAI _x;
}forEach ["TARGET","AUTOTARGET","FSM","AUTOCOMBAT","SUPPRESSION"];
_ZCP_AS_plane flyInHeight ZCP_FlyHeight;

_ZCP_AS_positionOrigin set [2, ZCP_FlyHeight];

_ZCP_AS_wayPoint2 = group _ZCP_AS_plane addWaypoint [_ZCP_AS_positionTarget, 0];
_ZCP_AS_wayPoint2 setWaypointSpeed "FULL";
_ZCP_AS_wayPoint2 setWaypointType "MOVE";

_ZCP_AS_positionOrigin set [2, ZCP_FlyHeight];

_ZCP_AS_wayPoint3 = group _ZCP_AS_plane addWaypoint [_ZCP_AS_positionOrigin ,0];
_ZCP_AS_wayPoint3 setWaypointSpeed "FULL";
_ZCP_AS_wayPoint3 setWaypointType "MOVE";

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _ZCP_AS_plane];

waitUntil { uiSleep 2; isNull _ZCP_AS_plane || currentWaypoint group _ZCP_AS_plane == 2};

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _ZCP_AS_plane];
// diag_log format["[ZCP-Debug]: %1:isNull _ZCP_AS_unitPilot, %2:isNull _ZCP_AS_plane, %3:!(alive _ZCP_AS_plane)",isNull _ZCP_AS_unitPilot, isNull _ZCP_AS_plane, !(alive _ZCP_AS_plane)];

[_ZCP_AS_baseObjects, _ZCP_AS_capturePosition, _ZCP_AS_baseRadius] call ZCP_fnc_airbomb;

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _ZCP_AS_plane];

waitUntil { uiSleep 2; isNull _ZCP_AS_unitPilot || isNull _ZCP_AS_plane || !(alive _ZCP_AS_plane) || (currentWaypoint group _ZCP_AS_plane == 3)};

// diag_log format["[ZCP-Debug]: %1:isNull _ZCP_AS_unitPilot, %2:isNull _ZCP_AS_plane, %3:!(alive _ZCP_AS_plane)",isNull _ZCP_AS_unitPilot, isNull _ZCP_AS_plane, !(alive _ZCP_AS_plane), currentWaypoint group _ZCP_AS_plane];

// diag_log format['[ZCP-Debug]: Waypoint %1, deleting units',  currentWaypoint group _ZCP_AS_plane ];

if(!isNull _ZCP_AS_plane) then {
	deleteVehicle _ZCP_AS_plane;
	// diag_log format['[ZCP-Debug]: Deleted plane'];
};

if(!isNull _ZCP_AS_unitPilot) then {
	deleteVehicle _ZCP_AS_unitPilot;
	// diag_log format['[ZCP-Debug]: Deleted pilot'];
};
