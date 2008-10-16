--[[
	Integrated PopBar v2.03 (17th May 2008 for v2.4.2.8278)
	By Xinhuan

	Inspired by PopBar, this mod integrates the fundamental
	aspect of PopBar into the menu bar itself, toggle-able
	between the Bag Buttons and 2 extra rows of buttons.
]]

IPopBar = {}
local IPopBar = IPopBar
local L = IPopBar_Localization

-- Setup the text displayed in the keybindings
BINDING_HEADER_IPopBar			= L["IPopBar Buttons"]
BINDING_NAME_TOGGLEIPOPBAR		= L["Toggle Menu Bar/IPopBar"]
for i = 0, 32 do
	local row, col = floor(i/11)+1, i%11+1
	_G[("BINDING_NAME_CLICK IPopBarButton%d:LeftButton"):format(i+1)] = L["IPopBar Button %d/%d"]:format(row, col)
end

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
local IPopbar_Hovering      = 1
local IPopBar_LastUpdate    = 0
local IPopBar_ModeBeforeCombat = false
local IPOPBAR_UPDATETIME    = 0.1


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
local IPopBarFrame = CreateFrame("Frame", nil, MainMenuBar)
IPopBarFrame:SetMovable(nil)
IPopBarFrame:SetAllPoints(MainMenuBar)
IPopBarFrame.t2a = IPopBarFrame:CreateTexture(nil, "OVERLAY")
IPopBarFrame.t2a:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrame.t2a:SetWidth(18)
IPopBarFrame.t2a:SetHeight(43)
IPopBarFrame.t2a:SetPoint("BOTTOM", 9, 0)
IPopBarFrame.t2a:SetTexCoord(0, 0.0703125, 0.33203125, 0.5)
IPopBarFrame.t2b = IPopBarFrame:CreateTexture(nil, "OVERLAY")
IPopBarFrame.t2b:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrame.t2b:SetWidth(31)
IPopBarFrame.t2b:SetHeight(43)
IPopBarFrame.t2b:SetPoint("BOTTOM", 31, 0)
IPopBarFrame.t2b:SetTexCoord(0, 0.12109375, 0.08203125, 0.25)

-- The frame to show when in Bar mode, just more textures
local IPopBarFrameBar = CreateFrame("Frame", nil, MainMenuBar)
IPopBarFrameBar:SetMovable(nil)
IPopBarFrameBar:SetPoint("TOPLEFT", 556, 0)
IPopBarFrameBar:SetPoint("BOTTOMRIGHT")
--[[IPopBarFrameBar.bg1 = IPopBarFrameBar:CreateTexture(nil, "ARTWORK")
IPopBarFrameBar.bg1:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrameBar.bg1:SetWidth(252)
IPopBarFrameBar.bg1:SetHeight(43)
IPopBarFrameBar.bg1:SetPoint("BOTTOMLEFT")
IPopBarFrameBar.bg1:SetTexCoord(0.015625, 1.0, 0.83203125, 1.0)
IPopBarFrameBar.bg2 = IPopBarFrameBar:CreateTexture(nil, "ARTWORK")
IPopBarFrameBar.bg2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrameBar.bg2:SetWidth(214)
IPopBarFrameBar.bg2:SetHeight(43)
IPopBarFrameBar.bg2:SetPoint("BOTTOMLEFT", 252, 0)
IPopBarFrameBar.bg2:SetTexCoord(0.1640625, 1.0, 0.58203125, 0.75)]]

-- The frame to show when in Bag mode, just more textures
local IPopBarFrameBag = CreateFrame("Frame", nil, MainMenuBar)
IPopBarFrameBag:SetMovable(nil)
IPopBarFrameBag:SetAllPoints(MainMenuBar)
--[[IPopBarFrameBag.t3a = IPopBarFrameBag:CreateTexture(nil, "ARTWORK")
IPopBarFrameBag.t3a:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrameBag.t3a:SetWidth(237)
IPopBarFrameBag.t3a:SetHeight(43)
IPopBarFrameBag.t3a:SetPoint("BOTTOM", 163, 0)
IPopBarFrameBag.t3a:SetTexCoord(0.11328125, 1.0, 0.33203125, 0.5)
IPopBarFrameBag.t3b = IPopBarFrameBag:CreateTexture(nil, "ARTWORK")
IPopBarFrameBag.t3b:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
IPopBarFrameBag.t3b:SetWidth(231)
IPopBarFrameBag.t3b:SetHeight(43)
IPopBarFrameBag.t3b:SetPoint("BOTTOM", 396, 0)
IPopBarFrameBag.t3b:SetTexCoord(0.09765625, 1.0, 0.08203125, 0.25)]]

