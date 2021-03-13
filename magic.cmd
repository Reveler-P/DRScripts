# Quick and dirty magic trainer by Reveler
# Will gradually increase or decrease mana if your spells stop training
# Discord: Reveler#6969
# March 2021
# Use with magicset.cmd

#debug 10

action var prepped 1 when ^You feel fully prepared|^You have fully prepared the
action var prepped 0 when ^With tense|^You begin chanting|your head skyward|^You raise your
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 1;var BackfireSpell $MAGIC.%skill.spell when ^Your spell barely backfires\.
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 2;var BackfireSpell $MAGIC.%skill.spell when ^Your spell backfires\.
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 3;var BackfireSpell $MAGIC.%skill.spell when ^Your spell backfires somewhat\.
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 4;var BackfireSpell $MAGIC.%skill.spell when ^Your spell badly backfires\.
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 5;var BackfireSpell $MAGIC.%skill.spell when ^Your spell horribly backfires\.
action var Backfired 1;math %skill.backfirecount add 1;var BackfireSeverity 6;var BackfireSpell $MAGIC.%skill.spell when ^Your spell hopelessly backfires\.
action var Failed 1;var FailedSpell $MAGIC.%skill.spell when ^Currently lacking the skill to complete the pattern\, your spell fails completely\.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 0 when ^The spell pattern resists the influx of .* mana and fails completely.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 1 when ^The spell pattern resists the influx of .* mana though the backlash leaves you stunned!
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 1 when ^The spell pattern resists the influx of .* mana. You are able to contain the backlash but doing so leaves your attunement to the mana streams dulled.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 1 when ^The spell pattern resists the influx of .* mana. You are able to contain the backlash but doing so results in a splitting headache.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 1 when ^The spell pattern resists the influx of .* mana though you are able to channel the worst of the backlash into your nervous system.
action var Backlashed 1; math backlashcount add 1; var BacklashSeverity 1 when ^The spell pattern resists the influx of .* mana.  You are able to contain the backlash but doing so leaves your attunement to the mana streams dulled.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 2 when ^The spell pattern resists the influx of .* mana as a strange itching sensation builds under your skin.  Geysers of uncontrolled mana suddenly erupt
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 2 when ^The spell pattern resists the influx of .* mana overloading your arcane senses in a torrent of uncontrolled power.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 2 when An instant rush of black and blue fire explodes into being, consuming your (right|left) hand and turning it into ash!
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 3 when ^The spell pattern resists the influx of .* mana and everything goes black.
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 3 when ^The spell pattern resists the influx of <mana type> mana overloading your arcane senses and rendering you magically inert.	
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 3 when An instant rush of black and blue fire explodes into being, consuming your outstretched limbs and turning them into ash!	
action var Backlashed 1;math backlashcount add 1;var BacklashSeverity 4 when Geysers of blue-black fire suddenly erupt from your body consuming you in a horrific display of unbridled sorcery.
action var %skill.spellMin $1;var %skill.spellMax $2 when ^The spell requires at minimum (\d+) .*\, for a total of (\d+) streams\.
action var %skill.spellMax 1 when ^You don't think you are able to cast this spell\.
var Augmentation.spellMax 0
var Utility.spellMax 0
var Sorcery.spellMax 0
var Warding.spellMax 0
var Augmentation.manabump 0
var Utility.manabump 0
var Sorcery.manabump 0
var Warding.manabump 0
var Augmentation.manadrop 0
var Utility.manadrop 0
var Warding.manadrop 0
var Sorcery.manadrop 0
var Augmentation.backfirecount 0
var Utility.backfirecount 0
var Warding.backfirecount 0
var Sorcery.backfirecount 0
var Backlashed 0
var backlashcount 0
var Failed 0
if_1 then var arg %1




################################################
#-Variables-#
#___________#

if ("$MAGIC.SET" != "DONE") then {
put .magicset
pause 5
if ("$MAGIC.SET" != "DONE") then goto VARERROR
}


