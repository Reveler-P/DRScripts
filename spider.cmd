## Reveler's HE Spider Gift Script
## 05/25/2020 
## Version 2.1
##  - Bug fixes and robustification
##
##
## 12/30/19
##	- Created variables for your tarantula - update your variable if you've gotten your tarantula altered
##  - Adjusted wait time due to early activation to tie to the game output
## 11/21/19
##  - Reduced wait time when not enough learning and too early activation
##  - Fixed bug where it would lose track of itself if the last skill checked was in the prior skillset activated
## 
## MUST BE NAMED spider.cmd IN YOUR SCRIPTS FOLDER

debug 10
## NOTE: if you want your pool absorption turned OFF you must do this manually!
##################################################

## Set your chosen minimum learning rate for sacrificing skills
var LearningRate 33
if matchre("$charactername", "(XXXXXXX|XXXXXXX)") then goto end

if ("$charactername" = "XXXXXXX") then 
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Inner_Fire|Augmentation|Arcana
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
#var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors
}

if ("$charactername" = "XXXXXXX") then 
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Primary_Magic|Arcana
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning|Outdoorsmanship
var Armors.skillstocheck Defending|Shield_Usage|Light_Armors
var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors|Weapons
}

if ("$charactername" = "XXXXXXX") then 
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Primary_Magic|Arcana
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning|Outdoorsmanship
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors|Weapons
}

if ("$charactername" = "XXXXXXX") then
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Inner_Fire|Augmentation|Arcana
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
#var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors
}
if ("$charactername" = "XXXXXXX") then
{
##  Set your tarantula noun if you had it altered
var tarantula orbweaver

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Primary_Magic|Augmentation
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors|Weapons
}
if ("$charactername" = "XXXXXXX") then
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
var Magic.skillstocheck Primary_Magic|Augmentation
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Magic|Lore|Survival|Armors|Weapons
}
if ("$charactername" = "XXXXXXX") then
{
##  Set your tarantula noun if you had it altered
var tarantula tarantula

##  Set your chosen skills to sacrifice below, use ExpTracker output
#var Magic.skillstocheck Primary_Magic|Augmentation
var Lore.skillstocheck Appraisal|Tactics
var Survival.skillstocheck Perception|Skinning
var Armors.skillstocheck Defending|Shield_Usage|Light_Armor
var Weapons.skillstocheck Melee_Mastery|Missile_Mastery

##  Set your pools to fill - Match the skills above
var PoolsToFill Lore|Survival|Armors|Weapons
}

##################################################
## Do not change anything below this line
## Counters and other variables
if !def(SpiderLastPool) then put #var SpiderLastPool NULL
var PoolsToFillCount 0
action put #var SpiderSacrifice $1;put #var SpiderLastPool $2;put #echo >log cyan Tarantula: Sacrificed $1 for $2 pool when It is mere moments afterward that you feel an itching\, tingling\, and crawling sensation all across the inside of your skull\.  In a mind-wracking flurry of sensation\, you find yourself forgetting your recent progress on (.*)\, but somehow unbidden knowledge into other (.*) tasks are mapped into your psyche\.$



eval TotalPools count("%PoolsToFill", "|")

# sets the counters for each of the pools to check the skills being sacrificed
getskillcounts:
{
	eval Total.%PoolsToFill(%PoolsToFillCount) count ("%%PoolsToFill(%PoolsToFillCount).skillstocheck", "|")
	if (%PoolsToFillCount < %TotalPools) then
	{
		math PoolsToFillCount add 1
		goto getskillcounts
	}
	var PoolsToFillCount 0
}
var lastaction $lastcommand
gosub getskill


