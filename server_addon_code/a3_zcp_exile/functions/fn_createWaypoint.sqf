private['_ZCP_CWP_attackWP','_ZCP_CWP_group','_ZCP_CWP_capturePosition','_ZCP_CWP_holdWP'];

_ZCP_CWP_group = _this select 0;
_ZCP_CWP_capturePosition = _this select 1;
_ZCP_CWP_attackWP = _ZCP_CWP_group addWaypoint [_ZCP_CWP_capturePosition, 5];
_ZCP_CWP_attackWP setWaypointType "MOVE";
_ZCP_CWP_attackWP setWaypointSpeed "FULL";
_ZCP_CWP_attackWP setWaypointBehaviour "COMBAT";

_ZCP_CWP_holdWP = _ZCP_CWP_group addWaypoint [_ZCP_CWP_capturePosition, 5];
_ZCP_CWP_holdWP setWaypointType "HOLD";
_ZCP_CWP_holdWP setWaypointSpeed "NORMAL";
_ZCP_CWP_holdWP setWaypointBehaviour "COMBAT";

_ZCP_CWP_group setCurrentWaypoint _ZCP_CWP_attackWP;
