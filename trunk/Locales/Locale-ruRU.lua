-- IPopBar
-- ruRU Localization file
-- Note: The english localization file must be loaded before this file.

if ( GetLocale() ~= "ruRU" ) then return end
local L = {}

-- Name (short and long) and version of the addon
L["IPopBar"] = true
L["Integrated PopBar"] = true
L["IPOPBAR_VERSION"] = "2.03"





-- Convert the "true" entries to the same as the key
for k, v in pairs(L) do
	if v == true then
		L[k] = k
	end
end

-- Set the english table as the base lookup table
IPopBar_Localization = setmetatable(L, {__index = IPopBar_Localization})

-- vim: ts=4 noexpandtab
