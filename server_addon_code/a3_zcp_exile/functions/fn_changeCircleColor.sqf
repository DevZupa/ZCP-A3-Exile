private ['_ZCP_CCC_colorType','_ZCP_CCC_circleObjects','_ZCP_CCC_color'];
_ZCP_CCC_circleObjects = _this select 0;
_ZCP_CCC_colorType = _this select 1;

_ZCP_CCC_color = ZCP_circleNeutralColor;

switch (_ZCP_CCC_colorType) do {
    case ("capping"): {
        _ZCP_CCC_color = ZCP_circleCappingColor;
    };
    case ("contested"): {
        _ZCP_CCC_color = ZCP_circleContestedColor;
    };
};

{
  _x enableSimulation true;
  _x setObjectTextureGlobal [0,_ZCP_CCC_color];
  _x enableSimulation false;
}count _ZCP_CCC_circleObjects;
