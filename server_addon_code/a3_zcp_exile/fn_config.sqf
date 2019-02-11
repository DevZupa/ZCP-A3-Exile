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

ZCP_useOldMessages = false;

/*Exile Toasts Notification Settings*/
ZCP_DMS_ExileToasts_Title_Size			= 22;					// Size for Client Exile Toasts  mission titles.
ZCP_DMS_ExileToasts_Title_Font			= "puristaMedium";			// Font for Client Exile Toasts  mission titles.
ZCP_DMS_ExileToasts_Message_Color		= "#FFFFFF";				// Exile Toasts color for "ExileToast" client notification type.
ZCP_DMS_ExileToasts_Message_Size		= 19;					// Exile Toasts size for "ExileToast" client notification type.
ZCP_DMS_ExileToasts_Message_Font		= "PuristaLight";			// Exile Toasts font for "ExileToast" client notification type.
/*Exile Toasts Notification Settings*/

ZCP_AI_useLaunchersChance = 25; // %Change to spawn Launcher on AI soldier ( never exceeds the MIN and MAX defined per cappoint).

// Put the following to -1 to disable it.
ZCP_AI_killAIAfterMissionCompletionTimer = 60; // Amount of seconds before all ZCP AI get auto killed after a mission is completed. ( DMS only ).

// ZCP_Min_AI_Amount = 4; Not used anymore
// ZCP_Random_AI_Max = 8; Not used anymore

ZCP_MessagePlayersBeforeWaves = true; // True -> Inform for an icoming wave of AI, false is not inform the players inside.

// ZCP_CapTime = 300; // Now defined for each mission seperate
ZCP_ServerStartWaitTime = 120;
ZCP_MinWaitTime = 120; // seconds to wait to spawn a new capturepoint when 1 was capped.
ZCP_MaxWaitTime = 120; // random between 0 and THIS number added to the ZCP_MinWaitTime to counter spawning points at the same time
ZCP_BaseCleanupDelay = 180; // seconds to wait to delete a captured base.

ZCP_RewardRelativeToPlayersOnline = true; // This will recalculate the crypto reward according the amount of online players.
ZCP_PoptabReward = 25; // Poptab reward for capping per player online. ( When poptab reward is selected or randomly chosen ).
ZCP_MinPoptabReward = 1000; // Poptabreward is added to this number

ZCP_ReputationReward = 25; // Respect reward for capping per  player online.
ZCP_MinReputationReward = 1000; // ZCP_ReputationReward is added to this number
ZCP_ReputationRewardForGroup = 500; // Each group members gets this amount of reputation ( for the trouble).
ZCP_CONFIG_GroupDistanceForRespect = 200; // meters to be close to the capper to get the group award

ZCP_CleanupBase = true; // Let the base dissappear after completing
ZCP_CleanupBaseWithAIBomber = true; // Cleanup with a airstrike
ZCP_CleanupAIVehicleClasses = ['B_Plane_CAS_01_F']; // Any flying vehicle in arma (default B_Plane_CAS_01_F = A10)
ZCP_FlyHeight = 150; // Height of the flying plane;

ZCP_BomberCanDestroyMapBuildings = false; // if true damage of the bombs are applied to all objects in the blastradius.
// If false nothing gets hit ( except players and vehicles ) - base cleanup will happen in both cases after explosion.

ZCP_UseSpecificNamesForCappers = true; // Use the player name, if false it says 'A player'

// ZCP_giveSurvivalBoxWithPoptabsReward = true; not used anymore. You can now define multiple rewards per mission.
ZCP_RewardWeightForRandomChoice = [
	["Poptabs", 4],
	["BuildBox", 3],
	["WeaponBox", 4],
	["SurvivalBox", 4],
	["Vehicle", 2],
	["SniperWeaponBox", 1],
	["BigWeaponBox", 2]
];
// How does this work ( 6 + 3 + 5 + 2 = 16)
// 6/16 = 37.50 %
// 3/16 = 18.75 %
// 5/16 = 31.25 %
// 2/16 = 12.50 %
// You can add extra types here if you want them in the random option.

// Server will keep as many missions up as ZCP_MaxMissions, And they will be randomly chosen from the following list

ZCP_MaxMissions = 2; // Amount of cap points at the same time when ZCP_MaxMissionsRelativeToPlayers = false

ZCP_Minimum_Online_Players = 0; // Amount of players to be online before it allows to spawn a capture point. !!! O = always

