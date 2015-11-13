private["_position","_missiondata","_name","_index","_mission","_type","_marker","_dot"];		
_position		= _this select 1;		
_name 			= _this select 0;
_mission 		= _this select 3;
_index 			= _this select 4;		
while {(ZCP_Data select _index) select 0} do {			
	_marker 		= createMarker [str(_mission), _position];
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
	_marker 		setMarkerSize [ZCP_CapRadius*3,ZCP_CapRadius*3];
	_marker 		setMarkerText _name;
	_dot 			= createMarker [str(_mission) + "dot", _position];
	_dot 			setMarkerColor "ColorBlack";
	_dot 			setMarkerType "hd_flag";
	_dot 			setMarkerText _name;
	uiSleep 1;
	deleteMarker 	_marker;
	deleteMarker 	_dot;			
};