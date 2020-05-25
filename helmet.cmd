#  Reveler's Su Helmas Script
#  For the quick run
#  Start standing in front of the empath


#debug 10
### SET YOUR TRASH HERE - CAREFUL WITH MATCHES - if you don't want to match "oilcan" make sure your "oil" has \b at the end!  Do not leave empty - if keeping everything set to NULL
var SHtrash oil\b|oilcan
var lootcontainer shadow
var contractcontainer backpack
var weapon stiletto

action var action search when tickle at the frayed edges of sanity
action var action move darkness when stir within it may have other things in mind
action var action smite when The seed might well be the only thing in the world right now, as you slowly threaten to
action var action meditate when but it's certainly enough to make someone scream\, too
action var action climb when granite slab at the center of the sunken pit
action var action dodge when past the vines you see a lit chamber beckoning
action var action crawl when little sense moving forward until this is dealt with
if matchre("$guild", "(Commoner|Barbarian|Thief)") then action var action break when magical barrier blocks further travel down the cold passageway
if matchre("$guild", "(Bard|Cleric|Empath|Moon Mage|Necromancer|Paladin|Ranger|Trader|Warrior Mage)") then action var action invoke when magical barrier blocks further travel down the cold passageway
action put #echo >log Blue Su Helmet Loot: $2 when guide shoves (a|some) (.*) into

Begin:
	if !matchre("$roomobjs", "empath") then goto WRONGROOM
Begin1:
	matchre Begin1 ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre WeaponLost ^Get what\?|^I could not find what you were referring to\.	
	matchre Redeem ^You get|^With a flick|^You deftly|You are already holding that
	put get my %weapon
	matchwait 5
	goto Weaponerror

Redeem:
	matchre Redeem ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre Redeem1 ^You get a Su Helmas contract|^You are already|^You get a handful of Su Helmas contracts|^You get a stack of Su Helmas contracts
	matchre ALLOUT ^Get what\?|^I could not find what you were referring to\.|^What were you referring to\?
	put get contract from my %contractcontainer
	matchwait 5
Redeem1:
	matchre Redeem1 ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre ALLOUT ^Get what\?|^I could not find what you were referring to\.
	matchre Redeem2 ^Once you redeem this
	put redeem contract
	matchwait 5
Redeem2:
	matchre Redeem2 ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre ALLOUT ^Get what\?|^I could not find what you were referring to\.
	matchre PuzzleRun ^The violet empath takes
	put redeem contract
	matchwait 5

PuzzleRun:
	if matchre("$righthand $lefthand", "contract(s?)") then put put contract in my %contractcontainer
	matchre PuzzleRun ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre Looper \[Beneath Su Helmas\]
	put join empath
	matchwait 3
	
Looper:
	matchre Looper ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre Move ^You hesitate at the edge of the light
	matchre Looper ^\[Beneath Su Helmas\]
	matchre Looting ^Your guide enthusiastically greets you as you return
	put %action
	matchwait 10
	goto Looper

Move:
	matchre Move ^\.\.\.wait|^Sorry\,|^Please wait\.
	matchre Move ^You hesitate at the edge of the light
	matchre Looper ^\[Beneath Su Helmas\]
	put %action
	matchwait 10
	goto Looper

Looting:
	pause .5
	if matchre("$lefthandnoun", "(%SHtrash)") then put empty left
	if !matchre("$lefthandnoun", "(%SHtrash)") then put put $lefthandnoun in my %lootcontainer
	pause 3
	goto Redeem


WRONGROOM:
echo ##############################
echo ##############################
echo #### ARE YOU IN THE ROOM WITH THE EMPATH??
echo ##############################
echo ##############################
goto end

ALLOUT:

echo ##############################
echo ##############################
echo #### YOU ARE OUT OF CONTRACTS
echo ##############################
echo ##############################
goto end

Weaponerror:

echo ##############################
echo ##############################
echo #### Problem with your weapon variable?
echo ##############################
echo ##############################
goto end


end: