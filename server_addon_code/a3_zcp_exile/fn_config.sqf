/*
	Zupa's Capture Points
	Configuration of ZCP
	Capture points and earn rewards.

	╔════╗─────────╔═══╗────────╔╗─────────────╔╗
	╚══╗═║─────────╚╗╔╗║────────║║────────────╔╝╚╗
	──╔╝╔╬╗╔╦══╦══╗─║║║╠══╦╗╔╦══╣║╔══╦╗╔╦══╦═╗╚╗╔╬══╗
	─╔╝╔╝║║║║╔╗║╔╗║─║║║║║═╣╚╝║║═╣║║╔╗║╚╝║║═╣╔╗╗║║║══╣
	╔╝═╚═╣╚╝║╚╝║╔╗║╔╝╚╝║║═╬╗╔╣║═╣╚╣╚╝║║║║║═╣║║║║╚╬══║
	╚════╩══╣╔═╩╝╚╝╚═══╩══╝╚╝╚══╩═╩══╩╩╩╩══╩╝╚╝╚═╩══╝
	────────║║
	────────╚╝
*/

// First person in the Cap zone is the capper (If he leaves, the closest on of the group is the new capper but time is reset!).
// When multiple people are in the zone and not in the same group, the zone is contested and the timer pauses
// Being first in the zone starts the timer.
// Holding a zone  gives you a reward after x Min.

ZCP_dev = false; // Devmode for shorter development capture times

ZCP_AI_Type = 'DMS'; // NONE | DMS | FUMS
ZCP_Min_AI_Amount = 4; // Min ammount of AI at a ZCP
ZCP_Random_AI_Max = 8; // so min 4 and max 12 (4+8) AI

ZCP_CapTime = 300; // Seconds to cap an area uncontested
ZCP_ServerStartWaitTime = 120;
ZCP_MinWaitTime = 120; // seconds to wait to spawn a new capturepoint when 1 was capped.
ZCP_MaxWaitTime = 120; // random between 0 and THIS number added to the ZCP_MinWaitTime to counter spawning points at the same time
ZCP_BaseCleanupDelay = 180; // seconds to wait to delete a captured base.

ZCP_Minimum_Online_Players = 0; // Amount of players to be online before it allows to spawn capture points. !!! O = always

ZCP_RewardRelativeToPlayersOnline = true; // This will recalculate the crypto reward according the amount of online players.
ZCP_PoptabReward = 25; // Poptab reward for capping per player online. ( When poptab reward is selected or randomly chosen ).
ZCP_MinPoptabReward = 1000; // Poptabreward is added to this number

/* Reputation is ALWAYS given as addition on the normal reward.*/
ZCP_ReputationReward = 25; // Respect reward for capping per  player online.
ZCP_MinReputationReward = 1000; // ZCP_ReputationReward is added to this number
ZCP_ReputationRewardForGroup = 500; // Each group members gets this amount of reputation ( for the trouble).
ZCP_MinGroupDistance = 200; // meters to be close to the capper to get the group award

ZCP_CleanupBase = true; // Let the base dissappear after completing
ZCP_CleanupBaseWithAIBomber = true; // Cleanup with a airstrike
ZCP_CleanupAIVehicleClasses = ['B_Plane_CAS_01_F']; // Any flying vehicle in arma (default B_Plane_CAS_01_F = A10)
ZCP_FlyHeight = 150; // Height of the flying plane;

ZCP_UseSpecificNamesForCappers = true; // Use the player name, if false it say 'A player'

ZCP_giveSurvivalBoxWithPoptabsReward = true;
ZCP_RewardWeightForRandomChoice = [
	["Poptabs", 5],
	["BuildBox", 3],
	["WeaponBox", 5],
	["SurvivalBox", 1],
	["Vehicle", 2]
];
// How does this work ( 6 + 3 + 5 + 2 = 16)
// 6/16 = 37.50 %
// 3/16 = 18.75 %
// 5/16 = 31.25 %
// 2/16 = 12.50 %

