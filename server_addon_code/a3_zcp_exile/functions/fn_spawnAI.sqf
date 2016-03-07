private['_group',"_capturePosition","_ammountAI","_capRadius"];
_capturePosition = _this select 0;
_capRadius = _this select 1;

if(ZCP_DMS_doIUseDMS) then {
  if (isNil "DMS_Version") exitWith {
    ZCP_DMS_doIUseDMS = false;
    diag_log "You're an idiot";
  };

  _ammountAI = ZCP_Min_AI_Amount + (floor random ZCP_Random_AI_Max);
  // Posted on forums by second_coming;
  _group = [_capturePosition, _ammountAI, "moderate", "random", "bandit"] call DMS_fnc_SpawnAIGroup;
  [_group, _capturePosition, _capRadius] call bis_fnc_taskPatrol;
  _group setBehaviour "AWARE";
  _group setCombatMode "RED";
} else {
  diag_log format ['No ai system chosen'];
};
