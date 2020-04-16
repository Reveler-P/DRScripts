#debuglevel 10
################################################################################################################################
# Lock Carving Script - For Dragonrealms - by Reveler
# - Works only for thieves
# - Can be set to carve specific lockpick types - will not be 100% effective at capturing just that lockpick due to game mechanics
# - Only designed to fill lockpick rings and will stop when lockpick ring is full
# - If using keyblank pockets, all keyblank types must be the same.  Any different keyblank pockets should be stored in action
#      closed container before starting
# - Send errors/bugs/requests to Discord: Reveler#6969
# LAST UPDATE - 9/30/19
################################################################################################################################
#####################
## USER VARIABLES 
#####################
## LockpickLevel - Can be set to GRAND or MASTER.  If set to MASTER will stop carving once level reaches Master
## ONLY WORKS FOR MASTER CURRENTLY
var LockpickLevel master
## RingContainer - set for "worn" if worn; give container in which your empty lockpick rings are stored
var RingContainer shadow 
## FinishedRings Where do you want to put your finished lockpick rings? NOT IMPLEMENTED
#var FinishedRings bag
## KeyblankType - set to the type of keyblank in the description that is used in the $lefthand or $righthand variable
var KeyblankType iron
## KeyblankContainer
var KeyblankContainer pocket
## BuyandCarve - Set to yes if you are in Kilam's shop and want to buy keyblanks before carving  NOT CURRENTLY IMPLEMENTED
var no
## Carver - Set to the name of your carver as it appears in $righthand
var Carver carving knife
## CarverStorage - Set to your storage for your carver.  It can be a belt
var CarverStorage satchel


#####################
## GENERAL VARIABLES 
## DO NOT ADJUST
#####################
var tie 0
var open 0
eval lockpick tolower(%LockpickLevel)
var remaining 1
action var remaining $2 when looks to be holding (.*) lockpicks and it might hold an additional (.*)\.
action var remaining 0 when appears to be full
action var remaining 25 when The lockpick ring is empty but you think 25 lockpicks would probably fit\.
action var tie 1 when untie
action var open 0 when is closed
action var open 1 when you open

     var trash NULL
     if matchre("$roomobjs", "a small hole") then var trash hole
     if matchre("$roomobjs", "a small mud puddle") then var trash puddle
     if matchre("$roomobjs", "a marble statue ") then var trash statue
     if matchre("$roomobjs", "(a disposal bin|a waste bin|firewood bin)") then var trash bin
     if matchre("$roomobjs", "(a tree hollow|darken hollow)") then var trash hollow
     if matchre("$roomobjs", "(a bucket of viscous gloop|a waste bucket|a bucket|metal bucket|iron bucket)") then var trash bucket
     if matchre("$roomobjs", "a large stone turtle") then var trash turtle
     if matchre("$roomobjs", "an oak crate") then var trash crate
     if matchre("$roomobjs", "a driftwood log") then var trash log
     if matchre("$roomobjs", "ivory urn") then var trash urn
     if matchre("$roomobjs", "a waste basket") then var trash basket
     if matchre("$roomobjs", "a bottomless pit") then var trash pit
     if matchre("$roomobjs", "trash receptacle") then var trash receptacle
     if matchre("$roomobjs", "domesticated gelapod") then var trash gelapod
     if matchre("$roomobjs", "large wooden barrel") then var trash barrel
     if matchre("$roomname", "^\[Garden Rooftop, Medical Pavilion\]") then var trash gutter


gosub ClearHands

Start:
	gosub RingCheck
		 pause 0.0001
		 pause 0.1
	if %remaining = 0 then goto full
		 pause 0.0001
		 pause 0.1
	PrepDone:
	if %open = 0 then gosub Open
		 pause 0.0001
		 pause 0.1
	gosub GetCarver %Carver from my %CarverStorage
		 pause 0.0001
		 pause 0.1
	gosub GetKeyblank %KeyblankType keyblank from my %KeyblankContainer
		 pause 0.0001
		 pause 0.1
	gosub Carve
		 pause 0.0001
		 pause 0.1
	gosub Finish
	goto Start