var testskills Utility|Augmentation|Warding|Sorcery
var counter 0
cycletest:
if (matchre("$MAGIC.%testskills(%counter).spell", "(?i)(NULL|NO|NONE|NIL|0)") || ("$Magic.%testskills(%counter).spell" = "")) then put #var %testskills.exp.stop 0
put #var MAGIC.%testskills(%counter).mana {#evalmath ($MAGIC.%testskills(%counter).cast + $MAGIC.%testskills(%counter).harness + $MAGIC.%testskills(%counter).charge)}
math counter add 1
if (%counter = 4) then goto travel
goto cycletest 



#################
#-End Variables-#
###############################################



travel:
put #script pause ubercombat
put research stop
if %arg = here then goto start
if ($zoneid = 61) && ($roomid = 123) then goto start
if ($zoneid = 66) && ($roomid = 640) then goto start
if ($zoneid = 31) && ($roomid = 75) then goto start
if ($zoneid = 40) && ($roomid = 175) then goto start
if ($zoneid = 4) && ($roomid = 423) then goto start
if ($zoneid = 1) && ($roomid = 307) then goto start
if ($zoneid = 150) && ($roomid = 46) then goto start
moving:
	if $zoneid = 61 then 
	{
	put #goto 123
	matchre locationcheck ^YOU HAVE ARRIVED\!
	matchwait 600
	}
	if $zoneid = 40 then 
	{
	put #goto 175
	matchre locationcheck ^YOU HAVE ARRIVED\!
	matchwait 600
	}
	if $zoneid = 31 then 
	{
	put #goto 75
	matchre locationcheck ^YOU HAVE ARRIVED\!
	matchwait 600
	}
	if $zoneid = 150 then 
	{
	put #goto 46
	matchre locationcheck ^YOU HAVE ARRIVED\!
	matchwait 600
	}
	put .travel steelclaw 640
	matchre locationcheck ^YOU ARRIVED\!
	matchwait 600



matchloop:
if matchre ("$scriptlist", "travel") then 
	{
	matchre locationcheck ^YOU ARRIVED\!|^YOU HAVE ARRIVED\!
	matchwait 500
	goto matchloop
	}
goto end
	


locationcheck:
if ($zoneid = 61) && ($roomid = 123) then goto start
if ($zoneid = 66) && ($roomid = 640) then goto start
if ($zoneid = 31) && ($roomid = 75) then goto start
if ($zoneid = 40) && ($roomid = 175) then goto start
if ($zoneid = 4) && ($roomid = 423) then goto start
if ($zoneid = 1) && ($roomid = 307) then goto start
if ($zoneid = 150) && ($roomid = 46) then goto start
goto travel


##############################################
##############################################
start:
if ($SpellTimer.ROC.active = 1) then put release roc
start_1:
if ($Augmentation.LearningRate < $MAGIC.Augmentation.exp.stop) && ($MAGIC.Augmentation.spell != NULL) then
	{
	  gosub train Augmentation
	}
if ($Utility.LearningRate < $MAGIC.Utility.exp.stop) && ($MAGIC.Utility.spell != NULL) then
	{
	  gosub train Utility
	}
if ($Warding.LearningRate < $MAGIC.Warding.exp.stop) && ($MAGIC.Warding.spell != NULL) then
	{
	  gosub train Warding
	}
if ($Sorcery.LearningRate < $MAGIC.Sorcery.exp.stop) && ($MAGIC.Sorcery.spell != NULL) then
	{
	  gosub train Sorcery
	}
if ($Warding.LearningRate >= $MAGIC.Warding.exp.stop) && ($Utility.LearningRate >= $MAGIC.Utility.exp.stop) && ($Augmentation.LearningRate >= $MAGIC.Augmentation.exp.stop) && ($Sorcery.LearningRate >= $MAGIC.Sorcery.exp.stop) then
	{
	goto end
	}
goto start_1

train:
  var skill $1
  if $bleeding = 1 then goto BLEEDING
