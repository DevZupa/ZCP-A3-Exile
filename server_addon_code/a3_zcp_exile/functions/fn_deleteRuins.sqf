private['_ZCP_DR_pos','_ZCP_DR_radius','_ZCP_DR_ruins'];
_ZCP_DR_pos = _this select 0;
_ZCP_DR_pos set [2,0];
_ZCP_DR_radius = _this select 1;
_ZCP_DR_ruins = _ZCP_DR_pos nearObjects ["Ruins", (_ZCP_DR_radius * 2)];
// diag_log format['[ZCP]: deleting %1 ruins on pos %2 and radius %3', count _ZCP_DR_ruins, _ZCP_DR_pos, _ZCP_DR_radius ];
{
  _nil = deleteVehicle _x;
}count _ZCP_DR_ruins;