RingCheck:
	matchre NoRings ^I could not find what you were referring to\.
	matchre WAIT ^\.\.\.wait
	matchre WAIT ^Sorry\,
	matchre RETURN ^The lockpick ring looks to be holding
	matchre RETURN ^The lockpick ring is empty but
	if ("%RingContainer" = "worn") then send glance lockpick ring
	else send glance lockpick ring in my %RingContainer
	matchwait 10
	return

NoRings:
	echo ####################
	echo # No Lockpick Rings?
	echo # Check your inventory
	echo ####################
	return

Open:
	var Last Open
		matchre Open_1 ^You open
		matchre Open_1 ^You slowly open
		matchre Open_1 ^That is already
		matchre NoPocket ^What were you
		matchre WAIT ^\.\.\.wait
		matchre WAIT ^Sorry\,
		send open my %KeyblankContainer
		matchwait 4
		goto ERROR
Open_1:
	var open 1
return

NoPocket:
	echo ####################
	echo # No container?
	echo # Check your variables
	echo ####################
	goto end

### FROM KILAM'S SHOP
### NOT IMPLEMENTED
#KilamOrder:
	#var Last KilamOrder
	#send order soft iron keyblank
	#pause .01
	#waitforre Kilam says
	#send offer 150
	#waitforre Kilam says|hands over
	#send offer 150
	#waitforre hands over|order something 
	#return


GetCarver:
	var GetC $0
	var Last GetCarver %GetC
	if !matchre("%Carver", "($righthand|$lefthand)") then 
	{
		matchre WAIT ^\.\.\.wait|^Sorry\,
		matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
		matchre HoldIt ^But that is already in your inventory\.
		matchre RETURN ^You get .*\.
		matchre RETURN ^You pick up .*\.
		matchre RETURN ^You are already holding that\.
		matchre ERROR ^You need a free hand 
		matchre NoCarver ^Get what\?|^I could not find what you were referring to\.|^What were you referring to\?
		matchre RETURN ^You grab .*(?:\.|\!|\?)
		matchre UNTIE ^You pull at it|^You pull at|^You should untie
		send get %GetC
		matchwait 5
		goto ERROR
	}
	return
	
NoCarver:
echo ##############################
echo # Missing your knife?
echo # Could not find carving knife
echo ##############################
return	

GetKeyblank:
	var Last GetKeyblank
	matchre WAIT ^\.\.\.wait|^Sorry\,
	matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
	matchre HoldIt ^But that is already in your inventory\.
	matchre RETURN ^You get .*\.
	matchre RETURN ^You pick up .*\.
	matchre RETURN ^You are already holding that\.
	matchre ERROR ^You need a free hand 
	matchre NoKeyblank ^Get what\?
	matchre NoKeyblank ^I could not find what you were referring to\.
	matchre NoKeyblank ^What were you referring to\?
	matchre RETURN ^You grab .*(?:\.|\!|\?)
	send get my %KeyblankType keyblank from my %KeyblankContainer
	matchwait 5
	return
	goto ERROR
	
NoKeyblank:
	if matchre("%KeyblankContainer", "pocket") then goto nextpocket
echo ########## Out of Keyblanks
echo ########## Done Carving
goto end
	
nextpocket:
	var LAST nextpocket
	matchre dumpit ^There is nothing in there\.
	matchre GetKeyblank multitude of 
	matchre GetKeyblank you see a (.*) keyblank
	matchre OPEN ^That is closed\.
	matchre ERROR ^I could not find
	send look in my %KeyblankContainer
	matchwait 10
	goto error

dumpit:
	pause .01
	pause .01
	send get my pocket
	pause .1
	pause .01
	gosub trash %KeyblankContainer
	var open 0
	goto PrepDone

HoldIt:
	var Last HoldIt
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre RETURN ^You sling .*\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You take .*\.
     matchre RETURN ^You pull .*\.
     matchre RETURN ^You remove .*\.
     matchre RETURN ^You loosen .*\.
     matchre RETURN ^You remove .* from your belt\.
     matchre RETURN ^You are already holding that\.
     matchre ERROR ^Get what\?
     matchre ERROR ^Hold hands with whom
     matchre RETURN ^You work your way out of
     matchre RETURN ^You aren't
     matchre ERROR ^I could not find what you were referring to\.
     matchre ERROR ^What were you referring to\?
	send hold %Get
	matchwait 5
	put #echo >$Log Crimson $datetime MISSING MATCH IN HOLDIT! 
	put #echo >$Log Crimson $datetime HOLDIT = %Get
	put #log $datetime MISSING MATCH IN HOLDIT
	return

