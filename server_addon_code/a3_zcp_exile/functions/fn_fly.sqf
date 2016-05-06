private ["_ZCP_F_veh","_ZCP_F_dir","_ZCP_F_velocity"];
_ZCP_F_veh = _this select 0;
_ZCP_F_dir = _this select 1;
_ZCP_F_velocity = velocity _ZCP_F_veh;
_ZCP_F_veh setDir _ZCP_F_dir;
_ZCP_F_veh setVelocity [
    (_ZCP_F_velocity select 1) * sin _ZCP_F_dir - (_ZCP_F_velocity select 0) * cos _ZCP_F_dir,
    (_ZCP_F_velocity select 0) * sin _ZCP_F_dir + (_ZCP_F_velocity select 1) * cos _ZCP_F_dir,
    _ZCP_F_velocity select 2
];
