/*
	Zupa's Capture Points
	Reward giver of ZCP
	Capture points and earn money over time.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/

private["_ZCP_currentCapper","_ZCP_name","_capturePosition","_reward","_vars","_cIndex","_current_crypto"];
_ZCP_currentCapper = _this select 0;
_ZCP_name = _this select 1;
_capturePosition = _this select 2;
_reward = _this select 3;
switch (_reward) do {
	case "Reputation" : {
		_awardToGive = ZCP_MinReputationReward + (ZCP_ReputationReward) * (count playableUnits);
		_playerMoney = _ZCP_currentCapper getVariable ["ExileScore", 0];
		_playerMoney = _playerMoney + _awardToGive;

		_ZCP_currentCapper setVariable ["ExileScore",_playerMoney];
		format["setAccountScore:%1:%2", _playerMoney,getPlayerUID _ZCP_currentCapper] call ExileServer_system_database_query_fireAndForget;

		PV_ZCP_zupastic_client = ["ZCP",format["%1", _playerMoney], 'Reputation'];
		owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic_client";

		_ZCP_currentCapper call ExileServer_object_player_database_update;

		PV_ZCP_zupastic = ["ZCP",[format["%2 captured %1. Bombing in %4s.",_ZCP_name,name _ZCP_currentCapper,_awardToGive,ZCP_BaseCleanupDelay]],'ZCP_Capped'];
		publicVariable "PV_ZCP_zupastic";
		diag_log text format ["[ZCP]: %1 won %2, received %3 Reputation",name _ZCP_currentCapper,_ZCP_name,_awardToGive];
	};
	case "Poptabs" : {
		_awardToGive = ZCP_MinPoptabReward + (ZCP_PoptabReward) * (count playableUnits);
		_playerMoney = _ZCP_currentCapper getVariable ["ExileMoney", 0];
		_playerMoney = _playerMoney + _awardToGive;
		_ZCP_currentCapper setVariable ["ExileMoney", _playerMoney];
		format["setAccountMoney:%1:%2", _playerMoney, (getPlayerUID _ZCP_currentCapper)] call ExileServer_system_database_query_fireAndForget;

		PV_ZCP_zupastic_client = ["ZCP",format["%1", _playerMoney], 'Poptabs'];
		owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic_client";

		_ZCP_currentCapper call ExileServer_object_player_database_update;

		PV_ZCP_zupastic = ["ZCP",[format["%2 captured %1. Bombing in %4s.",_ZCP_name,name _ZCP_currentCapper,_awardToGive,ZCP_BaseCleanupDelay]], 'ZCP_Capped'];
		publicVariable "PV_ZCP_zupastic";
		diag_log text format ["[ZCP]: %1 won %2, received %3 Poptabs",name _ZCP_currentCapper,_ZCP_name,_awardToGive];
	};
	// case "BuildBox" : {
	// 	private["_box"];
	// 	PV_ZCP_zupastic = ["ZCP",format["%2 captured %1 and received his buildbox. The base will dismantle in %4 seconds.",_ZCP_name,name _ZCP_currentCapper,"",ZCP_BaseCleanupDelay]];
	// 	publicVariable "PV_ZCP_zupastic";
	// 	diag_log text format ["[ZCP]: %1 won %2, received a buildbox.",name _ZCP_currentCapper,_ZCP_name];
	// 	_box = "Box_IND_AmmoVeh_F" createVehicle [0,0,150];
	// 	clearWeaponCargoGlobal _box;
	// 	clearMagazineCargoGlobal _box;
	// 	clearBackpackCargoGlobal _box;
	// 	clearItemCargoGlobal _box;
	// 	{
	// 		_box addItemCargoGlobal [_x select 0,_x select 1];
	// 	}count ZCP_BuildingReward;
	// 	_box setDir random 360;
	// 	_box setPos [_capturePosition select 0,_capturePosition select 1,150];
	// 	_box call ZCP_fnc_paraDrop;
	// };
	// case "WeaponBox" : {
	// 	private["_box","_mags"];
	// 	PV_ZCP_zupastic = ["ZCP",format["%2 captured %1 and received his weaponbox. The base will dismantle in %4 seconds.",_ZCP_name,name _ZCP_currentCapper,"",ZCP_BaseCleanupDelay]];
	// 	publicVariable "PV_ZCP_zupastic";
	// 	diag_log text format ["[ZCP]: %1 won %2, received a weaponbox.",name _ZCP_currentCapper,_ZCP_name];
	// 	_box = "Box_IND_AmmoVeh_F" createVehicle [0,0,150];
	// 	clearWeaponCargoGlobal _box;
	// 	clearMagazineCargoGlobal _box;
	// 	clearBackpackCargoGlobal _box;
	// 	clearItemCargoGlobal _box;
	// 	{
	// 		_box addWeaponCargoGlobal [_x select 0,_x select 1];
	// 		_mags=getArray(configFile >> "CfgWeapons" >> (_x select 0) >> "magazines");
	// 		if !(_mags isEqualTo[])then{
	// 			_box addMagazineCargoGlobal[_mags select 0,ceil(random 5)];
	// 		};
	// 	}count ZCP_WeaponReward;
	// 	{
	// 		_box addItemCargoGlobal [_x select 0,_x select 1];
	// 	}count ZCP_ItemWeaponReward;
	// 	_box setDir random 360;
	// 	_box setPos [_capturePosition select 0,_capturePosition select 1,150];
	// 	_box call ZCP_fnc_paraDrop;
	// };
	// case "Vehicle" : {
	// 	private["_vehicle","_vehicleClass","_cfg","_name"];
	//
	// 	if(ZCP_DisableVehicleReward)then{
	// 		[_ZCP_currentCapper,_ZCP_name,_capturePosition,"Crypto"] call ZCP_fnc_giveReward;
	// 	}else{
	// 		_vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
	// 		_cfg  = (configFile >>  "CfgVehicles" >>  _vehicleClass);
	// 	    _name = if (isText(_cfg >> "displayName")) then {
	// 	        getText(_cfg >> "displayName")
	// 	   		 }
	// 	    else {
	// 	        _vehicleClass
	// 	    };
	// 		PV_ZCP_zupastic = ["ZCP",format["%2 captured %1 and received a %3. The base will dismantle in %4 seconds.",_ZCP_name,name _ZCP_currentCapper,_name,ZCP_BaseCleanupDelay]];
	// 		publicVariable "PV_ZCP_zupastic";
	// 		diag_log text format ["[ZCP]: %1 won %2, received a %3.",name _ZCP_currentCapper,_ZCP_name,_name];
	// 		_vehicle = _vehicleClass createVehicle [0,0,150];
	// 		clearWeaponCargoGlobal _vehicle;
	// 		clearMagazineCargoGlobal _vehicle;
	// 		clearBackpackCargoGlobal _vehicle;
	// 		clearItemCargoGlobal _vehicle;
	// 		_vehicle setDir random 360;
	// 		_vehicle setPos [_capturePosition select 0,_capturePosition select 1,150];
	// 		_vehicle call ZCP_fnc_paraDrop;
	// 	};
	// };
	default {
		diag_log text format["[ZCP] %1 has no valid reward name. Falling back on Reputation reward.",_ZCP_name];
		//Crypto fallback.
		[_ZCP_currentCapper,_ZCP_name,_capturePosition,"Reputation"] call ZCP_fnc_giveReward;
	};
};
