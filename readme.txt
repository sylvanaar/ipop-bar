Integrated PopBar v3.08 (24 December 2009)
For Live Servers v3.3.0.11159
By Xinhuan

Inspired by PopBar, this mod integrates the fundamental aspect of PopBar into the menu bar itself, toggleable between the Bag Buttons and 3 extra rows of buttons.


===========================
Description:

Inspired by PopBar, this mod integrates the fundamental aspect of PopBar into the menu bar itself, toggleable between the Bag Buttons and 3 extra rows of buttons.

This AddOn is not designed to be draggable or movable and is not as customizable as some of the other additional toolbar addons. This AddOn is completely standalone and is not dependent on any other AddOn.

The design of this addon is based on the fact that many players use the hotkeys to open all their bags: Shift-B. You can rebind B to also open all your bags, or use F8-F12 for each individual bag. Hence, there is no real reason for the bag buttons to be displayed at all most of the time.

Similarly, all the interface has shortcuts, L for quest log, O for guild list, C for character, U for reputation, K for skills, P for spells, N for talents, etc. You don't actually need those bag or microbuttons, which is what this mod has in mind when being designed. Your playing mode should mostly be in the "Ipopbar" mode rather than the "bag mode".


===========================
Commands:

/ipopbar : Shows help on available commands.
/ipopbar rows X : Use X rows of buttons. X can be 1, 2 or 3.
/ipopbar togglecombat : Automatically switch to bar mode on entering combat.
/ipopbar scale X : Scale the main menu bar. X can be between 0.5 and 2.0.
/ipopbar endcaps : Show/hide the dragon end caps on the main menu bar.
/ipopbar rowXstartID Y : Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110.
/ipopbar resetstartID : Resets the starting action IDs of all the rows to the defaults.
/ipopbar disappear X : Change the time it takes before the popbar rows disappear. Only affects combat.

If you have Ace3 core libraries installed, then typing /ipopbar will instead open the Ace3 configuration screen for IPopBar.


===========================
Quirks:

If you loot an item, the normal animation of the item that goes into the bag doesn't display, until you toggle to the bags.


===========================
Download:
Download this UI from
- http://ui.worldofwar.net/ui.php?id=370
- http://www.wowace.com/projects/ipop-bar/
- http://wow.curse.com/downloads/wow-addons/details/ipop-bar.aspx


===========================
Installation:
Just copy all the the files into Interface\AddOns\IPopBar\
so if your WoW is installed in C:\Games\World of Warcraft\
then all the files should be in
C:\Games\World of Warcraft\Interface\AddOns\IPopBar\*.*


===========================
Credits:
- Idea based on PopBar by Mugendai.


===========================
Patch Notes

v3.08 (from v3.07) (24 December 2009)
- Written for Live Servers v3.3.0.11159.
- Add workaround for Blizzard_AchievementUI\Blizzard_AchievementUI.lua:671 errors.
- Add fix for SaveBindings() error that occurs for new characters.

v3.07 (from v3.06) (9 December 2009)
- Written for Live Servers v3.3.0.10958.
- Fix the errors resulting from WoW Patch 3.3.0. Blizzard did away with the conditional talent/achievement buttons, making things simpler.

v3.06 (from v3.05) (16 April 2009)
- Written for Live Servers v3.1.0.9767.
- Fix the achievement micro menu button from appearing every time you enter/leave combat.

v3.05 (from v3.04) (21st January 2009)
- Written for Live Servers v3.0.8.9464.
- A bunch of secureheader stuff to workaround the loss of SecureHandlerShowHideTemplate and control:SetTimer().
- You can no longer control hover out time. Popup bars will now disappear immediately on mouse out.
- Delayed-close menus and action bars are now off-limits until the next patch, if even that.
- See http://forums.worldofwarcraft.com/thread.html?topicId=8202271194&postId=144650995300&sid=1#374 post 374-380 for details.

v3.04 (from v3.03) (16th January 2009)
- Fix overlapping micro menu buttons if you zone while being in a vehicle.

v3.03 (from v3.02) (21st November 2008)
- Written for Live Servers v3.0.3.9183.
- Fixes some issues with IPopBar when using vehicles.
- Fixes show/hide states of row2 and row3 buttons when logging in, moving actions or otherwise.

