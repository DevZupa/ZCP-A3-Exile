/**
* Creates the trigger for a ZCP mission. Trigger activates when a player enters the area.
* Trigger will be recreated if player moves out the ZCP circle.
*
* @param
*/
private ['_missionIndex', '_trigger', '_radius','_pos'];

_missionIndex = _this select 0;
_pos = _this select 1;
_radius = _this select 2;

_trigger = createTrigger ["EmptyDetector", _pos];
_trigger setTriggerArea [_radius, _radius, 45, false];
_trigger setTriggerActivation ["GUER", "PRESENT", false];
_trigger setTriggerStatements ["this", format['[_this, %1] call ZCP_fnc_monitorMission;', _missionIndex], ""];
