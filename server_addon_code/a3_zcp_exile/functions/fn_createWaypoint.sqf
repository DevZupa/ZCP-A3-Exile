private['_attackWP','_group','_capturePosition']

_group = _this select 0;
_capturePosition = _this select 1;
_attackWP = _group addWaypoint [_capturePosition, 5];
_attackWP setWaypointType "MOVE";
_attackWP setWaypointSpeed "NORMAL";
_attackWP setWaypointBehaviour "COMBAT";

_holdWP = _group addWaypoint [_capturePosition, 5];
_holdWP setWaypointType "HOLD";
_holdWP setWaypointSpeed "NORMAL";
_holdWP setWaypointBehaviour "COMBAT";

_group setCurrentWaypoint _attackWP;