// Server will keep as many missions up as ZCP_MaxMissions, And they will be randomly chosen from the following list
// Location is ignored if not using static points. just put [0,0,0] then. activate static buy using isStatic = true
// valid rewards -> Random, Poptabs, Vehicle, Buildingbox, WeaponBox
// baseFile -> Random or the basefile name. Random will chose from ZCP_CapBases
// capradius -> 0 for Random, real number for Static base files.
ZCP_CapPoints = [ // [name,[x,y,z],reward, unique varname,index, spanwnAI, isStatic, baseFile, capradius, baseFileType, max terrainGradient ( only used if it has staticbaseFile), distancefromojects( only used if it has staticbaseFile)]
	["ZCP Alpha",[0,0,0],"Random","alpha",0, true, false, 'Random', 0, 'Random', 40, 40] ,
	["ZCP Bravo",[0,0,0],"Random","beta",1, true, false, 'Random', 0, 'Random', 40, 40]
	// example -> ["ZCP Charlie",[3598,5888,0],"Random","charlie",2, true, true, 'm3e_base1.sqf', 60, 'm3e', 10]    // A base on always the same location with always the same base
	// example -> ["ZCP Delta",[0,0,0],"Random","delta",3, true, false, 'xcam_milPoint.sqf', 100, 'xcam', 15] 			// A base on random location with always the same base
	// example -> ["ZCP Echo",[1455,8888,0],"Random","echo",4, true, true, 'Random', 0, 'Random', 10] 					// A base on on always the same location with a random base
	// example -> ["ZCP Foxtrot",[0,0,0],"Random","foxtrot",5, true, false, 'Random', 0, 'Random', 10] 					// Random base on random location
];

ZCP_MaxMissions = count ZCP_CapPoints; // Amount of cap points at the same time.

// For every spawned mission,
// buildeditor currenty supported -> m3e, xcam
ZCP_CapBases = [ // located in capbases folder [filename, capradius, buildeditor, max terraingradient (if not overwritten by staticbasefile), radius of open space for it to spawn base]
	["m3e_base1.sqf", 60, "m3e", 40, 60],
	["m3e_smallBase1.sqf", 40, "m3e", 40, 40],
	["m3e_village.sqf", 50, "m3e", 20, 50],
	["xcam_milPoint.sqf", 50, "xcam", 30, 50],
	["ec_audacity.sqf", 30, "EdenConverted", 40, 30],
	["ec_bravery.sqf", 35, "EdenConverted", 40, 35],
	["ec_courage.sqf", 25, "EdenConverted", 40, 25],
	["ec_defiance.sqf", 20, "EdenConverted", 40, 20],
	["ec_endurance.sqf", 20, "EdenConverted", 40, 20],
	["ec_fortitude.sqf", 25, "EdenConverted", 40, 25]
];

// ZCP_TerrainGradient = 10; // Now defined per base or overwritten when using staticbaseFile for a cappoint
//ZCP_MinDistanceFromObject = 60; // now defined per base.


ZCP_Blacklist = [ // [ [x,y,z], radius ];
	[[-999,-999,0] , 500],
	[[-999,-999,0] , 500]
];

ZCP_createVirtualCircle = true;

ZCP_circleNeutralColor = "#(rgb,8,8,3)color(0,1,0,1)"; // green
ZCP_circleCappingColor = "#(rgb,8,8,3)color(0,0,1,1)"; // blue
ZCP_circleContestedColor = "#(rgb,8,8,3)color(1,0,0,1)"; // red

//Boxtypes
ZCP_SurvivalBox = "O_supplyCrate_F";
ZCP_BuildingBox = "O_CargoNet_01_ammo_F";
ZCP_WeaponBox = "I_CargoNet_01_ammo_F";

// Same as DMS -> Credits DMS
ZCP_DistanceBetweenMissions = 500;
ZCP_SpawnZoneDistance = 500;
ZCP_TradeZoneDistance = 500;
ZCP_DistanceFromWater = 100;
ZCP_DistanceFromPlayers = 200;
ZCP_TraderZoneMarkerTypes =			[							// If you're using custom trader markers, make sure you define them here. CASE SENSITIVE!!!
										"ExileTraderZone"
									];
ZCP_SpawnZoneMarkerTypes =			[							// If you're using custom spawn zone markers, make sure you define them here. CASE SENSITIVE!!!
										"ExileSpawnZone"
									];