train2:
  var last train2
  if ("$%skill.LearningRate" = "$MAGIC.%skill.exp.stop") then return
  if $mana <= 25 then goto mana.wait
  gosub PREP
  if !matchre("$MAGIC.%skill.symbiosis","(?i)(YES|ON|1)") then put release symb
  if matchre("$MAGIC.%skill.symbiosis","(?i)(YES|ON|1)") then gosub PREP_SYMB
  gosub power
  gosub charge
  if (%prepped = 0) then waitforre ^You feel fully prepared to cast
  gosub harness
  var learningrate $%skill.LearningRate
  gosub cast
  if ($SpellTimer.OsrelMeraud.active = 1) then 
  {
  put harness 6;-2 infuse om 6
  pause 5
  }
  return

prep:
  put release mana
  pause .1
  put release $MAGIC.%skill.spell
  pause .1
  var prepped 0
  matchre prep ^\.\.\.wait|^Sorry|^You are still stunned
  matchre RETURN ^But you're already
  matchre END ^Something in the area interferes
  matchre RETURN ^With a .+ to your voice\,
  matchre RETURN ^You are already preparing the .* spell\!
  matchre RETURN ^Slow\, rich tones form a somber introduction
  matchre RETURN ^But you've already prepared the .* symbiosis\!
  matchre RETURN ^You begin chanting .* to invoke the .* spell\.
  matchre RETURN ^Images of streaking stars falling from the heavens
  matchre RETURN ^You mutter .* to yourself while preparing the .* spell\.
  matchre RETURN ^With .* movements you prepare your body for the .* spell\.
  matchre RETURN ^A strong wind swirls around you as you prepare the .* spell\.
  matchre RETURN ^You raise your .* skyward\, chanting the .* of the .* spell\.
  matchre RETURN ^You trace a .* sigil in the air\, shaping the pattern of the .* spell\.
  matchre RETURN ^You whistle an intricate sequence of notes as you prepare the .* spell\.
  matchre RETURN ^Shadow and light collide wildly around you as you prepare the .* spell\.
  matchre RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
  matchre RETURN ^You rock back and forth\, humming tunelessly as you invoke the .* spell\.
  matchre RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
  matchre RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
  matchre RETURN ^You close your eyes and breathe deeply, gathering energy for the .* spell\.
  matchre RETURN ^A soft breeze surrounds your body as you confidently prepare the .* spell\.
  matchre RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
  matchre RETURN ^Light withdraws from around you as you speak arcane words for the .* spell\.
  matchre RETURN ^You trace a geometric sigil in the air\, shaping the pattern of the .* spell\.
  matchre RETURN ^Tiny tendrils of lightning jolt between your hands as you prepare the .* spell\.
  matchre RETURN ^Heatless orange flames blaze between your fingertips as you prepare the .* spell\.
  matchre RETURN ^Entering a trance-like state\, your hands begin to tremble as you prepare the .* spell\.
  matchre RETURN ^Glowing geometric patterns arc between your upturned palms as you prepare the .* spell\.
  matchre RETURN ^You adeptly sing the incantations for the .* spell\, setting the words to a favorite tune\.
  matchre RETURN ^You gaze skyward and trace the planetary alignments in the air as you prepare the .* spell\.
  matchre RETURN ^You bring your hand slowly to your forehead as you begin chanting the words of the .* spell\.
  matchre RETURN ^Low\, hummed tones form a soft backdrop for the opening notes of the Eye of Kertigen enchante\.
  matchre RETURN ^You start frantically flailing your hands and shouting nonsensical phrases as you prepare the .* spell\.
  matchre RETURN ^You recall the exact details of the .* symbiosis\, preparing to integrate it with the next spell you cast\.
  matchre RETURN ^Icy blue frost crackles up your arms with the ferocity of a blizzard as you begin to prepare the .* spell\!
  matchre RETURN ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.
  matchre RETURN ^A radiant glow wreathes your hands as you weave lines of light into the complicated pattern of the .* spell\.
  matchre RETURN ^You giggle to yourself as you move through the syncopated gestures that accompany the preparations of the .* spell\.
  matchre RETURN ^Darkly gleaming motes of sanguine light swirl briefly about your fingertips as you gesture while uttering the .* spell\.
  matchre RETURN ^As you begin to solemnly intone the .* spell a blue glow swirls about forming a nimbus that surrounds your entire being\.
  matchre RETURN ^You begin to hum the soothing introduction to Damaris\' Lullaby\, modulating the volume of each phrase for hypnotic effect\.
  matchre RETURN ^Your skin briefly withers and tightens\, becoming gaunt as the energies of the .* spell begin to build up through your body\.
  matchre RETURN ^You trace an intricate rune in the air with your finger\, illusory lines lingering several seconds as you prepare the .* spell\.
  matchre RETURN ^You begin reciting a solemn incantation\, causing familiar patterns of geometric shapes to circle your hand as the .* spell forms\.
  matchre RETURN ^In one fluid motion\, you bring your palms close together and a fiery crimson mist begins to burn within them as you prepare the .* spell\.
  matchre RETURN ^The first gentle notes of Blessing of the Fae waft from you with delicate ease\, riddled with low tones that gradually give way to a higher\-pitched theme\.
  matchre RETURN ^Calmly reaching out with one hand\, a silvery\-blue beam of light descends from the sky to fill your upturned palm with radiance as you prepare the .* spell\.
  matchre RETURN ^You take up a handful of dirt in your palm to prepare the .* spell\.  As you whisper arcane words\, you gently blow the dust away and watch as it becomes swirling motes of ttering light that veil your hands in a pale aura\.
  matchre MANA.WAIT ^You strain
  matchre CASTFAIL ^What do you want to prepare\?
  matchre CASTFAIL ^That is not a spell you can cast\.
  matchre CASTFAIL ^You have no idea how to cast that spell\.
  matchre CASTFAIL ^You wouldn't have the first clue how to do that\.
  matchre CASTFAIL ^You stop\, convinced that there's no way to control that much mana\.
  matchre CASTFAIL alone is an incomplete pattern
  matchre CASTFAIL ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.|^You strain\, but are too mentally fatigued to finish the pattern\, and it slips away\.
  matchre CASTFAIL ^You feel intense strain as you try to manipulate the mana streams to form this pattern\, and you are not certain that you will have enough mental stamina to complete it\.
  put prepare $MAGIC.%skill.spell $MAGIC.%skill.cast
  matchwait 10
  put #echo >Log Crimson *** MISSING MATCH IN PREP! (magic.cmd) ***
  goto RETURN

