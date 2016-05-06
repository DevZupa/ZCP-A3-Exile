private['_ZCP_DL_pos','_ZCP_DL_radius','_ZCP_DL_loot','_lootToDelete'];
_ZCP_DL_pos = _this select 0;
_ZCP_DL_pos set [2,0];
_ZCP_DL_radius = _this select 1;
_ZCP_DL_loot = _ZCP_DL_pos nearObjects ["LootWeaponHolder", (_ZCP_DL_radius * 2)];
// diag_log format['[ZCP]: deleting %1 loot on pos %2 and radius %3', count _ZCP_DL_loot, _ZCP_DL_pos, _ZCP_DL_radius ];
{
  if(((getPosATL _x) select 2) > 0.5 ) then {
     _nil = deleteVehicle _x;
  };
}count _ZCP_DL_loot;