/* These are arma 3 colors, look up the color naming if you are going to change this */
ZCP_FreeColor = "ColorGreen"; // uncontested marker color -> also correct size
ZCP_CappedColor = "ColorBlue"; // uncontested + capping color
ZCP_ContestColor = "ColorRed"; // contested + capping color
ZCP_BackgroundColor = "ColorWhite"; // Color to get attention on the map, if zoomed out this will be bigger then the cap circle which is the normal size.
ZCP_MissionMarkerWinDotTime = 120; // Seconds to show a marker after a capped point. Change to 0 to disable!

ZCP_DisableVehicleReward = false; // Because it doesnt save without changing epoch code.

/** Uses DMS system, why make one if it already excist? Credits DMS **/
ZCP_DMS_MinimumMagCount					= 2;						// Minimum number of magazines for weapons.
ZCP_DMS_MaximumMagCount					= 4;						// Maximum number of magazines for weapons.
ZCP_DMS_CrateCase_Sniper =				[							// If you pass "Sniper" in _lootValues, then it will spawn these weapons/items/backpacks
										[
											["Rangefinder",1],
											["srifle_GM6_F",1],
											["srifle_LRR_F",1],
											["srifle_EBR_F",1],
											["hgun_Pistol_heavy_01_F",1],
											["hgun_PDW2000_F",1]
										],
										[
											["ItemGPS",1],
											["U_B_FullGhillie_ard",1],
											["U_I_FullGhillie_lsh",1],
											["U_O_FullGhillie_sard",1],
											["U_O_GhillieSuit",1],
											["V_PlateCarrierGL_blk",1],
											["V_HarnessO_brn",1],
											["Exile_Item_InstaDoc",3],
											["Exile_Item_Surstromming_Cooked",5],
											["Exile_Item_PlasticBottleFreshWater",5],
											["optic_DMS",1],
											["acc_pointer_IR",1],
											["muzzle_snds_B",1],
											["optic_LRPS",1],
											["optic_MRD",1],
											["muzzle_snds_acp",1],
											["optic_Holosight_smg",1],
											["muzzle_snds_L",1],
											["5Rnd_127x108_APDS_Mag",3],
											["7Rnd_408_Mag",3],
											["20Rnd_762x51_Mag",5],
											["11Rnd_45ACP_Mag",3],
											["30Rnd_9x21_Mag",3]
										],
										[
											["B_Carryall_cbr",1],
											["B_Kitbag_mcamo",1]
										]
									];
ZCP_DMS_BoxWeapons =					[							// List of weapons that can spawn in a crate
										"Exile_Melee_Axe",
										"arifle_Katiba_GL_F",
										"arifle_MX_GL_Black_F",
										"arifle_Mk20_GL_F",
										"arifle_TRG21_GL_F",
										"arifle_Katiba_F",
										"arifle_MX_Black_F",
										"arifle_TRG21_F",
										"arifle_TRG20_F",
										"arifle_Mk20_plain_F",
										"arifle_Mk20_F",
										"LMG_Zafir_F",
										"LMG_Mk200_F",
										"arifle_MX_SW_Black_F",
										"srifle_EBR_F",
										"srifle_DMR_01_F",
										"srifle_GM6_F",
										"srifle_LRR_F",
										"arifle_MXM_F",
										"arifle_MXM_Black_F",
										"srifle_DMR_02_F"
									];
ZCP_DMS_BoxFood =						[							// List of food that can spawn in a crate.
										"Exile_Item_GloriousKnakworst_Cooked",
										"Exile_Item_Surstromming_Cooked",
										"Exile_Item_SausageGravy_Cooked",
										"Exile_Item_ChristmasTinner_Cooked",
										"Exile_Item_BBQSandwich_Cooked",
										"Exile_Item_Catfood_Cooked",
										"Exile_Item_DogFood_Cooked"
									];
ZCP_DMS_BoxDrinks =						[
										"Exile_Item_PlasticBottleCoffee",
										"Exile_Item_PowerDrink",
										"Exile_Item_PlasticBottleFreshWater",
										"Exile_Item_EnergyDrink",
										"Exile_Item_MountainDupe"
									];
