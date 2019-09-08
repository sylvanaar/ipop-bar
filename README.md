[![Build Status](https://travis-ci.org/sylvanaar/ipop-bar.svg?branch=master)](https://travis-ci.org/sylvanaar/ipop-bar)
![License](https://img.shields.io/github/license/sylvanaar/ipop-bar)

![Wide Logo](https://cdn-wow.mmoui.com/preview/pvw71866.png)

# ipop-bar
Inspired by PopBar, this mod integrates the fundamental aspect of PopBar into the menu bar itself, toggleable between the Bag Buttons and 3 extra rows of buttons.

This AddOn is not designed to be draggable or movable and is not as customizable as some of the other additional toolbar addons. This AddOn is completely standalone and is not dependent on any other AddOn.

The design of this addon is based on the fact that many players use the hotkeys to open all their bags: Shift-B. You can rebind B to also open all your bags, or use F8-F12 for each individual bag. Hence, there is no real reason for the bag buttons to be displayed at all most of the time.

Similarly, all the interface has shortcuts, L for quest log, O for guild list, C for character, U for reputation, K for skills, P for spells, N for talents, etc. You don't actually need those bag or microbuttons, which is what this mod has in mind when being designed. Your playing mode should mostly be in the "Ipopbar" mode rather than the "bag mode".

## Commands:

```
/ipopbar : Shows help on available commands.
/ipopbar rows X : Use X rows of buttons. X can be 1, 2 or 3.
/ipopbar togglecombat : Automatically switch to bar mode on entering combat.
/ipopbar scale X : Scale the main menu bar. X can be between 0.5 and 2.0.
/ipopbar endcaps : Show/hide the dragon end caps on the main menu bar.
/ipopbar rowXstartID Y : Set the starting action ID of row X to action ID Y. X can be 1, 2, or 3; Y can be between 1 and 110.
/ipopbar resetstartID : Resets the starting action IDs of all the rows to the defaults.
```
If you have Ace3 core libraries installed, then typing /ipopbar will instead open the Ace3 configuration screen for IPopBar.

## Quirks:

If you loot an item, the normal animation of the item that goes into the bag doesn't display, until you toggle to the bags.
