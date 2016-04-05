private['_pos','_radius','_ruins'];
_pos = _this select 0;
_radius = _this select 1;
_ruins = _pos nearObjects ["Ruins", _radius];
_ruins call ZCP_fnc_cleanupBase;