ZCP_DMS_BoxMeds =						[
										"Exile_Item_InstaDoc",
										"Exile_Item_Vishpirin",
										"Exile_Item_Bandage"
									];
ZCP_DMS_BoxSurvivalSupplies	=			[							//List of survival supplies (food/drink/meds) that can spawn in a crate. "ZCP_DMS_BoxFood", "ZCP_DMS_BoxDrinks", and "ZCP_DMS_BoxMeds" is automatically added to this list.
										"Exile_Item_Matches",
										"Exile_Item_CookingPot",
										"Exile_Melee_Axe",
										"Exile_Item_CanOpener"
									] + ZCP_DMS_BoxFood + ZCP_DMS_BoxDrinks + ZCP_DMS_BoxMeds;
ZCP_DMS_BoxBaseParts =					[
										"Exile_Item_CamoTentKit",
										"Exile_Item_WoodWallKit",
										"Exile_Item_WoodWallHalfKit",
										"Exile_Item_WoodDoorwayKit",
										"Exile_Item_WoodDoorKit",
										"Exile_Item_WoodFloorKit",
										"Exile_Item_WoodFloorPortKit",
										"Exile_Item_WoodStairsKit",
										"Exile_Item_WoodSupportKit",
										"Exile_Item_FortificationUpgrade"
									];
ZCP_DMS_BoxCraftingMaterials =			[
										"Exile_Item_MetalPole",
										"Exile_Item_MetalBoard",
										"Exile_Item_JunkMetal"
									];
ZCP_DMS_BoxTools =						[
										"Exile_Item_Grinder",
										"Exile_Item_Handsaw"
									];
ZCP_DMS_BoxBuildingSupplies	=			[							// List of building supplies that can spawn in a crate ("ZCP_DMS_BoxBaseParts", "ZCP_DMS_BoxCraftingMaterials", and "ZCP_DMS_BoxTools" are automatically added to this list. "ZCP_DMS_BoxCraftingMaterials" is added twice for weight.)
										"Exile_Item_DuctTape",
										"Exile_Item_PortableGeneratorKit"
									] + ZCP_DMS_BoxBaseParts + ZCP_DMS_BoxCraftingMaterials + ZCP_DMS_BoxCraftingMaterials + ZCP_DMS_BoxTools;
ZCP_DMS_BoxOptics =						[							// List of optics that can spawn in a crate
										"optic_Arco",
										"optic_Hamr",
										"optic_Aco",
										"optic_Holosight",
										"optic_MRCO",
										"optic_SOS",
										"optic_DMS",
										"optic_LRPS"
										//"optic_Nightstalker"			// Nightstalker scope lost thermal in Exile v0.9.4
									];
ZCP_DMS_BoxBackpacks =					[							//List of backpacks that can spawn in a crate
										"B_Bergen_rgr",
										"B_Carryall_oli",
										"B_Kitbag_mcamo",
										"B_Carryall_cbr",
										"B_FieldPack_oucamo",
										"B_FieldPack_cbr",
										"B_Bergen_blk"
									];
ZCP_DMS_BoxItems						= ZCP_DMS_BoxSurvivalSupplies+ZCP_DMS_BoxBuildingSupplies+ZCP_DMS_BoxOptics;	// Random "items" can spawn optics, survival supplies, or building supplies

ZCP_DMS_RareLoot						= true;						// Potential chance to spawn rare loot in any crate.
ZCP_DMS_RareLootList =					[							// List of rare loot to spawn
										"Exile_Item_SafeKit",
										"Exile_Item_CodeLock"
									];
ZCP_DMS_RareLootChance	= 10;						// Percentage Chance to spawn rare loot in any crate | Default: 10%

// Vehicles
ZCP_DMS_ArmedVehicles =					[							// List of armed vehicles that can spawn
										"Exile_Car_Offroad_Armed_Guerilla01"
									];

ZCP_DMS_MilitaryVehicles =				[							// List of military vehicles that can spawn
										"Exile_Car_Strider",
										"Exile_Car_Hunter",
										"Exile_Car_Ifrit"
									];

ZCP_DMS_TransportTrucks =				[							// List of transport trucks that can spawn
										"Exile_Car_Van_Guerilla01",
										"Exile_Car_Zamak",
										"Exile_Car_Tempest",
										"Exile_Car_HEMMT",
										"Exile_Car_Ural_Open_Military",
										"Exile_Car_Ural_Covered_Military"
									];

