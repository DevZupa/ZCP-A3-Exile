/*  JTD_CityCenter.sqf function.
    By Trexian
    ooooooooooooooooooooooooooooooooooooooooooooooooooo
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

private _posTown = [0,0];
private _cntThis = 0;
private _initArray = [];
private _initCnt = 0;
private _bldgTemp = "";
private _bldgPos = 0;
private _t = 0;
private _z = 0;
private _d = 0;
private _tempArray = [];
private _centerBool = false;
private _posCenter = [0,0,0];
private _direction = 0;
private _cntTemp = 0;
private _posTemp = [0,0,0];
private _srchPos = [0,0,0];
private _srchBldg = [];
private _srchArray = [];
private _srchCnt = 0;
private _holderCnt = 0;
private _holderPos = [0,0,0];
private _posElem = [];
private _posX = 0;
private _posY = 0;


_posX = _posElem select 0;
_posY = _posElem select 1;
_posCenter = [_posX, _posY, 0];         // initial setting of the "center"
_initPos = _posCenter;

   while {! _centerBool} do
   {
      _posTemp = _posCenter;
      _holderCnt = _initCnt;
      _holderPos = _posCenter;
         for [{_d = 1},{_d <= 8},{_d = _d + 1}] do
         {
         _direction = _direction + 45;
         // builds an initial array of buildings within the search area
         // the distance could be tweaked, depending on the results

         _srchPos = [((_posTemp select 0) + sin (_direction) * 100), ((_posTemp select 1) + cos (_direction) *100), 0];
            _tempArray = nearestObjects [_srchPos, ["HOUSE"], 100];
            _t = count _tempArray;
            _t = _t - 1;

            // this is a quick routine to make sure the buildings found are occupiable
            for [{_z = 0},{_z <_t> _holderCnt) then
            {
            _holderPos = _srchPos;
            _holderCnt = _srchCnt;
            };
            // conditional to determine if the search yielded a position different than the last center - that no higher densities were found
            if (((_holderPos select 0) != (_posCenter select 0)) && ((_holderPos select 1) != (_posCenter select 1)) && ((_d == 8))) then
            {
            _posCenter = _holderPos;
            _initCnt = _holderCnt;
            _d = 0;
            };
         };
         _tempArray = nearestObjects [_holderPos, ["HOUSE"], 50];
         if ((count _tempArray) <1> _radA)) then
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
