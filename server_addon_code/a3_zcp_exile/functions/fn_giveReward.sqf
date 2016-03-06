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
		private['_awardToGive','_playerScore'];
		_awardToGive = ZCP_MinReputationReward + (ZCP_ReputationReward) * (count playableUnits);
		_playerScore = _ZCP_currentCapper getVariable ["ExileScore", 0];
		_playerScore = _playerScore + _awardToGive;

		_ZCP_currentCapper setVariable ["ExileScore",_playerScore];
		_ZCP_currentCapper setVariable['PLAYER_STATS_VAR', [_ZCP_currentCapper getVariable ['ExileMoney', 0], _playerScore],true];

		format["setAccountScore:%1:%2", _playerScore,getPlayerUID _ZCP_currentCapper] call ExileServer_system_database_query_fireAndForget;

		[_ZCP_currentCapper, "showFragRequest", [[[format ["ZCP Reputation"],_awardToGive]]]] call ExileServer_system_network_send_to;

		ExileClientPlayerScore = _playerScore;
		(owner _ZCP_currentCapper) publicVariableClient "ExileClientPlayerScore";
		ExileClientPlayerScore = nil;

		_ZCP_currentCapper call ExileServer_object_player_database_update;

		if( ZCP_ReputationRewardForGroup > 0 ) then {
			private['_capperGroup'];
			_capperGroup = group _ZCP_currentCapper;
			if( _capperGroup != grpNull ) then {
				{
					if (_x != _ZCP_currentCapper && _x distance2D _ZCP_currentCapper < 200 ) then {
						_newScore = (_x getVariable ["ExileScore", 0]) + ZCP_ReputationRewardForGroup;
						_x setVariable ["ExileScore", _newScore ];
						_x setVariable['PLAYER_STATS_VAR', [_x getVariable ['ExileMoney', 0], _newScore],true];
						format["setAccountScore:%1:%2", _newScore, getPlayerUID _x] call ExileServer_system_database_query_fireAndForget;
						_x call ExileServer_object_player_database_update;

						ExileClientPlayerScore = _newScore;
						(owner _x) publicVariableClient "ExileClientPlayerScore";
						ExileClientPlayerScore = nil;

						[_x, "showFragRequest", [[[format ["ZCP Group Reputation"],ZCP_ReputationRewardForGroup]]]] call ExileServer_system_network_send_to;
					}
				}count (units _capperGroup);
			};
		};
	};
	case "Poptabs" : {
		private['_awardToGive','_playerMoney'];
		_awardToGive = ZCP_MinPoptabReward;
		if(ZCP_RewardRelativeToPlayersOnline) then {
				_awardToGive = _awardToGive + (ZCP_PoptabReward) * (count playableUnits);
		};
		_playerMoney = _ZCP_currentCapper getVariable ["ExileMoney", 0];
		_playerMoney = _playerMoney + _awardToGive;

		_ZCP_currentCapper setVariable ["ExileMoney", _playerMoney];
		_ZCP_currentCapper setVariable['PLAYER_STATS_VAR', [_playerMoney, _ZCP_currentCapper getVariable ['ExileScore', 0]],true];

		format["setAccountMoney:%1:%2", _playerMoney, (getPlayerUID _ZCP_currentCapper)] call ExileServer_system_database_query_fireAndForget;

		PV_ZCP_zupastic = ["ZCP",[format["Package delivered, eyes on the sky! Poptabs on bank!"]], 'ZCP_Capped'];
		owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic";

		[_ZCP_currentCapper, "moneyReceivedRequest", [str _playerMoney, format ["ZCP Poptabs reward"]]] call ExileServer_system_network_send_to;

		[_capturePosition,'FoodBox'] spawn ZCP_fnc_spawnCrate;

		diag_log format ["[ZCP]: %1 won %2, received %3 Poptabs and ItemBox",name _ZCP_currentCapper,_ZCP_name,_awardToGive];

		_this set[3, "Reputation"];
		_this call ZCP_fnc_giveReward;
	};
	case "BuildBox" : {

		[_capturePosition,'BuildBox'] spawn ZCP_fnc_spawnCrate;

		PV_ZCP_zupastic = ["ZCP",[format["Package delivered, eyes on the sky!"]], 'ZCP_Capped'];
		owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic";

		diag_log format ["[ZCP]: %1 won %2, received a buildbox.",name _ZCP_currentCapper,_ZCP_name];

		_this set[3, "Reputation"];
		_this call ZCP_fnc_giveReward;
	};
	case "WeaponBox" : {
		private[];

		[_capturePosition, 'WeaponBox'] spawn ZCP_fnc_spawnCrate;

		PV_ZCP_zupastic = ["ZCP",[format["Package delivered, eyes on the sky!"]], 'ZCP_Capped'];
		owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic";
		diag_log text format ["[ZCP]: %1 won %2, received a weaponbox.",name _ZCP_currentCapper,_ZCP_name];

		_this set[3, "Reputation"];
		_this call ZCP_fnc_giveReward;
	};
	case "Vehicle" : {
		private["_vehicle","_vehicleClass","_cfg","_name"];

		if(ZCP_DisableVehicleReward)then{
			[_ZCP_currentCapper,_ZCP_name,_capturePosition,"Random"] call ZCP_fnc_giveReward;
		}else{
			_vehicleClass = ZCP_VehicleReward call BIS_fnc_selectRandom;
			_cfg  = (configFile >>  "CfgVehicles" >>  _vehicleClass);
		    _name = if (isText(_cfg >> "displayName")) then {
		        getText(_cfg >> "displayName")
		   		 }
		    else {
		        _vehicleClass
		    };

			_vehicle = _vehicleClass createVehicle [0,0,150];
			clearWeaponCargoGlobal _vehicle;
			clearMagazineCargoGlobal _vehicle;
			clearBackpackCargoGlobal _vehicle;
			clearItemCargoGlobal _vehicle;
			_vehicle setDir random 360;
			_vehicle setPos [_capturePosition select 0,_capturePosition select 1,150];
			_vehicle call ZCP_fnc_paraDrop;

			PV_ZCP_zupastic = ["ZCP",[format["Package delivered, eyes on the sky!"]], 'ZCP_Capped'];
			owner _ZCP_currentCapper publicVariableClient "PV_ZCP_zupastic";
			diag_log text format ["[ZCP]: %1 won %2, received a %3.",name _ZCP_currentCapper,_ZCP_name, _vehicleClass];

			_this set[3, "Reputation"];
			_this call ZCP_fnc_giveReward;
		};
	};
	case "Random" : {
		private ['_rewardType'];
		_rewardType = ["Vehicle", "WeaponBox", "BuildBox","Poptabs"] call BIS_fnc_selectRandom;
		_this set[3, _rewardType];
		_this call ZCP_fnc_giveReward;
	};
	default {
		_this set[3, "Random"];
		_this call ZCP_fnc_giveReward;
	};
};
