private ["_ZCP_FP_safepos","_ZCP_FP_validspot","_ZCP_FP_position","_baseRadius","_ZCP_FP_distanceFromObjects", "_ZCP_FP_terrainGradientPos"];
_ZCP_FP_distanceFromObjects = _this select 0;
_ZCP_FP_terrainGradientPos = _this select 1;

_ZCP_FP_safepos		= [ZCP_MapCenterPos, 0, ZCP_MapRadius, _ZCP_FP_distanceFromObjects, 0, _ZCP_FP_terrainGradientPos, 0];
//diag_log format['[ZCP]: %1 selected | Objectdistance: %2 | Gradient: %3', _ZCP_FP_safepos, _ZCP_FP_distanceFromObjects, _ZCP_FP_terrainGradientPos];
_ZCP_FP_validspot 	= false;
while{!_ZCP_FP_validspot} do {
	sleep 1;
	_ZCP_FP_position 	= _ZCP_FP_safepos call BIS_fnc_findSafePos;
	_ZCP_FP_validspot	= true;
	if (_ZCP_FP_position call ZCP_fnc_inDebug) then {
		_ZCP_FP_validspot = false;
		//diag_log format['[ZCP]: %1 in debug', _ZCP_FP_position];
	};
	if(_ZCP_FP_validspot ) then {
		if ([_ZCP_FP_position, ZCP_DistanceFromWater] call ZCP_fnc_nearWater) then {
		_ZCP_FP_validspot = false;
		//diag_log format['[ZCP]: %1 to close to water (%2 meter)', _ZCP_FP_position, ZCP_DistanceFromWater];
		};
	};
	if(_ZCP_FP_validspot) then {
		{
			if ( (_x select 2) select 0 != -99999 && _ZCP_FP_position distance2D (_x select 2) < ZCP_DistanceBetweenMissions) then {
					_ZCP_FP_validspot = false;
					//diag_log format['[ZCP]: %1 to close to other mission', _ZCP_FP_position];
			};
		} count ZCP_Data;
  };
	if(_ZCP_FP_validspot) then {
		{
			if ( _ZCP_FP_position distance2D _x < ZCP_DistanceFromPlayers) then {
					_ZCP_FP_validspot = false;
					//diag_log format['[ZCP]: %1 to close to a player called %2', _ZCP_FP_position, name _x];
			};
		} count allPlayers;
	};
	if(_ZCP_FP_validspot) then {
		{
			if ( _ZCP_FP_position distance2D (_x select 0) < (_x select 1)) then {
					_ZCP_FP_validspot = false;
					//diag_log format['[ZCP]: %1 to close to bloacklist %2', _ZCP_FP_position, _x];
			};
		} count ZCP_Blacklist;
  };
	if(_ZCP_FP_validspot ) then {
		// DMS code, Credits -> DMS
		{
			// Check for nearby spawn points
			if ((ZCP_SpawnZoneDistance>0) && {((markertype _x) in ZCP_SpawnZoneMarkerTypes) && {((getMarkerPos _x) distance2D _ZCP_FP_position) <= ZCP_SpawnZoneDistance}}) then
			{
					_ZCP_FP_validspot = false;
					//diag_log format['[ZCP]: %1 to close to spanwzone %2 meter', _ZCP_FP_position, ZCP_SpawnZoneDistance];
			};

			// Check for nearby trader zones
			if ((ZCP_TradeZoneDistance>0) && {((markertype _x) in ZCP_TraderZoneMarkerTypes) && {((getMarkerPos _x) distance2D _ZCP_FP_position) <= ZCP_TradeZoneDistance}}) then
			{
					_ZCP_FP_validspot = false;
					//diag_log format['[ZCP]: %1 to close to traderzone %2 meter', _ZCP_FP_position, ZCP_TradeZoneDistance];
			};
		} forEach allMapMarkers;
	};
};
_ZCP_FP_position set [2, 0];
_ZCP_FP_position
