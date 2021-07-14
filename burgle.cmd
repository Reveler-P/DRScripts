## Reveler's Burgle Script
## v.5.0
## 07/13/2021
## Discord Reveler#6969
##
## TO USE:  
##		FIRST SET YOUR VARIABLES IN BURGLEVARIABLES.CMD
##		If travel is off, go to an appropriate room
##		The script will check if there is a guard in the room
##		PLEASE MESSAGE ME IF YOU FIND A GUARD NOT LISTED IN THE GUARD VARIABLE BELOW OR LOOT NOT LISTED IN LOOT VARIABLES BELOW
##		YOU need to confirm there's no guard in NEARBY rooms (hint: HUNT or be sure it's a no-guard room)
##		hit .burgle and go at it!
##
##		BURGLE LOCATION AND PAWNING NOT SUPPORTED
##		You need to have Spelltimer plugin for buff checks
##		DISCLAIMER: NOT RESPONSIBLE FOR YOUR ASTRONOMICAL FINES

##		V 4.9 updates
##		Robustified actions to test for errors
##		More guard checks
##		More options for worn/stored lockpick rings and ropes
##		Added multi room search; will still leave immediately when you hear footsteps (after rt); specify number of times to search in maxgrabs variable
##		Cleaned up a few RT issues
##		Cleaned up a few issues that appear when there's lag
##		Moved travel module to after burgle timer check
## 		Thief Upgrades to Khri by Azarael
## 		Ability to have script wait for Burgle timer by Azarael
## 		Integration of Globals for setting user variables by Azarael
##		Logic for pawning and item capture provided by Shroom
##		Moved variables to separate file to avoid errors
##		Robustified matches to avoid errors
##		Will remain hidden when searching first room to optimize stealth
##		Added variables for loot - if not using ubercombat pawning you can choose the loot to keep and not pawn
##		Disabled cooldown wait
##		Added option to hide before search - set variable in variable script
##		Added option to skip rooms.  Set your variable in variable script
##		Added out when encountering clan justice
##		Added option to start burgle from inside the house as a failsafe - will immediately exit
##		Added support for eddy container
##		Added new bedroom loots
##		Added new kitchen loots
##		Added ability to put certain items in your trash list to drop if looted
##
##		V 5.0 updates 
##		Updated pawning, still mostly untested  DO NOT USE PAWNING IF USING UBERCOMBAT
##		Fixed known bug with dropping trash loot



#debug 10


pause 0.2
put .BurgleVariables
pause 0.2


