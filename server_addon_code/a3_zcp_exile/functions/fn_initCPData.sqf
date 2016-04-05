private["_nil"];
{
	_nil = ZCP_Data pushBack [false,0,[-99999,0,0],true];
	_nil = ZCP_MissionTriggerData pushBack [];
	_x set [4, _forEachIndex];
	_x set [3, format['%1%2',(_x select 3),_forEachIndex]];
} forEach ZCP_CapPoints;

diag_log format['ZCP - CPdata: %1', ZCP_CapPoints];
