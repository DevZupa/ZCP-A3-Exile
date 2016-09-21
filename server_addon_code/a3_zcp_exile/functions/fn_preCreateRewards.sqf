params
[
	"_ZCP_PCR_rewards",
	"_ZCP_PCR_location",
	"_ZCP_PCR_radius",
	'_ZCP_PCR_isCity',
	["_ZCP_PCR_isRandom", false, [true]]
];

private _ZCP_PCR_rewardObjects = [];

if (typeName _ZCP_PCR_rewards == "STRING") then {
    _ZCP_PCR_rewards = [_ZCP_PCR_rewards];
};

{
        switch (_x) do { // add extra cases here and in spawnCrate.sqf
            case "Reputation" : {
                _nil = _ZCP_PCR_rewardObjects pushBack objNull;
            };
            case "Poptabs" : {
                _nil = _ZCP_PCR_rewardObjects pushBack objNull;
            };
            case "BuildBox" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _x] call ZCP_fnc_preRewardBox);
            };
            case "SurvivalBox" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _x] call ZCP_fnc_preRewardBox);
            };
            case "WeaponBox" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _x] call ZCP_fnc_preRewardBox);
            };
            case "BigWeaponBox" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _x] call ZCP_fnc_preRewardBox);
            };
            case "SniperWeaponBox" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _x] call ZCP_fnc_preRewardBox);
            };
            case "Vehicle" : {
                _nil = _ZCP_PCR_rewardObjects pushBack ([_ZCP_PCR_location, _ZCP_PCR_radius, _ZCP_PCR_isCity] call ZCP_fnc_preRewardVehicle);
            };
            default {
                private _ZCP_GR_rewardType = ZCP_RandomReward call BIS_fnc_selectRandom;
                private _ZCP_GR_newThis = +_this;
                _ZCP_GR_newThis set [0, [_ZCP_GR_rewardType]];
                _nil = _ZCP_GR_newThis pushBack true;
                _ZCP_PCR_rewards set [_forEachIndex, _ZCP_GR_rewardType];
                _nil = _ZCP_PCR_rewardObjects pushBack (_ZCP_GR_newThis call ZCP_fnc_preCreateRewards);
            };
        };
    }forEach _ZCP_PCR_rewards;

if (_ZCP_PCR_isRandom) then {
    _ZCP_PCR_rewardObjects = _ZCP_PCR_rewardObjects select 0;
};

_ZCP_PCR_rewardObjects