v3.02 (from v3.01) (22th October 2008)
- Fix possible issue with /ipopbar command generating an "Open" error.
- Fix nil error on line 466 which only happens if you use 0 popup bars.

v3.01 (from v2.03) (20th October 2008)
- Written for Live Servers v3.0.2.9056 or WotLK Beta Servers v3.0.3.9095.
- Massive rewrite due to the changed secure headers in 3.0.
- The latency meter is now gone. The action bar page number text coloring will now show latency, in addition to being clickable to toggle between bag and bar modes.
- You may now toggle between bag and bar modes in combat.
- Hover-in time option is temporarily removed.
- Showing/hiding action bar page number option is removed.

v2.03 (from v2.02) (17th May 2008)
- Written for v2.4.2.8278
- Added option to change the hover in and out time for the popup rows.

v2.02 (from v2.01) (27th March 2008)
- Update TOC to 20400 for 2.4.0.8089.

v2.01 (from v2.0) (15th February 2008)
- Fix missing translation
- Fix error from using auto toggle.

v2.0 (from v1.15) (1st February 2008)
- Written for v2.3.3.7799.
- Rewrote the whole addon. It now has more options. Slash commands reworked.
- Added options for bar scaling and endcaps hiding.
- Added options for setting the action ID you want for each row.
- Now optionally supports Ace3 configuration dialogs if the user has Ace3 installed.
- Fixed keybinds to show up properly in the keybindings menu.
- Fixed ADDON ACTION BLOCKED error that occur when you try to drag spells around in combat.

v1.15 (from v1.14) (15th November 2007)
- Written for v2.3.0.7561.
- Updated TOC. Yes, that's it.

v1.14 (from v1.13) (26th September 2007)
- Written for v2.2.0.7272.
- FIXED: Fixed WoW patch 2.2.0 breaking IPopBar.
- UPDATED: Made various optimizations available in v2.2.0.

v1.13 (from v1.12) (14th August 2007)
- Written for v2.1.3.6898.
- FIXED: IPopBar will now work on non-English clients for Druids, Warriors and Rogues.

v1.12 (from v1.11) (7th July 2007)
- Written for v2.1.2.6803.
- FIXED: Fixed a bug with Key Bbindings not appearing in the default Key Bindings menu.

v1.11 (from v1.10) (22nd May 2007)
- Written for v2.1.0.6692. TOC number updated to 20100.
- UPDATED: Hovering the mouse over the latency button will now display the default tooltip information containing the latency, framerate and addon memory data as introduced in the default UI in patch v2.1.
- UPDATED: Added option to turn on/off auto-toggle to bar mode when entering combat. Exiting combat will return you to your old mode. Use /ipopbar togglecombat or /ipopbar notogglecombat.

v1.10 (from v1.09) (22nd March 2007)
- Written for v2.0.10.6448.
- FIXED: Fixed a minor issue where sometimes buttons that do not have a hotkey assigned and is out of range of its associated action incorrectly shows a white dot instead of a red dot.
- FIXED: Really fixed the issue where the XP/Reputation bar overlaps IPopBar this time.
- CHANGED: When you enter combat, IPopBar will now always switch to Bar Mode if you aren't in Bar Mode.

v1.09 (from v1.08c) (10th January 2007)
- Written for v2.0.3.6299.
- TOC update to 20003.
- CHANGED: Optimized code substantially to use less CPU cycles in OnUpdate and OnEvent events (by dynamically assigning/registering scripts/events).
- FIXED: Fixed a graphical glitch where the XP bar overlaps the top border of the menu bar beginning at the page buttons. Thanks Koorogi.

v1.08c (from v1.08b) (22nd December 2006)
- Written for TBC beta v2.0.3.6244.
- Players on live realms should still use v1.08 (although this version should also work on live realms if you change the TOC back to 20000).
- CHANGED: Restored the ability of popup rows to show/hide even while in combat when hovering the mouse over the bottom row (using SecureAnchorEnterTemplate).
- REMOVED: The options combatshow and combathide are removed since the popup rows are now able to shown/hidden while in combat.

