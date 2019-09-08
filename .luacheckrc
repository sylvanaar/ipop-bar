std = "lua51"
max_line_length = false
exclude_files = {
	"**/libraries",
}

ignore = {
	"11/SLASH_.*", -- slash handlers
	"1/[A-Z][A-Z][A-Z0-9_]+", -- three letter+ constants
	"212/self" -- unused self
}
globals = {
	-- wow std api
	"abs",
	"acos",
	"asin",
	"atan",
	"atan2",
	"bit",
	"ceil",
	"cos",
	"date",
	"debuglocals",
	"debugprofilestart",
	"debugprofilestop",
	"debugstack",
	"deg",
	"difftime",
	"exp",
	"fastrandom",
	"floor",
	"forceinsecure",
	"foreach",
	"foreachi",
	"format",
	"frexp",
	"geterrorhandler",
	"getn",
	"gmatch",
	"gsub",
	"hooksecurefunc",
	"issecure",
	"issecurevariable",
	"ldexp",
	"log",
	"log10",
	"max",
	"min",
	"mod",
	"rad",
	"random",
	"scrub",
	"securecall",
	"seterrorhandler",
	"sin",
	"sort",
	"sqrt",
	"strbyte",
	"strchar",
	"strcmputf8i",
	"strconcat",
	"strfind",
	"string.join",
	"strjoin",
	"strlen",
	"strlenutf8",
	"strlower",
	"strmatch",
	"strrep",
	"strrev",
	"strsplit",
	"strsub",
	"strtrim",
	"strupper",
	"table.wipe",
	"tan",
	"time",
	"tinsert",
	"tremove",
	"wipe",

	-- framexml
	"CopyTable",
	"getprinthandler",
	"hash_SlashCmdList",
	"setprinthandler",
	"tContains",
	"tDeleteItem",
	"tInvert",
	"tostringall",

	-- everything else
	"BINDING_HEADER_oRA3",
	"AlertFrame",
	"Ambiguate",
	"BasicMessageDialog",
	"BNGetFriendGameAccountInfo",
	"BNGetFriendIndex",
	"BNGetGameAccountInfoByGUID",
	"BNGetNumFriendGameAccounts",
	"BNInviteFriend",
	"BNIsSelf",
	"BNSendWhisper",
	"BossBanner",
	"C_ChatInfo",
	"C_EncounterJournal",
	"C_FriendList",
	"ChatFrame_ImportAllListsToHash",
	"ChatTypeInfo",
	"CheckInteractDistance",
	"CinematicFrame_CancelCinematic",
	"C_Map",
	"CollapseFactionHeader",
	"CombatLogGetCurrentEventInfo",
	"CombatLog_String_GetIcon",
	"ConvertToRaid",
	"CreateFrame",
	"C_CVar",
	"C_RaidLocks",
	"C_Scenario",
	"C_Spell",
	"C_Timer",
	"C_TradeSkillUI",
	"C_UIWidgetManager",
	"DemoteAssistant",
	"DoReadyCheck",
	"EJ_GetCreatureInfo",
	"EJ_GetEncounterInfo",
	"EJ_GetTierInfo",
	"ElvUI",
	"EnableAddOn",
	"ExpandFactionHeader",
	"FlashClientIcon",
	"FriendsFrame",
	"GameFontHighlight",
	"GameFontNormal",
	"GameTooltip",
	"GameTooltip_Hide",
	"GetAddOnDependencies",
	"GetAddOnEnableState",
	"GetAddOnInfo",
	"GetAddOnMetadata",
	"GetAddOnOptionalDependencies",
	"GetAverageItemLevel",
	"GetBattlefieldStatus",
	"GetChannelDisplayInfo",
	"GetChannelName",
	"GetCVarBool",
	"GetDetailedItemLevelInfo",
	"GetDifficultyInfo",
	"GetExpansionLevel",
	"GetFactionInfo",
	"GetFramesRegisteredForEvent",
	"GetGossipActiveQuests",
	"GetGossipAvailableQuests",
	"GetGossipOptions",
	"GetGossipText",
	"GetGuildInfo",
	"GetGuildRosterInfo",
	"GetInstanceInfo",
	"GetInventoryItemLink",
	"GetInventoryItemQuality",
	"GetItemCount",
	"GetItemStats",
	"GetLFGMode",
	"GetLocale",
	"GetMapNameByID",
	"GetMaxBattlefieldID",
	"GetNumAddOns",
	"GetNumDisplayChannels",
	"GetNumFactions",
	"GetNumGroupMembers",
	"GetNumGuildMembers",
	"GetNumSubgroupMembers",
	"GetPartyAssignment",
	"GetPlayerFacing",
	"GetPlayerMapAreaID",
	"GetProfessionInfo",
	"GetProfessions",
	"GetRaidDifficultyID",
	"GetRaidRosterInfo",
	"GetRaidTargetIndex",
	"GetReadyCheckStatus",
	"GetReadyCheckTimeLeft",
	"GetRealmName",
	"GetRealZoneText",
	"GetSpecialization",
	"GetSpecializationInfoByID",
	"GetSpecializationRole",
	"GetSpellBookItemName",
	"GetSpellBookItemTexture",
	"GetSpellCharges",
	"GetSpellCooldown",
	"GetSpellDescription",
	"GetSpellInfo",
	"GetSpecializationRoleByID",
	"GetSpellLink",
	"GetSpellTabInfo",
	"GetSpellTexture",
	"GetSubZoneText",
	"GetTexCoordsForRole",
	"GetTexCoordsForRoleSmallCircle",
	"GetTime",
	"GetTrackedAchievements",
	"GuildControlGetNumRanks",
	"GuildControlGetRankName",
	"GuildRoster",
	"InCombatLockdown",
	"InviteUnit",
	"IsAddOnLoaded",
	"IsAddOnLoadOnDemand",
	"IsAltKeyDown",
	"IsControlKeyDown",
	"IsEncounterInProgress",
	"IsEveryoneAssistant",
	"IsGuildMember",
	"IsInGroup",
	"IsInGuild",
	"IsInInstance",
	"IsInRaid",
	"IsItemInRange",
	"IsLoggedIn",
	"IsPartyLFG",
	"IsShiftKeyDown",
	"IsSpellKnown",
	"IsTestBuild",
	"LeaveParty",
	"LFGDungeonReadyPopup",
	"LibStub",
	"LoadAddOn",
	"LoggingCombat",
	"MovieFrame",
	"ObjectiveTrackerFrame",
	"PlayerHasToy",
	"PlaySound",
	"PlaySoundFile",
	"PromoteToAssistant",
	"RaidBossEmoteFrame",
	"RaidNotice_AddMessage",
	"RaidWarningFrame",
	"RolePollPopup",
	"SecondsToTime",
	"SelectGossipOption",
	"SendChatMessage",
	"SetEveryoneIsAssistant",
	"SetPortraitToTexture",
	"SetRaidDifficulties",
	"SetRaidTarget",
	"SlashCmdList",
	"StopSound",
	"Tukui",
	"UIErrorsFrame",
	"UIParent",
	"UninviteUnit",
	"UnitAffectingCombat",
	"UnitAura",
	"UnitCanAttack",
	"UnitCastingInfo",
	"UnitChannelInfo",
	"UnitClass",
	"UnitDetailedThreatSituation",
	"UnitEffectiveLevel",
	"UnitExists",
	"UnitFactionGroup",
	"UnitGetTotalAbsorbs",
	"UnitGroupRolesAssigned",
	"UnitGUID",
	"UnitHealth",
	"UnitHealthMax",
	"UnitInBattleground",
	"UnitInParty",
	"UnitInPhase",
	"UnitInRaid",
	"UnitInVehicle",
	"UnitIsConnected",
	"UnitIsCorpse",
	"UnitIsDead",
	"UnitIsDeadOrGhost",
	"UnitIsFeignDeath",
	"UnitIsGhost",
	"UnitIsGroupAssistant",
	"UnitIsGroupLeader",
	"UnitIsInMyGuild",
	"UnitIsPlayer",
	"UnitInRange",
	"UnitIsUnit",
	"UnitIsVisible",
	"UnitLevel",
	"UnitName",
	"UnitPlayerControlled",
	"UnitPosition",
	"UnitPower",
	"UnitPowerMax",
	"UnitRace",
	"UnitSetRole",
	"WorldFrame",

	"UIPanelWindows",
	"CanOpenPanels",
	"GetUIPanel",
	"GetUIPanelWidth",
	"AchievementMicroButton_Update",
	"AttemptToSaveBindings",
	"BINDING_HEADER_IPopBar",
	"CharacterBag0Slot",
	"CharacterBag1Slot",
	"CharacterBag2Slot",
	"CharacterBag3Slot",
	"CharacterMicroButton",
	"GetBindingAction",
	"GetBindingKey",
	"GetBindingText",
	"GetCurrentBindingSet",
	"GetNetStats",
	"HelpMicroButton",
	"IPopBar_Config",
	"MainMenuBar",
	"MainMenuBarArtFrame",
	"MainMenuBarBackpackButton",
	"MainMenuBarLeftEndCap",
	"MainMenuBarPageNumber",
	"MainMenuBarPerformanceBarFrame_OnEnter",
	"MainMenuBarRightEndCap",
	"MainMenuBarTexture2",
	"MainMenuBarTexture3",
	"MainMenuMicroButton",
	"MicroButtonTooltipText",
	"MultiBarBottomLeft",
	"MultiBarBottomRight",
	"MultiBarLeft",
	"MultiBarRight",
	"QuestLogMicroButton",
	"SecureHandlerUnwrapScript",
	"SecureHandlerWrapScript",
	"SetBinding",
	"SetBindingClick",
	"SocialsMicroButton",
	"SpellbookMicroButton",
	"SpellFlyout",
	"TalentMicroButton",
	"UpdateMicroButtons",
	"WorldMapMicroButton",
}