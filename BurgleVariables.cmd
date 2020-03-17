## Reveler's BurgleVariables Script
## v.1.3 
## 03/10/2020
## Discord Reveler#6969

## v. 1.3 updates:
## Added option to hide before searches

## THIS IS AN INCLUDED SCRIPT IN THE BURGLE SCRIPT AND MUST BE COMPLETED BEFORE RUNNING .BURGLE.CMD

#debug 10

## SET YOUR CHARACTER'S NAMES BELOW, IF NOTHING USE NULL
## MAKE SURE TO UPDATE EACH CHARACTERS VARIABLES INDIVIDUALLY BELOW
var CHARACTER1 NULL
var CHARACTER2 NULL
var CHARACTER3 NULL
var CHARACTER4 NULL
var CHARACTER5 NULL
var CHARACTER6 NULL

## SET ALL YOUR CUSTOM VARIABLES PER EACH CHARACTER IN THE BLOCKS BELOW THIS!
##### CHARACTER 1 VARIABLES
if ("$charactername" = "%CHARACTER1") then 
{
# where do you want to store your stolen items?
var pack haversack
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
if ($Athletics.LearningRate >= $Locksmithing.LearningRate) then var method RING
else var method ROPE
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype heavy rope
# Toggle for worn lockpick ring/rope
if ("%method" = "RING") then var worn YES
else var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 5
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme YES
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis case|manual|scimitar|opener
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip NULL
}

if ("$charactername" = "%CHARACTER2") then 
{
# where do you want to store your stolen items?
var pack haversack
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
var method ROPE
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype braided rope
# Toggle for worn lockpick ring/rope
var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 2
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme NO
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis case|manual
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip NULL
}

if ("$charactername" = "%CHARACTER3") then 
{
# where do you want to store your stolen items?
var pack carry
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
var method rope
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype braided rope
# Toggle for worn lockpick ring/rope
var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 7
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme NO
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis NULL
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip kitchen|bedroom
}

if ("$charactername" = "%CHARACTER4") then 
{
# where do you want to store your stolen items?
var pack basket
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
var method ROPE
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype heavy rope
# Toggle for worn lockpick ring/rope
var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 2
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme NO
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis case|manual
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip NULL
}

if ("$charactername" = "%CHARACTER5") then 
{
# where do you want to store your stolen items?
var pack carryall
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
var method ROPE
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype braided rope
# Toggle for worn lockpick ring/rope
var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 2
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme NO
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis case|manual
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip NULL
}

if ("$charactername" = "%CHARACTER6") then 
{
# where do you want to store your stolen items?
var pack basket
# method can be RING, LOCKPICK, or ROPE; RING (uses lockpick stacker) and LOCKPICK (uses spare lockpicks) teach locks, ROPE teaches athletics. VARIABLE MUST BE IN ALL CAPS
var method ROPE
# ringtype is the type of lockpick ring you have.  It can be any of the following: lockpick ring|lockpick case|lockpick ankle-cuff|golden key
var ringtype lockpick ring
# Use your adjective-noun for your rope
# DANCING ROPES DO NOT WORK
var ropetype heavy rope
# Toggle for worn lockpick ring/rope
var worn NO
# Travel location should be the city and the roomid.  Pick a room where you *know* there will not be a guard, or leave NULL NOTE: LEAVE NULL IF USING WITHIN UBERCOMBAT
var travel NULL
# maximum times to try to search surfaces
var maxgrabs 2
# do you want to hide before you search? Will ALWAYS be hidden for first search. ON will attempt to hide before any additional search. WARNING - MAY BE MORE RISKY BECAUSE OF ROUND TIME AND WILL REDUCE NUMBER OF POTENTIAL ROOMS YOU WILL HAVE TIME TO SEARCH
var hideme NO
# pawn YES will try to pawn your stolen goods NOTE - PUT NO IF PAWNING THROUGH UBERCOMBAT
var pawn NO
# put loot you DO NOT wish to sell here if you use pawning within .BURGLE.  The full lootpool variable is in .burgle. Separate with |
var donotpawnthis case|manual
# Rooms you do not want to search.  Choose from following: kitchen|bedroom|workroom|sanctum|armory|library
var skip NULL
}
######### END USER VARIABLES DON'T TOUCH ANYTHING ELSE



put #var BURGLE.PACK %pack
put #var BURGLE.METHOD %method
put #var BURGLE.RINGTYPE %ringtype
put #var BURGLE.ROPETYPE %ropetype
put #var BURGLE.WORN %worn
put #var BURGLE.TRAVEL %travel
put #var BURGLE.MAXGRABS %maxgrabs
put #var BURGLE.PAWN %pawn
put #var BURGLE.KEEP %donotpawnthis
put #var BURGLE.HIDE %hideme
put #var BURGLE.SKIP %skip