Carve:
	var Last Carve
	matchre WAIT ^\.\.\.wait|type ahead
	matchre return With careful trimming
	matchre error It would be better to find a creature to carve or specify which tool you want to carve with
	matchre return \b%lockpick
	matchre injured too injured
	matchre start snaps like a twig
	matchre Carve_1 Roundtime
	send carve my keyblank with my knife 
	matchwait 10

Carve_1:
	pause .01
	pause .01
	var Last Carve_1
	matchre WAIT ^\.\.\.wait|type ahead
	matchre return With careful trimming
	matchre error It would be better to find a creature to carve or specify which tool you want to carve with
	matchre return \b%lockpick
	matchre start snaps like a twig
	matchre Carve_1 Roundtime
	send carve my lockpick with my knife 
	matchwait 10

WAIT:
     pause 0.0001
     pause 0.1
     goto %Last

finish: 
	pause .01
	pause .01
	if ("%RingContainer" = "worn") then gosub WornRing
	if ("%RingContainer" != "worn") then gosub PutIt
	pause .01
	pause .01
	return

WornRing:
	matchre start You put
	var Last WornRing
	matchre WAIT ^\.\.\.wait|type ahead
	matchre error You can't put that there\!
	matchre StowBadLockpick ^You don\'t think you should put different kinds of lockpicks on the same lockpick ring
	matchre full The lockpick ring already has as many lockpicks on it as you can get to fit
	matchre error What were you
	matchre error You can't
	send put my lockpick on my ring
	matchwait 10
	return
	
PutIt:
	pause 0.1
	var Last PutIt
	matchre WAIT ^\.\.\.wait|type ahead
	matchre start You put
	matchre error You can\'t put that there\!
	matchre StowBadLockpick You don't think you should put different kinds of lockpicks on the same lockpick ring
	matchre full The lockpick ring already has as many lockpicks on it as you can get to fit
	matchre error What were you
	send put my lock on my lockpick ring in my %RingContainer
	matchwait 10
	return
	 
StowBadLockpick:
	var Last StowBadLockpick
	matchre WAIT ^\.\.\.wait|type ahead
	matchre RETURN ^You put
	matchre error What were you
	send stow lockpick
	matchwait 3
	return

ClearHands:
	gosub StowRight
	gosub StowLeft
	return

StowLeft:
     if "$lefthandnoun" != "" then
        {
		 if matchre("%Carver", "$lefthandnoun") then 
               {
               if %Tie = 1 then 
                    {
                    var Tie 0
					pause 0.5
                    send tie my $lefthandnoun to my %CarverStorage
                    pause 0.5
                    }
				else send put my %Carver in my %CarverStorage
			   }
		send stow left
		}
	return
     
StowRight:
     if "$righthandnoun" != "" then
        {
		 if matchre("%Carver", "$righthandnoun") then 
               {
               if %Tie = 1 then 
                    {
                    var Tie 0
					pause 0.5
                    send tie my $righthandnoun to my %CarverStorage
                    pause 0.5
                    }
				else send put my %Carver in my %CarverStorage
			   }
		send stow right
		}
	return

Trash:
	 
	var Last Trash
	pause .01
	pause .01
	matchre WAIT ^\.\.\.wait|type ahead
	matchre RETURN ^You put
	matchre error What were you
     if !matchre("%trash", "(NULL|gelapod)") then
          {
               pause 0.2
               if matchre("$righthandnoun","pocket") then put put my pocket in %trash
               if matchre("$lefthandnoun","pocket") then put put my pocket in %trash
               pause 0.5
          }
     if matchre("%trash", "gelapod") then
          {
               pause 0.2
               if matchre("$righthandnoun","pocket") then put feed my pocket to gelapod
               if matchre("$lefthandnoun","pocket") then put feed my pocket to gelapod
               pause 0.5
          }
	matchwait 5
return

Injured:
ECHO ################### TOO INJURED
ECHO ################### GET HEALED
goto end

Error:
ECHO ################### UNKNOWN ERROR
goto end

full:
gosub ClearHands
ECHO ################### DONE CARVING
ECHO ################### Lockpick Ring Full
goto end


return:
return

end:
