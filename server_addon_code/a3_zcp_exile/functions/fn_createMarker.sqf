private["_ZCP_CM_position","_ZCP_CM_name","_ZCP_CM_index","_ZCP_CM_mission","_ZCP_CM_marker","_ZCP_CM_dot",
"_ZCP_CM_capRadius","_ZCP_CM_attentionMarker",
"_ZCP_CM_captureObject","_ZCP_CM_previousMarkers","_ZCP_CM_newMarkers"];

_ZCP_CM_captureObject = _this select 0;
_ZCP_CM_capRadius 		= _this select 1;
_ZCP_CM_previousMarkers = _this select 2;

_ZCP_CM_position		= _this select 3;
_ZCP_CM_name 			= _ZCP_CM_captureObject select 0;
_ZCP_CM_mission 		= _ZCP_CM_captureObject select 3;
_ZCP_CM_index 			= _ZCP_CM_captureObject select 4;

[_ZCP_CM_previousMarkers] call ZCP_fnc_removeMarker;

_ZCP_CM_attentionMarker = createMarker [format['%1area',_ZCP_CM_mission], _ZCP_CM_position];
_ZCP_CM_attentionMarker 		setMarkerShape "ELLIPSE";
_ZCP_CM_attentionMarker 		setMarkerColor ZCP_BackgroundColor;
_ZCP_CM_attentionMarker 		setMarkerBrush "Solid";
_ZCP_CM_attentionMarker 		setMarkerSize [_ZCP_CM_capRadius * 3,_ZCP_CM_capRadius * 3];
_ZCP_CM_marker 		= createMarker [format['%1',_ZCP_CM_mission], _ZCP_CM_position];
if((ZCP_Data select _ZCP_CM_index) select 1 == 1)then{
	_ZCP_CM_marker 		setMarkerColor ZCP_CappedColor;
}
else{
	if((ZCP_Data select _ZCP_CM_index) select 1 == 2)then{
		_ZCP_CM_marker 		setMarkerColor ZCP_ContestColor;
	}else{
		_ZCP_CM_marker 		setMarkerColor ZCP_FreeColor;
	};
};
_ZCP_CM_marker 		setMarkerShape "ELLIPSE";
_ZCP_CM_marker 		setMarkerBrush "Solid";
_ZCP_CM_marker 		setMarkerSize [_ZCP_CM_capRadius,_ZCP_CM_capRadius];
_ZCP_CM_marker 		setMarkerText _ZCP_CM_name;
_ZCP_CM_dot 			= createMarker [format['%1dot',_ZCP_CM_mission], _ZCP_CM_position];
_ZCP_CM_dot 			setMarkerColor "ColorBlack";
_ZCP_CM_dot 			setMarkerType "hd_flag";
_ZCP_CM_dot 			setMarkerText _ZCP_CM_name;

_ZCP_CM_newMarkers = [format['%1area',_ZCP_CM_mission], format['%1',_ZCP_CM_mission], format['%1dot',_ZCP_CM_mission]];

_ZCP_CM_newMarkers
