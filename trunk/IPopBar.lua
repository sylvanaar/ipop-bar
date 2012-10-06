--[[
	Integrated PopBar v3.17 (6 October 2012)
	For Live Servers v5.0.5.16057.
	By Xinhuan

	Inspired by PopBar, this mod integrates the fundamental
	aspect of PopBar into the menu bar itself, toggle-able
	between the Bag Buttons and 2 extra rows of buttons.
]]

IPopBar = {}
local IPopBar = IPopBar
local L = IPopBar_Localization
local TOC = select(4, GetBuildInfo())

-- Setup the text displayed in the keybindings
BINDING_HEADER_IPopBar = L["IPopBar Buttons"]
for i = 0, 32 do
	local row, col = floor(i/11)+1, i%11+1
	_G[("BINDING_NAME_CLICK IPopBarButton%d:LeftButton"):format(i+1)] = L["IPopBar Button %d/%d"]:format(row, col)
end
_G["BINDING_NAME_CLICK IPopBarToggleButton:LeftButton"] = L["Toggle Menu Bar/IPopBar"]

-- Our database defaults
local db
local defaults = {
	Enabled          = 1,
	NumRows          = 2,
	ShowPageNum      = true,
	AutoToggleCombat = true,
	Scale            = 1,
	ShowEndCaps      = true,
	TimeIn           = 0.2,
	TimeOut          = 0.2,
	Version          = 3.10,
}
local defaultStartIDs = {
	WARRIOR = {
		Row1StartID = 97-96, -- 1 -- ActionIDs 1-12 are not used by default, as a warrior is always in a stance
		Row2StartID = 109,   -- 109
		Row3StartID = 85-36, -- 49
	},
	DRUID = {
		Row1StartID = 97-12, -- 85
		Row2StartID = 109,   -- 109
		Row3StartID = 85-36, -- 49
	},
	DEFAULT = {
		Row1StartID = 97,
		Row2StartID = 109,
		Row3StartID = 85,
	},
}
do
	-- Create inheritence so that defaultStartIDs.Row1StartID will redirect to defaultStartIDs.CLASS.Row1StartID
	local _, class = UnitClass("player")
	if not defaultStartIDs[class] then class = "DEFAULT" end
	setmetatable(defaultStartIDs, {__index = function(t, k) return t[class][k] end})
end
setmetatable(defaults, {__index = defaultStartIDs})

-- Localize some globals
local tinsert, tremove = tinsert, tremove
local GameTooltip = GameTooltip
local InCombatLockdown = InCombatLockdown

-- Some locals we use, these are tables used to store our button references
local allB, row1, row2, row3 = {}, {}, {}, {}

-- These are variables used by IPopBar
local IPopBar_ModeBeforeCombat = false


---------------------------------------------------------------------------
-- Modified functions from ActionButtun.lua
-- Our button handler functions in a neat table
local buttonHandler = {}

function buttonHandler:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", allB[11*db.NumRows], "TOPRIGHT", 3, 3)
	if GameTooltip:SetAction(self.action) then
		self.UpdateTooltip = buttonHandler.OnEnter
	else
		self.UpdateTooltip = nil
	end
end

---------------------------------------------------------------------------
-- Frame, button and texture creation

-- Just a frame with some textures to be shown all the time
-- This is also our main addon frame that listens to events
local IPopBarFrame = CreateFrame("Frame", "IPopBarFrame", MainMenuBar)
IPopBarFrame:SetMovable(nil)
IPopBarFrame:SetAllPoints(MainMenuBar)
IPopBarFrame.t2a = IPopBarFrame:CreateTexture(nil, "OVERLAY")
IPopBarFrame.t2a:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrame.t2a:SetWidth(38)
IPopBarFrame.t2a:SetHeight(43)
IPopBarFrame.t2a:SetPoint("BOTTOM", 19, 0)
IPopBarFrame.t2a:SetTexCoord(0, 0.1484375, 0.33203125, 0.5)

