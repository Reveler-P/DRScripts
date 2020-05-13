# Reveler Favor Script
# Array management by VTCifer
# Clickable functions from PELIC
# 
# Clickable - select the god you want
# Works in crossing area/zoluren only
# Will use global variable for favorgod and watercontainer.  Default water container is chalice.  Set globals if you want something different
# Use: For multiple favors enter argument number after .altarfavors like so: .altarfavors 6 - will get 6 primers from your favorgod.  Default is 2 favors.
# Will stop after you use up all your field experience UNLESS you have the global variable favorcontinue turned ON


#debug 10


WHEREAT:
if !matchre("\b($zoneid)\b", "\b(1|1a|2|2a|4|4a|6|7|8|9|9a|9b|10|11|13)\b") then
{
	echo ########################################
	echo     Must be run in/near Crossing
	echo     Not in Crossing or nearby
	echo ########################################
	goto end
}

VARIABLES:
	put #var automapper.typeahead 0

	if_1 then var favors %1
	else var favors 2
	var primeramount %favors
	
	#USER VARIABLES - Adjust your global variables, do not adjust these variables
	# favorcontinue will continue gathering EXP and sacrificing orbs until it collects the number of favors you have requested.  Can be YES or NO
	if !def(favorcontinue) then var continue NO
	else var continue $favorcontinue
	if !def(watercontainer) then var watercontainer chalice
	else var watercontainer $favorwatercontainer	
	
	#SCRIPT VARIABLES
	var orbcount 0
	var finishedorbs 0
	var noexp 0
	var shamanrooms 47|46|43|48|42|44|45|41|40|39|38|49|50|51

	var god god|kertigen|hodierna|meraud|damaris|everild|truffenyi|hav'roth|eluned|glythtide|tamsine|faenella|chadatru|urrem'tier|divyaush|berengaria|firulf|phelim|kuniyo|alamhif|peri'el|lemicus|saemus|albreda|murrula|rutilor|eylhaar|zachriedek|asketi|kerenhappuch|dergati|trothfang|huldah|ushnish|drogor|be'ort|harawep|idon|botolf|aldauth
	var aspect aspect|raven|unicorn|wolf|panther|boar|ox|cobra|dolphin|ram|cat|wren|lion|scorpion|welkin|cow|owl|nightengale|wolverine|magpie|kingsnake|albatross|donkey|dove|phoenix|mongoose|jackal|raccoon|adder|shrew|shrike|centaur|weasel|viper|shark|coyote|spider|heron|goshawk|vulture
	var altar altar|altar|altar|altar|altar|altar|altar|altar|altar|altar|altar|altar|altar|altar|iron altar|sandstone altar|marble altar|marble altar|walnut altar|marble altar|sandalwood altar|driftwood altar|small altar|modest altar|ash altar|granite altar|lacewood altar|rusty altar|heavy altar|lacquered altar|alabaster altar|iron altar|mistwood altar|basalt altar|crude altar|metal altar|bloodwood altar|marble altar|basalt altar|ironwood altar

	if !def(favorgod) then gosub SELECTGOD
	eval favorgod tolower($favorgod)
	if (!matchre("%favorgod", "\b%god\b") then
	{
		echo ########################################
		echo     Error with your favorgod: "$favorgod"
		echo     create a global variable with
		echo     #var favorgod [nameofgod]
		echo     Remember to include ' if necessary
		echo ########################################
	}
	
	gosub GETASPECT
	
GO:
	gosub CONTAINERCHECK
	gosub ORBCHECK
	gosub PRIMERCHECK
	gosub GETCOIN

GETPRIMERS:
	if (%primeramount <= 0) then goto GOTOTEMPLE
	gosub TRAVEL dirge
	gosub FINDSHAMAN
	gosub BUYPRIMERS

GOTOTEMPLE:
	if ("$zoneid" != "1") && ("$zoneid" != "2a") then gosub TRAVEL crossing
	if ("$zoneid" != "2a") then gosub AUTOMOVE temple
GETHOLYWATER:
	gosub AUTOMOVE holy
	gosub WATERCHECK
GOTOALTAR:
	gosub AUTOMOVE %favorgod
ORBCYCLE:
	if (%orbcount > 0) then gosub GETMYORB
	if (%orbcount > 0) && (%finishedorbs >= %favors) && (%noexp != 1) then goto ORBCYCLE
	if (%orbcount = 0) && (%noexp != 1) && (%finishedorbs < %favors) then gosub SACRIFICE
	if (%noexp = 1) && matchre("%continue", "(?i)yes") then goto GETEXP
	if (%noexp = 1) && !matchre("%continue", "(?i)yes") then goto DONE
	if (%finishedorbs >= %favors) then goto DONE
	goto ORBCYCLE

GETEXP:
	if !matchre("%continue", "(?i)yes") then goto DONE
	gosub AUTOMOVE 12
	put stow left
	pause .2
	put stow right
	pause .2
	put .collect rock
	waitfor mind lock
	put #script abort collect
	var noexp 0
	goto GOTOALTAR

DONE:
	echo *************************
	if (%noexp = 1) then echo   Ran out of EXP to fill orbs!
	echo   DONE! Got %finishedorbs favors!
	echo *************************
	goto END

####################################################
GETASPECT:
	var Base.Array god
	var Base.SearchItem %favorgod
	var Base.ReturnVal index
	   
	if !matchre("%%Base.Array", "(.*(?:\||^)%Base.SearchItem)(?:\||$)") then var %Base.ReturnVal Null
	else
	{
		var substring_element $1
		eval %Base.ReturnVal count ("%substring_element","|")
	}
	return

CONTAINERCHECK:
	matchre RETURN ^You tap
	matchre CONTAINERERROR ^I could not find what you were referring to\.
	put tap %watercontainer
	matchwait
CONTAINERERROR:
	echo ************************************
	echo ERROR WITH WATER CONTAINER!
	echo BUY A CHALICE
	echo ************************************
	goto END
	
TRAVEL:
	var Travel.Loc $1
	pause 0.1
	if matchre("$guild", "%MAGICUSER") then gosub RELEASE cyclic
	pause 0.1
TRAVEL1:
	matchre TRAVEL_ARRIVED ^YOU ARRIVED\!
	send .travel %Travel.Loc
	matchwait 2000
	goto TRAVEL1
TRAVEL_ARRIVED:
	return

AUTOMOVE:
     delay 0.0001
     action (moving) on
     action (moving) var Moving 1 when Obvious (path|exits)|Roundtime|You step
     var Moving 0
     var randomloop 0
     var Destination $0
     var automovefailCounter 0
     if ($hidden = 1) then gosub UNHIDE
     if ($standing = 0) then gosub AUTOMOVE_STAND
     if ($roomid = 0) then gosub RANDOMMOVE
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     pause 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchre AUTOMOVE_FAILED ^You don\'t seem
     put #goto %Destination
     matchwait 4
     if (%Moving = 0) then goto AUTOMOVE_FAILED
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchwait 160
     goto AUTOMOVE_FAILED
AUTOMOVE_STAND:
     pause 0.1
     if ($standing = 1) then goto AUTOMOVE_RETURN
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing
     send stand
     matchwait 20
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     pause 0.1
     # put #script abort automapper
     pause 0.2
     math automovefailCounter add 1
     if (%automovefailCounter > 3) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.1
     put look
     pause 0.5
     pause 0.2
     if ($roomid = 0) || (%automovefailCounter > 2) then gosub RANDOMMOVE
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     action (moving) off
     put #echo
     put #echo >Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     return
AUTOMOVE_RETURN:
     action (moving) off
     pause 0.1
     pause 0.2
     return
### GO IN RANDOM DIRECTIONS AND DON'T BACKTRACK FROM LAST MOVED DIRECTION IF POSSIBLE
RANDOMMOVE:
     pause 0.001
     var moved 0
     var NPC.count 0
     math randomloop add 1
     if (%randomloop > 60) then
          {
               echo *** Cannot find a room exit???!! Stupid fog???
               echo *** SEND ME THE ROOM DESCRIPTION AND EXITS WHEN YOU TYPE LOOK 
               echo *** ATTEMPTING RANDOM DIRECTIONS...
               put look
               pause 0.1
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM_2
               var lastmoved null
               var randomloop 0
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM_2
               return
          }
     if matchre("$roomname","Temple Hill Manor, Grounds") then
          {
               gosub MOVE go gate
               return
          }
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then
          {
               gosub MOVE climb pine branches
               return
          }
     if matchre("$roomname","Darkling Wood, Pine Tree") then
          {
               gosub MOVE climb white pine
               return
          }
     if matchre("$roomobjs","strong creeper") then
          {
               gosub MOVE climb ladder
               return
          }
     random 1 11
     if (%moved = 1) then return
     if ((%r = 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r = 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r = 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if (%moved = 1) then return
     if ((%r = 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r = 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r = 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r = 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved = 1) then return
     if ((%r = 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r = 9) && ($out) then gosub MOVE out
     if ((%r = 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r = 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved = 1) then return
     if (%randomloop > 10) then
          {
               if ($out) then gosub MOVE out
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice") then gosub MOVE go crevice
               if matchre("$roomobjs $roomdesc","\bgate") && ("%lastmoved" != "go gate") then gosub MOVE go gate
               if matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch") then gosub MOVE go arch
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit") then gosub MOVE go exit
               if matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path") then gosub MOVE go path
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor") then gosub MOVE go trapdoor
               if matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain") then gosub MOVE go curtain
               if matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door") then gosub MOVE go door
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal") then gosub MOVE go portal
               if matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel") then gosub MOVE go tunnel
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair") then gosub MOVE climb stair
               if matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step") then gosub MOVE climb step
               if (%moved = 1) then return
               if matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel") then gosub MOVE go panel
               if matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track") then gosub MOVE go track
               if matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field") then gosub MOVE go lava field
          }
     if (%moved = 0) then goto RANDOMMOVE
     # if ($roomid = 0) then goto RANDOMMOVE
     # if $roomid == 0 then goto moveRandomDirection_2
     return
MOVE:
     delay 0.0001
     var Direction $0
     var movefailCounter 0
     var randomloop 0
     var lastmoved %Direction
MOVE_RESUME:
     matchre MOVE_RETRY ^\.\.\.wait|^Sorry\, you may only type|^Please wait\.|You are still stunned\.
     matchre MOVE_RESUME ^You make your way up the .*\.\s*Partway up\, you make the mistake of looking down\.\s*Struck by vertigo\, you cling to the .* for a few moments\, then slowly climb back down\.
     matchre MOVE_RESUME ^You pick your way up the .*\, but reach a point where your footing is questionable\.\s*Reluctantly\, you climb back down\.
     matchre MOVE_RESUME ^You approach the .*\, but the steepness is intimidating\.
     matchre MOVE_RESUME ^You struggle
     matchre MOVE_RESUME ^You blunder
     matchre MOVE_RESUME ^You slap
     matchre MOVE_RESUME ^You work
     matchre MOVE_RESUME make much headway
     matchre MOVE_RESUME ^You flounder around in the water\.
     matchre MOVE_RETREAT ^You are engaged to .*\!
     matchre MOVE_RETREAT ^You can't do that while engaged\!
     matchre MOVE_STAND ^You start up the .*\, but slip after a few feet and fall to the ground\!\s*You are unharmed but feel foolish\.
     matchre MOVE_STAND ^Running heedlessly over the rough terrain\, you trip over an exposed root and land face first in the dirt\.
     matchre MOVE_STAND ^You can\'t do that while lying down\.
     matchre MOVE_STAND ^You can\'t do that while sitting\!
     matchre MOVE_STAND ^You can\'t do that while kneeling\!
     matchre MOVE_STAND ^You must be standing to do that\.
     matchre MOVE_STAND ^You don\'t seem
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_STAND ^Stand up first.
     matchre MOVE_DIG ^You make no progress in the mud \-\- mostly just shifting of your weight from one side to the other\.
     matchre MOVE_DIG ^You find yourself stuck in the mud\, unable to move much at all after your pathetic attempts\.
     matchre MOVE_DIG ^You struggle forward\, managing a few steps before ultimately falling short of your goal\.
     matchre MOVE_DIG ^Like a blind\, lame duck\, you wallow in the mud in a feeble attempt at forward motion\.
     matchre MOVE_DIG ^The mud holds you tightly\, preventing you from making much headway\.
     matchre MOVE_DIG ^You fall into the mud with a loud \*SPLUT\*\.
     matchre MOVE_FAIL_BAIL ^You can't go there
     matchre MOVE_FAILED ^Noticing your attempt
     matchre MOVE_FAILED ^I could not find what you were referring to\.
     matchre MOVE_FAILED ^What were you referring to\?
     matchre MOVE_RETURN ^It's pitch dark
     matchre MOVE_RETURN ^Obvious
     send %Direction
     matchwait 15
     goto MOVE_RETURN
MOVE_RETRY:
     pause
     goto MOVE_RESUME
MOVE_STAND:
     pause 0.1
     matchre MOVE_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_STAND ^The weight
     matchre MOVE_STAND ^You try
     matchre MOVE_STAND ^You don\'t
     matchre MOVE_RETREAT ^You are already standing\.
     matchre MOVE_RETREAT ^You stand(?:\s*back)? up\.
     matchre MOVE_RETREAT ^You stand up\.
     send stand
     matchwait 15
     goto MOVE_STAND
MOVE_RETREAT:
     pause 0.1
     if ($invisible = 1) then gosub STOP_INVIS
     matchre MOVE_RETREAT ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_RETREAT ^You retreat back to pole range\.
     matchre MOVE_RETREAT ^You stop advancing
     matchre MOVE_RETREAT ^You try to back away
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_RESUME ^You retreat from combat\.
     matchre MOVE_RESUME ^You are already as far away as you can get\!
     send retreat
     matchwait 10
     goto MOVE_RETREAT
MOVE_DIG:
     pause 0.1
     matchre MOVE_DIG ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
     matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
     matchre MOVE_DIG_STAND ^Maybe you can reach better that way\, but you'll need to stand up for that to really do you any good\.
     matchre MOVE_RESUME ^You will have to kneel
     send dig
     matchwait 10
     goto MOVE_DIG
MOVE_DIG_STAND:
     pause 0.1
     matchre MOVE_DIG_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre MOVE_DIG_STAND ^The weight
     matchre MOVE_DIG_STAND ^You try
     matchre MOVE_DIG_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_DIG ^You stand(?:\s*back)? up\.
     matchre MOVE_DIG ^You are already standing\.
     send stand
     matchwait 10
     goto MOVE_DIG_STAND
MOVE_FAILED:
     var moved 0
     math movefailCounter add 1
     if (%movefailCounter > 3) then goto MOVE_FAIL_BAIL
     pause 0.5
     put look
     pause 0.4
     goto MOVE_RESUME
MOVE_FAIL_BAIL:
     put #echo
     # put #echo >$Log Crimson *** MOVE FAILED. ***
     put #echo Crimson *** MOVE FAILED.  ***
     put #echo
     return
MOVE_RETURN:
     var moved 1
     pause 0.001
     return
FIND_MYSELF:
MOVERANDOM:
moveRandomDirection:
     var moveloop 0
     moveRandomDirection_2:
     math moveloop add 1
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM_2
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM_2
               return
          }
     if $north then
          {
               gosub MOVE north
               return
          }
     if $northwest then
          {
               gosub MOVE northwest
               return
          }
     if $northeast then
          {
               gosub MOVE northeast
               return
          }
     if $southeast then
          {
               gosub MOVE southeast
               return
          }
     if $south then
          {
               gosub MOVE south
               return
          }
     if $west then
          {
               gosub MOVE west
               return
          }
     if $east then
          {
               gosub MOVE east
               return
          }
     if $southwest then
          {
               gosub MOVE southwest
               return
          }
     if $out then
          {
               gosub MOVE out
               return
          }
     if $up then
          {
               gosub MOVE up
               return
          }
     if $down then
          {
               gosub MOVE down
               return
          }
     if matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") then
          {
               gosub MOVE climb stair
               return
          }
     if matchre("$roomobjs $roomdesc","\bsteps\b") then
          {
               gosub MOVE climb step
               return
          }
     if matchre("$roomobjs $roomdesc","\b(exit|curtain|arch|door|gate|hole|hatch|trapdoor|path|animal trail|tunnel|portal)\b") then
          {
               gosub MOVE go $1
               return
          }
     echo *** No random direction possible?? Looking to attempt to reset room exit vars
     send search
     pause 0.4
     pause 0.2
     #might need a counter here to prevent infinite loops
     put look
     pause 0.5
     pause 0.2
     if (%moveloop > 6) then
          {
               echo *** Cannot find a room exit!! Stupid fog!
               echo *** ATTEMPTING RANDOM DIRECTIONS...
               gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM_2
               return
          }
     goto moveRandomDirection_2	

GETCOIN:
	if (%index <= 13) then var primercost 250
	if (%index > 13) && (%index <= 26) then var primercost 500
	if (%index > 26) then var primercost 750
	evalmath coinneeded %primercost * %primeramount
	matchre GETCOIN1 \((\d+) copper Kronars\)\.
	matchre GETCOIN1 Dokoras\.
	put wealth
	matchwait 5
GETCOIN1:
	if def($1) then var onhand $1
	else var onhand 0
	evalmath coinneeded %coinneeded - %onhand
	if (%coinneeded <= 0) then return
	evalmath coinneeded ceiling(%coinneeded / 10)
GETCOIN2:
	if ($zoneid != 1) then gosub TRAVEL crossing
	if ($roomid != 233) then gosub AUTOMOVE teller
	matchre RETURN ^The clerk counts out
	matchre GETCOIN2 \.\.\.wait
	matchre COINERROR ^The clerk tells you\, \"You don\'t have that much money in your account\.  I\'m sorry\, we are not lending money at this time\.\"
	put withdraw %coinneeded bronze
	matchwait 5
COINERROR:
	echo ************************************
	echo ERROR WITH COIN! CAN'T BUY PRIMERS
	echo ************************************
	goto END

ORBCHECK:
	var orbcount 0
ORBCHECK1:
	action (orbcount) math orbcount add 1 when Your (?i)%favorgod orb is
	action (orbcount) on
	pause .1
	matchre ORBCHECK2 ^You can\'t seem to find anything that looks like that\.|^Roundtime\:
	matchre ORBCHECK1 \.\.\.wait
	put inventory search orb
	matchwait 5
ORBCHECK2:
	action (orbcount) off
	evalmath primeramount %primeramount - %orbcount
	if (%primeramount <= 0) then goto GOTOTEMPLE
	return

PRIMERCHECK:
	var primercount 0
PRIMERCHECK1:
	action (primercount) math primercount add 1 when Your (?i)%aspect(%index) primer is
	action (primercount) on
	pause .1
	matchre PRIMERCHECK2 ^You can\'t seem to find anything that looks like that\.|^Roundtime\:
	matchre PRIMERCHECK1 \.\.\.wait
	put inventory search primer
	matchwait 5
PRIMERCHECK2:
	action (primercount) off
	evalmath primeramount %primeramount - %primercount
	if (%primeramount <= 0) then goto GOTOTEMPLE
	return

FINDSHAMAN:
	if $zoneid != 13 then gosub TRAVEL1
	var shamanloop 1
FINDSHAMAN1:
	action (shaman) put #script abort automapper when eval matchre("$roomobjs", "shaman")
	action (shaman) put #parse YOU HAVE ARRIVED when eval matchre("$monsterlist", "shaman")
	action (shaman) on
	var found 0
	var temp 0
	eval temp.max count("%shamanrooms","|")
	if matchre("$roomobjs", "shaman") then
	{
		unvar temp
		unvar temp.max
		action (shaman) off
		return
	}
FINDSHAMAN2:
	pause 1
	if matchre("$roomobjs", "shaman") then
	{
		unvar temp
		unvar temp.max
		action (shaman) off
		return
	}
	gosub automove %shamanrooms(%temp)
	if matchre("$roomobjs", "shaman") then
	{
		unvar temp
		unvar temp.max
		action (shaman) off
		return
	}
	math temp add 1
	if %temp > %temp.max then
	{
		math shamanloop add 1
		if %shamanloop < 3 then goto FINDSHAMAN
		echo Could not find the shaman!  Collect your own primers and re-start the script.
		exit
	}
	goto FINDSHAMAN2
	return

BUYPRIMERS:
	action (primerget) var primernumber $1 when (\d+) -- (?i)%aspect(%index)
	action (primerget) var movedirection $1 when ^A somber shaman walks placidly (\w+).
	action (primerget) on
BUYPRIMERS1:
	matchre BUYPRIMERS2 ^\[ORDER \# FROM SHAMAN\]
	matchre BUYPRIMERS1 \.\.\.wait
	matchre SHAMANMOVED ^To whom
	put ask shaman about primer
	matchwait 25
	goto BUYPRIMERS1
BUYPRIMERS2:
	pause .1
	matchre PRIMERERROR ^A somber shaman frowns and says\, \"I\'m afraid I don\'t carry that\.  If you\'d like to see what I sell\, please ask me about my list of wares or about primers\.\"
	matchre GOTPRIMER ^The shaman hands you a parchment
	matchre BUYPRIMERS2 \.\.\.wait
	put order %primernumber from shaman
	matchwait 5
GOTPRIMER:
	math primeramount subtract 1
	matchre PRIMERERROR ^Stow what
	matchre PRIMERCONTINUE ^You put
	matchre GOTPRIMER \.\.\.wait
	put stow primer
	matchwait 5
SHAMANMOVED:
	move %movedirection
	gosub FINDSHAMAN
	goto BUYPRIMERS1
PRIMERCONTINUE:
	if %primeramount > 0 then goto BUYPRIMERS2
	return
PRIMERERROR:
	echo ************************************
	echo ERROR WITH PRIMERS!
	echo ************************************
	goto END

WATERCHECK:
	matchre GETWATER ^There are .+ parts left of the holy water\.
	matchre GETWATER ^I could not find what you were referring to\.
	matchre GETWATER ^There is only one part
	put count water in %watercontainer
	matchwait 5
	goto WATERERROR
GETWATER:
	if ($roomid != 67) then gosub AUTOMOVE holy
	matchre WATERERROR ^What
	matchre GETWATER1 ^You get|^You are already
	matchre GETWATER \.\.\.wait
	put get my %watercontainer
	matchwait 5
GETWATER1:
	matchre GETWATER1 \.\.\.wait
	matchre GETWATER2 ^You fill your .* with some water\.|^There is no more room
	put fill %watercontainer with water from basin
	matchwait 5
	goto WATERERROR
GETWATER2:
	matchre GETWATER2 \.\.\.wait
	matchre RETURN ^You fill your .* with some water\.|^There is no more room
	put fill %watercontainer with water from basin
	matchwait 5
	goto WATERERROR
WATERERROR:
	echo ************************************
	echo ERROR WITH GETTING HOLY WATER!
	echo ************************************
	goto END

SACRIFICE:
	matchre GOTOIT I could not find what you were referring to. 
	matchre CLEANALTAR ^The altar looks a bit dusty
	matchre SACRIFICE \.\.\.wait
	matchre SACRIFICE1 altar
	put look %altar(%index)
	matchwait 5
	goto SACRIFICEERROR
CLEANALTAR:
	matchre SACRIFICE1 You finish your job, pleased to see
	matchre SACRIFICE1 But the altar is perfectly clean!
	matchre CLEANALTAR \.\.\.wait|^Noticing that the .* does not look any cleaner\, you furrow your brow in confusion\.  What a failure\.
	put clean %altar(%index) with my water
	matchwait 25
	goto SACRIFICEERROR
SACRIFICE1:
	matchre PRAY ^You get a parchment \w+ primer|^You are already holding
	matchre SACRIFICEERROR ^What were you referring to\?
	put get %aspect(%index) primer
	matchwait 5
	goto SACRIFICEERROR
PRAY:
	matchre PRAY1 ^You reverently place a parchment
	matchre SACRIFICEERROR ^What were you
	matchre PRAY \.\.\.wait
	put put my %aspect(%index) primer on %altar(%index)
	matchwait 5
	goto SACRIFICEERROR
PRAY1:
	matchre PRAY1 \.\.\.wait
	matchre GETTINGORB ^An overwhelming sense of contentment fills you as your offering is consumed in a blinding flash of light\.
	matchre SACRIFICE sending the \w+ primer tumbling to the ground.
	put pray
	matchwait 30
	goto SACRIFICEERROR
GETTINGORB:
	matchre GOTORB ^You get
	matchre SACRIFICEERROR ^What were you
	put get orb from %altar(%index)
	matchwait 5
GOTORB:
	math orbcount add 1
	return
SACRIFICEERROR:
	echo ************************************
	echo ERROR WITH DROPPING OFF YOUR SACRIFICE!
	echo ************************************
	goto END
GOTOIT:
	gosub AUTOMOVE %favorgod

GETMYORB:
	if matchre("$righthand $lefthand", "orb") then goto HUGORB
	matchre HUGORB ^You get|^You are already holding
	matchre GETMYORB \.\.\.wait
	matchre RETURN ^What were you
	put get my %favorgod orb
	matchwait 5
	return
HUGORB:
	matchre ORBDONE your sacrifice is properly prepared\.$
	matchre EXPOUT You sense, though, that your sacrifice is not yet fully prepared\.$|^You press the \w+ orb against your chest and feel a strange tugging\, but nothing really seems to happen\.  You sense you are lacking in the type of sacrifice the orb requires\.
	matchre BADORB You sense that this \w+ orb is not deemed worthy to hold your required sacrifice\.  Perhaps another would work at this time\?
	matchre ORBERROR Rub what?
	matchre HUGORB \.\.\.wait
	put hug my %favorgod orb
	matchwait 5
	goto ORBERROR
ORBDONE:
	matchre ORBDONE1 ^As you start to place your \w+ orb on the altar it leaps
	matchre ORBERROR ^The orb dims and seems to resist\, nearly twisting from your hand\!
	matchre ORBDONE \.\.\.wait
	put put orb on %altar(%index)
	matchwait 5
	goto ORBERROR
ORBDONE1:
	math orbcount subtract 1
	math finishedorbs add 1
	return
BADORB:
	put drop my %favorgod orb
	pause .1
	return
ORBERROR:
	echo ************************************
	echo ERROR WITH HUGGING ORBS!
	echo ************************************
	goto END
EXPOUT:
	var noexp 1
	return

SELECTGOD:
	 debug 0
     echo
     echo ***************************************************************************
     echo **    GODS             ** GUILDS                     ** RACES            **
     echo ***************************************************************************
     pause 0.3
     put #link {**  Chadatru           ** Paladins                   **                  **} {#var favorgod Chadatru;#parse CHOICE MADE!}
     put #link {**  Rutilor (light)    **                            **                  **} {#var favorgod Rutilor;#parse CHOICE MADE!}
     put #link {**  Botolf (dark)      **                            **                  **} {#var favorgod Botolf;#parse CHOICE MADE!}
     put #link {**  Damaris            ** Thieves                    **                  **} {#var favorgod Damaris;#parse CHOICE MADE!}
     put #link {**  Phelim (light)     **                            **                  **} {#var favorgod Phelim;#parse CHOICE MADE!}
     put #link {**  Dergati (dark)     **                            **                  **} {#var favorgod Dergati;#parse CHOICE MADE!}
     put #link {**  Eluned             **                            ** Elotheans        **} {#var favorgod Eluned;#parse CHOICE MADE!}
     put #link {**  Lemicus (light)    **                            **                  **} {#var favorgod Lemicus;#parse CHOICE MADE!}
     put #link {**  Drogor (dark)      **                            **                  **} {#var favorgod Drogor;#parse CHOICE MADE!}
     put #link {**  Everild            ** Barbarians                 **                  **} {#var favorgod Everild;#parse CHOICE MADE!}
     put #link {**  Kuniyo (light)     **                            **                  **} {#var favorgod Kuniyo;#parse CHOICE MADE!}
     put #link {**  Trothfang (dark)   **                            **                  **} {#var favorgod Trothfang;#parse CHOICE MADE!}
     put #link {**  Faenella           ** Bards/Paladins/Traders     ** Elves            **} {#var favorgod Faenella;#parse CHOICE MADE!}
     put #link {**  Murrula (light)    **                            **                  **} {#var favorgod Murrula;#parse CHOICE MADE!}
     put #link {**  Idon (dark)        **                            **                  **} {#var favorgod Idon;#parse CHOICE MADE!}
     put #link {**  Glythtide          ** Bards                      ** Halflings        **} {#var favorgod Glythtide;#parse CHOICE MADE!}
     put #link {**  Saemaus (light)    **                            **                  **} {#var favorgod Saemaus;#parse CHOICE MADE!}
     put #link {**  Be'ort (dark)      **                            **                  **} {#var favorgod Be'ort;#parse CHOICE MADE!}
     put #link {**  Hav'roth           **                            ** S'Kra Mur        **} {#var favorgod Hav'roth;#parse CHOICE MADE!}
     put #link {**  Peri'el (light)    **                            **                  **} {#var favorgod Peri'el;#parse CHOICE MADE!}
     put #link {**  Ushnish (dark)     **                            **                  **} {#var favorgod Ushnish;#parse CHOICE MADE!}
     put #link {**  Hodierna           ** Empaths/Clerics            **                  **} {#var favorgod Hodierna;#parse CHOICE MADE!}
     put #link {**  Berengaria (light) **                            **                  **} {#var favorgod Berengaria;#parse CHOICE MADE!}
     put #link {**  Asketi (dark)      **                            **                  **} {#var favorgod Asketi;#parse CHOICE MADE!}
     put #link {**  Kertigen           ** Traders/Thieves            ** Dwarves          **} {#var favorgod Kertigen;#parse CHOICE MADE!}
     put #link {**  Divyaush (light)   **                            **                  **} {#var favorgod Divyaush;#parse CHOICE MADE!}
     put #link {**  Zachriedek (dark)  **                            **                  **} {#var favorgod Zachriedek;#parse CHOICE MADE!}
     put #link {**  Meraud             ** Mages                      ** Elotheans        **} {#var favorgod Meraud;#parse CHOICE MADE!}
     put #link {**  Firulf (light)     **                            **                  **} {#var favorgod Firulf;#parse CHOICE MADE!}
     put #link {**  Kerenhappuch (dark)**                            **                  **} {#var favorgod Kerenhappuch;#parse CHOICE MADE!}
     put #link {**  Tamsine            **                            **                  **} {#var favorgod Tamsine;#parse CHOICE MADE!}
     put #link {**  Albreda (light)    **                            **                  **} {#var favorgod Albreda;#parse CHOICE MADE!}
     put #link {**  Harawep (dark)     **                            **                  **} {#var favorgod Harawep;#parse CHOICE MADE!}
     put #link {**  Truffenyi          ** Clerics                    ** Humans/Halflings **} {#var favorgod Truffenyi;#parse CHOICE MADE!}
     put #link {**  Alamhif (light)    **                            **                  **} {#var favorgod Alamhif;#parse CHOICE MADE!}
     put #link {**  Huldah (dark)      **                            **                  **} {#var favorgod Huldah;#parse CHOICE MADE!}
     put #link {**  Urrem'tier         **                            **                  **} {#var favorgod Urrem'tier;#parse CHOICE MADE!}
     put #link {**  Eylhaar (light)    **                            **                  **} {#var favorgod Eylhaar;#parse CHOICE MADE!}
     put #link {**  Aldauth (dark)     **                            **                  **} {#var favorgod Aldauth;#parse CHOICE MADE!}
     pause 0.3
     echo **********************************************************************
     echo
     echo Please select the God of your choice.
     echo
     waitforre ^CHOICE MADE\!
     if "$favorgod" = "NULL" then goto SELECT
CONFIRM.CHOICE:
     echo
     echo You wish to set $favorgod as your preferred god for favors?
     echo
     echo Select 'YES' to confirm, or 'NO' to refresh the list and choose again.
     echo
     echo ***********************************************
     pause 0.3
     put #link {**                     YES                   **}{#parse GOOD TO GO!}
     put #link {**                     NO                    **}{#parse RESELECT!}
     pause 0.3
     echo ***********************************************
     echo
	 debug 10
     matchre RETURN ^GOOD TO GO\!
     matchre SELECTGOD ^RESELECT\!
     matchwait



CONTAINERERROR:
	echo *************************************************************************
	echo    Something wrong with your water container - go buy a chalice
	echo *************************************************************************
	goto END

RETURN:
Return

END:
	put stow left
	pause .2
	put stow right
	pause .2
	put stand
