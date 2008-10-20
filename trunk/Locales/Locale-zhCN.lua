-- IPopBar
-- zhCN Localization file
-- Note: The english localization file must be loaded before this file.
--这是一个测试版本的本地化文件..还有诸多未能完善的地方
if ( GetLocale() ~= "zhCN" ) then return end
local L = {}

-- Name (short and long) and version of the addon
L["IPopBar"] = "IPopBar"
L["Integrated PopBar"] = "Integrated PopBar"
L["IPOPBAR_VERSION"] = "3.00"

-- Keybindings Menu
L["IPopBar Buttons"] = "IPopBar 按钮"
L["Toggle Menu Bar/IPopBar"] = "主目录与动作条之间切换"
L["IPopBar Button %d/%d"] = "第 %d 动作条按钮 %d"

-- Other strings
L["Click to toggle IPopBar."] = "点击切换"

-- Used in the slash commands
L["IPopBar cannot change this setting while in combat."] = "IPopBar不能在战斗中更改设置."
L["IPopBar is now set to only use %d row(s) of buttons."] = "IPopBar 当前使用动作条数量为 %d "
L["IPopBar is now showing the action bar page number on the latency meter."] = "IPopBar 将在延迟条处显示动作条页码."
L["IPopBar is now hiding the action bar page number on the latency meter."] = "IPopBar 不在延迟条处显示动作条页码."
L["IPopBar will now automatically switch to bar mode on entering combat."] = "IPopBar 将在进入战斗时自动切换."
L["IPopBar will no longer automatically switch to bar mode on entering combat."] = "IPopBar 进入战斗时不会自动切换."
L["Use X rows of buttons. X can be 1, 2 or 3."] = "Use X rows of buttons. X can be 1, 2 or 3."
L["Show/hide the action page number on the latency meter"] = "Show/hide the action page number on the latency meter"
L["Automatically switch to bar mode on entering combat."] = "Automatically switch to bar mode on entering combat."
L["Display this help. (IPopBar v%s)"] = "显示帮助信息. (IPopBar v%s)"
L["Scale the main menu bar. X can be between 0.5 and 2.0."] = "主动作条缩放. X的取值范围是 0.5~2.0."
L["Invalid scale specified. It must be between 0.5 and 2.0."] = "Invalid scale specified. It must be between 0.5 and 2.0."
L["Show/hide the gryphon end caps on the main menu bar"] = "Show/hide the gryphon end caps on the main menu bar"
L["Invalid ID specified. It must be between 1 and 110."] = "Invalid ID specified. It must be between 1 and 110."
L["Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110."] = "Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110."
L["Resets the starting action IDs of all the rows to the defaults."] = "Resets the starting action IDs of all the rows to the defaults."
L["Change the time it takes before the popbar rows appear. Only affects combat. X can be between 0 and 5. (0.2 default)"] = "Change the time it takes before the popbar rows appear. Only affects combat. X can be between 0 and 5. (0.2 default)"
L["Change the time it takes before the popbar rows disappear. Only affects combat. X can be between 0 and 5. (0.2 default)"] = "Change the time it takes before the popbar rows disappear. Only affects combat. X can be between 0 and 5. (0.2 default)"
L["Invalid time specified. It must be between 0 and 5.0."] = true

-- Used in Ace Config Dialog
L["Settings"] = "基本设置"
L["Number of rows"] = "动作条数量"
L["Number of rows of buttons to use"] = "设置动作条数量"
L["Main bar scaling"] = "主动作条缩放"
L["The scale of the main menu bar and side bars."] = "缩放主动作条及主菜单大小"
L["Show dragon end caps"] = "显示动作条两侧狮鹫"
L["Show action bar page number"] = "显示动作条页码"
L["Show/hide the action page number on the latency meter"] = "在延时条显示动作条页码"
L["Auto-switch to bar mode on combat"] = "战斗中自动切换"
L["Automatically switch IPopBar to bar mode on entering combat"] = "在战斗中自动切换至泡泡动作条"
L["Advanced"] = "高级设置"
L["ADVANCED_DESC"] = "这个选项是高级用户用于设置泡泡动作条按钮的起始编号的。\n\n魔兽世界服务器提供了120个动作条按钮用于让你在动作条上链接物品或技能, 系统动作条使用了1-72号按钮, 还有一些额外的按钮(如73-84号按钮)也以各种形式或位置被某些功能占有.\n"
L["Row %d starting action ID"] = "第%d动作条按钮的起始编号"
L["The number of the actionID IPopBar Button %d/1 should use"] = "第 %d 动作条按钮 1 使用的编号"
L["Reset to defaults"] = "恢复默认设置"
L["Reset the actionIDs to default values"] = "将动作条按钮编号恢复到默认值"
L["Keybinds"] = "按键绑定"
L["Row %d"] = "第%d动作条"
L["Technical Information"] = "技术信息"
L["Hover in time"] = "鼠标悬停时间"
L["The amount of time before the popbar rows appear. Only affects combat."] = "使动作条出现所需要的鼠标悬停时间"
L["Hover out time"] = "动作条悬停时间"
L["The amount of time before the popbar rows disappear. Only affects combat."] = "动作条退出的悬停时间"
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

-- Set the english table as the base lookup table
IPopBar_Localization = setmetatable(L, {__index = IPopBar_Localization})

-- vim: ts=4 noexpandtab
