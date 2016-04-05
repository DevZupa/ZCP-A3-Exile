private['_pos','_radius','_ruins'];
_pos = _this select 0;
_radius = _this select 1;
_ruins = _pos nearObjects ["Ruins", (_radius * 2)];
diag_log format['[ZCP]: deleting %1 ruins', count _ruins];
{
  _nil = deleteVehicle _x;
}count _ruins