CASTFAIL:
  put #echo >Log Crimson *** ERROR WITH %skill, casting $MAGIC.%skill.spell at $MAGIC.%skill.cast mana (magic.cmd) ***
  put release symb
  pause .1
  put #var $MAGIC.%skill.spell NULL
  put #var $MAGIC.%skill.exp.stop 0
  return
  
PREP_SYMB:
  matchre PREP_SYMB ^\.\.\.wait|^Sorry
  matchre RETURN ^But you're already
  matchre RETURN ^You recall the exact|^But you've already
  put prep symbiosis
  matchwait 10
  put #echo >Log Crimson *** MISSING MATCH IN PREP_SYMB! (magic.cmd) ***
  goto RETURN

POWER:
  matchre POWER ^\.\.\.wait|^Sorry
  matchre RETURN ^You reach out with your 
  matchre RETURN ^Roundtime
  matchre END ^Something in the area
  matchre END ^You aren't trained in the ways of magic\.
  matchre END ^You aren't trained in the ways of magic\, but you fake it\.
  matchre RETURN ^There isn't the slightest trace
  matchre RETURN ^You cannot detect the slightest trace
  matchre END ^Something interferes
  if matchre("$guild", "Trader|Moon Mage") then put perc mana
  else put pow
  matchwait 10
  put #echo >Log Crimson *** MISSING MATCH IN POWER! (magic.cmd) ***
  goto RETURN


charge:
  if ("$MAGIC.%skill.charge" = "0") OR if ("$MAGIC.%skill.charge" = "") then return
charge_1:
  matchre charge_1 ^\.\.\.wait|^Sorry
  matchre invoke ^You harness
  matchre mana.wait strain\, but
  matchre removecamb ^Try though you may, you find it too clumsy 
  matchre removecamb ^You\'ll have to hold it\, set it on the ground\, or put it on something first\.
  put CHARGE $MAGIC.cambrinth $MAGIC.%skill.charge
  matchwait 5
  put #echo >Log Crimson *** MISSING MATCH IN CHARGE! (magic.cmd) ***
  return
