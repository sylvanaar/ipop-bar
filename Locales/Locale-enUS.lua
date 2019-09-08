-- IPopBar
-- enUS and enGB Localization file

local IPopBar = select(2, ...)

IPopBar.Localization = {}
local L = IPopBar.Localization


-- Name (short and long) and version of the addon
L["IPopBar"] = true
L["Integrated PopBar"] = true

-- Keybindings Menu
L["IPopBar Buttons"] = true
L["Toggle Menu Bar/IPopBar"] = true
L["IPopBar Button %d/%d"] = true

-- Other strings
L["Click to toggle IPopBar."] = true

-- Used in the slash commands
L["IPopBar cannot change this setting while in combat."] = true
L["IPopBar is now set to only use %d row(s) of buttons."] = true
L["IPopBar is now showing the action bar page number on the latency meter."] = true
L["IPopBar is now hiding the action bar page number on the latency meter."] = true
L["IPopBar will now automatically switch to bar mode on entering combat."] = true
L["IPopBar will no longer automatically switch to bar mode on entering combat."] = true
L["Use X rows of buttons. X can be 1, 2 or 3."] = true
L["Show/hide the action page number on the latency meter"] = true
L["Automatically switch to bar mode on entering combat."] = true
L["Display this help. (IPopBar v%s)"] = true
L["Scale the main menu bar. X can be between 0.5 and 2.0."] = true
L["Invalid scale specified. It must be between 0.5 and 2.0."] = true
L["Show/hide the gryphon end caps on the main menu bar"] = true
L["Invalid ID specified. It must be between 1 and 110."] = true
L["Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110."] = true
L["Resets the starting action IDs of all the rows to the defaults."] = true
L["Change the time it takes before the popbar rows appear. Only affects combat. X can be between 0 and 5. (0.2 default)"] = true
L["Change the time it takes before the popbar rows disappear. Only affects combat. X can be between 0 and 5. (0.2 default)"] = true
L["Invalid time specified. It must be between 0 and 5.0."] = true

-- Used in Ace Config Dialog
L["Settings"] = true
L["Number of rows"] = true
L["Number of rows of buttons to use"] = true
L["Main bar scaling"] = true
L["The scale of the main menu bar and side bars."] = true
L["Show dragon end caps"] = true
L["Show action bar page number"] = true
L["Show/hide the action page number on the latency meter"] = true
L["Auto-switch to bar mode on combat"] = true
L["Automatically switch IPopBar to bar mode on entering combat"] = true
L["Advanced"] = true
L["ADVANCED_DESC"] = "This section is for advanced users to setup IPopBar buttons to use a specific range of action IDs on each bar.\n\nThe WoW servers store 120 action IDs corresponding to your spells and items on your action bars, the default UI bars uses action IDs 1-72, with some extra action IDs (typically 73-84) for the various forms and stances that some classes have.\n"
L["Row %d starting action ID"] = true
L["The number of the actionID IPopBar Button %d/1 should use"] = true
L["Reset to defaults"] = true
L["Reset the actionIDs to default values"] = true
L["Keybinds"] = true
L["Row %d"] = true
L["Technical Information"] = true
L["Hover in time"] = true
L["The amount of time before the popbar rows appear. Only affects combat."] = true
L["Hover out time"] = true
L["The amount of time before the popbar rows disappear. Only affects combat."] = true
L["TECH_INFO"] = [[|cFFFFFFFFThe following are the default Action IDs for the default bars|r
ActionBar page 1: Action ID 1 to 12 -- Except for warriors
ActionBar page 2: Action ID 13 to 24
ActionBar page 3 (Right ActionBar): Action ID 25 to 36
ActionBar page 4 (Right ActionBar 2): Action ID 37 to 48
ActionBar page 5 (Bottom Right ActionBar): Action ID 49 to 60
ActionBar page 6 (Bottom Left ActionBar): Action ID 61 to 72

|cFFFFFFFFWarrior Bonus Action Bars|r
Warriors do not use Action ID 1 to 12 because they are always in one of the following stances:

ActionBar page 1 Battle Stance: Action ID 73 to 84
ActionBar page 1 Defensive Stance: Action ID 85 to 96
ActionBar page 1 Berserker Stance: Action ID 97 to 108

|cFFFFFFFFDruid Bonus Action Bars|r

ActionBar page 1 Cat Form: Action ID 73 to 84
ActionBar page 1 Tree Form: Action ID 85 to 96
ActionBar page 1 Bear Form: Action ID 97 to 108
ActionBar page 1 Moonkin Form: Action ID 109 to 120

|cFFFFFFFFRogue Bonus Action Bars|r

ActionBar page 1 Stealth: Action ID 73 to 84

|cFFFFFFFFPriest Bonus Action Bars|r

ActionBar page 1 Shadowform: Action ID 73 to 84
]]

-- Convert the "true" entries to the same as the key
for k, v in pairs(L) do
	if v == true then
		L[k] = k
	end
end

setmetatable(IPopBar.Localization, {
	__index = function(self, key)
		geterrorhandler()("Non-critical error: '"..key.."' is not defined in the IPopBar localization tables.")
		self[key] = key
		return key
	end
})

-- vim: ts=4 noexpandtab