-- Function to create one of our buttons
local function CreateIPopBarButton(num)
	local b = CreateFrame("CheckButton", "IPopBarButton"..num, nil, "ActionBarButtonTemplate")
	b:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
	b:SetAttribute("actionpage", 1)
	b:SetScript("OnEnter", buttonHandler.OnEnter)
	return b
end

-- Create our 33 buttons and store frame references to them in tables
for i = 1, 33 do
	local b = CreateIPopBarButton(i)
	if i <= 11 then
		tinsert(row1, b)
	elseif i <= 22 then
		tinsert(row2, b)
	else
		tinsert(row3, b)
	end
	tinsert(allB, b)
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

-- Create our secure anchor that controls all our buttons
local anchor = CreateFrame("Button", nil, MainMenuBar, "SecureHandlerEnterLeaveTemplate")
anchor:SetAllPoints(IPopBarFrameBar)
for i = 1, 33 do
     allB[i]:SetParent(anchor)
end
anchor:Execute( [[Buttons = table.new(self:GetChildren())]] )
anchor:Execute( [[HideAll = "if not self:IsUnderMouse(true) then for i = 12, 33 do Buttons[i]:Hide() end end"]] )
anchor:SetAttribute("_onenter", [[ for i = 12, 33 do Buttons[i]:Show() end ]])
anchor:SetAttribute("_onleave", [[ control:SetTimer(0.2, nil, HideAll) ]] )
for i = 1, 33 do
	SecureHandlerWrapScript(allB[i], "OnEnter", anchor, [[
		for i = 12, 33 do
			Buttons[i]:Show()
		end
	]])
end
for i = 1, 33 do
	SecureHandlerWrapScript(allB[i], "OnLeave", anchor, [[ control:SetTimer(0.2, nil, HideAll) ]] )
end


---------------------------------------------------------------------------
-- Setting up the MainMenuBar to IPopBar style by modifying it

-- Move some of the default elements
MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton:GetParent(), "BOTTOMRIGHT", -6, 4)
CharacterMicroButton:SetPoint("BOTTOMLEFT", CharacterMicroButton:GetParent(), "BOTTOMLEFT", 568, 2)
--MainMenuBarPerformanceBarFrame:SetPoint("BOTTOMRIGHT", MainMenuBarPerformanceBarFrame:GetParent(), "BOTTOMRIGHT", -468, -10)
--MainMenuBarPageNumber:SetPoint("CENTER", MainMenuBarPerformanceBarFrameButton, "CENTER", -3, 0)

-- Hide some of the default elements
MainMenuBarTexture2:Hide()
MainMenuBarTexture3:Hide()

-- Raise our frame's framelevel so that it covers the XP bar
IPopBarFrame:SetFrameLevel(IPopBarFrame:GetFrameLevel() + 1)
IPopBarFrameBar:SetFrameLevel(IPopBarFrameBar:GetFrameLevel() + 1)
IPopBarFrameBag:SetFrameLevel(IPopBarFrameBag:GetFrameLevel() + 1)

-- Set the cooldown frame's framelevel to be the same as our buttons
for i = 1, 33 do
	_G[allB[i]:GetName().."Cooldown"]:SetFrameLevel(allB[i]:GetFrameLevel())
end

--[[ Add stuff to the latency display button
MainMenuBarPerformanceBarFrameButton:SetScript("OnClick", function()
	IPopBar:ShowBars(1 - db.Enabled)
end)
hooksecurefunc("MainMenuBarPerformanceBarFrame_OnEnter", function()
	local tooltiptext = MicroButtonTooltipText("", "TOGGLEIPOPBAR")
	local line1 = GameTooltipTextLeft1:GetText()
	if (not line1) then return end
	GameTooltipTextLeft1:SetText(line1.." "..tooltiptext)
	GameTooltip:AddLine("\n")
	GameTooltip:AddLine(L["Click to toggle IPopBar."], 1.0, 0.8, 0, 1)
	GameTooltip:Show()
end)]]

-- Hook Functions
hooksecurefunc("TalentMicroButton_OnEvent", function()
	if (db.Enabled == 1) then
		TalentMicroButton:Hide()
	else
		UpdateTalentButton()
	end
end)