-- The frame to show when in Bar mode.
-- It's also our secure header that controls all our buttons
local IPopBarFrameBar = CreateFrame("Button", "IPopBarFrameBar", MainMenuBar, "SecureHandlerEnterLeaveTemplate, SecureHandlerAttributeTemplate")
IPopBarFrameBar:SetMovable(nil)
IPopBarFrameBar:SetPoint("TOPLEFT", 556, 0)
IPopBarFrameBar:SetPoint("BOTTOMRIGHT")
IPopBarFrameBar.bg1 = IPopBarFrameBar:CreateTexture(nil, "ARTWORK")
IPopBarFrameBar.bg1:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-NightElf")
IPopBarFrameBar.bg1:SetWidth(252)
IPopBarFrameBar.bg1:SetHeight(43)
IPopBarFrameBar.bg1:SetPoint("BOTTOMLEFT")
IPopBarFrameBar.bg1:SetTexCoord(0.015625, 1.0, 0.83203125, 1.0)
IPopBarFrameBar.bg2 = IPopBarFrameBar:CreateTexture(nil, "ARTWORK")
IPopBarFrameBar.bg2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-NightElf")
IPopBarFrameBar.bg2:SetWidth(214)
IPopBarFrameBar.bg2:SetHeight(43)
IPopBarFrameBar.bg2:SetPoint("BOTTOMLEFT", 252, 0)
IPopBarFrameBar.bg2:SetTexCoord(0.1640625, 1.0, 0.58203125, 0.75)
IPopBarFrameBar.bg3 = IPopBarFrameBar:CreateTexture(nil, "ARTWORK")
IPopBarFrameBar.bg3:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-NightElf")
IPopBarFrameBar.bg3:SetWidth(9)
IPopBarFrameBar.bg3:SetHeight(43)
IPopBarFrameBar.bg3:SetPoint("BOTTOMLEFT", -6, 0)
IPopBarFrameBar.bg3:SetTexCoord(0.0859375, 0.12109375, 0.08203125, 0.25)
if TOC >= 40000 then
	IPopBarFrameBar:SetFrameRef("SpellFlyout", SpellFlyout)
end

-- Function to create one of our buttons
local function CreateIPopBarButton(num)
	local name = ("IPopBarButton%d"):format(num)
	local b = CreateFrame("CheckButton", name, IPopBarFrameBar, "ActionBarButtonTemplate")
	b:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
	b:SetAttribute("actionpage", 1)
	b:SetScript("OnEnter", buttonHandler.OnEnter)
	-- Set the cooldown frame's framelevel to be the same as our buttons
	_G[name.."Cooldown"]:SetFrameLevel(b:GetFrameLevel())
	return b
end

-- Create our 33 buttons and store frame references to them in tables
for i = 1, 33 do
	local b = CreateIPopBarButton(i)
	if i <= 11 then
		row1[i] = b
	elseif i <= 22 then
		row2[i - 11] = b
	else
		row3[i - 22] = b
	end
	allB[i] = b
end

-- Position all the buttons
row1[1]:SetPoint("BOTTOMLEFT", IPopBarFrameBar, "BOTTOMLEFT", 3, 4)
row2[1]:SetPoint("BOTTOMLEFT", row1[1], "TOPLEFT", 0, 6)
row3[1]:SetPoint("BOTTOMLEFT", row2[1], "TOPLEFT", 0, 6)
for i = 2, 11 do
	row1[i]:SetPoint("LEFT", row1[i-1], "RIGHT", 6, 0)
	row2[i]:SetPoint("LEFT", row2[i-1], "RIGHT", 6, 0)
	row3[i]:SetPoint("LEFT", row3[i-1], "RIGHT", 6, 0)
end

-- Get button references into our secure header
IPopBarFrameBar:Execute("Buttons = table.new(self:GetChildren())")
IPopBarFrameBar:Execute("IPopBarFrameBar = self")

-- Create our secure toggle button
local IPopBarToggleButton = CreateFrame("Button", "IPopBarToggleButton", MainMenuBarArtFrame, "SecureHandlerClickTemplate")
IPopBarToggleButton:RegisterForClicks("LeftButtonDown")
IPopBarToggleButton:SetFrameRef("IPopBarFrameBar", IPopBarFrameBar)
IPopBarToggleButton:SetAttribute("_onclick", [[
	local IPopBarFrameBar = self:GetFrameRef("IPopBarFrameBar")
	if IPopBarFrameBar:GetAttribute("shown") then
		IPopBarFrameBar:Hide()
		IPopBarFrameBar:SetAttribute("shown", false)
	else
		IPopBarFrameBar:Show()
		IPopBarFrameBar:SetAttribute("shown", true)
	end
	control:CallMethod("UpdateButtons", true)
]])
IPopBarToggleButton:SetPoint("CENTER", 30, -5)
IPopBarToggleButton:SetWidth(12)
IPopBarToggleButton:SetHeight(12)
IPopBarToggleButton:SetScript("OnEnter", function(self, motion)
	self.tooltipText = MicroButtonTooltipText("IPopBar v"..defaults.Version, "CLICK IPopBarToggleButton:LeftButton")
	MainMenuBarPerformanceBarFrame_OnEnter(self)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["Click to toggle IPopBar."], 1.0, 0.8, 0, 1)
	GameTooltip:Show()
