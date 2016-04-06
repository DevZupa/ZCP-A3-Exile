// This code goes into the if of the fumsinit.sqf
"FuMS_ZCP_Handler" addPublicVariableEventHandler
{
        private['_ZCP_AI_position','_ZCP_AI_amount','_units', '_themeIndex', '_group', '_types'];
        _transferedData = _this select 1;

        diag_log format['[ZCP-HC]: Received request.'];

        _type = _transferedData select 0;
        _data = _transferedData select 1;

        if(_type == 'Normal') then {

        _ZCP_AI_position = _data select 0;
        _ZCP_AI_amount = _data select 1;
        _ZCP_AI_radius = _data select 2;

        _themeIndex = 0;

        diag_log format['[ZCP-HC]: Spawning %1 AI.', _ZCP_AI_amount];

        {
            if ( (_x select 0) select 0 == 'SEM' ) then {
                _themeIndex = _forEachIndex;
            };
        } forEach FuMS_THEMEDATA;

        _units = [];

        _types = ["Rifleman","LMG", "Sniper"];

        for "_i" from 1 to _ZCP_AI_amount do
        {
            _units pushBack [1, _types call BIS_fnc_selectRandom];
        };

        _group = createGroup EAST;
        _group = [_group,_ZCP_AI_position, _units,_themeIndex ] call FuMS_fnc_HC_msnCtrl_Spawn_CreateGroup;

        _group setBehaviour "SAFE";
        _group setCombatMode "YELLOW";

        [_group, _ZCP_AI_position, (_ZCP_AI_radius / 3 * 2) ] call AreaPatrol;
      };
};
