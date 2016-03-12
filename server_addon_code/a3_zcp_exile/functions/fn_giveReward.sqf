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

private["_reward"];
_reward = _this select 3;
switch (_reward) do {
	case "Reputation" : {
		_this call ZCP_fnc_rewardReputation;
	};
	case "Poptabs" : {
		_this call ZCP_fnc_rewardPoptabs;
	};
	case "BuildBox" : {
		_this call ZCP_fnc_rewardBuildingBox;
	};
	case "SurvivalBox" : {
		_this call ZCP_fnc_rewardSurvivalBox;
	};
	case "WeaponBox" : {
		_this call ZCP_fnc_rewardWeaponBox;
	};
	case "Vehicle" : {
		_this call ZCP_fnc_rewardVehicle;
	};
	case "Random" : {
		private ['_rewardType'];
		_rewardType = ZCP_RandomReward call BIS_fnc_selectRandom;
		_this set[3, _rewardType];
		_this call ZCP_fnc_giveReward;
	};
	default {
		_this set[3, "Random"];
		_this call ZCP_fnc_giveReward;
	};
};
