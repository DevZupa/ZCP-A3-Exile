private ['_ZCP_CVC_radius','_ZCP_CVC_center','_ZCP_CVC_waitTime','_ZCP_CVC_extraRadius','_ZCP_CVC_newRadius'];

_ZCP_CVC_center = _this select 0;
_ZCP_CVC_radius = _this select 1;
_ZCP_CVC_waitTime = _this select 2;
_ZCP_CVC_extraRadius = _this select 3;

_ZCP_CVC_newRadius = _ZCP_CVC_radius + _ZCP_CVC_extraRadius;

uiSleep _ZCP_CVC_waitTime;

for '_i' from 0 to 360 step (360 / _ZCP_CVC_radius * 1.5) do
{
  _ZCP_CVC_location = [(_ZCP_CVC_center select 0) + ((cos _i) * _ZCP_CVC_newRadius), (_ZCP_CVC_center select 1) + ((sin _i) * _ZCP_CVC_newRadius),0];
  _nil = "SmokeShellArty" createVehicle _ZCP_CVC_location;
};


