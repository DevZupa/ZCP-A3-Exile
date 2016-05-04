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


private["_ZCP_GR_reward","_ZCP_GR_newThis"];
_ZCP_GR_reward = _this select 3;

if (typeName _ZCP_GR_reward == "STRING") then {
    _ZCP_GR_reward = [_ZCP_GR_reward];
};

if (typeName _ZCP_GR_reward == "ARRAY") then {
    {
        switch (_x) do {
            case "Reputation" : {
                _this call ZCP_fnc_rewardReputation;
            };
            case "Poptabs" : {
                _this call ZCP_fnc_rewardPoptabs;
            };
            case "BuildBox" : {
                _this call ZCP_fnc_rewardBuildBox;
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
                private ['_ZCP_GR_rewardType'];
                _ZCP_GR_rewardType = ZCP_RandomReward call BIS_fnc_selectRandom;
                _ZCP_GR_newThis = +_this;
                _ZCP_GR_newThis set[3, [_ZCP_GR_rewardType]];
                _ZCP_GR_newThis call ZCP_fnc_giveReward;
            };
            default {
                _ZCP_GR_newThis = +_this;
                _ZCP_GR_newThis set[3, ["Random"]];
                _ZCP_GR_newThis call ZCP_fnc_giveReward;
            };
        };
    }forEach _ZCP_GR_reward;
} else {
    diag_log format["[ZCP]: Invalid reward for %1", _this];
};