ZCP_MaxMissionsRelativeToPlayers = true; // ZCP_MaxMissions will be ignored if true. ZCP_RelativeMaxMissions will be used
ZCP_RelativeMaxMissions = [
    //[ min players,  amount of cappoints],
    [5, 1],
    [15, 2],
    [40, 3],
    [65, 4]
];
ZCP_SecondsCheckPlayers = 600; // seconds for loop check if the server holds more players now (and spawn extra cappoints). ( 600 = every 10 minuts)

// For every spawned mission,
// buildeditor currenty supported -> m3e, xcam, EdenConverted ( THis is exported as terrainbuilder and converted with my site), m3eEden
ZCP_CapBases = [ // located in capbases folder [filename, capradius, buildeditor, max terraingradient (if not overwritten by staticbasefile), radius of open space for it to spawn base]
	["m3e_base1.sqf", 60, "m3e", 90, 60],
	["m3e_village.sqf", 50, "m3e", 90, 50],
	["xcam_milPoint.sqf", 50, "xcam", 90, 50],
	["ec_audacity.sqf", 30, "EdenConverted", 90, 30],
	["ec_bravery.sqf", 35, "EdenConverted", 90, 35],
	["ec_courage.sqf", 25, "EdenConverted", 90, 25],
	["ec_defiance.sqf", 20, "EdenConverted", 90, 20],
	["ec_endurance.sqf", 20, "EdenConverted", 90, 20],
	["ec_fortitude.sqf", 25, "EdenConverted", 90, 25],
	["m3e_exoBase1.sqf", 30, "m3e", 90, 50],
  ["m3e_exoBase2.sqf", 30, "m3e", 90, 50],
  ["m3e_exoBase3.sqf", 35, "m3e", 90, 50]
];

ZCP_Blacklist = [ // [ [x,y,z], radius ];
	[[23644,18397,0] , 1200], // altis saltlake
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

/* 3.1 new configs */
ZCP_CONFIG_TerritoryDistance = 500;  // Distance from territories. ( 0 to disable )

ZCP_CONFIG_AI_side = east; // The side where the AI is on.
ZCP_CONFIG_AI_soldierClass = 'O_G_Soldier_F'; // The class model for the soldier ( This needs to be a soldier from the AI faction! -> otherwise they shoot eachother on spawn)
ZCP_CONFIG_MaxRandomAIMoney = 100; // Max poptabs on in AI it's inventory. ( Random between 0 -> this number ).

// These are used when the cappoint is a city point.
ZCP_CONFIG_UseCityName = true; // Use City name CP for maker naming instead of ZCP alpha..
ZCP_CONFIG_CityDistanceToPlayer = 100; // distance for the town to be from a player ( From center town )
ZCP_CONFIG_CityDistanceToTrader = 500; // distance for the town to be from a trader ( From center town )
ZCP_CONFIG_CityDistanceToSpawn = 500; // distance for the town to be from a spawnpoint ( From center town )
ZCP_CONFIG_CityDistanceToTerritory = 100; // distance for the town to be from a spawnpoint ( From center town )
ZCP_CONFIG_CityDistanceToAI = 100; // distance for the town to be from other AI missions, patrols ..

/* END NEW CONFIGS 3.1 */

// Same as DMS -> Credits DMS
ZCP_DistanceBetweenMissions = 500;
ZCP_SpawnZoneDistance = 500;
ZCP_TradeZoneDistance = 500;
ZCP_DistanceFromWater = 100;
ZCP_DistanceFromPlayers = 200;
ZCP_DistanceFromBaseObjects = 100;

ZCP_CONFIG_BaseObjectsClasses = [
                                    'Exile_Construction_Abstract_Physics',
                                     'Exile_Construction_Abstract_Static'
                                 ];


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

/* Uses DMS system, why make one if it already excist? Credits DMS */
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

ZCP_VehicleReward = ZCP_DMS_ArmedVehicles+ZCP_DMS_MilitaryVehicles+ZCP_DMS_TransportTrucks+ZCP_DMS_RefuelTrucks+ZCP_DMS_CivilianVehicles+ZCP_DMS_TransportHelis;//Will choose from all above categories, edit as required
ZCP_DMS_DEBUG = false;




ZCP_CurrentMod = "Exile"; // Exile, ( Epoch coming soon again)

/** If you want to change the language of the addon
Go to server_addon_code/a3_zcp_exile/fn_translations.sqf and edit the Strings however you like
You can also use one of the pre-defined languages which are currently English (default) and German
Just uncomment the language you prefer and comment out the other one you don't need */

/* Do not change this*/
ZCP_CapPoints = call ZCP_fnc_missions;
ZCP_Translations = call ZCP_fnc_translations; //currently available pre-defined languages are English (default) and German
diag_log text format["[ZCP]: Config loaded succesfull"];
ZCP_ConfigLoaded = true;
