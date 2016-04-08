// This code goes into the if of the fumsinit.sqf
"FuMS_ZCP_Handler" addPublicVariableEventHandler
{
        private['_ZCP_AI_position','_ZCP_AI_amount','_ZCP_AI_radius','_units', '_themeIndex', '_group', '_types','_themeIndex','_type','_transferedData','_data'];
        _transferedData = _this select 1;

        diag_log format['[ZCP-HC]: Received request.'];

        _type = _transferedData select 0;
        _data = _transferedData select 1;

        _themeIndex = 0;
        {
            if ( (_x select 0) select 0 == 'SEM' ) then {
                _themeIndex = _forEachIndex;
            };
        } forEach FuMS_THEMEDATA;

        _units = [];

        _types = ["Rifleman","LMG", "Sniper"];

        if(_type == 'Normal') then {

        _ZCP_AI_position = _data select 0;
        _ZCP_AI_amount = _data select 1;
        _ZCP_AI_radius = _data select 2;

        diag_log format['[ZCP-HC]: Spawning %1 AI.', _ZCP_AI_amount];

        for "_i" from 1 to _ZCP_AI_amount do
        {
            _units pushBack [1, _types call BIS_fnc_selectRandom];
        };

        _group = createGroup EAST;
        _group = [_group,_ZCP_AI_position, _units,_themeIndex ] call FuMS_fnc_HC_msnCtrl_Spawn_CreateGroup;

        _group setBehaviour "COMBAT";
        _group setCombatMode "YELLOW";

        [_group, _ZCP_AI_position, (_ZCP_AI_radius / 3 * 2) ] call AreaPatrol;
      };

      if(_type == 'Wave') then {
        diag_log format['[ZCP]: FUMS ZCP Wave'];

        _waveData = _data select 0;
        _unitsPerGroup = _waveData select 1;
        _amountOfGroups = _waveData select 2;
        _distanceFromZCP = _waveData select 3;

        _useRandomGroupLocations = _waveData select 4;

        _capturePosition = _data select 1;

        _spawnAIPos = [_capturePosition, (_distanceFromZCP - 50), (_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;

        for "_i" from 1 to _amountOfGroups do
        {
          _units = [];
          for "_j" from 1 to _unitsPerGroup do
          {
              _units pushBack [1, _types call BIS_fnc_selectRandom];
          };

          if(_useRandomGroupLocations) then {
            _spawnAIPos = [_capturePosition, (_distanceFromZCP - 50), (_distanceFromZCP + 50), 1, 0, 9999, 0] call BIS_fnc_findSafePos;
          };

          _group = createGroup EAST;
          _group = [_group,_spawnAIPos, _units,_themeIndex ] call FuMS_fnc_HC_msnCtrl_Spawn_CreateGroup;

          _group setBehaviour "COMBAT";
          _group setCombatMode "YELLOW";

          uiSleep 2;

          _attackWP = _group addWaypoint [_capturePosition, 5];
          _attackWP setWaypointType "MOVE";
          _attackWP setWaypointSpeed "FULL";
          _attackWP setWaypointBehaviour "COMBAT";

          _holdWP = _group addWaypoint [_capturePosition, 5];
          _holdWP setWaypointType "HOLD";
          _holdWP setWaypointSpeed "NORMAL";
          _holdWP setWaypointBehaviour "COMBAT";

          _group setCurrentWaypoint _attackWP;
        };
      };
};