invoke:
  matchre invoke ^\.\.\.wait|^Sorry
  matchre RETURN ^Your link to the .* is intact
  matchre RETURN ^The .* dim\, almost magically null\.  A very faint pattern indicates its readiness to absorb .*energy\.
  matchre RETURN ^The .* pulse .* energy.  You reach for their centers and forge a magical link to them, readying .* for your use\.
  matchre RETURN ^The .* pulses .* energy\.  You reach for its center and forge a magical link to it\, readying .* mana for your use\. 
  matchre INVOKEFAIL attempting to forge a magical link, but fail.
  put INVOKE $MAGIC.cambrinth SPELL
  matchwait 5
  put #echo >Log Crimson *** MISSING MATCH IN INVOKE! (magic.cmd) ***
  return

invokefail:
  put #var MAGIC.%skill.charge 0
  put #var MAGIC.skill.mana {#evalmath ($MAGIC.%skill.cast + $MAGIC.%skill.harness)}
  return

removecamb:
put remove my $MAGIC.cambrinth
put get my $MAGIC.cambrinth
goto charge

harness:
  if ("$MAGIC.%skill.harness" = "0") OR if ("$MAGIC.%skill.harness" = "") then return
  matchre harness ^\.\.\.wait|^Sorry\,|^Please wait\.
  matchre mana.wait ^You strain, but cannot harness that much power\.
  matchre return ^You tap into the mana from .* of the surrounding streams and
  put harness $MAGIC.%skill.harness
  matchwait 5
  put #echo >Log Crimson *** MISSING MATCH IN harness! (magic.cmd) ***
  return
  
