/*
* Creates the trigger for a ZCP mission. Trigger activates when a player enters the area.
* Trigger will be recreated if player moves out the ZCP circle.
*
* @param
*/
private ['_ZCP_CT_missionIndex', '_ZCP_CT_trigger', '_ZCP_CT_radius','_ZCP_CT_pos'];

_ZCP_CT_missionIndex = _this select 0;
_ZCP_CT_pos = _this select 1;
_ZCP_CT_radius = _this select 2;

_ZCP_CT_trigger = createTrigger ["EmptyDetector", _ZCP_CT_pos];
_ZCP_CT_trigger setTriggerArea [_ZCP_CT_radius, _ZCP_CT_radius, 45, false];
_ZCP_CT_trigger setTriggerActivation ["GUER", "PRESENT", false];
_ZCP_CT_trigger setTriggerStatements ["this", format['deleteVehicle thisTrigger; [%1] spawn ZCP_fnc_monitorMission;', _ZCP_CT_missionIndex], ""];
