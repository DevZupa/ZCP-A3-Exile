private['_ZCP_CDG_spawnAIPos','_ZCP_CDG_unitsPerGroup','_ZCP_CDG_dificulty','_ZCP_CDG_solierType','_ZCP_CDG_side', '_ZCP_CDG_groupAI'];
_ZCP_CDG_spawnAIPos = _this select 0;
_ZCP_CDG_unitsPerGroup = _this select 1;
_ZCP_CDG_dificulty = _this select 2;
_ZCP_CDG_solierType = _this select 3;
_ZCP_CDG_side = _this select 4;

_ZCP_CDG_groupAI = createGroup _ZCP_CDG_side;
_ZCP_CDG_groupAI setBehaviour "COMBAT";
_ZCP_CDG_groupAI setCombatMode "RED";

for "_i" from 1 to _ZCP_CDG_unitsPerGroup do {
  [_ZCP_CDG_groupAI, _ZCP_CDG_spawnAIPos, _ZCP_CDG_dificulty, _ZCP_CDG_solierType] call ZCP_fnc_createDMSSoldier;
};

_ZCP_CDG_groupAI selectLeader ((units _ZCP_CDG_groupAI) select 0);
_ZCP_CDG_groupAI setFormation "WEDGE";

_ZCP_CDG_groupAI