ZCP_DMS_RefuelTrucks =					[							// List of refuel trucks that can spawn
										"Exile_Car_Van_Fuel_Black",
										"Exile_Car_Van_Fuel_White",
										"Exile_Car_Van_Fuel_Red",
										"Exile_Car_Van_Fuel_Guerilla01",
										"Exile_Car_Van_Fuel_Guerilla02",
										"Exile_Car_Van_Fuel_Guerilla03"
									];

ZCP_DMS_CivilianVehicles =				[							// List of civilian vehicles that can spawn
										"Exile_Car_SUV_Red",
										"Exile_Car_Hatchback_Rusty1",
										"Exile_Car_Hatchback_Rusty2",
										"Exile_Car_Hatchback_Sport_Red",
										"Exile_Car_SUV_Red",
										"Exile_Car_Offroad_Rusty2",
										"Exile_Bike_QuadBike_Fia"
									];

ZCP_DMS_TransportHelis =				[							// List of transport helis that can spawn
										"Exile_Chopper_Hummingbird_Green",
										"Exile_Chopper_Orca_BlackCustom",
										"Exile_Chopper_Mohawk_FIA",
										"Exile_Chopper_Huron_Black",
										"Exile_Chopper_Hellcat_Green",
										"Exile_Chopper_Taru_Transport_Black"
									];

ZCP_VehicleReward = ZCP_DMS_TransportTrucks;
ZCP_DMS_DEBUG = false;


ZCP_Translations = [ // ['original','original in your language'] the %1 %2 and so on are Variables!
	['%1 capbase set up. Capture for %2 min!' , '%1 capbase set up. Capture for %2 min!'], // ZCP Alpha capbase set up. Capture for 10 min!
	['%2 is capping %1. %3min left!' , '%2 is capping %1. %3min left!'], // Zupa is capping ZCP alpha, 5min left.
	['A player' , 'A player'], // A player
	['%1 is 50%4 captured by %2. %3min left!', '%1 is 50%4 captured by %2. %3min left!'], // ZCP Alpha is 50% captured by Zupa/A player. 2min left!
	['%1 is almost captured by %2. 60s left!', '%1 is almost captured by %2. 60s left!'], // ZCP Alpha is almost captured by Zupa/A player. 60s left!
	['%1 is captured. %2.', '%1 is captured. %2.'], // ZCP Alpha is captured. (%2 is on of the 2 following translations, so leave the variable there!
	['Bombing in %1s!', 'Bombing in %1s!'], // Bombing in 600s
	['Cleanup in %1s!', 'Cleanup in %1s!'], // Cleanup in 600s
	['Captured point', 'Captured point'], // Captured point
	['Reputation', 'Reputation'], // Reputation
	['Group Reputation', 'Group Reputation'], // Group reputation
	['Package delivered, eyes on the sky!', 'Package delivered, eyes on the sky!'], // Package delivered, eyes on the sky!
	['Package delivered, eyes on the sky! Poptabs on bank!', 'Package delivered, eyes on the sky! Poptabs on bank!'], // Package delivered, eyes on the sky! Poptabs on bank!
	['Capture point is contested!', 'Capture point is contested!'], // Package delivered, eyes on the sky! Poptabs on bank!
	['Capture point is contested is no longer contested!', 'Capture point is no longer contested!'] // Capture point is contested!
];

ZCP_CurrentMod = "Exile"; // Exile, ( Epoch coming soon again)

if(ZCP_dev) then {
	ZCP_CapTime = 20;
	ZCP_MinWaitTime = 10;
	ZCP_MaxWaitTime = 1;
	ZCP_BaseCleanupDelay = 1;
};

/* Do not change this*/
ZCP_Version = "ZCP_Exile_1.1";
ZCP_Data = [];
ZCP_MissionTriggerData = [];
ZCP_MissionCounter = 0;
ZCP_DMS_MagRange = ZCP_DMS_MaximumMagCount - ZCP_DMS_MinimumMagCount;
diag_log format["ZCP: Config loaded succesfull"];
