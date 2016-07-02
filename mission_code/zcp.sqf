"PV_ZCP_zupastic" addPublicVariableEventHandler {
	private["_messageArray","_messageString"];
	_messageArray = _this select 1;
	_messageArrayNotification = _messageArray select 1;
	_messageString = _messageArray select 2;
	[_messageString,_messageArrayNotification] call BIS_fnc_showNotification;
	{
		systemChat format["%1",_x];
	}count _messageArrayNotification;
};
