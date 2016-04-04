private ["_i","_safepos","_validspot","_position","_baseRadius","_distanceFromObjects", "_terrainGradientPos"];
_distanceFromObjects = _this select 0;
_terrainGradientPos = _this select 1;

_safepos		= [ZCP_MapCenterPos, 0, ZCP_MapRadius, _distanceFromObjects, 0, _terrainGradientPos, 0];
//diag_log format['[ZCP]: %1 selected | Objectdistance: %2 | Gradient: %3', _safepos, _distanceFromObjects, _terrainGradientPos];
_validspot 	= false;
while{!_validspot} do {
	sleep 1;
	_position 	= _safepos call BIS_fnc_findSafePos;
	_validspot	= true;
	if (_position call ZCP_fnc_inDebug) then {
		_validspot = false;
		//diag_log format['[ZCP]: %1 in debug', _position];
	};
	if(_validspot ) then {
		if ([_position, ZCP_DistanceFromWater] call ZCP_fnc_nearWater) then {
		_validspot = false;
		//diag_log format['[ZCP]: %1 to close to water (%2 meter)', _position, ZCP_DistanceFromWater];
		};
	};
	if(_validspot) then {
		{
			if ( (_x select 2) select 0 != -99999 && _position distance2D (_x select 2) < ZCP_DistanceBetweenMissions) then {
					_validspot = false;
					//diag_log format['[ZCP]: %1 to close to other mission', _position];
			};
		} count ZCP_Data;
  };
	if(_validspot) then {
		{
			if ( _position distance2D _x < ZCP_DistanceFromPlayers) then {
					_validspot = false;
					//diag_log format['[ZCP]: %1 to close to a player called %2', _position, name _x];
			};
		} count allPlayers;
	};
	if(_validspot) then {
		{
			if ( _position distance2D (_x select 0) < (_x select 1)) then {
					_validspot = false;
					//diag_log format['[ZCP]: %1 to close to bloacklist %2', _position, _x];
			};
		} count ZCP_Blacklist;
  };
	if(_validspot ) then {
		// DMS code, Credits -> DMS
		{
			// Check for nearby spawn points
			if ((ZCP_SpawnZoneDistance>0) && {((markertype _x) in ZCP_SpawnZoneMarkerTypes) && {((getMarkerPos _x) distance2D _position) <= ZCP_SpawnZoneDistance}}) then
			{
					_validspot = false;
					//diag_log format['[ZCP]: %1 to close to spanwzone %2 meter', _position, ZCP_SpawnZoneDistance];
			};

			// Check for nearby trader zones
			if ((ZCP_TradeZoneDistance>0) && {((markertype _x) in ZCP_TraderZoneMarkerTypes) && {((getMarkerPos _x) distance2D _position) <= ZCP_TradeZoneDistance}}) then
			{
					_validspot = false;
					//diag_log format['[ZCP]: %1 to close to traderzone %2 meter', _position, ZCP_TradeZoneDistance];
			};
		} forEach allMapMarkers;
	};
};
_position set [2, 0];
_position
