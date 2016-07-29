/* JTD_CityBorder.sqf function.
By Trexian
Credits:
OFPEC
DMarkwick, for math
Hoz, for the FindNearestTown resource
Baddo, for findBuildingPositions sqf reference
Raven, for takeBuilding sqs reference
*/

params[
  '_posElem'
];

// these are the main tweakable values
private _densityCutoff = .2;
private _dist = 0;
private _radiusFactor = 0;

private _initCnt = 0;
private _t = 0;
private _d = 0;
private _tempArray = [];
private _centerBool = false;
private _posCenter = [0,0,0];
private _direction = 0;
private _cntTemp = 0;
private _posTemp = [0,0,0];
private _srchPos = [0,0,0];
private _srchCnt = 0;
private _radA = 10;
private _radB = 10;
private _tmpRatio = .2;
private _angle = 0;
private _radius = 50;


private _return = [];
_posX = _posElem select 0;
_posY = _posElem select 1;

_posCenter = [_posX, _posY, 0];
_tempArray = nearestObjects [_posCenter, ["HOUSE"], 100];
_cntTemp = count _tempArray;
_posCenter = getPos (_tempArray select 0);
_initPos = _posCenter;
_initCnt = _cntTemp;
_initRatio = _cntTemp / 100;



// conditional to determine whether to use the Big City function or not
if (_initRatio < .75) then
   {
      _radius = 100;
      _dist = 50;
      _densityCutoff = .2;
      _radiusFactor = .75;
   }
   else
   {
      _radius = 150;
      _dist = 50;
      _densityCutoff = .1;
      _radiusFactor = 1;
   };

   for [{_t = 1},{_t <4> (_initRatio * _densityCutoff)} do
         {
            _d = _d + 1;

            _dist = _d * _radius;
            _direction = _t * 90;
            _srchPos = [((_posCenter select 0) + sin (_direction) * (_dist)), ((_posCenter select 1) + cos (_direction) * (_dist)), 0];
            _tempArray = nearestObjects [_srchPos, ["HOUSE"], _radius];
            _cntTemp = count _tempArray;
            _tmpRatio = (_cntTemp / _radius);
         };
         _d = 0;
        // conditional to determine which direction we're looking at
      if (((_t == 1) || (_t == 3)) && (_dist > _radA)) then
         {
            _radA = _dist;
         };
      if (((_t == 2) || (_t == 4))  && (_dist > _radB)) then
         {
            _radB = _dist;
         };

         _radA = _radA * _radiusFactor;
         _radB = _radB * _radiusFactor;
         _return = [_radA, _radB];
   };

_return