spidertimer:
pause 610
var lastaction $lastcommand
gosub getskill
goto spidertimer
 
 
getskill:
var skillcounter 0
var sacrifice NULL
var Checked 0
var checkPools %PoolsToFill
var beginningPool %PoolsToFillCount
eval checkPools replacere("%checkPools", "$SpiderLastPool", "")
eval checkPools replacere("%checkPools", "\|+", "|")
eval checkPools replacere("%checkPools", "^\|", "")
eval checkPools replacere("%checkPools", "\|$", "")
eval TotalPoolstoCheck count("%checkPools", "|")
getskill_1:
var temppool %checkPools(%PoolsToFillCount)
if (%Checked > %TotalPoolstoCheck) then goto noskills
var tempskill %%checkPools(%PoolsToFillCount).skillstocheck(%skillcounter)
var tempnumberskills %Total.%checkPools(%PoolsToFillCount)
if (($%tempskill.LearningRate >= %LearningRate) then
{
    var sacrifice %tempskill
    goto getskill_2
}
if (($%tempskill.LearningRate < %LearningRate) && ("%sacrifice" = "NULL")) then
{
    if (%PoolsToFillCount < %TotalPoolstoCheck) && (%skillcounter >= %tempnumberskills) then
    {
        var skillcounter 0
        math PoolsToFillCount add 1
        math Checked add 1
        if ((%PoolsToFillCount > %TotalPoolstoCheck)&&(%TotalPoolstoCheck >= %Checked)) then var PoolsToFillCount 0
        goto getskill_1
    }
    if (%skillcounter < %tempnumberskills) then
    {
        math skillcounter add 1
        goto getskill_1
    }
    if (%PoolsToFillCount >= %TotalPoolstoCheck) then
    {
        var skillcounter 0
		var PoolsToFillCount 0
		if (%Checked >= %TotalPoolstoCheck) then goto noskills
		goto getskill_1
    }
}
getskill_2:
eval sacrifice replacere("%%checkPools(%PoolsToFillCount).skillstocheck(%skillcounter)", "_", " ")
goto activatespider
 
activatespider:
    put #script pause all except spider
    pause .1
    activatespider_1:
    matchre activatespider_1 ^\.\.\.wait|^Sorry\,|^Please wait\.
    matchre activatespider_1 ^You don't seem to be able to move to do that
    matchre activatespider_1 ^You can't do that while entangled in a web
    matchre activatespider_1 ^You are still stunned
	matchre lastskillseterror ^However\, your changes fail to lock into place\.|^\[You need to vary which skillset you select with every use\.
	matchre badskill ^What skill did you want to attune
	matchre activatespider_2 ^You fiddle with the tiny levers and dials
    put turn my %tarantula to %sacrifice
    matchwait 5
    activatespider_2:
    matchre lastskillseterror ^\[You need to vary which skillset you select with every use\.
    matchre lastskillseterror ^You try\, but it does nothing.
    matchre activatespider_2 ^\.\.\.wait|^Sorry\,|^Please wait\.
    matchre activatespider_2 ^You don't seem to be able to move to do that
    matchre activatespider_2 ^You can't do that while entangled in a web
    matchre activatespider_2 ^You are still stunned
    matchre resume It is mere moments afterward that you feel an itching
    matchre tooearly ^You try\, but the (.+) is unresponsive\.  It needs approximately ([0-9]) roisaen to generate enough venom again.
    put rub my %tarantula
    matchwait 5
    pause .1
    resume:
    put #script resume all
    math PoolsToFillCount add 1
    if  (%PoolsToFillCount > %TotalPoolstoCheck) then var PoolsToFillCount 0
    goto spidertimer

badskill:
put #var SpiderLastPool NULL
put #script resume all
pause .1
put %lastaction
goto getskill
 
lastskillseterror:
put #var SpiderLastPool %checkPools(%PoolsToFillCount)
put #script resume all
pause .1
put %lastaction
goto getskill
 
noskills:
put #echo >log cyan Tarantula: No skills with enough learning - checking in 3 minutes
var PoolsToFillCount %beginningPool
var Checked 0
pause 180
var lastaction $lastcommand
goto getskill
 
 
tooearly:
var minutes $2
if (%minutes = 0) then 
{
	var wait 60
	var minutes 1
}
else evalmath wait %minutes * 65
put #echo >log cyan Tarantula: Activated too early - trying again in about %minutes minutes
put #script resume all
put %lastaction
pause %wait
var lastaction $lastcommand
goto getskill
 
end: