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
private ['_ZCP_baseObjects','_center','_pos1','_pos2','_index'];
_ZCP_baseObjects = _this select 0;
_index = _this select 1;

_center = _ZCP_baseObjects select 0;

_pos1 = [1] call ZCP_fnc_findPosition;

if (round (random 1) > 0) then {
	_pos1 set [0, 0];
} else {
	_pos1 set [1, 0];
};
	_pos1 set [2, 1000];

_pos2 = getPos _center;

_pos2 set [2, 300];

_ang = [_pos1,_pos2] call BIS_fnc_dirTo;
_angorig = _ang - 180;

_unitGroup	= createGroup west;
_unitGroup setBehaviour "COMBAT";
_unitGroup setCombatMode "BLUE";
_unitGroup allowFleeing 0;

_vehObj = createVehicle ["B_Plane_CAS_01_F", [_pos1 select 0,_pos1 select 1,1000], [], 0, "FLY"];
_plane = _vehObj;
_vehObj setVariable ["ExileIsPersistent", false];
_vehObj setFuel 1;
_vehObj call ExileServer_system_simulationMonitor_addVehicle;

_plane setPosASL [getPosATL _plane select 0, getPosATL _plane select 1, 300];

//[_plane,_angorig] call ZCP_fnc_fly;
_unit = _unitGroup createUnit ["i_g_soldier_unarmed_f",[(_pos1 select 0) + 30,(_pos1 select 1)+30,0],[],1, "Form"];
_unit setRank "Private";
{
	_unit enableAI _x;
}forEach ["TARGET","AUTOTARGET","MOVE","ANIM"];
_unit disableAI "FSM";
_unit allowDammage true;

[_unit] joinSilent _unitGroup;

_unit2 = _unitGroup createUnit ["i_g_soldier_unarmed_f",[0,0,0],[],1, "Form"];
_unit2 setRank "Private";
{
	_unit2 enableAI _x;
}forEach ["TARGET","AUTOTARGET","MOVE","ANIM"];
_unit2 disableAI "FSM";
_unit2 allowDammage true;

[_unit2] joinSilent _unitGroup;

removeallweapons _unit;
removeallassigneditems _unit;
removebackpack _unit;
removevest _unit;
removeuniform _unit;

removeallweapons _unit2;
removeallassigneditems _unit2;
removebackpack _unit2;
removevest _unit2;
removeuniform _unit2;

_unit moveInDriver _vehObj;

_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane flyInHeight 300;

_wp2 = group _plane addWaypoint [_pos2, 70];
_wp2 setWaypointSpeed "FULL";
_wp2 setWaypointType "MOVE";

_wp3 = group _plane addWaypoint [_pos1 ,70];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "FULL";
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];

waitUntil { UIsleep 2; currentWaypoint group _plane == 2};

_ZCP_baseObjects call ZCP_fnc_airbomb;

waitUntil { UIsleep 2; currentWaypoint group _plane == 3};

if(!isNull _unit) then {
	deleteVehicle _unit;
};
if(!isNull _unit2) then {
	deleteVehicle _unit2;
};
