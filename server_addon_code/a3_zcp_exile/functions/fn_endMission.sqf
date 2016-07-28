params[
  '_ZCP_EM_capPointIndex'
];

(ZCP_Data select _ZCP_EM_capPointIndex) set[0,false];
(ZCP_Data select _ZCP_EM_capPointIndex) set[1,0];
(ZCP_Data select _ZCP_EM_capPointIndex) set[2,[-99999,0,0]];
(ZCP_Data select _ZCP_EM_capPointIndex) set[3,false];
ZCP_MissionCounter = ZCP_MissionCounter - 1;
ZCP_MissionTriggerData set [_ZCP_EM_capPointIndex, []];
