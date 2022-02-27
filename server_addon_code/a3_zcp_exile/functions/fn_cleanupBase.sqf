private ["_location","_pos","_nil","_position","_nearPlayers","_positionX","_positionNew"];
_location = [];
{
	_pos = getPosATL _x;
	_location pushBackUnique _pos;
	_nil = deleteVehicle _x;
}count _this;

_position = _location select 0;
_nearPlayers = [];
_nearPlayers = _position nearObjects ["Man", 100];
if !(_nearPlayers isEqualTo []) then
{
	{
		if !(alive _x) then
		{
			_positionX = getPosATL _x;
			if ((_positionX select 2 > 1) && !(isTouchingGround _x)) then
			{
				_positionNew = [(_positionX select 0),(_positionX select 1), 0] findEmptyPosition [0,30];
				_x setPosATL _positionNew;
			};
		};
	} forEach _nearPlayers;
};
