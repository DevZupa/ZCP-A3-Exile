class CfgPatches {
	class A3_exile_zcp {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"exile_client","exile_server_config"};
	};
};
class CfgFunctions {
	class zcp {
		tag = "ZCP";
		class main {
			file = "x\addons\ZCP";
			class startZCP
			{
				postInit = 1;
			};
			class config {};
			class missions {};
			class cities {};
			class translations {};
			class missionLooper {};

		};
		class compileFunctions {
			file = "x\addons\ZCP\functions";
			class inDebug {};
			class nearWater {};
			class paraDrop {};
			class start {};
			class findPosition {};
			class cleanupBase {};
			class initCPData {};
			class giveReward {};
			class createMarker {};
			class createWinMarker {};
			class createM3eBase {};
			class airbomb {};
			class airstrike {};
			class fly {};
			class spawnAI {};
			class spawnCrate {};
			class fillCrate {};
			class selectMagazine {};
			class removeMarker {};
			class translate {};
			class showNotification {};
			class createXcamBase {};
			class createEdenConvertedBase {};
			class createM3eEdenBase {};
			class rewardReputation {};
			class rewardPoptabs {};
			class rewardVehicle {};
			class rewardBox {};
			class createVirtualCircle {};
			class changeCircleColor {};
			class createTrigger {};
			class deleteLoot {};
			class deleteRuins {};
			class monitorMission {};
			class waveAI {};
			class createDMSSoldier {};
			class createDMSGroup {};
			class createWaypoint {};
			class createSmokeScreen {};
			class cleanupAI {};
			class preCreateRewards {};
			class preRewardBox {};
			class preRewardVehicle {};
			class getRandomCity {};
			class endMission {};
		};
	};
};