end)
IPopBarToggleButton:SetScript("OnLeave", function(self, motion)
	GameTooltip:Hide()
end)
IPopBarToggleButton:SetScript("OnUpdate", function(self, elapsed)
	if self.updateInterval > 0 then
		self.updateInterval = self.updateInterval - elapsed
	else
		self.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL
		local bandwidthIn, bandwidthOut, latency = GetNetStats()
		if latency > PERFORMANCEBAR_MEDIUM_LATENCY then
			MainMenuBarPageNumber:SetTextColor(1, 0, 0)
		elseif latency > PERFORMANCEBAR_LOW_LATENCY then
			MainMenuBarPageNumber:SetTextColor(1, 1, 0)
		else
			MainMenuBarPageNumber:SetTextColor(0, 1, 0)
		end
	end
end)
IPopBarToggleButton.updateInterval = 0

-- Create an update frame that wraps any SpellFlyout buttons that
-- get created during combat the moment we exit combat
local IPopBarSpellFlyoutWrapper
if SpellFlyout then
	IPopBarSpellFlyoutWrapper = CreateFrame("Frame")
	IPopBarSpellFlyoutWrapper:Hide()
	IPopBarSpellFlyoutWrapper:SetScript("OnEvent", function(self, event)
		IPopBar:WrapFlyoutButtons()
		self:UnregisterEvent(event)
	end)
end

-- Raise our frame's framelevel so that it covers the XP bar
IPopBarFrame:SetFrameLevel(IPopBarFrame:GetFrameLevel() + 1)
IPopBarFrameBar:SetFrameLevel(IPopBarFrameBar:GetFrameLevel() + 1)

-- Hook Functions
if TOC < 40200 then
	hooksecurefunc("MainMenuBar_UpdateKeyRing", function()
		if db.Enabled == 1 and IPopBarFrameBar:IsVisible() then KeyRingButton:Hide() end
	end)
end
if not AchievementMicroButton_Update then
	AchievementMicroButton_Update = function() end
end
if TOC < 50001 then
	hooksecurefunc("VehicleMenuBar_MoveMicroButtons", function(skinName)
		if not skinName then IPopBar:ShowBars(db.Enabled) end
	end)
	hooksecurefunc("MainMenuBar_UpdateArt", function(MainMenuBar)
		IPopBar:ShowBars(db.Enabled)
	end)
	-- Stops the error on Blizzard_AchievementUI\Blizzard_AchievementUI.lua:671
	-- which calls this non-existant function if the AchievementMicroButton is hidden
else
	OverrideActionBar:HookScript("OnShow", function(self)
		IPopBar:ShowMicroButtons()
	end)
	PetBattleFrame:HookScript("OnShow", function(self)
		IPopBar:ShowMicroButtons()
	end)
	MainMenuBar:HookScript("OnShow", function(self)
		IPopBar:ShowBars(db.Enabled)
	end)
end
if SpellFlyout then
	hooksecurefunc(SpellFlyout, "Toggle", function(self, flyoutID, parent, direction, distance, isActionBar)
		if InCombatLockdown() then
			IPopBarSpellFlyoutWrapper:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			IPopBar:WrapFlyoutButtons()
		end
	end)
end


---------------------------------------------------------------------------
-- Function to toggle IPopBar to Bar mode when entering combat

IPopBarFrameBar:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" and db.Enabled == 0 then
		-- Enter IPopBar mode when entering combat
		IPopBar:ShowBars(1)
		IPopBar_ModeBeforeCombat = true
	elseif event == "PLAYER_REGEN_ENABLED" and IPopBar_ModeBeforeCombat then
		IPopBar:ShowBars(0)
		IPopBar_ModeBeforeCombat = false
	end
end)


---------------------------------------------------------------------------
-- Function to apply loaded settings when savedvariables are loaded

-- Adjust the actionIDs
local function IPopBar_AdjustActionIDs()
	if InCombatLockdown() then
		DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
		return
	end
	for i = 1, 33 do
		local b = allB[i]
		local actionID
		if i <= 11 then
			actionID = db.Row1StartID + i - 1
		elseif i <= 22 then
			actionID = db.Row2StartID + i - 12
		else
			actionID = db.Row3StartID + i - 23
		end
		b:SetID(actionID)
		b:SetAttribute("action", actionID)
	end
end

