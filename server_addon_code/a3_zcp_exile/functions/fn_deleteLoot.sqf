private['_pos','_radius','_loot','_lootToDelete'];
_pos = _this select 0;
_radius = _this select 1;

_loot = _pos nearObjects ["GroundWeaponHolder", 20];

_lootToDelete = [];

{
  if((getPosATL _x) select 2 > 0.5 ) then {
    _lootToDelete pushBack _x;
  };
}count _loot;

_lootToDelete call ZCP_fnc_cleanupBase;
