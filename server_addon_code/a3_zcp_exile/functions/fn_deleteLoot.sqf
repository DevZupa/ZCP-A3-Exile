private['_pos','_radius','_loot','_lootToDelete'];
_pos = _this select 0;
_radius = _this select 1;
_loot = _pos nearObjects ["LootWeaponHolder", (_radius * 2)];
diag_log format['[ZCP]: deleting %1 ruins', count _loot];
{
  if(((getPosATL _x) select 2) > 0.5 ) then {
     _nil = deleteVehicle _x;
  };
}count _loot;
