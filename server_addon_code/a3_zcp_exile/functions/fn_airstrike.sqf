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
private ['_ZCP_baseObjects','_center','_positionOrigin','_positionTarget','_unitPilot'
,'_unitGroup','_ang','_plane','_wayPoint2','_wayPoint3'
];
_ZCP_baseObjects = _this;

_center = _ZCP_baseObjects select 0;

_positionOrigin = [1,100] call ZCP_fnc_findPosition;

if (round (random 1) > 0) then {
	_positionOrigin set [0, 10];
} else {
	_positionOrigin set [1, 10];
};
_positionOrigin set [2, 1000];

_positionTarget = getPos _center;

_positionTarget set [2, ZCP_FlyHeight];

_ang = [_positionOrigin,_positionTarget] call BIS_fnc_dirTo;

_unitGroup	= createGroup west;
_unitGroup setBehaviour "SAFE";
_unitGroup setCombatMode "BLUE";
_unitGroup allowFleeing 0;

_planeType = ZCP_CleanupAIVehicleClasses call BIS_fnc_selectRandom;

_plane = createVehicle [_planeType, [_positionOrigin select 0,_positionOrigin select 1,1000], [], 0, "FLY"];
_plane setVariable ["ExileIsPersistent", false];
_plane setFuel 1;
_plane call ExileServer_system_simulationMonitor_addVehicle;

_plane setPosASL [getPosATL _plane select 0, getPosATL _plane select 1, ZCP_FlyHeight + 300];
[_plane,_ang] call ZCP_fnc_fly;

_unitPilot = _unitGroup createUnit ["i_g_soldier_unarmed_f",[(_positionOrigin select 0) + 30,(_positionOrigin select 1)+30,0],[],1, "Form"];
_unitPilot setRank "Private";
{
	_unitPilot enableAI _x;
}forEach ["MOVE","ANIM"];
{
	_unitPilot disableAI _x;
}forEach ["FSM","AUTOTARGET","AUTOCOMBAT","SUPPRESSION"];
_unitPilot allowDammage false;

[_unitPilot] joinSilent _unitGroup;

removeallweapons _unitPilot;
removeallassigneditems _unitPilot;
removebackpack _unitPilot;
removevest _unitPilot;
removeuniform _unitPilot;

_unitPilot moveInDriver _plane;

{
	_plane enableAI _x;
}forEach ["MOVE","ANIM"];
{
	_plane disableAI _x;
}forEach ["TARGET","AUTOTARGET","FSM","AUTOCOMBAT","SUPPRESSION"];
_plane flyInHeight ZCP_FlyHeight;

_positionOrigin set [2, ZCP_FlyHeight];

_wayPoint2 = group _plaNE addWaypoint [_positionTarget, 0];
_wayPoint2 setWaypointSpeed "FULL";
_wayPoint2 setWaypointType "MOVE";

_positionOrigin set [2, (ZCP_FlyHeight + 100)];

_wayPoint3 = group _plane addWaypoint [_positionOrigin ,0];
_wayPoint3 setWaypointSpeed "FULL";
_wayPoint3 setWaypointType "MOVE";

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _plane];

waitUntil { UIsleep 2; isNull _plane || currentWaypoint group _plane == 2};

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _plane];
// diag_log format["[ZCP-Debug]: %1:isNull _unitPilot, %2:isNull _plane, %3:!(alive _plane)",isNull _unitPilot, isNull _plane, !(alive _plane)];

_ZCP_baseObjects call ZCP_fnc_airbomb;

_plane flyInHeight (ZCP_FlyHeight + 100);

// diag_log format['[ZCP-Debug]: Waypoint %1', currentWaypoint group _plane];

waitUntil { UIsleep 2; isNull _unitPilot || isNull _plane || !(alive _plane) || (currentWaypoint group _plane == 3)};

// diag_log format["[ZCP-Debug]: %1:isNull _unitPilot, %2:isNull _plane, %3:!(alive _plane)",isNull _unitPilot, isNull _plane, !(alive _plane), currentWaypoint group _plane];

// diag_log format['[ZCP-Debug]: Waypoint %1, deleting units',  currentWaypoint group _plane ];

if(!isNull _plane) then {
	deleteVehicle _plane;
	// diag_log format['[ZCP-Debug]: Deleted plane'];
};

if(!isNull _unitPilot) then {
	deleteVehicle _unitPilot;
	// diag_log format['[ZCP-Debug]: Deleted pilot'];
};
