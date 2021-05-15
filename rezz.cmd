## Reveler's REZZ script
## Any problems, find me on discord REVELER#6969
## Ver 4/13/2021
## USE: You must use the full name of the person being rezzed.  input .rezz charactername


### Your Variables Here

### Variables for Spell Casting
## Put your spell prep message below - a number have been added, but if yours is different, you'll need to put it here
var SpellPrep ^You begin chanting .* to invoke the .* spell\.

### Variables for putting POM up
## cast POM, true or false
var CastPOM true
## adjective plus noun of your ritual focus
var RitualFocus staff
## worn ritual focus, true or false
var FocusWorn false
## Amount of cast for POM
var POMCast 500
## Do you want POM in your orb? True or False
var POMInOrb true

### Variables for mana amounts
var RezzMana 15
var RejuvMana 30
var SBMana 20

## How fast do you cast Rejuv and SB?  MUST BE A NUMBER, if greater than 25 will wait for full prep
var SnapRejuv 10
var SnapSB 10


#debug 10

################### DO NOT TOUCH BELOW HERE ###################
var Patient %1
var Rejuv 0
var Bond 0
var Mana 0
var Spirit 0
var Favors 1

if ("%Patient" = "") then 
{
echo ###### .rezz [charactername] to use
exit
}


Actions:
	action var Nimbus $1 when ^A thin (.*) nimbus surrounds (?i)%Patient
	action var Nimbus $1 when a thin (.*) nimbus flickers into view around (?i)%Patient
	action var Nimbus 0 when ^The thin silver nimbus shrouding .*(?i)%Patient.* body fades away\.
	action var Bond 0 when ^A shroud of vapor rises from .*(?i)%Patient.* corpse
	action var Bond 0 when ^(His|Her) soul is not bound
	action var Bond 1 when ^(His|Her) soul is bound|^(?i)%Patient is outlined by a silvery corona for a moment.
	action var Favors 0 when has no favor with
	action var Spirit 1 when the spirit of (?i)%Patient in the Void\.
	action var SpellPrepped 1 when ^You feel fully prepared

Master:
	gosub Body
	if %Favors = 0 then goto Rejuve 
	if ($SpellTimer.PersistenceofMana.active = 0) && matchre("%CastPOM", "(?i)true") then gosub POM
	gosub Rejuve
	if ($SpellTimer.Resurrection.active = 0) then gosub Rezz %RezzMana
	gosub Infuse
	gosub Bond
	goto Gesture

Body:
	send perc %1 
	pause
	return

POM:
	if ($mana < 50) || ($concentration < 80) then gosub MANAWAIT
	matchre POM ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre POM ^You don't seem to be able to move to do that
	matchre POM ^You can't do that while entangled in a web
	matchre POM2 %SpellPrep
	var SpellPrepped 0
	put prep pom %POMCast
	matchwait 10
	goto POM
POM2:
	gosub get %RitualFocus
	gosub put invoke %RitualFocus
POM3:
    if (%SpellPrepped = 1) then goto POM4
    matchre POM4 ^You feel fully prepared to cast your spell\.
    matchre POM ^Your concentration slips for a moment\, and your spell is lost\.
	matchwait %
	goto POM3
POM4:
	matchre POM5 ^Your spell finally takes full shape
	if matchre("%POMInOrb", "(i?)true") then put touch orb
	put cast
	matchwait 20
	goto POM4
POM5:
	gosub put stow %RitualFocus
	return

Rezz:
	if ($mana < 50) || ($concentration < 80) then gosub MANAWAIT
	var LAST Rezz
	matchre Rezz ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre Rezz ^You don't seem to be able to move to do that
	matchre Rezz ^You can't do that while entangled in a web
	matchre Rezz ^You are still stunned
	matchre BadRoom ^Something in the area interferes
	matchre StopPlay ^You should stop
	matchre Rezz2 %SpellPrep
	matchre Rezz2 ^But you're already
	matchre Rezz2 ^You are already preparing the .* spell\!
	put prep rezz %RezzMana
	matchwait 25
Rezz2:
	matchre Rezz2 ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre Rezz3 ^You feel fully prepared to cast your spell\.
	matchre Rezz ^You don\'t have a spell
	matchwait 25
	goto Rezz2
Rezz3:
	matchre Rezz3 ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre RETURN ^You gesture
	matchre Rezz ^You don\'t have a spell
	put cast 
	matchwait 25
	goto Rezz

StopPlay:
	put stop play
	goto %LAST

BadRoom:
	echo BAD ROOM FOR REZZING - NO CASTING.  MOVE!
	exit

Infuse: 
	if ($mana < 50) || ($concentration < 80) then gosub MANAWAIT
	if ($Attunement.Ranks < 550) then 
	{
		matchre Manawait ^Strain though
		send harness %RezzMana
		matchwait 1
	}
Infuse2:
	matchre Infuse2 ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre Infuse2 ^You don't seem to be able to move to do that
	matchre Infuse2 ^You can't do that while entangled in a web
	matchre Infuse2 ^You are still stunned
	matchre Infuse3 ^You tap
	matchre Manawait ^Strain though
	put infuse rezz %RezzMana
	math Mana add %RezzMana
	matchwait 5