action math successful add 1 when ^You rummage around (.*)\, until you find 
action var footsteps ON when ^Footsteps nearby make you wonder if you\'re pushing your luck\.
#action instant goto LEAVE when ^Footsteps nearby make you wonder
action var surface counter when ^\[Someone Else\'s Home\, Kitchen\]$
action var room kitchen when Kitchen\]$
action var surface bed when ^\[Someone Else\'s Home\, Bedroom\]$
action var room bedroom when Bedroom\]$
action var surface table when ^\[Someone Else\'s Home\, Work Room\]$
action var room workroom when Work Room\]$
action var surface desk when ^\[Someone Else\'s Home\, Sanctum\]$
action var room sanctum when Sanctum\]$
action var surface rack when ^\[Someone Else\'s Home\, Armory\]$
action var room armory when Armory\]$
action var surface bookshelf when ^\[Someone Else\'s Home\, Library\]$
action var room library when Library\]$
action instant goto JAIL when ^Before you really realize what\'s going on\, your hands are firmly bound behind you and you are marched off\.$
action goto PLEA when ^The eyes of the court|PLEAD INNOCENT or PLEAD GUILTY|Your silence shall be taken|How do you plead\?
action goto CLANJUSTICE when ^After a moment the leader steps forward grimly
action instant var fine 0;var platfine 0;var goldfine 0;var silverfine 0;var bronzefine 0;var copperfine 0;if ($1) then evalmath platfine $1*10000;if ($2) then evalmath goldfine $2*1000;if ($3) then evalmath silverfine $3*100;if ($4) then evalmath bronzefine $4*10;if ($5) then var copperfine $5;evalmath fine %platfine+%goldfine+%silverfine+%bronzefine+%copperfine when I pronounce a fine upon you of (?:(\d+) platinum[,.]?)?(?:(?: and)? ?(\d+) gold[,.]?)?(?:(?: and)? ?(\d+) silver[,.]?)?(?:(?: and)? ?(\d+) bronze[,.]?)?(?:(?: and)? ?(\d+) copper\.)?
#action goto DONE when ^You take a moment to reflect on the caper
#action put #var test.burgle.start $gametime;put #log >Burgle.log Start,$charactername,$gametime when ^You make short work of the lock on the window and slip inside|^You scale up the side of a wall, quickly slipping inside
#action put #var test.burgle.warntime $gametime;put #evalmath test.burgle.warning $gametime - $test.burgle.start;put #log >Burgle.log Footsteps,$charactername,$gametime,$test.burgle.warning when ^Footsteps nearby make you wonder if you're pushing your luck
#action put #evalmath test.burgle.caught $gametime - $test.burgle.warntime;put -1 #log >Burgle.log Caught,$charactername,$gametime,$test.burgle.caught when ^Before you really realize what\'s going on\, your hands are firmly bound behind you|^After a moment the leader steps forward 
var done NOPE
var footsteps OFF
var successful 0
var grabs 0
var moves 0
var surface NULL
var searched NULL
var priorexit(kitchen)
var priorexit(bedroom)
var priorexit(workroom)
var priorexit(sanctum)
var priorexit(armory)
var priorexit(library)
var guards Gwaerd|guard|Shard sentinel|Sentinel|Elven Warden|Riverhaven Warden|Warden|Baronial guardsman|sickly tree|Muspar'i constable
var trashitems NULL
var item1 NULL
var item2 NULL
var item3 NULL
var item4 NULL
var item5 NULL
var item6 NULL
var rooms_captured kitchen
var pawnmoveloop 0
if ($standing = 0) then put stand
var kitchenloot bowl|sieve|stove|stick|mortar|pestle|helm|knife|towel|broom|skillet|lunchbox|cylinder|sphere|vase|napkin|tankard|shakers|snare|knives|twine|cider\sjug|house\smouse|kitchen\srat|basket|recipe\sbox|basket|canvas\stote|tote
var bedroomloot pajamas|cloak|fabric|bathrobe|cube|comb|locket|bangles|box|bear|handkerchief|blanket|pillow|mirror|top|bottoms|nightcap|cufflinks|razor|diary|slippers|choker|nightgown|bank
var armoryloot stones|arrows|bolts|plate|gloves|hauberk|leathers|shield|briquet|scimitar|cudgel|crossbow|dagger|longsword|stick|hammer|sipar
var workroomloot rod|burin|shaper|rasp|oil|apron|brush|scissors|pins|distaff|case|ledger
var sanctumloot bracer|ring|amulet|blossom|statuette|charts|opener|orb|kaleidoscope|rod|ball|case|telescope|prism|lens
var libraryloot paperweight|slate|manual|guide|cowbell|harp|book|ring|case|fan|leaflet|scroll|portrait|quill|lamp
var lootpool %kitchenloot|%bedroomloot|%armoryloot|%workroomloot|%sanctumloot|%libraryloot
######## DON'T TOUCH LINES ABOVE