local Original_MainMenuBar_UpdateKeyRing
local function IPopBar_MainMenuBar_UpdateKeyRing()
	--Don't call the original one at all. (Could be dangerous if other addons hook here.)
	--Original_MainMenuBar_UpdateKeyRing()

	if HasKey() and db.Enabled == 0 then
		IPopBarFrameBag.t3b:SetWidth(241)
		IPopBarFrameBag.t3b:SetPoint("BOTTOM", IPopBarFrameBag.t3b:GetParent(), "BOTTOM", 393.5, 0)
		IPopBarFrameBag.t3b:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-KeyRing")
		IPopBarFrameBag.t3b:SetTexCoord(0.05859375, 1, 0.1640625, 0.5)

		IPopBarFrameBag.t3a:SetWidth(227)
		IPopBarFrameBag.t3a:SetPoint("BOTTOM", IPopBarFrameBag.t3a:GetParent(), "BOTTOM", 160, 0)
		KeyRingButton:Show()
	end
end
-- Yes, this this an unsecure hook, because I am replacing the function totally.
Original_MainMenuBar_UpdateKeyRing = MainMenuBar_UpdateKeyRing
MainMenuBar_UpdateKeyRing = IPopBar_MainMenuBar_UpdateKeyRing


---------------------------------------------------------------------------
-- Function to show or hide the popup rows when out of combat (more responsive)

local function IPopBar_OnUpdate(self, elapsed)
	IPopBar_LastUpdate = IPopBar_LastUpdate + elapsed
	if not InCombatLockdown() and db.Enabled == 1 and db.NumRows > 1 then
		if IPopBar_LastUpdate >= IPOPBAR_UPDATETIME then
			IPopBar_LastUpdate = 0

			local scale = self:GetEffectiveScale()
			local xPos, yPos = GetCursorPosition()
			xPos = xPos / scale
			yPos = yPos / scale
			local top = self:GetTop()
			local bottom = self:GetBottom()

			if IPopbar_Hovering == 1 then
				top = bottom + (db.NumRows * 42)
			end
			
			if yPos <= top and yPos >= bottom and xPos >= self:GetLeft() and xPos <= self:GetRight() then
				IPopbar_Hovering = 1
				IPopBar:ShowRow2()
			else
				IPopbar_Hovering = 0
				IPopBar:HideRow2()
			end
		end
	end
end

-- Set scripts and some events for out of combat hovering
IPopBarFrameBar:SetScript("OnShow", function(self)
	if db.Enabled == 1 and db.NumRows > 1 then
		self:SetScript("OnUpdate", IPopBar_OnUpdate)
	end
end)
IPopBarFrameBar:SetScript("OnHide", function(self)
	self:SetScript("OnUpdate", nil)
end)

function IPopBar:ShowRow2()
	if not InCombatLockdown() then
		--hdr:SetAttribute("state", 1)
	end
end

function IPopBar:HideRow2()
	if IPopbar_Hovering == 0 and not InCombatLockdown() then
		--hdr:SetAttribute("state", 0)
	end
end


---------------------------------------------------------------------------
-- Function to toggle IPopBar to Bar mode when entering combat

IPopBarFrameBar:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		-- Enter IPopBar mode when entering combat
		if db.Enabled == 0 and db.AutoToggleCombat then
			IPopBar:ShowBars(1)
			IPopBar_ModeBeforeCombat = true
		end
		self:SetScript("OnUpdate", nil)

	elseif event == "PLAYER_REGEN_ENABLED" then
		if self:IsVisible() and db.Enabled == 1 and db.NumRows > 1 then
			self:SetScript("OnUpdate", IPopBar_OnUpdate)
		end
		if IPopBar_ModeBeforeCombat then
			IPopBar:ShowBars(0)
			IPopBar_ModeBeforeCombat = false
		end
	end
end)
IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_DISABLED")
IPopBarFrameBar:RegisterEvent("PLAYER_REGEN_ENABLED")


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

