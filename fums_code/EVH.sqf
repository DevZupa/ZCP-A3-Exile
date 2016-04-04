"FuMS_ZCP_Handler" addPublicVariableEventHandler
{
        private['_ZCP_AI_position','_ZCP_AI_amount','_units', '_themeIndex', '_group', '_types'];
        _data = _this select 1;

        diag_log format['[ZCP]: Received request.'];

        _ZCP_AI_position = _data select 0;
        _ZCP_AI_amount = _data select 1;
        _ZCP_AI_radius = _data select 2;

        _themeIndex = 0;

        diag_log format['[ZCP]: Spawning %1 AI.', _ZCP_AI_amount];

        {
            if ( (_x select 0) select 0 == 'SEM' ) then {
                _themeIndex = _forEachIndex;
            };
        } forEach FuMS_THEMEDATA;

        _units = [];

        _types = ["Rifleman","LMG", "Sniper"];

        {
            _units pushBack [1, _types call BIS_fnc_selectRandom];
        }count _ZCP_AI_amount;

        _group = createGroup RESISTANCE;
        _group = [_group,_spawnpos, _units,_themeIndex ] call FuMS_fnc_HC_msnCtrl_Spawn_CreateGroup;

        _group setBehaviour "SAFE";
        _group setCombatMode "YELLOW";

    [_group, _ZCP_AI_position, _ZCP_AI_radius] call bis_fnc_taskPatrol;
};
