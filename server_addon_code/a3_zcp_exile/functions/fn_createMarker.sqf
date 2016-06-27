params
[
	"_ZCP_CM_captureObject",
	"_ZCP_CM_capRadius",
	"_ZCP_CM_previousMarkers",
	"_ZCP_CM_position"
];


private _ZCP_CM_name 			= _ZCP_CM_captureObject select 0;
private _ZCP_CM_mission 		= _ZCP_CM_captureObject select 3;
private _ZCP_CM_index 			= _ZCP_CM_captureObject select 4;

[_ZCP_CM_previousMarkers] call ZCP_fnc_removeMarker;

private _ZCP_CM_attentionMarker = createMarker [format['ZCP_CM_%1_area',_ZCP_CM_mission], _ZCP_CM_position];
_ZCP_CM_attentionMarker 		setMarkerShape "ELLIPSE";
_ZCP_CM_attentionMarker 		setMarkerColor ZCP_BackgroundColor;
_ZCP_CM_attentionMarker 		setMarkerBrush "Solid";
_ZCP_CM_attentionMarker 		setMarkerSize [_ZCP_CM_capRadius * 3,_ZCP_CM_capRadius * 3];

private _ZCP_CM_marker 			= createMarker [format['ZCP_CM_%1',_ZCP_CM_mission], _ZCP_CM_position];

_ZCP_CM_marker setMarkerColor
(
	switch (ZCP_Data select _ZCP_CM_index) do
	{
	    case 1:
		{
			ZCP_CappedColor
		};
	    case 2:
		{
			ZCP_ContestColor
		};
		default
		{
			ZCP_FreeColor
		};
	}
);

_ZCP_CM_marker 		setMarkerShape "ELLIPSE";
_ZCP_CM_marker 		setMarkerBrush "Solid";
_ZCP_CM_marker 		setMarkerSize [_ZCP_CM_capRadius,_ZCP_CM_capRadius];
_ZCP_CM_marker 		setMarkerText _ZCP_CM_name;

private _ZCP_CM_dot 	= createMarker [format['ZCP_CM_dot_%1',_ZCP_CM_mission], _ZCP_CM_position];
_ZCP_CM_dot 			setMarkerColor "ColorBlack";
_ZCP_CM_dot 			setMarkerType "hd_flag";
_ZCP_CM_dot 			setMarkerText _ZCP_CM_name;

[_ZCP_CM_attentionMarker, _ZCP_CM_marker, _ZCP_CM_dot]