#### RUN .BURGLEVARIABLES TO SET THESE UP FOR EACH CHARACTER OR JUST FILL THEM IN HERE #####
var eddy $BURGLE.EDDY
var pack $BURGLE.PACK
var method $BURGLE.METHOD
var ringtype $BURGLE.RINGTYPE
var ropetype $BURGLE.ROPETYPE
var worn $BURGLE.WORN
var travel $BURGLE.TRAVEL
var maxgrabs $BURGLE.MAXGRABS
var keep $BURGLE.KEEP
var trashall $BURGLE.TRASHALL
var trashitems $BURGLE.TRASHITEMS
var hideme $BURGLE.HIDE
var skip $BURGLE.SKIP
var home $BURGLE.HOME
if (matchre("$scriptlist", "ubercombat\.cmd") then var pawn NO 
else var pawn $BURGLE.PAWN


if !matchre("%method", "(?i)(RING|ROPE|LOCKPICK)") then
{
echo ERROR WITH VARIABLE FOR BNE METHOD
put #echo >log red BURGLE: Error with variables
goto end
}


if matchre("$roomname", "Someone Else\'s Home") then goto ESCAPE

CHECKTIMER:
	var last CHECKTIMER
	matchre NOTYET ^You should wait at least (.+) roisaen for the heat to die down\.
	matchre TRAVEL ^The heat has died down from your last caper\.
	matchre WAIT \.\.\.wait|still stunned|^Sorry, you may only
	put burgle recall
	matchwait
	
TRAVEL:
	if matchre("%travel" = "(?i)NULL") then goto BUFF
	else put .travel %travel
	match BUFF ^YOU ARRIVED\!
	matchwait 20
	goto TRAVEL
	
BUFF:
	if ("$guild"="Thief") then
	{
		match KHRICLEAR ^Your recent use of
		send khri check
		matchwait 6
		if ($concentration < 55) then gosub CONC_REGEN
		if ($SpellTimer.KhriSilence.active = 0) then gosub KHRI SILENCE
		if ($SpellTimer.KhriPlunder.active = 0) then gosub KHRI PLUNDER
		if ($SpellTimer.KhriSlight.active = 0) then gosub KHRI SLIGHT
		if ($SpellTimer.KhriHasten.active = 0) then gosub KHRI HASTEN
	}
	if ("$guild"="Necromancer") then
	{
		if ($SpellTimer.RiteofContrition.active = 0) then put release cyclic
		if ($SpellTimer.RiteofContrition.active = 0) then gosub CAST ROC
		if ($SpellTimer.EyesoftheBlind.active = 0) then gosub CAST EOTB
	}
	if ("$guild"="Moon Mage") then 
	{
		if ($SpellTimer.RefractiveField.active = 0) then gosub CAST RF
	}
	goto GETREADY

KHRI:
	var khri $0
	KHRI1:
	var last KHRI1
	matchre KNEEL ^\[Sitting\, kneeling\, or lying down can make starting this khri easier\.\]
	matchre RETURN ^Your hand twitches|^Slipping into the proper|^Centering your mind|^Turning inwards
	matchre RETURN ^You have not recovered from your previous use|^Your body is willing, but|^You're already using
	matchre WAIT \.\.\.wait|still stunned|^Sorry, you may only
	put khri %khri
	matchwait 5
	GOSUB ERROR KHRI
 
KHRICLEAR:
	matchre KHRICLEAR ^You focus your attention
	matchre KHRIWAIT ^Your thoughts
	matchre KHRICLEAR \.\.\.wait|still stunned|^Sorry, you may only
	send khri med
	matchwait
	
KHRIWAIT:
	pause 60
	goto BUFF
	
KNEEL:
	var last KNEEL
	matchre WAIT \.\.\.wait|still stunned|^Sorry, you may only
	matchre KHRI1 ^You kneel|^You are already kneeling
	put kneel
	matchwait 5
	GOSUB ERROR KNEELING
	
CAST:
	var spell $0
	var last CAST
	CAST1:
	pause .1
	matchre GETREADY ^You have no training in the magical arts\.
    matchre GETREADY ^You have no idea how to cast that spell\.
	put prepare %spell
	matchwait 5
	if ("$preparedspell" = "NONE") then goto CAST1
	CAST2:
	pause 10
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
    matchre RETURN ^You gesture
    matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
    matchre RETURN ^You raise your hand in an imaginary
    matchre RETURN ^You don't have a spell prepared\!
    matchre RETURN ^Your spell pattern collapses
    matchre RETURN ^With a wave of your hand,
    matchre RETURN ^Your target pattern dissipates
    matchre RETURN ^You wave your hand\.
    matchre RETURN ^You place your hands on your temples
    matchre RETURN ^A newfound fluidity of your mind
    matchre RETURN ^With a flick of your wrist,
    matchre RETURN ^You make a holy gesture
    matchre RETURN ^You raise your palms and face to the heavens
    matchre RETURN ^You have difficulty manipulating the mana streams, causing the spell pattern to collapse at the last moment\.
    matchre RETURN ^You strain
	put cast
	matchwait 5
	return

GETREADY:
	var last GETREADY
	gosub EMPTYHANDS
	if ($standing = 0) then 
	{
		gosub STAND
	}

	if matchre("%method", "(?i)RING") then
	{
		matchre HIDEPREP ^You tap (.+) you are wearing
		matchre NOTWORN ^You tap (.*) in your
	    matchre NORING ^I could not|^What
		matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
		put tap my %ringtype
		matchwait 6
		gosub ERROR LOCKPICKS
	}
	if matchre("%method", "(?i)LOCKPICK") then
	{
		if matchre("%eddy","(?i)LOCKPICK") then goto EDDYPICK
		matchre HIDEPREP ^You get
		matchre HIDEPREP ^You are already holding that\.
		matchre EDDYPICK ^I could not|^What
		matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
		put get my lockpick
		matchwait 6
		gosub ERROR LOCKPICKS
	}
	if matchre("%method", "(?i)ROPE") && matchre("%worn", "(?i)(YES|ON|1)") then
	{
		matchre HIDEPREP ^You sling
		matchre HIDEPREP ^You aren\'t
		matchre NOTWORN ^Remove what
		matchre EDDYROPE ^I could not|^What
		matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
		put remove my %ropetype
		matchwait 6
		gosub ERROR LOCKPICKS
	}
	if matchre("%method", "(?i)ROPE") && matchre("%worn", "(?i)(NO|NULL|OFF|0)") then
	{
		if matchre("%eddy","(?i)ROPE") then goto EDDYROPE
		matchre HIDEPREP ^You get
		matchre HIDEPREP ^You are already holding that\.
		matchre EDDYROPE ^I could not|^What
		matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
		put get my %ropetype
		matchwait 6
		gosub ERROR ROPE
	}
	gosub error METHOD_VARIABLE

EDDYPICK:
	matchre HIDEPREP ^You get
	matchre HIDEPREP ^You fade in
	matchre HIDEPREP ^You are already holding that\.
	matchre NOLOCKPICK ^I could not|^What
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
	put get my lockpick from my portal
	matchwait 6
	gosub ERROR LOCKPICKS

EDDYROPE:
	matchre HIDEPREP ^You get
	matchre HIDEPREP ^You fade in
	matchre HIDEPREP ^You are already holding that\.
	matchre NOROPE ^I could not|^What
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
	put get my %ropetype from my portal
	matchwait 6
	gosub ERROR ROPE
	
NOTWORN:
   	if matchre("%method", "(?i)RING") then
	{
		echo YOU CANNOT BURGLE WITH A LOCKPICK RING UNLESS IT IS WORN.  
		gosub ERROR LOCKPICKS
	}
	var worn NO
	goto %last
	
WORN:
	var worn YES
	goto %last
	
HIDEPREP:
	if matchre("$roomobjs","(%guards)") then goto GUARDABORT
	var hidecount 0
HIDE:
	if (($hidden = 0) && ($invisible = 0)) then
	{
		put hide
		pause
		pause .1
		math hidecount add 1
		if (($hidden = 0) && (%hidecount < 3)) then goto HIDE
		if (($hidden = 0) && ($invisible = 0)) then goto NOHIDE
	}
	if (($hidden = 1) || ($invisible = 1)) then goto BURGLE
	goto ERROR HIDING

BURGLE:
	var last BURGLE
	if matchre("$roomobjs","(%guards)") then goto GUARDABORT
	matchre NOLOCKPICK ^And how were you planning to get in\?
	matchre NOBURGLE ^You don't see any likely marks in the area\.
	matchre SEARCH ^\[Someone Else\'s Home\,
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
#	matchre SEARCH ^You make short work of the lock
#	matchre SEARCH ^You scale up the side of a wall
	if (($hidden = 1) || ($invisible = 1)) then put burgle
	else goto HIDEPREP
	matchwait 10
	gosub ERROR ENTERING HOME

SEARCH:
	if !matchre("%rooms_captured", "%room") then var rooms_captured %rooms_captured|%room
	if (!matchre("%surface", "%searched")) && (%grabs < %maxgrabs) && ("%footsteps" = "OFF") && !matchre("%room", "%skip") then 
	{
		if (("%footsteps" = "OFF") && ($hidden = 0) && ($invisible = 0) && matchre("%hideme", "(?i)(YES|ON|1)")) then gosub PUT hide
		if ("%footsteps" = "OFF") then
		{
			gosub put search %surface
			math grabs add 1
			var searched %searched|%surface
		}
	}
	if ("%footsteps" = "ON") then goto LEAVE
	if ("%footsteps" = "OFF") then gosub STOWLOOT
	if ("%footsteps" = "OFF")&&(%grabs < %maxgrabs) then goto NEXTSEARCH
	goto LEAVE
	
NEXTSEARCH:
	var priorgrab %moves
	if ("%footsteps" = "ON") then goto LEAVE
	math moves add 1
    gosub GETDIRECTION
	gosub MOVEROOMS %direction(%moves)
	goto SEARCH

GETDIRECTION:
	var roomexits 0
	if (($north = 1) && ("%reverse(%priorgrab)" != "north") && !matchre("%priorexit(%room)","north")) then
	{
		var direction(%moves) north
		var reverse(%moves) south
		var priorexit(%room) north|%priorexit(%room)
		var roomexits 1
	}
	if (($east = 1) && ("%reverse(%priorgrab)" != "east") && (%roomexits = 0) && !matchre("%priorexit(%room)","east")) then
	{
		var direction(%moves) east
		var reverse(%moves) west
		var priorexit(%room) east|%priorexit(%room)
		var roomexits 1
	}
	if (($south = 1) && ("%reverse(%priorgrab)" != "south") && (%roomexits = 0) && !matchre("%priorexit(%room)","south")) then
	{
		var direction(%moves) south
		var reverse(%moves) north
		var priorexit(%room) south|%priorexit(%room)
		var roomexits 1
	}
	if (($west = 1) && ("%reverse(%priorgrab)" != "west") && (%roomexits = 0) && !matchre("%priorexit(%room)","west")) then
	{
		var direction(%moves) west
		var reverse(%moves) east
		var priorexit(%room) west|%priorexit(%room)
		var roomexits 1
	}
	if (($northeast = 1) && ("%reverse(%priorgrab)" != "northeast") && (%roomexits = 0) && !matchre("%priorexit(%room)","northeast")) then
	{
		var direction(%moves) northeast
		var reverse(%moves) southwest
		var priorexit(%room) northeast|%priorexit(%room)
		var roomexits 1
	}
	if (($northwest = 1) && ("%reverse(%priorgrab)" != "northwest") && (%roomexits = 0) && !matchre("%priorexit(%room)","northwest")) then
	{
		var direction(%moves) northwest
		var reverse(%moves) southeast
		var priorexit(%room) northwest|%priorexit(%room)
		var roomexits 1
	}
	if (($southeast = 1) && ("%reverse(%priorgrab)" != "southeast") && (%roomexits = 0) && !matchre("%priorexit(%room)","southeast")) then
	{
		var direction(%moves) southeast
		var reverse(%moves) northwest
		var priorexit(%room) southeast|%priorexit(%room)
		var roomexits 1
	}
	if (($southwest = 1) && ("%reverse(%priorgrab)" != "southwest") && (%roomexits = 0) && !matchre("%priorexit(%room)","southwest")) then
	{
		var direction(%moves) southwest
		var reverse(%moves) northeast
		var priorexit(%room) southwest|%priorexit(%room)
		var roomexits 1
	}
	if (%roomexits = 0) then 
	{
		var direction(%moves) %reverse(%priorgrab)
		var reverse(%moves) %direction(%priorgrab)
		var priorexit(%room) %reverse(%priorgrab)|%priorexit(%room)
	} 
	return

MOVEROOMS:
	var movement $0
	MOVEROOMS1:
	var last MOVEROOMS1
	matchre ESCAPE ^Please rephrase
	matchre RETURN ^Obvious
	matchre RETURN ^You can't
	matchre WAIT \.\.\.wait
	put %movement
	matchwait 5
	
LEAVE:
	var last leave
	if matchre("$roomname", "Kitchen") then 
	{
	matchre DONE ^You take a moment to reflect on the caper you just pulled as you slip out the kitchen window\.\.\.
	matchre ESCAPE ^What were you referring to\? 
	matchre ESCAPE ^Please rephrase
	matchre WAIT \.\.\.wait
	put go window
	matchwait 6
	}
	gosub moverooms %reverse(%moves)
	math moves subtract 1
	goto LEAVE

ESCAPE:
	var last escape
	if matchre("$roomname", "Kitchen") then 
	{
	matchre ESCAPED ^You take a moment to reflect on the caper you just pulled as you slip out the kitchen window\.\.\.
	matchre ESCAPE ^What were you referring to\? 
	matchre WAIT \.\.\.wait
	put go window
	matchwait 6
	goto ESCAPE
	}
	gosub GETDIRECTION
	gosub MOVEROOMS %direction(%moves)
	math moves add 1
	goto ESCAPE	

ESCAPED:
	gosub EMPTYHANDS
	echo ###################################
	echo #####
	echo #####       FINISHED BURGLING.
	echo #####		SUCCESSFULLY ESCAPED.
	echo #####       Thievery: $Thievery.LearningRate/34
	echo #####       Stealth: $Stealth.LearningRate/34
	if matchre("%method", "(?i)ROPE") then echo #####       Athletics: $Athletics.LearningRate/34
	if matchre("%method", "(?i)(LOCKPICK|RING)") then echo #####       Locksmithing: $Locksmithing.LearningRate/34
	echo #####
	echo ###################################
	goto END

DONE:
	var done YES
	if (%successful > 0) then gosub STOWLOOT
	else gosub EMPTYHANDS
	echo ###################################
	echo #####
	echo #####       FINISHED BURGLING.
	echo #####       Made %grabs attempts
	echo #####       Found %successful items
     if ("%item6" != "NULL") then 
          {
               echo #####       Items: %item1, %item2, %item3, %item4, %item5, %item6
               goto DONE_2
          }
     if ("%item5" != "NULL") then 
          {
               echo #####       Items: %item1, %item2, %item3, %item4, %item5
               goto DONE_2
          }
     if ("%item4" != "NULL") then 
          {
               echo #####       Items: %item1, %item2, %item3, %item4
               goto DONE_2
          }
     if ("%item3" != "NULL") then 
          {
               echo #####       Items: %item1, %item2, %item3
               goto DONE_2
          }
     if ("%item2" != "NULL") then 
          {
               echo #####       Items: %item1, %item2
               goto DONE_2
          }
     if ("%item1" != "NULL") then 
          {
               echo #####       Items: %item1
               goto DONE_2
          }
DONE_2:
	echo #####       Thievery: $Thievery.LearningRate/34
	echo #####       Stealth: $Stealth.LearningRate/34
	if matchre("%method", "(?i)ROPE") then echo #####       Athletics: $Athletics.LearningRate/34
	if matchre("%method", "(?i)(LOCKPICK|RING)") then echo #####       Locksmithing: $Locksmithing.LearningRate/34
	echo #####
	echo ###################################
    if matchre("%pawn", "(?i)(YES|ON|1)") then goto PAWN
DONE_3:
	matchre burgletimer ^You should wait at least (.+) roisaen for the heat to die down\.
	put burgle recall
	matchwait 5
	
BURGLETIMER:
	put #echo >log red New Burgle Cooldown: $1 Rois
	put #echo >log red Burgled %successful items
	put #echo >log red Found following rooms: %rooms_captured
	     if ("%item3" != "NULL") then 
          {
               put #echo >log red Found: %item1, %item2, %item3
               goto END
          }
     if ("%item2" != "NULL") then 
          {
               put #echo >log red Found: %item1, %item2
               goto END
          }
     if ("%item1" != "NULL") then 
          {
               put #echo >log red Found: %item1
               goto END
          }
     if ("%item1" != "NULL") then 
          {
               put #echo >log red No successful searches
               goto END
          }
	goto END
	
PAWN:
	 var last pawn
     if matchre("%pawn", "(?i)(NO|NULL|0|OFF)") then goto DONE_3
	 if ("%successful" = 0) then 
	 {
		echo ######################
		echo ##### No finds, skipping pawning
		echo ######################
		goto DONE_3
	 }
     echo #
     echo #
     echo #
     echo ######################
     echo ##### PAWNING BURGLED ITEMS!
     echo ######################
     pause 0.1
	 PAWN_1:
	 matchre PAWN_2 ^YOU ARRIVED
	 matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
	 matchre PAWNMOVELOOP ^MOVE FAILED
	 matchre PAWNMOVELOOP ^DESTINATION NOT FOUND
     put .travel %home pawn
	 matchwait 40
	 goto PAWN
PAWN_2:
     if ($invisible = 1) then gosub STOP_INVIS
	 var n 1
     pause 0.5
	 pawnloop:
     if (matchre("%item%n", "NULL") || matchre("%item%n", "%trashitems") || matchre("%item%n", "%keep")) then math n add 1
	 else gosub PAWN_IT %item%n
	 if (%n <= %successful) then goto pawnloop
	 goto DONE_3
PAWN_IT:
if (!matchre("%item%n", "%keep")) then
	{
		if matchre("%item%n", "jug") then var item jug
		if matchre("%item%n", "tote") then var item tote
		if matchre("%itemvv", "bank") then var item bank
		if matchre("%item%n", "box") then var item box
		gosub put get %item%n from my %pack
		pause 0.5
		if matchre("$righthand", "recipe box") then gosub DUMPBOX
		gosub put sell %item%n
		pause 0.5
		if !matchre("$righthand", "Empty") then gosub put put %item%n in bucket
	}
	math n add 1
	pause 0.1		 
	return
PAWNMOVELOOP:
	math pawnmoveloop add 1
	if (%pawnmoveloop = 3) then 
	{
     echo ######################
     echo ##### PAWNING FAILED - NO PAWN SHOP?
     echo ######################
	 goto DONE_3
	}
	goto PAWN_1

DUMPBOX:
	gosub put open my box
	gosub put get key from my box
	gosub put key in bucket
	gosub put drop key
	return

##### UTILITY MODULES
CONC_REGEN:
	pause
     echo ######################
     echo ##### WAITING FOR CONCENTRATION
     echo ######################
	gosub put khri stop
	pause .1
	put hide
CONC_REGEN1:
	pause 10
	put khri meditate
	pause .1
	if ($concentration > 75) then return
	goto CONC_REGEN1
	

EMPTYHANDS:
	if matchre("$righthandnoun|$lefthandnoun", "(?i)rope") && matchre("%worn", "(?i)(YES|ON)") then gosub put wear rope
	if matchre("$righthandnoun|$lefthandnoun", "(?i)rope") && matchre("%worn", "(?i)(NO|NULL|OFF)") then gosub put stow rope
	if matchre("$righthandnoun|$lefthandnoun", "(?i)lockpick") then gosub put stow lockpick
	if matchre("$righthandnoun|$lefthandnoun", "%ringtype") && matchre("%worn", "(?i)(YES|ON)") then gosub put wear %ringtype
	if matchre("$righthandnoun|$lefthandnoun", "%ringtype") then gosub put stow %ringtype
	if !matchre("$righthand", "Empty") then gosub put stow right
	if !matchre("$lefthand", "Empty") then gosub put stow left
	return

STOWLOOT:
	if matchre("$righthandnoun|$lefthandnoun", "(?i)rope") && matchre("%worn", "(?i)(YES|ON)") then gosub put wear rope
	if matchre("$righthandnoun|$lefthandnoun", "(?i)rope") && matchre("%worn", "(?i)(NO|NULL|OFF)") then gosub put stow rope
	if matchre("$righthandnoun|$lefthandnoun", "(?i)lockpick") then gosub put stow lockpick
	if matchre("$righthandnoun|$lefthandnoun", "%ringtype") && matchre("%worn", "(?i)(YES|ON)") then gosub put wear %ringtype
	if matchre("$righthandnoun|$lefthandnoun", "%ringtype") then gosub put stow %ringtype
	if !matchre("$righthand", "Empty") then 
          {
               if matchre("$righthandnoun", "%lootpool") then gosub ITEM_SET $righthand
			   if (!matchre("$righthandnoun", "(%keep|rope|lockpick|ring)") && (matchre("%trashall", "(?i)(YES|ON)"))||matchre("$righthandnoun", "%trashitems")) then gosub DROP right
			   else gosub PUTLOOT put my $righthandnoun in my %pack
			   if ((%nofit = 1) && !matchre("$righthandnoun", "(%keep|rope|lockpick|ring)")) then 
			   {
				gosub DROP right
				var nofit 0
			   }			   
          }
	if !matchre("$lefthand", "Empty") then 
          {
               if matchre("$lefthandnoun", "%lootpool") then gosub ITEM_SET $lefthand
			   if (!matchre("$lefthandnoun", "(%keep|rope|lockpick|ring)") && (matchre("%trashall", "(?i)(YES|ON)")) || matchre("$lefthandnoun", "%trashitems")) then gosub DROP left
			   else gosub PUTLOOT put my $lefthandnoun in my %pack
			   if ((%nofit = 1) && !matchre("$lefthandnoun", "(%keep|rope|lockpick|ring)")) then 
			   {
				gosub DROP left
				var nofit 0
			   }			   
          }
#    pause 0.4
	return
     
ITEM_SET:
     var thing $0
     var j 1
ITEM_SET_1:
     if ("%item%j" = "NULL") then
          {
			   eval thing replacere("%thing", "^(\S+ )+(?=\S+ \S+)", "")
               var item%j %thing
               put #tvar BurgleItem%j %thing
               return
          }
     math j add 1
     if (%j > 6) then return
     goto ITEM_SET_1
PUT:
	var put $0
	PUT_1:
	var last PUT_1
#	pause .1
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
    matchre RETURN ^You put|^You sling|^You attach|^You attempt to relax|^You rummage|^What were|^You sell|^You get|not worth anything to me\.\"$
#" added for formatting
	matchre RETURN ^You slip into a hiding|^You melt into the background|^Eh\?  But you're already hidden\!|^You blend in with your surroundings
	matchre NOWEAR ^You can\'t wear
	matchre LEAVE ^You\'re going to need a free hand to rummage around in there\.
	matchre STORAGEERROR ^But that\'s closed|^That\'s too heavy|too long to fit|too long\, even after stuffing it\, to fit
	put %put
	matchwait 5
	return
	
PUTLOOT:
	var put $0
	PUTLOOT_1:
	var last PUTLOOT_1
#	pause .1
	matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
    matchre RETURN ^You put|^You sling|^You attach|^You attempt to relax|^You rummage|^What were|^You sell|^You get
	matchre NOWEAR ^You can\'t wear
	matchre NOFIT ^But that\'s closed|^That\'s too heavy|^The .* too long to fit|too long\, even after stuffing it\, to fit|^Weirdly, you can\'t manage|^There isn\'t any more room
	put %put
	matchwait 5
	return

NOFIT:
	echo Could not fit looted item! Get a bigger bag.
	var nofit 1
	return

STAND:
     matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
     matchre WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre WAIT ^The weight of all your possessions prevents you from standing\.
     matchre WAIT ^You are overburdened and cannot manage to stand\.
     matchre STAND_1 ^You stand 
     matchre STAND_1 ^You are already 
     matchre STAND_1 ^As you stand
     put stand
     matchwait 5
     STAND_1:
     if ($standing = 0) then goto STAND
     return	

STORAGEERROR:
	echo ###################################
	echo #####
	echo #####       ERROR WITH STORAGE? LEAVING
	echo #####
	echo ###################################
	goto LEAVE

DROP:
	 var drophand $0
	 DROP1:
	 var last DROP1
     matchre DROP1 ^\.\.\.wait|^Sorry,|^Please wait\.
     matchre return ^You drop 
     matchre DROP1 ^\[If you still wish to drop it
	 matchre return ^You can only empty
	 matchre DROP1 ^Trying to go unnoticed, are you\?
     put empty %drophand
     matchwait 5
     return	

WAIT:
#	pause .01
	goto %last
	
NOWEAR:
	var worn NO
	goto EMPTYHANDS
	
JAIL:
	put kick pile
	put collect dust bunny
	pause .5
	goto JAIL
	
PLEA:
	pause .1
    matchre PLEA ^\.\.\.wait|^Sorry,
	matchre TAKEOVER ^After a weighty pause\, 
	put plead guilty
	matchwait 5

STOPINVIS:
STOP_INVIS:
     delay 0.001
     echo *** Removing Invis..
     if ("$guild" = "Necromancer") then
          {
               gosub PUT release eotb
               pause 0.3
          }
     if ("$guild" = "Thief") then
          {
               gosub PUT khri stop silence vanish
               pause 0.3
          }
     if ("$guild" = "Moon Mage") then
          {
               gosub PUT release rf
               pause 0.3
          }
     pause 0.3
     return

TAKEOVER: 
	echo ###################################
	echo #####
	echo #####       JAILED - FINE: %fine
	echo #####
	echo ###################################
	put #echo >log red Jailed when burgling!
	goto DONE
	
CLANJUSTICE:
	echo ###################################
	echo #####
	echo ##### YOU GOT CAUGHT IN CLAN JUSTICE!
	echo ##### GO HEAL YOURSELF!	
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Caught in clan justice!
	goto DONE
	
RETURN:
	return

##### ERROR MODULES

NOBURGLE:
	echo ###################################
	echo #####
	echo #####       Not a valid place to burgle.
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Not a valid place to burgle
	goto END

NORING:
	echo ###################################
	echo #####
	echo #####       No Lockpick Ring?
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Missing lockpick ring?
	goto END

NOLOCKPICK:
	echo ###################################
	echo #####
	echo #####       No Lockpick?
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Missing lockpick?
	goto END

NOROPE:
	echo ###################################
	echo #####
	echo #####       No Climbing Rope?
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Missing climbing rope?
	goto END

NOHIDE:
	echo ###################################
	echo #####
	echo #####       Could not hide, not invisible
	echo #####          Try a different room
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Error with hiding?
	goto END

GUARDABORT:
	echo ###################################
	echo #####
	echo #####       There's a guard in the room!
	echo #####          PAY ATTENTION NEWB
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: Did not burgle - guard alert!
	goto END

NOTYET:
	echo ###################################
	echo #####
	echo #####       STILL ON COOLDOWN
	echo #####          WAIT $1 ROIS
	echo #####
	echo #####
	echo ###################################
	put #echo >log red Burgle: $1 minute cooldown left
#	waitfor A tingling on the back of your neck draws attention
#	goto CHECKTIMER
	goto END
	
ERROR: 
	echo ###################################
	echo #####
	echo #####       UNKNOWN ERROR WITH $0
	echo #####
	echo ###################################
	put #echo >log red Burgle: Unknown error
	goto END

END:
    put #parse SCRIPT FINISHED!
	exit