cast:
  matchre cast ^\.\.\.wait|^Sorry\,|^Please wait\.
  matchre castfail ^You can't cast that at yourself\!
  matchre castfail ^Maintaining two cyclic spells at once is beyond your mental comprehension
  matchre castfail ^I could not find what you were referring to\.
  matchre castfail ^You have difficulty manipulating the mana streams, causing the spell pattern to collapse at the last moment\.
  matchre RETURN ^Currently lacking the skill to complete the pattern, your spell fails completely\.
  matchre backfired backfires
  matchre STUNNED leaves you stunned!
  matchre BACKLASH ^The spell pattern resists the influx of .+ mana
  matchre BACKLASH resists the influx of
  matchre SUCCESS ^You raise your hand in an imaginary
  matchre RETURN ^You don't have a spell prepared\!
  matchre RETURN ^Your spell pattern collapses
  matchre SUCCESS ^With a wave of your hand,
  matchre SUCCESS ^You wave your hand\.
  matchre SUCCESS ^You place your hands on your temples
  matchre SUCCESS ^A newfound fluidity of your mind
  matchre SUCCESS ^Your heart skips a beat as your spell
  matchre SUCCESS ^With a flick of your wrist,
  matchre SUCCESS ^You cup your palms skyward
  matchre RETURN ^Your secondary spell pattern dissipates
  matchre RETURN ^You can't cast .+ on yourself\!
  matchre SUCCESS ^You make a holy gesture
  matchre SUCCESS ^You raise your palms and face to the heavens
  matchre SUCCESS ^You whisper the final word of your spell so that none may notice your effort\.
  matchre SUCCESS ^You gesture
  if ("$preparedspell" = "Sanctify Pattern" then put cast warding
  else put cast
  matchwait 8
  put #echo >Log Crimson *** MISSING MATCH IN cast! (magic.cmd) ***
  echo MISSING MATCH IN CAST!
  return
 
BACKLASH:
  put #echo >Log Crimson *** Backlashed sorcery! Severity: %BacklashSeverity ***
  var Backlashed 0
  if ($bleeding = 1) then goto BLEEDING
  if (%backlashcount > 3) then goto end
  return
 
SUCCESS:
  if (%Backfired = 1) then goto backfired
  if (%Backlashed = 1) then goto backlash
  if (%Failed = 1) then 
	{
	var Failed 0
	return
	}
  evalmath learningrate ($%skill.LearningRate - %learningrate)
  if (%learningrate < 2) then gosub mana_bump
  return
 
BACKFIRED:
var Backfired 0
if (%%skill.spellMax = 0) then 
{
put discern $MAGIC.%skill.spell
waitfor Roundtime
}
pause .5
if ($MAGIC.%skill.mana > %%skill.spellMin) then
{
	evalmath newmana ($MAGIC.%skill.mana - 1)
	put #echo >Log Crimson *** backfired $MAGIC.%skill.spell - Dropping mana by 1
	put #var MAGIC.%skill.mana %newmana
	if matchre(%%skill.manadrop, [123]?[036]) then
	{
		if ($MAGIC.%skill.charge = 0) then math %skill.manadrop add 1
		else 
		{
		evalmath newcamb ($MAGIC.%skill.charge - 1)
		put #var MAGIC.%skill.charge %newcamb
		}
	}
	if matchre(%%skill.manadrop, [123]?[258]) then
	{
		if ($MAGIC.%skill.harness = 0) then math %skill.manadrop add 1
		else
		{
		evalmath newharness ($MAGIC.%skill.harness - 1)
		put #var MAGIC.%skill.harness %newharness
		}
	}	
	if matchre(%%skill.manadrop, [123]?[1479]) then
	{
		evalmath newcast ($MAGIC.%skill.cast - 1)
		if (%newcast = 0) then put #var MAGIC.%skill.cast 1
		else put #var MAGIC.%skill.cast %newcast
	}
	math %skill.manadrop add 1
	put #var save
}
return
    
mana.wait:
  send release mana
  put .textbook
mana.wait_1:
  if ($mana > 85) then 
  {
  put #script abort textbook
  pause .1
  put #script abort collect
  pause .5
  put stow left;stow right
  pause .5
  put stop play
  return
  }
  echo
  echo WAITING ON MANA
  echo 
  pause 5
  if !matchre("$scriptlist", "textbook") then put .collect
  goto mana.wait_1

BLEEDING:
  if $bleeding = 1 then echo ****  Bleeding! Did you backlash?
  else goto train
  goto END

STUNNED:
if ($stunned = 1) then waiteval ($stunned = 0)
return

  
MANA_BUMP:
if (%%skill.backfirecount > 3) then return
if (%%skill.spellMax = 0) then 
{
put discern $MAGIC.%skill.spell
waitfor Roundtime
}
pause .5
if ($MAGIC.%skill.mana < %%skill.spellMax) then
{
	evalmath newmana ($MAGIC.%skill.mana + 1)
	put #echo >Log Crimson *** %skill not learning! - Bumping %skill mana to %newmana - old mana: $MAGIC.%skill.mana
	put #var MAGIC.%skill.mana %newmana
	if matchre(%%skill.manabump, [123]?[036]) then
	{
		evalmath newcast ($MAGIC.%skill.cast + 1)
		put #var MAGIC.%skill.cast %newcast
	}
	if matchre(%%skill.manabump, [123]?[1479]) then
	{
		evalmath newcamb ($MAGIC.%skill.charge + 1)
		put #var MAGIC.%skill.charge %newcamb
	}
	if matchre(%%skill.manabump, [123]?[258]) then
	{
		evalmath newharness ($MAGIC.%skill.harness + 1)
		put #var MAGIC.%skill.harness %newharness
	}
	math %skill.manabump add 1
	put #var save
}
return

VARERROR:
  put echo ERROR WITH MAGIC VARIABLES - you need to set up .magicset before running this script
  exit


RETURN:
   return

end:
if ($bleeding = 1) && matchre("$scriptlist", "ubercombat") then put .ubercombat heal
else put #script resume ubercombat
ECHO
ECHO *** You have finished training magics.  Break time!
ECHO
end2:
put wear $MAGIC.cambrinth
put stow $MAGIC.cambrinth
pause .1
put #parse SCRIPT FINISHED!
   

