private["_ZCP_CWM_position","_ZCP_CWM_mission","_ZCP_CWM_attentionMarker","_ZCP_CWM_captureObject","_ZCP_CWM_previousMarkers"];

_ZCP_CWM_captureObject = _this select 0;
_ZCP_CWM_previousMarkers = _this select 1;

[_ZCP_CWM_previousMarkers] call ZCP_fnc_removeMarker;

if(ZCP_MissionMarkerWinDotTime > 0) then {
  _ZCP_CWM_position		= _this select 2;
  _ZCP_CWM_mission 		= _ZCP_CWM_captureObject select 3;

  _ZCP_CWM_attentionMarker = createMarker [format['%1capped%2',_ZCP_CWM_mission,random 10], _ZCP_CWM_position];
  _ZCP_CWM_attentionMarker 		setMarkerType "hd_destroy";
  _ZCP_CWM_attentionMarker 		setMarkerColor ZCP_BackgroundColor;
  _ZCP_CWM_attentionMarker 		setMarkerText ([8] call ZCP_fnc_translate);

  [ZCP_MissionMarkerWinDotTime, {deleteMarker _this;}, _ZCP_CWM_attentionMarker, false] call ExileServer_system_thread_addTask;
};
