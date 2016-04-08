private["_position","_missiondata","_name","_index","_mission","_type","_marker","_dot","_capRadius","_attentionMarker","_captureObject","_previousMarkers","_newMarkers"];

_captureObject = _this select 0;
_capRadius 		= _this select 1;
_previousMarkers = _this select 2;

_position		= _this select 3;
_name 			= _captureObject select 0;
_mission 		= _captureObject select 3;
_index 			= _captureObject select 4;

[_previousMarkers] call ZCP_fnc_removeMarker;

_attentionMarker = createMarker [format['%1area',_mission], _position];
_attentionMarker 		setMarkerShape "ELLIPSE";
_attentionMarker 		setMarkerColor ZCP_BackgroundColor;
_attentionMarker 		setMarkerBrush "Solid";
_attentionMarker 		setMarkerSize [_capRadius * 3,_capRadius * 3];
_marker 		= createMarker [format['%1',_mission], _position];
if((ZCP_Data select _index) select 1 == 1)then{
	_marker 		setMarkerColor ZCP_CappedColor;
}
else{
	if((ZCP_Data select _index) select 1 == 2)then{
		_marker 		setMarkerColor ZCP_ContestColor;
	}else{
		_marker 		setMarkerColor ZCP_FreeColor;
	};
};
_marker 		setMarkerShape "ELLIPSE";
_marker 		setMarkerBrush "Solid";
_marker 		setMarkerSize [_capRadius,_capRadius];
_marker 		setMarkerText _name;
_dot 			= createMarker [format['%1dot',_mission], _position];
_dot 			setMarkerColor "ColorBlack";
_dot 			setMarkerType "hd_flag";
_dot 			setMarkerText _name;

_newMarkers = [   format['%1area',_mission]     ,      format['%1',_mission]       , format['%1dot',_mission]     ];

_newMarkers
