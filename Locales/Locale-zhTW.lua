-- IPopBar
-- zhTW Localization file
-- Note: The english localization file must be loaded before this file.

local IPopBar = select(2, ...)
if ( GetLocale() ~= "zhTW" ) then return end
local L = {}

-- Name (short and long) and version of the addon
L["IPopBar"] = true
L["Integrated PopBar"] = true





-- Convert the "true" entries to the same as the key
for k, v in pairs(L) do
	if v == true then
		L[k] = k
	end
end

-- Set the english table as the base lookup table
IPopBar.Localization = setmetatable(L, {__index = IPopBar.Localization})

-- vim: ts=4 noexpandtab
