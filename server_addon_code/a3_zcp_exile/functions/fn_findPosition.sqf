private ["_i","_safepos","_validspot","_position"];
_safepos		= [ZCP_MapCenterPos,0,ZCP_MapRadius,ZCP_MinDistanceFromObject,0,ZCP_TerrainGradient,0];
_validspot 	= false;
while{!_validspot} do {
	sleep 1;
	_position 	= _safepos call BIS_fnc_findSafePos;
	_validspot	= true;
	if (_position call ZCP_fnc_inDebug) then {
		_validspot = false;
	};
	if(_validspot ) then {
		if ([_position,10] call ZCP_fnc_nearWater) then {
		_validspot = false;
		};
	};
	if(_validspot ) then {
		// DMS code, Credits -> DMS
		{
			// Check for nearby spawn points
			if ((ZCP_SpawnZoneDistance>0) && {((markertype _x) in ZCP_SpawnZoneMarkerTypes) && {((getMarkerPos _x) distance2D _position)<=ZCP_SpawnZoneDistance}}) then
			{
					_validspot = false;
			};

			// Check for nearby trader zones
			if ((ZCP_TradeZoneDistance>0) && {((markertype _x) in ZCP_TraderZoneMarkerTypes) && {((getMarkerPos _x) distance2D _position)<=ZCP_TradeZoneDistance}}) then
			{
					_validspot = false;
			};
		} forEach allMapMarkers;
	};
};
_position set [2, 0];
_position
