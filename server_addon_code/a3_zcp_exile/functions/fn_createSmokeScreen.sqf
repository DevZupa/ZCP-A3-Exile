params[
  '_ZCP_CVC_center',
  '_ZCP_CVC_radius',
  '_ZCP_CVC_waitTime',
  '_ZCP_CVC_extraRadius',
  '_ZCP_CVC_cityX',
  '_ZCP_CVC_cityY'
];

private _ZCP_CVC_radiusX = _ZCP_CVC_cityX;
private _ZCP_CVC_radiusY = _ZCP_CVC_cityY;

if( _ZCP_CVC_cityX == 0 || _ZCP_CVC_cityY == 0 ) then
{
    _ZCP_CVC_radiusX =  _ZCP_CVC_radius;
    _ZCP_CVC_radiusY =  _ZCP_CVC_radius;
};

private _ZCP_CVC_newRadiusX = _ZCP_CVC_radiusX + _ZCP_CVC_extraRadius;
private _ZCP_CVC_newRadiusY = _ZCP_CVC_radiusY + _ZCP_CVC_extraRadius;

uiSleep _ZCP_CVC_waitTime;

for '_i' from 0 to 360 step (360 / _ZCP_CVC_radius * 1.5) do
{
  _ZCP_CVC_location = [(_ZCP_CVC_center select 0) + ((cos _i) * _ZCP_CVC_newRadiusX), (_ZCP_CVC_center select 1) + ((sin _i) * _ZCP_CVC_newRadiusY),0];
  _nil = "SmokeShellArty" createVehicle _ZCP_CVC_location;
};
