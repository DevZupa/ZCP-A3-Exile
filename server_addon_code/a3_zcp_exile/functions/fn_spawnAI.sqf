private['_ZCP_SA_minAI','_ZCP_SA_maxAI','_ZCP_SA_group',"_ZCP_SA_capturePosition","_ZCP_SA_amountAI","_ZCP_SA_capRadius",'_message','_client','_ZCP_SA_headlessClients','_ZCP_SA_holdWP'];

_ZCP_SA_capturePosition = _this select 0;
_ZCP_SA_capRadius = _this select 1;
_ZCP_SA_minAI = _this select 2;
_ZCP_SA_maxAI = _this select 3;

switch (ZCP_AI_Type) do {
  case ('DMS'): {
    if (isNil "DMS_Version") exitWith {
      ZCP_DMS_doIUseDMS = false;
      for "_i" from 0 to 99 do
    	{
    		  diag_log "[ZCP]: You don't have DMS, please edit the config.";
    	};
    };

    _ZCP_SA_amountAI = _ZCP_SA_minAI;

    if(_ZCP_SA_maxAI - _ZCP_SA_minAI > 0) then {
       _ZCP_SA_amountAI = _ZCP_SA_minAI + (floor random (_ZCP_SA_maxAI - _ZCP_SA_minAI));
    };
    // Posted on forums by second_coming;
    _ZCP_SA_group = [_ZCP_SA_capturePosition, _ZCP_SA_amountAI, "moderate", "random", EAST] call ZCP_fnc_createDMSGroup;

    _ZCP_SA_group setBehaviour "AWARE";
    _ZCP_SA_group setCombatMode "YELLOW";

    _ZCP_SA_holdWP = _ZCP_SA_group addWaypoint [_ZCP_SA_capturePosition, 5];
    _ZCP_SA_holdWP setWaypointType "HOLD";
    _ZCP_SA_holdWP setWaypointSpeed "NORMAL";
    _ZCP_SA_holdWP setWaypointBehaviour "COMBAT";

  };
  case ('FUMS'): {
    diag_log format['[ZCP]: Calling FUMS AI.'];
    _ZCP_SA_headlessClients = entities "HeadlessClient_F";

   _ZCP_SA_amountAI = _ZCP_SA_minAI;

   if(_ZCP_SA_maxAI - _ZCP_SA_minAI > 0) then {
      _ZCP_SA_amountAI = _ZCP_SA_minAI + (floor random (_ZCP_SA_maxAI - _ZCP_SA_minAI));
   };
    diag_log format['[ZCP]: Requesting %1 AI soldiers.', _ZCP_SA_amountAI];
    FuMS_ZCP_Handler = ['Normal',[_ZCP_SA_capturePosition, _ZCP_SA_amountAI, _ZCP_SA_capRadius]];

    {
      diag_log format['[ZCP]: Sending request to client %1', owner _x];
      (owner _x) publicVariableClient "FuMS_ZCP_Handler";
    }count _ZCP_SA_headlessClients;
  };
  default {
        diag_log format ['[ZCP]: No ai system chosen'];
  };
};
