private['_group',"_capturePosition","_amountAI","_capRadius",'_message','_client','_headlessClients'];
_capturePosition = _this select 0;
_capRadius = _this select 1;

switch (ZCP_AI_Type) do {
  case ('DMS'): {
    if (isNil "DMS_Version") exitWith {
      ZCP_DMS_doIUseDMS = false;
      for "_i" from 0 to 99 do
    	{
    		  diag_log "[ZCP]: You're an idiot";
    	};
    };

    _amountAI = ZCP_Min_AI_Amount + (floor random ZCP_Random_AI_Max);
    // Posted on forums by second_coming;
    _group = [_capturePosition, _amountAI, "moderate", "random", "bandit"] call DMS_fnc_SpawnAIGroup;
    [_group, _capturePosition, _capRadius] call bis_fnc_taskPatrol;
    _group setBehaviour "SAFE";
    _group setCombatMode "YELLOW";
  };
  case ('FUMS'): {
    diag_log format['[ZCP]: Calling FUMS AI.'];
    _headlessClients = entities "HeadlessClient_F";

    _amountAI = ZCP_Min_AI_Amount + (floor random ZCP_Random_AI_Max);
    diag_log format['[ZCP]: Requesting %1 AI soldiers.', _amountAI];
    FuMS_ZCP_Handler = [_capturePosition, _amountAI, _capRadius];

    {
      diag_log format['[ZCP]: Sending request to client %1', owner _x];
      (owner _x) publicVariableClient "FuMS_ZCP_Handler";
    }count _headlessClients;
  };
  default {
        diag_log format ['[ZCP]: No ai system chosen'];
  };
};