local function IPopBar_Initialize(self, event, arg1)
	if arg1 == "IPopBar" then
		IPopBar_Config = IPopBar_Config or {}
		db = IPopBar_Config
		setmetatable(IPopBar_Config, {__index = defaults})

		-- Configure our buttons based on number of rows
		IPopBar:ConfigureButtonHideStates()

		-- Apply loaded settings
		IPopBar:ShowBars(db.Enabled)
		if db.NumRows == 1 then IPopBar:HideRow2() end
		if not db.ShowPageNum then MainMenuBarPageNumber:Hide() end
		if IPopBarFrameBar:IsVisible() and db.Enabled == 1 and db.NumRows > 1 then
			IPopBarFrameBar:SetScript("OnUpdate", IPopBar_OnUpdate)
		end
		MainMenuBar:SetScale(db.Scale)
		MultiBarBottomLeft:SetScale(db.Scale)
		MultiBarBottomRight:SetScale(db.Scale)
		MultiBarRight:SetScale(db.Scale)
		MultiBarLeft:SetScale(db.Scale)
		if not db.ShowEndCaps then
			MainMenuBarLeftEndCap:Hide()
			MainMenuBarRightEndCap:Hide()
		end
		IPopBar_AdjustActionIDs()

		-- Make it so that our buttons go above these buttons, since the default is "HIGH", and MainMenuBar is at "MEDIUM"
		MultiBarBottomLeft:SetFrameStrata("LOW")
		MultiBarBottomRight:SetFrameStrata("LOW")
		MultiBarRight:SetFrameStrata("LOW")
		MultiBarLeft:SetFrameStrata("LOW")

		-- Set the time in/out on the popbars
		--hdr:SetAttribute("delaytimemap-anchor-enter",  "0:"..db.TimeOut)
		--hdr:SetAttribute("delaytimemap-anchor-leave",  "1:"..db.TimeIn)

		IPopBarFrame:UnregisterEvent("ADDON_LOADED")
		IPopBarFrame:SetScript("OnEvent", nil)
	end
end
IPopBarFrame:RegisterEvent("ADDON_LOADED")
IPopBarFrame:SetScript("OnEvent", IPopBar_Initialize)


---------------------------------------------------------------------------
-- Other functions

function IPopBar:ShowBars(toggle)
	if InCombatLockdown() then return end

	if (toggle == 1) then 
		db.Enabled = 1
		CharacterMicroButton:Hide()
		SpellbookMicroButton:Hide()
		QuestLogMicroButton:Hide()
		SocialsMicroButton:Hide()
		LFGMicroButton:Hide()
		MainMenuMicroButton:Hide()
		HelpMicroButton:Hide()
		MainMenuBarBackpackButton:Hide()
		CharacterBag0Slot:Hide()
		CharacterBag1Slot:Hide()
		CharacterBag2Slot:Hide()
		CharacterBag3Slot:Hide()
		IPopBarFrameBag:Hide()
		IPopBarFrameBar:Show()
		anchor:Show()
		TalentMicroButton:Hide()
		KeyRingButton:Hide()
		AchievementMicroButton:Hide()
		PVPMicroButton:Hide()
	else
		db.Enabled = 0
		IPopBarFrameBar:Hide()
		anchor:Hide()
		IPopBarFrameBag:Show()
		CharacterMicroButton:Show()
		SpellbookMicroButton:Show()
		QuestLogMicroButton:Show()
		SocialsMicroButton:Show()
		LFGMicroButton:Show()
		MainMenuMicroButton:Show()
		HelpMicroButton:Show()
		MainMenuBarBackpackButton:Show()
		CharacterBag0Slot:Show()
		CharacterBag1Slot:Show()
		CharacterBag2Slot:Show()
		CharacterBag3Slot:Show()
		UpdateTalentButton()
		MainMenuBar_UpdateKeyRing()
		AchievementMicroButton:Show()
		PVPMicroButton:Show()
	end
end

