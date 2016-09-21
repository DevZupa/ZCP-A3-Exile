params[
  '_ZCP_CVC_center',
  '_ZCP_CVC_radius',
  '_ZCP_CVC_cityX',
  '_ZCP_CVC_cityY'
];

private _ZCP_CVC_circleObjs = [];

private _ZCP_CVC_radiusX = _ZCP_CVC_cityX;
private _ZCP_CVC_radiusY = _ZCP_CVC_cityY;

if( _ZCP_CVC_cityX == 0 || _ZCP_CVC_cityY == 0 ) then
{
    _ZCP_CVC_radiusX = _ZCP_CVC_radius;
    _ZCP_CVC_radiusY = _ZCP_CVC_radius;
};

// diag_log text format['%1 %2 %3', _ZCP_CVC_radiusX , _ZCP_CVC_radiusY, _ZCP_CVC_radius];

for '_i' from 0 to 360 step (150 / _ZCP_CVC_radius)*2 do
{
  private _ZCP_CVC_location = [(_ZCP_CVC_center select 0) + ((cos _i) * _ZCP_CVC_radiusX), (_ZCP_CVC_center select 1) + ((sin _i) * _ZCP_CVC_radiusY),0];
  private _ZCP_CVC_object = createVehicle ['Sign_Sphere25cm_F', _ZCP_CVC_location, [], 0, 'CAN_COLLIDE'];
  _ZCP_CVC_object setObjectTextureGlobal [0, ZCP_circleNeutralColor];
  _ZCP_CVC_object enableSimulation false;
  _nil = _ZCP_CVC_circleObjs pushBack _ZCP_CVC_object;
};

_ZCP_CVC_circleObjs
