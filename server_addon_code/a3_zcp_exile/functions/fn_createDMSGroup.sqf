private['_spawnAIPos','_unitsPerGroup','_dificulty','_solierType','_side', '_groupAI'];
_spawnAIPos = _this select 0;
_unitsPerGroup = _this select 1;
_dificulty = _this select 2;
_solierType = _this select 3;
_side = _this select 4;

_groupAI createGroup EAST;
_groupAI setBehaviour "COMBAT";
_groupAI setCombatMode "RED";

for "_j" from 1 to _unitsPerGroup do {
  [_spawnAIPos, _dificulty, _solierType] call ZCP_fnc_createDMSSoldier;
};

_groupAI selectLeader ((units _groupAI) select 0);
_groupAI setFormation "WEDGE";

_groupAI
