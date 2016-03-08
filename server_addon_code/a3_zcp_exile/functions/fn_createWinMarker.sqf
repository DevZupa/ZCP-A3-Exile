private["_position","_missiondata","_name","_index","_mission","_type","_marker","_dot","_capRadius","_attentionMarker","_captureObject","_previousMarkers"];

_captureObject = _this select 0;
_capRadius 		= _this select 1;
_previousMarkers = _this select 2;

[_previousMarkers] call ZCP_fnc_removeMarker;

if(ZCP_MissionMarkerWinDotTime > 0) then {
  _position		= _captureObject select 1;
  _name 			= _captureObject select 0;
  _mission 		= _captureObject select 3;

  _attentionMarker = createMarker [format['%1capped%2',_mission,random 10], _position];
  _attentionMarker 		setMarkerType "hd_destroy";
  _attentionMarker 		setMarkerColor ZCP_BackgroundColor;
  _attentionMarker 		setMarkerText ([8] call ZCP_fnc_translate);

  [ZCP_MissionMarkerWinDotTime, {deleteMarker _this;}, _attentionMarker, false] call ExileServer_system_thread_addTask;
};
