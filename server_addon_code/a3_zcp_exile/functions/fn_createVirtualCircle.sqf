private ['_ZCP_CVC_radius','_ZCP_CVC_center','_ZCP_CVC_location','_dir','_ZCP_CVC_object','_ZCP_CVC_circleObjs'];
_ZCP_CVC_circleObjs = [];
_ZCP_CVC_center = _this select 0;
_ZCP_CVC_radius = _this select 1;

for '_i' from 0 to 360 step (150 / _ZCP_CVC_radius)*2 do
{
  _ZCP_CVC_location = [(_ZCP_CVC_center select 0) + ((cos _i) * _ZCP_CVC_radius), (_ZCP_CVC_center select 1) + ((sin _i) * _ZCP_CVC_radius),0];
  _ZCP_CVC_object = createVehicle ['Sign_Sphere25cm_F', _ZCP_CVC_location, [], 0, 'CAN_COLLIDE'];
  _ZCP_CVC_object setObjectTextureGlobal [0, ZCP_circleNeutralColor];
    _nil = _ZCP_CVC_circleObjs pushBack _ZCP_CVC_object;
};

_ZCP_CVC_circleObjs
