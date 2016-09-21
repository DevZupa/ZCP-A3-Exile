ZCP_Towns = [["NameVillage","NameCity","NameCityCapital"],[ZCP_MapCenterPos, ZCP_MapRadius] ] call BIS_fnc_locations;
ZCP_TownsCalculated = [];

{
  private _ZCP_CC_citycenter = [locationPosition _x] call ZCP_fnc_getActualCityCenter;
  private _ZCP_CC_cityborder = [_ZCP_CC_citycenter] call ZCP_fnc_getActualCitySize;
  _nil = ZCP_TownsCalculated pushBack [ _x, [_ZCP_CC_citycenter select 0, _ZCP_CC_citycenter select 1], [_ZCP_CC_cityborder select 0, _ZCP_CC_cityborder select 1]];

  private _ZCP_CM_marker 			= createMarker [format['ZCP_CM_%1', random 5000], (_ZCP_CC_citycenter set [2 , 0])];
  _ZCP_CM_marker setMarkerColor 'ColorPink';
  _ZCP_CM_marker setMarkerShape "ELLIPSE";
  _ZCP_CM_marker setMarkerBrush "Solid";
  _ZCP_CM_marker setMarkerSize [_ZCP_CC_cityborder select 0,_ZCP_CC_cityborder select 1];

} count ZCP_Towns;


// Not use anymore. TODO delete.