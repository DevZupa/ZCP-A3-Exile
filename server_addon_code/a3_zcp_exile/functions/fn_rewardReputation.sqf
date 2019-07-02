private['_ZCP_RR_awardToGive','_ZCP_RR_playerScore','_ZCP_RR_currentCapper'];

_ZCP_RR_currentCapper = _this select 0;

_ZCP_RR_awardToGive = ZCP_MinReputationReward + (ZCP_ReputationReward) * (count allPlayers);
_ZCP_RR_playerScore = _ZCP_RR_currentCapper getVariable ["ExileScore", 0];
_ZCP_RR_playerScore = _ZCP_RR_playerScore + _ZCP_RR_awardToGive;

_ZCP_RR_currentCapper setVariable ["ExileScore",_ZCP_RR_playerScore];
_ZCP_RR_currentCapper setVariable['PLAYER_STATS_VAR', [_ZCP_RR_currentCapper getVariable ['ExileScore', 0], _ZCP_RR_playerScore],true];

format["setAccountScore:%1:%2", _ZCP_RR_playerScore,getPlayerUID _ZCP_RR_currentCapper] call ExileServer_system_database_query_fireAndForget;

['Reputation',[_ZCP_RR_currentCapper, "showFragRequest", [[[format ["ZCP %1", [9] call ZCP_fnc_translate],_ZCP_RR_awardToGive]]]]] call ZCP_fnc_showNotification;

ExileClientPlayerScore = _ZCP_RR_playerScore;
(owner _ZCP_RR_currentCapper) publicVariableClient "ExileClientPlayerScore";
ExileClientPlayerScore = nil;

_ZCP_RR_currentCapper call ExileServer_object_player_database_update;

if( ZCP_ReputationRewardForGroup > 0 ) then {
  private['_ZCP_RR_capperGroup','_ZCP_RR_newScore'];
  _ZCP_RR_capperGroup = group _ZCP_RR_currentCapper;
  if( _ZCP_RR_capperGroup != grpNull ) then {
    {
      if (_x != _ZCP_RR_currentCapper && _x distance2D _ZCP_RR_currentCapper < ZCP_CONFIG_GroupDistanceForRespect ) then {
        _ZCP_RR_newScore = (_x getVariable ["ExileScore", 0]) + ZCP_ReputationRewardForGroup;
        _x setVariable ["ExileScore", _ZCP_RR_newScore ];
        _x setVariable['PLAYER_STATS_VAR', [_x getVariable ['ExileScore', 0], _ZCP_RR_newScore],true];
        format["setAccountScore:%1:%2", _ZCP_RR_newScore, getPlayerUID _x] call ExileServer_system_database_query_fireAndForget;
        _x call ExileServer_object_player_database_update;

        ExileClientPlayerScore = _ZCP_RR_newScore;
        (owner _x) publicVariableClient "ExileClientPlayerScore";
        ExileClientPlayerScore = nil;

        ['Reputation', [_x, "showFragRequest", [[[format ["ZCP %1", [10] call ZCP_fnc_translate],ZCP_ReputationRewardForGroup]]]]] call ZCP_fnc_showNotification;
      }
    }count (units _ZCP_RR_capperGroup);
  };
};
