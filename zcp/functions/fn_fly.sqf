private ["_veh","_dir","_v"];
_veh = _this select 0;
_dir = _this select 1;
_v = velocity _veh;
_veh setDir _dir;
_veh setVelocity [
    (_v select 1) * sin _dir - (_v select 0) * cos _dir,
    (_v select 0) * sin _dir + (_v select 1) * cos _dir,
    _v select 2
];
