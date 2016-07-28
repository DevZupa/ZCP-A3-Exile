/*
* Creates the trigger for a ZCP mission. Trigger activates when a player enters the area.
* Trigger will be recreated if player moves out the ZCP circle.
*
* @param
*/

params[
 '_ZCP_CT_missionIndex',
 '_ZCP_CT_pos',
 '_ZCP_CT_radius',
 '_ZCP_CT_cityX',
 '_ZCP_CT_cityY'
];

private _ZCP_CT_markerX = _ZCP_CT_cityX;
private _ZCP_CT_markerY = _ZCP_CT_cityY;

if( _ZCP_CT_cityX == 0 || _ZCP_CT_cityY == 0 ) then
{
    _ZCP_CT_markerX =  _ZCP_CT_radius;
    _ZCP_CT_markerY = _ZCP_CT_radius;
};

private _ZCP_CT_trigger = createTrigger ["EmptyDetector", _ZCP_CT_pos];
_ZCP_CT_trigger setTriggerArea [_ZCP_CT_markerX, _ZCP_CT_markerY, 45, false];
_ZCP_CT_trigger setTriggerActivation ["GUER", "PRESENT", false];
_ZCP_CT_trigger setTriggerStatements ["this", format['deleteVehicle thisTrigger; [%1] spawn ZCP_fnc_monitorMission;', _ZCP_CT_missionIndex], ""];