-- Configure button popup row hidestates
function IPopBar:ConfigureButtonHideStates()
	if InCombatLockdown() then return end
	if (db.NumRows == 1) then
		for i = 1, 11 do
			row2[i]:SetAttribute("hidestates", "*")
			row3[i]:SetAttribute("hidestates", "*")
		end
	elseif (db.NumRows == 2) then
		for i = 1, 11 do
			row2[i]:SetAttribute("hidestates", "0")
			row3[i]:SetAttribute("hidestates", "*")
		end
	elseif (db.NumRows == 3) then
		for i = 1, 11 do
			row2[i]:SetAttribute("hidestates", "0")
			row3[i]:SetAttribute("hidestates", "0")
		end
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
		IPopBar:HideRow2()
		if IPopBarFrameBar:IsVisible() and db.Enabled == 1 and db.NumRows > 1 then
			IPopBarFrameBar:SetScript("OnUpdate", IPopBar_OnUpdate)
		else
			IPopBarFrameBar:SetScript("OnUpdate", nil)
		end
		if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now set to only use %d row(s) of buttons."]:format(db.NumRows)) end

	elseif msg == "pagenum" then
		db.ShowPageNum = not db.ShowPageNum
		if db.ShowPageNum then
			MainMenuBarPageNumber:Show()
			if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now showing the action bar page number on the latency meter."]) end
		else
			MainMenuBarPageNumber:Hide()
			if not quietmode then DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar is now hiding the action bar page number on the latency meter."]) end
		end

	elseif msg == "togglecombat" then
		db.AutoToggleCombat = not db.AutoToggleCombat
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
			MultiBarBottomLeft:SetScale(scale)
			MultiBarBottomRight:SetScale(scale)
			MultiBarRight:SetScale(scale)
			MultiBarLeft:SetScale(scale)
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

	elseif string.match(msg, "^appear ([0-9.]+)$") then
		if InCombatLockdown() then
			DEFAULT_CHAT_FRAME:AddMessage(L["IPopBar cannot change this setting while in combat."])
			return
		end
		local t = tonumber(string.match(msg, "^appear ([0-9.]+)$"))
		if t and t >= 0 and t <= 5 then
			db.TimeIn = t
			--hdr:SetAttribute("delaytimemap-anchor-enter",  "0:"..tostring(t))
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
			--hdr:SetAttribute("delaytimemap-anchor-leave",  "1:"..tostring(t))
		else
			DEFAULT_CHAT_FRAME:AddMessage(L["Invalid time specified. It must be between 0 and 5.0."])
		end

	else
		if not quietmode then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.."|r - "..L["Display this help. (IPopBar v%s)"]:format(L["IPOPBAR_VERSION"]))
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." rows X|r - "..L["Use X rows of buttons. X can be 1, 2 or 3."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." pagenum|r - "..L["Show/hide the action page number on the latency meter"])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." togglecombat|r - "..L["Automatically switch to bar mode on entering combat."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." scale X|r - "..L["Scale the main menu bar. X can be between 0.5 and 2.0."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." endcaps|r - "..L["Show/hide the gryphon end caps on the main menu bar"])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." rowXstartID Y|r - "..L["Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." resetstartID|r - "..L["Resets the starting action IDs of all the rows to the defaults."])
			DEFAULT_CHAT_FRAME:AddMessage("|cff00f100"..SLASH_IPOPBARHELP1.." appear X|r - "..L["Change the time it takes before the popbar rows appear. Only affects combat. X can be between 0 and 5 (0.2 default)."])
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
				timein = {
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
				},
				endcaps = {
					name = L["Show dragon end caps"],
					desc = L["Show/hide the gryphon end caps on the main menu bar"],
					type = "toggle",
					set = function(info, v) IPopBar_Help("endcaps", true) end,
					arg = "ShowEndCaps",
					width = "double",
					order = 5,
				},
				pagenum = {
					name = L["Show action bar page number"],
					desc = L["Show/hide the action page number on the latency meter"],
					type = "toggle",
					set = function(info, v) IPopBar_Help("pagenum", true) end,
					arg = "ShowPageNum",
					width = "double",
					order = 6,
				},
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
						return table.concat(KeybindHelper:MakeKeyBindingTable(GetBindingKey("TOGGLEIPOPBAR")), ", ")
					end,
					set = function(info, key)
						if key == "" then
							local t = KeybindHelper:MakeKeyBindingTable(GetBindingKey("TOGGLEIPOPBAR"))
							for i = 1, #t do
								SetBinding(t[i])
							end
						else
							SetBinding(key, "TOGGLEIPOPBAR")
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
SLASH_IPOPBARHELP1 = "/ipopbar"
SlashCmdList["IPOPBARHELP"] = function(msg)
	local Ace3Registry = LibStub and LibStub("AceConfigRegistry-3.0", 1)
	local Ace3Dialog = LibStub and LibStub("AceConfigDialog-3.0", 1)
	if Ace3Registry and Ace3Dialog then
		Ace3Registry:RegisterOptionsTable("IPopBar", options)
		Ace3Dialog:Open("IPopBar")
	else
		IPopBar_Help(msg)
	end
end

-- Register options table with Ace3 if available, this is optional
-- as we don't depend on Ace3
local Ace3Registry = LibStub and LibStub("AceConfigRegistry-3.0", 1)
if Ace3Registry then
	Ace3Registry:RegisterOptionsTable("IPopBar", options)
end