Infuse3:
	if (%Spirit = 1) then return
	if $mana < 50 then gosub Manawait
	goto infuse


Manawait:
	put release mana
	pause 20
	echo Waiting for mana and concentration to regenerate
	return

Rejuve: 
	matchre REJUVE ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre REJUVE ^You don't seem to be able to move to do that
	matchre REJUVE ^You can't do that while entangled in a web
	matchre REJUVE2 %SpellPrep
	matchre REJUVE2 ^You are already preparing the .* spell\!
	matchre BadRoom ^Something in the area interferes
	var SpellPrepped 0
	put prep rejuv %RejuvMana
	matchwait 20
Rejuve2:
	if (%SpellPrepped = 1) then goto CAST
	matchre REJUVE3 ^You feel fully prepared to cast your spell\.
	matchre REJUVE ^Your concentration slips for a moment\, and your spell is lost\.
	matchwait %SnapRejuv
	if %SnapRejuv <= 25 then goto Rejuve3
	goto Rejuve2
Rejuve3:
	matchre Rejuve3 ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre Rejuve4 ^You gesture
	matchre REJUVE ^You don\'t have a spell
	put cast %Patient
	matchwait 25
    goto Rejuve3
Rejuve4:
	if ("%Nimbus" != "silver") then goto Rejuve
	if (%Favors = 0) then goto NoFavors
	return


Bond: 
	matchre Bond ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre Bond ^You don't seem to be able to move to do that
	matchre Bond ^You can't do that while entangled in a web
	matchre Bond2 %SpellPrep
	matchre Bond2 ^You are already preparing the .* spell\!
	var SpellPrepped 0
	put prep SB %SBMana
	matchwait 20
	goto Bond
Bond2:
	if (%SpellPrepped = 1) then goto CAST
	matchre Bond3 ^You feel fully prepared to cast your spell\.
	matchre Bond ^Your concentration slips for a moment\, and your spell is lost\.
	matchwait %SnapSB
	if %SnapSB <= 25 then goto Bond3
	goto Bond2
Bond3:
	matchre Bond3 ^\.\.\.wait|^Sorry,|^You are still stunned\.
	matchre RETURN ^You gesture
	matchre Bond ^You don\'t have a spell
	put cast %Patient
	matchwait 25
    goto Bond3


NoFavors:
	send whisper %Patient Your memories are protected, but you have no favors.  You may depart and I will remain with your grave.
	exit

Gesture: 
	if ("%Nimbus" != "silver") then goto Rejuve
	if (%Bond = 0) then goto Bond
	put gesture %Patient 
	echo ###### MANA USED %Mana
	exit

PUT:
	var put $0
PUT1:
    if ($stunned) then waiteval (!$stunned)
	matchre PUT1 ^\.\.\.wait|^Sorry,|^Please wait\.|^You are still stunned\.
    matchre RETURN ^You sling|^You attach|^You attempt to relax|^You rummage|^What were|^You sell|^You get|^You put
	put %put
	matchwait 5
	return

GET:
     var get $0
     var LOCATION GET1
     GET1:
     pause 0.001
     matchre GET1 ^\.\.\.wait|^Sorry\,|^You are still stunned\.
     matchre GET1 ^You don't seem to be able to move to do that
     matchre GET1 ^You can't do that while entangled in a web
     matchre GET1 ^You are still stunned
     matchre REMOVE ^But that is already in your inventory\.
     matchre RETURN You'?r?e? (?:hand|slip|put|get|.+ to|.+ fan|can't|leap|tug|quickly|dance|gracefully|reverently|breathe|switch|deftly|swiftly|untie|sheathe|strap|slide|desire|raise|sling|pull|drum|trace|wear|tap|recall|press|hang|gesture|push|move|whisper|lean|tilt|cannot|mind|drop|drape|loosen|work|lob|spread|not|fill|will|now|slowly|quickly|spin|filter|need|shouldn't|pour|blow|twist|struggle|place|knock|toss|set|add|search|circle|fake|weave|shove|try|must|wave|sit|fail|turn|already|glance|bend|swing|chop|bash|dodge|feint|draw|parry|carefully|quietly|sense|begin|rub|sprinkle|stop|combine|take|decide|insert|lift|retreat|load|fumble|exhale|yank|allow|have|are|wring|icesteel|scan|vigorously|adjust|bundle|ask|form|lose|remove|accept|pick|silently|realize|open|grab|fade|offer|tap|aren't|kneel|don\'t|close|let|find|attempt|tie|roll|attach|feel(?! fully rested)|read|reach|gingerly|come|effortlessly|corruption|count|secure|detach|unload|briefly|zills|remain|release|shield) .*(?:\.|\!|\?)?
     send get %get
     matchwait 5
     return
	 
WAITPREPARED:
    if (%SpellPrepped = 1) then goto CAST
    matchre RETURN ^You feel fully prepared to cast your spell\.
    matchre LASTSPELL ^Your concentration slips for a moment\, and your spell is lost\.
	matchwait 25
	goto WAITPREPARED

RETURN:
	return