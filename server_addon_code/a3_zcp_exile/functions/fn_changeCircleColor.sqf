private ['_radius','_type','_location','_dir','_object','_objs'];
_objs = _this select 0;
_type = _this select 1;

_color = ZCP_circleNeutralColor;

switch (_type) do {
    case ("capping"): {
        _color = ZCP_circleCappingColor;
    };
    case ("contested"): {
        _color = ZCP_circleContestedColor;
    };
};

{
  _x setObjectTextureGlobal [0,_color];
}count _objs;
