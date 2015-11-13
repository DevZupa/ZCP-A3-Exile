//Code for mission file.

"PV_ZCP_zupastic_client" addPublicVariableEventHandler {
	private["_type","_newPlayerMoneyString","_itemClassName","_quantity","_containerType","_containerNetID","_newPlayerMoney","_rewardPrice","_containersBefore","_containersAfter","_vehicle","_dialog"];
	_messageArray = _this select 1;
	_newPlayerMoneyString = _messageArray select 1;
	_type = _messageArray select 2;
	_rewardPrice = 0;
	if (_type == 'Poptabs') then {
		_newPlayerMoney = parseNumber _newPlayerMoneyString;
		_rewardPrice = _newPlayerMoney - ExileClientPlayerMoney;
		ExileClientPlayerMoney = _newPlayerMoney;
	} else {
		_newPlayerMoney = parseNumber _newPlayerMoneyString;
		_rewardPrice = _newPlayerMoney - ExileClientPlayerScore;
		ExileClientPlayerScore = _newPlayerMoney;
	};
	["Success",[format ["Gratz, You received %1 %2.",_rewardPrice, _type]]] call BIS_fnc_showNotification;
};

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

// THe folowing goes into mission.sqm
/**
*class CfgNotifications
*{
*	class ZCP
*	{
*		title = "ZCP";
*		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
*		description = "%1";
*		priority = 7;
*	};
*};
*/