v1.08b (from v1.08) (21st December 2006)
- Written for TBC beta v2.0.3.6244. TOC number updated to 20003.
- Players on live realms should still use v1.08 (although this version should also work on live realms if you change the TOC back to 20000).
- FIXED: Fixed the error that occurs on pressing any IPopBar button, due to the changes made in the default UI actionbutton templates (changes to how self-casting works).
- FIXED: Changed the framestrata of buttons to HIGH so that the popup row(s) of buttons will appear above the Blizzard bottom right action bar buttons (if they are enabled).
- FIXED: Moved the Blizzard action bar page number slightly to the right, so that it now looks centered on the latency meter.
- FIXED: Fixed the tooltip location on mouseover of buttons so that it will not overlap any visible IPopbar button regardless of your UIScale.
- NEW: Added option to show/hide the Blizzard action bar page number on the latency meter. Use /ipopbar showpagenum or /ipopbar hidepagenum.

v1.08 (from v1.07c) (14th December 2006)
- Written for live servers v2.0.1.6180 and TBC beta v2.0.2.6178.
- CHANGED: For warriors, changed the bottom row of actionbutton IDs from 61-72 (which was default action bar 5) to 1-12 (which are unused by warriors). This means you need to reassign this one row of actions, but you gain an otherwise unused set of button IDs.
- NEW: Increased the number of maximum number of rows by 1 (from 2 rows to 3 rows).
- NEW: The 3rd row of buttons that are added can be shown with /ipopbar threerow. For druids and warriors they default to actionbutton IDs 49-60 which corresponds to Blizzard's default bottomright bar (or default action bar 5). For the rest, they use actionbutton IDs 85-96.
- CHANGED: Changed IPopBar settings to be saved per character, instead of being the same global settings for all characters on the same account. This means you may need to reconfigure onerow/tworow/threerow and combatshow/combathide settings.
- FIXED: Fixed a bug with buttonframes showing/hiding when picking up an item/spell on the cursor.
- FIXED: Fixed a bug with hotkeys not being updated properly on the buttons when a button becomes unbinded (a display issue). This is inherently a bug/flaw in Blizzard's base UI code as well, which I have reported.

v1.07c (from v1.07b) (6th December 2006)
- Written for live servers v2.0.1.6180.
- No changes really.

v1.07b (from v1.07) (1st December 2006)
- Written for PTR/TBC beta v2.0.2.6178.
- Updated IPopBar basecode to match base UI code changes from v2.0.1 to v2.0.2 (mainly SetAttribute() changes).
- Updated IPopBar button behaviors to match that of the default Blizzard bars/options. This means that
  - Shift+Click will pick up the spell.
  - Buttons will use the default Self-Cast options set in the Blizzard interface options
  - Spells will not be dragged off if Action Bars are locked in the Blizzard interface options
- Added /ipopbar combatshow and ipopbar combathide options to always show/hide the popup row when entering combat before the frame lockdown.

v1.07 (from v1.06) (16th November 2006)
- Written for PTR/TBC beta v2.0.1.6114.
- Intended to be a quick temporary fix (until my exams are over).
- Rewrote IPopBar basecode based on TBC UI base code changes to protected frames and button locks.

v1.06 (from v1.05) (21th June 2006)
- Written for v1.11.0.5428.
- Fixed the bugs resulting from Blizzard's addition of the Key Ring.

v1.05 (from v1.04)
- Fixed the bugs resulting from Blizzard's addition of the reputation bar (above the XP bar).

v1.04 (from v1.03)
- Updated the .toc file.
- Removed the redundant RegisterForSave().
- Reanchored a few frames due to the reputation/xp bar changes to the default UI.

v1.03 (from v1.02)
- Updated the .toc file from 1300 (v1.3.0) to 1800 (v1.8.0).
- Fixed 2 bugs resulting from patch v1.8 changes.

v1.02 (from v1.01)
- Updated the .toc file from 4222 (v1.2.4) to 1300 (v1.3.1).
- Added onerow and tworow option, where the user can designate IPopBar to operate in one row or two rows of buttons.

v1.01 (from v1.0)
- Updated the .toc file from 4211 (v1.2.3) to 4222 (v1.2.4). That's it.


===========================
Contact Information

- Xinhuan (US Blackrock, Alliance, Mage)