-- This function migrates all the keybinds from the old
-- "TOGGLEIPOPBAR" to the new "CLICK IPopBarToggleButton:LeftButton"
local function IPopBar_MigrateOldKeyBind(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if key ~= "" then
			SetBindingClick(key, "IPopBarToggleButton")
		end
	end
	local s = GetCurrentBindingSet()
	if s == 1 or s == 2 then
		SaveBindings(s)
	end
end

local function IPopBar_OnEvent(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		IPopBar:UpdateButtons()
	
	elseif event == "ADDON_LOADED" and arg1 == "IPopBar" then
		IPopBar_Config = IPopBar_Config or {}
		db = IPopBar_Config
		setmetatable(IPopBar_Config, {__index = defaults})

		-- Configure our buttons based on number of rows
		IPopBar:ConfigureButtonHideStates()

		-- Apply loaded settings
		IPopBar:ShowBars(db.Enabled)
		--if not db.ShowPageNum then MainMenuBarPageNumber:Hide() end
		MainMenuBar:SetScale(db.Scale)
		if TOC < 40000 then
			MultiBarBottomLeft:SetScale(db.Scale)
			MultiBarBottomRight:SetScale(db.Scale)
		end
		MultiBarRight:SetScale(db.Scale)
		--MultiBarLeft:SetScale(db.Scale)
		if not db.ShowEndCaps then
			MainMenuBarLeftEndCap:Hide()
			MainMenuBarRightEndCap:Hide()
		end
		IPopBar_AdjustActionIDs()
		if db.AutoToggleCombat then
			IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_DISABLED")
			IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_ENABLED")
		end

		-- Make it so that our buttons go above these buttons, since
		-- the default is "HIGH", and MainMenuBar is at "MEDIUM"
		MultiBarBottomLeft:SetFrameStrata("LOW")
		MultiBarBottomRight:SetFrameStrata("LOW")
		MultiBarRight:SetFrameStrata("LOW")
		MultiBarLeft:SetFrameStrata("LOW")

		IPopBarFrame:UnregisterEvent("ADDON_LOADED")

	elseif event == "PLAYER_LOGIN" then
		-- Migrate the old keybind
		if not rawget(IPopBar_Config, "Version") or db.Version < 3.00 then
			IPopBar_MigrateOldKeyBind(GetBindingKey("TOGGLEIPOPBAR"))
			db.Version = defaults.Version
		end
		IPopBarFrame:UnregisterEvent("PLAYER_LOGIN")

	end
end
IPopBarFrame:RegisterEvent("ADDON_LOADED")
IPopBarFrame:RegisterEvent("PLAYER_LOGIN")
IPopBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
IPopBarFrame:SetScript("OnEvent", IPopBar_OnEvent)


---------------------------------------------------------------------------
-- Other functions

function IPopBar:ShowMicroButtons()
	CharacterMicroButton:Show()
	SpellbookMicroButton:Show()
	QuestLogMicroButton:Show()
	if TOC < 40000 then
		SocialsMicroButton:Show()
	else
		GuildMicroButton:Show()
	end
	LFDMicroButton:Show()
	MainMenuMicroButton:Show()
	HelpMicroButton:Show()
	PVPMicroButton:Show()
	TalentMicroButton:Show()
	AchievementMicroButton:Show()
	if TOC >= 40200 then
		EJMicroButton:Show()
		if TOC < 50001 then
			RaidMicroButton:Show()
		else
			CompanionsMicroButton:Show()
		end
	end
	UpdateMicroButtons()
end

function IPopBar:HideMicroButtons()
	CharacterMicroButton:Hide()
	SpellbookMicroButton:Hide()
	QuestLogMicroButton:Hide()
	if TOC < 40000 then
		SocialsMicroButton:Hide()
	else
		GuildMicroButton:Hide()
	end
	LFDMicroButton:Hide()
	MainMenuMicroButton:Hide()
	HelpMicroButton:Hide()
	TalentMicroButton:Hide()
	AchievementMicroButton:Hide()
	PVPMicroButton:Hide()
	if TOC >= 40200 then
		EJMicroButton:Hide()
		if TOC < 50001 then
			RaidMicroButton:Hide()
		else
			CompanionsMicroButton:Hide()
		end
	end
end

function IPopBar:ShowBars(toggle)
	if InCombatLockdown() then IPopBar:UpdateButtons() return end
	if toggle == 1 then
		db.Enabled = 1
		IPopBarFrameBar:Show()
		IPopBarFrameBar:SetAttribute("shown", true)
	else
		db.Enabled = 0
		IPopBarFrameBar:Hide()
		IPopBarFrameBar:SetAttribute("shown", false)
	end
	IPopBar:UpdateButtons()
end

function IPopBar:UpdateButtons(issecure)
	if issecure then db.Enabled = 1 - db.Enabled end
	if db.Enabled == 1 then
		if TOC < 50001 then
			if not VehicleMenuBar:IsShown() then
				IPopBar:HideMicroButtons()
			end
		else
			if OverrideActionBar:IsShown() or PetBattleFrame:IsShown() then
				IPopBar:ShowMicroButtons()
			else
				IPopBar:HideMicroButtons()
			end
		end

		MainMenuBarBackpackButton:Hide()
		CharacterBag0Slot:Hide()
		CharacterBag1Slot:Hide()
		CharacterBag2Slot:Hide()
		CharacterBag3Slot:Hide()
		if TOC < 40200 then
			KeyRingButton:Hide()
		end

		MainMenuBarTexture2:Hide()
		MainMenuBarTexture3:Hide()
	else
		IPopBar:ShowMicroButtons()
		MainMenuBarBackpackButton:Show()
		CharacterBag0Slot:Show()
		CharacterBag1Slot:Show()
		CharacterBag2Slot:Show()
		CharacterBag3Slot:Show()
		if TOC < 40200 then
			MainMenuBar_UpdateKeyRing()
		end

		MainMenuBarTexture2:Show()
		MainMenuBarTexture3:Show()
	end
end
IPopBarToggleButton.UpdateButtons = IPopBar.UpdateButtons

-- Configure button popup row hidestates
function IPopBar:ConfigureButtonHideStates()
	if InCombatLockdown() then return end

	local HideButtons = format("for i = 12, %d do Buttons[i]:Hide() end", db.NumRows * 11)..' IPopBarFrameBar:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 556, 0)'
	local onLeave = "if not IPopBarFrameBar:IsUnderMouse(true) then "..HideButtons.." end"
	local onEnter = format('for i = 12, %d do Buttons[i]:Show() end IPopBarFrameBar:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 556, %d)', db.NumRows * 11, (db.NumRows - 1) * 42)

	if db.NumRows > 1 then
		IPopBarFrameBar:SetAttribute("_onattributechanged", [[
			if name == "shown" then
				if value then
					if self:IsUnderMouse(true) then ]]..onEnter..[[ end
				else ]]
					..HideButtons..
				[[ end
			end
		]])
		--IPopBarFrameBar:SetAttribute("_onattributechanged", "SetUpAnimation(Buttons[1], 'SetAlpha', 'return elapsedFraction', 5, nil, true)")
	else
		IPopBarFrameBar:SetAttribute("_onattributechanged", nil)
	end

	if db.NumRows == 1 then
		for i = 1, 11 do
			row2[i]:Hide()
			row3[i]:Hide()
			SecureHandlerUnwrapScript(allB[i], "OnEnter")
			SecureHandlerUnwrapScript(allB[i], "OnLeave")
			row2[i]:SetAttribute("statehidden", true)
			row3[i]:SetAttribute("statehidden", true)
		end
		IPopBarFrameBar:SetAttribute("_onenter", nil)
		IPopBarFrameBar:SetAttribute("_onleave", nil)
	elseif db.NumRows == 2 then
		for i = 1, 11 do
			row2[i]:Show()
			row3[i]:Hide()
			row2[i]:SetAttribute("statehidden", nil)
			row3[i]:SetAttribute("statehidden", true)
		end
		IPopBarFrameBar:SetAttribute("_onenter", onEnter)
		IPopBarFrameBar:SetAttribute("_onleave", onLeave)
		for i = 1, 33 do
			SecureHandlerUnwrapScript(allB[i], "OnEnter")
			SecureHandlerUnwrapScript(allB[i], "OnLeave")
			SecureHandlerWrapScript(allB[i], "OnEnter", IPopBarFrameBar, onEnter)
			SecureHandlerWrapScript(allB[i], "OnLeave", IPopBarFrameBar, onLeave)
		end
	elseif db.NumRows == 3 then
		for i = 1, 11 do
			row2[i]:Show()
			row3[i]:Show()
			row2[i]:SetAttribute("statehidden", nil)
			row3[i]:SetAttribute("statehidden", nil)
		end
		IPopBarFrameBar:SetAttribute("_onenter", onEnter)
		IPopBarFrameBar:SetAttribute("_onleave", onLeave)
		for i = 1, 33 do
			SecureHandlerUnwrapScript(allB[i], "OnEnter")
			SecureHandlerUnwrapScript(allB[i], "OnLeave")
			SecureHandlerWrapScript(allB[i], "OnEnter", IPopBarFrameBar, onEnter)
			SecureHandlerWrapScript(allB[i], "OnLeave", IPopBarFrameBar, onLeave)
		end
	end

	self:UnwrapFlyoutButtons()
	self:WrapFlyoutButtons()

	IPopBarFrameBar:Execute(onEnter)
	IPopBarFrameBar:Execute(onLeave)
end

function IPopBar:WrapFlyoutButtons()
	if InCombatLockdown() then return end

	local HideButtons = format("for i = 12, %d do Buttons[i]:Hide() end", db.NumRows * 11)..' IPopBarFrameBar:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 556, 0)'
	local onLeave = "if not IPopBarFrameBar:IsUnderMouse(true) then "..HideButtons.." end"

	local i = 1
	local button = _G["SpellFlyoutButton"..i]
	while button do
		if not button.IPopBarWrapped then
			SecureHandlerWrapScript(button, "OnEnter", IPopBarFrameBar, "")
			SecureHandlerWrapScript(button, "OnLeave", IPopBarFrameBar, onLeave)
			button.IPopBarWrapped = true
		end
		i = i + 1
		button = _G["SpellFlyoutButton"..i]
	end
	if SpellFlyout and not SpellFlyout.IPopBarWrapped then
		SecureHandlerWrapScript(SpellFlyout, "OnEnter", IPopBarFrameBar, "")
		SecureHandlerWrapScript(SpellFlyout, "OnLeave", IPopBarFrameBar, onLeave)
		SecureHandlerWrapScript(SpellFlyout, "OnHide", IPopBarFrameBar, onLeave)
		SpellFlyout.IPopBarWrapped = true
	end
end

function IPopBar:UnwrapFlyoutButtons()
	if InCombatLockdown() then return end

	local i = 1
	local button = _G["SpellFlyoutButton"..i]
	while button do
		SecureHandlerUnwrapScript(button, "OnEnter")
		SecureHandlerUnwrapScript(button, "OnLeave")
		button.IPopBarWrapped = nil
		i = i + 1
		button = _G["SpellFlyoutButton"..i]
	end
	if SpellFlyout then
		SecureHandlerUnwrapScript(SpellFlyout, "OnEnter")
		SecureHandlerUnwrapScript(SpellFlyout, "OnLeave")
		SecureHandlerUnwrapScript(SpellFlyout, "OnHide")
		SpellFlyout.IPopBarWrapped = nil
	end
end

---------------------------------------------------------------------------
-- Slash command function

local function IPopBar_Help(msg, quietmode)
	msg = strtrim(msg)

	if string.match(msg, "^rows ([123])$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		db.NumRows = tonumber(string.match(msg, "^rows ([123])$"))
		IPopBar:ConfigureButtonHideStates()
		if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now set to only use %d row(s) of buttons."]:format(db.NumRows)) end

	--[[elseif msg == "pagenum" then
		db.ShowPageNum = not db.ShowPageNum
		if db.ShowPageNum then
			MainMenuBarPageNumber:Show()
			if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now showing the action bar page number on the latency meter."]) end
		else
			MainMenuBarPageNumber:Hide()
			if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now hiding the action bar page number on the latency meter."]) end
		end]]

	elseif msg == "togglecombat" then
		db.AutoToggleCombat = not db.AutoToggleCombat
		if db.AutoToggleCombat then
			IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_DISABLED")
			IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			IPopBarFrameBar:UnregisterEvent("PLAYER_REGEN_DISABLED")
			IPopBarFrameBar:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
		if not quietmode then
			if db.AutoToggleCombat then
				DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar will now automatically switch to bar mode on entering combat."])
			else
				DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar will no longer automatically switch to bar mode on entering combat."])
			end
		end

	elseif string.match(msg, "^scale ([0-9.]+)$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		local scale = tonumber(string.match(msg, "^scale ([0-9.]+)$"))
		if scale and scale >= 0.5 and scale <= 2 then
			db.Scale = scale
			MainMenuBar:SetScale(scale)
			if TOC < 40000 then
				MultiBarBottomLeft:SetScale(scale)
				MultiBarBottomRight:SetScale(scale)
			end
			MultiBarRight:SetScale(scale)
			--MultiBarLeft:SetScale(scale)
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["Invalid scale specified. It must be between 0.5 and 2.0."])
		end

	elseif msg == "endcaps" then
		db.ShowEndCaps = not db.ShowEndCaps
		if db.ShowEndCaps then
			MainMenuBarLeftEndCap:Show()
			MainMenuBarRightEndCap:Show()
		else
			MainMenuBarLeftEndCap:Hide()
			MainMenuBarRightEndCap:Hide()
		end

	elseif string.match(msg, "^row([123])startID ([0-9]+)$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		local row, id = string.match(msg, "^row([123])startID ([0-9]+)$")
		row = tonumber(row)
		id = tonumber(id)
		if id and id >= 1 and id <= 110 then
			db[("Row%dStartID"):format(row)] = id
			IPopBar_AdjustActionIDs()
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["Invalid ID specified. It must be between 1 and 110."])
		end

	elseif msg == "resetstartID" then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		db.Row1StartID = nil
		db.Row2StartID = nil
		db.Row3StartID = nil
		IPopBar_AdjustActionIDs()

	--[[elseif string.match(msg, "^appear ([0-9.]+)$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		local t = tonumber(string.match(msg, "^appear ([0-9.]+)$"))
		if t and t >= 0 and t <= 5 then
			db.TimeIn = t
			IPopBar:ConfigureButtonHideStates()
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["Invalid time specified. It must be between 0 and 5.0."])
		end

	elseif string.match(msg, "^disappear ([0-9.]+)$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		local t = tonumber(string.match(msg, "^disappear ([0-9.]+)$"))
		if t and t >= 0 and t <= 5 then
			db.TimeOut = t
			IPopBar:ConfigureButtonHideStates()
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["Invalid time specified. It must be between 0 and 5.0."])
		end]]

	else
		if not quietmode then
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.."|r - "..L["Display this help. (IPopBar v%s)"]:format(defaults.Version))
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." rows X|r - "..L["Use X rows of buttons. X can be 1, 2 or 3."])
			--DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." pagenum|r - "..L["Show/hide the action page number on the latency meter"])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." togglecombat|r - "..L["Automatically switch to bar mode on entering combat."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." scale X|r - "..L["Scale the main menu bar. X can be between 0.5 and 2.0."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." endcaps|r - "..L["Show/hide the gryphon end caps on the main menu bar"])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." rowXstartID Y|r - "..L["Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." resetstartID|r - "..L["Resets the starting action IDs of all the rows to the defaults."])
			--DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." appear X|r - "..L["Change the time it takes before the popbar rows appear. Only affects combat. X can be between 0 and 5 (0.2 default)."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." disappear X|r - "..L["Change the time it takes before the popbar rows disappear. Only affects combat. X can be between 0 and 5 (0.2 default)."])
		end
	end
end

-- Keybinding helper functions for the Ace3 options table
local KeybindHelper = {}
do
	local t = {}
	function KeybindHelper:MakeKeyBindingTable(...)
		for k in pairs(t) do t[k] = nil end
		for i = 1, select("#", ...) do
			local key = select(i, ...)
			if key ~= "" then
				tinsert(t, key)
			end
		end
		return t
	end

	function KeybindHelper:Get(info)
		self:MakeKeyBindingTable( GetBindingKey(("CLICK IPopBarButton%d:LeftButton"):format(info.arg)) )
		return table.concat(t, ", ")
	end

	function KeybindHelper:Set(info, key)
		if key == "" then
			-- Clear all keys binded
			self:MakeKeyBindingTable( GetBindingKey(("CLICK IPopBarButton%d:LeftButton"):format(info.arg)) )
			for i = 1, #t do
				SetBinding(t[i])
			end
		else
			-- Set the key bind
			local oldAction = GetBindingAction(key)
			local frame = LibStub("AceConfigDialog-3.0").OpenFrames["IPopBar"]
			if frame then
				if ( oldAction ~= "" and oldAction ~= ("CLICK IPopBarButton%d:LeftButton"):format(info.arg) ) then
					frame:SetStatusText(KEY_UNBOUND_ERROR:format(GetBindingText(oldAction, "BINDING_NAME_")))
				else
					frame:SetStatusText(KEY_BOUND)
				end
			end
			SetBindingClick(key, "IPopBarButton"..info.arg)
		end
		-- Save the keybinds
		SaveBindings(GetCurrentBindingSet())
	end
end

-- Options table for Ace3, used if detected/available
local options = {
	name = L["Integrated PopBar"],
	desc = L["Integrated PopBar"],
	type = "group",
	get = function(info) return db[info.arg] end,
	args = {
		settings = {
			name = L["Settings"],
			desc = L["Settings"],
			type = "group",
			order = 1,
			args = {
				numrows = {
					name = L["Number of rows"],
					desc = L["Number of rows of buttons to use"],
					type = "range",
					min = 1, max = 3, step = 1,
					set = function(info, v) IPopBar_Help("rows "..v, true) end,
					arg = "NumRows",
					order = 1,
				},
				scale = {
					name = L["Main bar scaling"],
					desc = L["The scale of the main menu bar and side bars."],
					type = "range",
					min = 0.5, max = 2, step = 0.01,
					set = function(info, v) IPopBar_Help("scale "..v, true) end,
					arg = "Scale",
					order = 2,
				},
				--[[timein = {
					name = L["Hover in time"],
					desc = L["The amount of time before the popbar rows appear. Only affects combat."],
					type = "range",
					min = 0, max = 5, step = 0.1,
					set = function(info, v) IPopBar_Help("appear "..v, true) end,
					arg = "TimeIn",
					order = 3,
				},
				timeout = {
					name = L["Hover out time"],
					desc = L["The amount of time before the popbar rows disappear. Only affects combat."],
					type = "range",
					min = 0, max = 5, step = 0.1,
					set = function(info, v) IPopBar_Help("disappear "..v, true) end,
					arg = "TimeOut",
					order = 4,
				},]]
				endcaps = {
					name = L["Show dragon end caps"],
					desc = L["Show/hide the gryphon end caps on the main menu bar"],
					type = "toggle",
					set = function(info, v) IPopBar_Help("endcaps", true) end,
					arg = "ShowEndCaps",
					width = "double",
					order = 5,
				},
				--[[pagenum = {
					name = L["Show action bar page number"],
					desc = L["Show/hide the action page number on the latency meter"],
					type = "toggle",
					set = function(info, v) IPopBar_Help("pagenum", true) end,
					arg = "ShowPageNum",
					width = "double",
					order = 6,
				},]]
				togglecombat = {
					name = L["Auto-switch to bar mode on combat"],
					desc = L["Automatically switch IPopBar to bar mode on entering combat"],
					type = "toggle",
					set = function(info, v) IPopBar_Help("togglecombat", true) end,
					arg = "AutoToggleCombat",
					width = "double",
					order = 7,
				},
			},
		},
		advanced = {
			name = L["Advanced"],
			desc = L["Advanced"],
			type = "group",
			order = 2,
			get = function(info) return allB[(info.arg - 1) * 11 + 1]:GetAttribute("action", id) end,
			set = function(info, v) IPopBar_Help(("row%dstartID %d"):format(info.arg, v), true) end,
			args = {
				desc = {
					name = L["ADVANCED_DESC"],
					type = "description",
					order = 0,
				},
				row1 = {
					name = L["Row %d starting action ID"]:format(1),
					desc = L["The number of the actionID IPopBar Button %d/1 should use"]:format(1),
					type = "range",
					min = 1, max = 110, step = 1,
					arg = 1,
					order = 1,
					width = "double",
				},
				row2 = {
					name = L["Row %d starting action ID"]:format(2),
					desc = L["The number of the actionID IPopBar Button %d/1 should use"]:format(2),
					type = "range",
					min = 1, max = 110, step = 1,
					arg = 2,
					order = 2,
					width = "double",
				},
				row3 = {
					name = L["Row %d starting action ID"]:format(3),
					desc = L["The number of the actionID IPopBar Button %d/1 should use"]:format(3),
					type = "range",
					min = 1, max = 110, step = 1,
					arg = 3,
					order = 3,
					width = "double",
				},
				reset = {
					name = L["Reset to defaults"],
					desc = L["Reset the actionIDs to default values"],
					type = "execute",
					func = function(info) IPopBar_Help("resetstartID") end,
					order = 4,
				},
				info = {
					name = L["Technical Information"],
					desc = L["Technical Information"],
					type = "group",
					order = 5,
					args = {
						desc = {
							name = L["TECH_INFO"],
							type = "description",
							order = 0,
						},
					},
				},
			},
		},
		keybinds = {
			name = L["Keybinds"],
			desc = L["Keybinds"],
			type = "group",
			handler = KeybindHelper,
			get = "Get",
			set = "Set",
			order = 3,
			args = {
				toggle = {
					name = L["Toggle Menu Bar/IPopBar"],
					desc = L["Toggle Menu Bar/IPopBar"],
					type = "keybinding",
					get = function(info)
						return table.concat(KeybindHelper:MakeKeyBindingTable(GetBindingKey("IPopBarToggleButton")), ", ")
					end,
					set = function(info, key)
						if key == "" then
							local t = KeybindHelper:MakeKeyBindingTable(GetBindingKey("IPopBarToggleButton"))
							for i = 1, #t do
								SetBinding(t[i])
							end
						else
							SetBinding(key, "IPopBarToggleButton")
						end
						SaveBindings(GetCurrentBindingSet())
					end,
					order = 0,
				}
			},
		},
	},
}
for i = 0, 32 do
	local row, col = floor(i/11)+1, i%11+1
	options.args.keybinds.args["keybind"..i+1] = {
		name = L["IPopBar Button %d/%d"]:format(row, col),
		desc = L["IPopBar Button %d/%d"]:format(row, col),
		type = "keybinding",
		arg = i+1,
		order = row*100+col,
	}
end
for i = 1, 3 do
	options.args.keybinds.args["header"..i] = {
		name = L["Row %d"]:format(i),
		desc = L["Row %d"]:format(i),
		type = "header",
		order = i*100,
	}
end

-- Add Slash Command
local isRegisteredWithAce3 = false
SLASH_IPOPBARHELP1 = "/ipopbar"
SlashCmdList["IPOPBARHELP"] = function(msg)
	local Ace3Registry = LibStub and LibStub("AceConfigRegistry-3.0", 1)
	local Ace3Dialog = LibStub and LibStub("AceConfigDialog-3.0", 1)
	if Ace3Registry and Ace3Dialog then
		if not isRegisteredWithAce3 then
			Ace3Registry:RegisterOptionsTable("IPopBar", options)
			isRegisteredWithAce3 = true
		end
		Ace3Dialog:Open("IPopBar")
	else
		IPopBar_Help(msg)
	end
end
