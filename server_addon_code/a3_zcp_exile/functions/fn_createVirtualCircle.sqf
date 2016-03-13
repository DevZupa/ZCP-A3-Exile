private ['_radius','_center','_location','_dir','_object','_objs'];
_objs = [];
_center = _this select 0;
_radius = _this select 1;

for '_i' from 0 to 360 step (150 / _radius)*2 do
{
  _location = [(_center select 0) + ((cos _i) * _radius), (_center select 1) + ((sin _i) * _radius),0];
  _object = createVehicle ['Sign_sphere25cm_EP1', _location, [], 0, 'CAN_COLLIDE'];
  _object setObjectTextureGlobal [0, ZCP_circleNeutralColor];
	_nil = _objs pushBack _object;
};

_objs
