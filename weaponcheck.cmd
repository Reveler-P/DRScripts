# Weapon check script by Reveler
# Discord: Reveler#6969
# Returns the lowest weapon skill with learning rate lower than specified
# Can call with .weaponcheck (skill array) from within another script and will set a global variable
# Logic can be used to check lowest of any skill, not just weapons
# If all skills are within the same learning rate range, it will pick the last in the array


debug 10


skillcheck:
if_1 
	{
		var skills %1 
	}
else 
	{
		var skills Small_Blunt|Small_Edged|Crossbow|Heavy_Thrown|Brawling|Light_Thrown|Bow|Large_Blunt|Large_Edged|Twohanded_Blunt|Staves|Slings|Polearms|Twohanded_Edged
	}
eval skills replacere("%skills", "\ ", "_")
eval skills.length count(“%skills”,”|”)
counter set 0
var lowratecycle 0
var learningratecheck 5|10|15|20|25|37
var low.skill %skills(%c)
skillcheck_1:
if (%c < %skills.length) then
	{
		if (($%skills(%c).Ranks < $%low.skill.Ranks) && ($%skills(%c).LearningRate < %learningratecheck(%lowratecycle)) then
		{
			var low.skill %skills(%c)
		}
		else if ($%low.skill.LearningRate > %learningratecheck(%lowratecycle)) then
		{
			var low.skill %skills(%c)
		}
		counter add 1
		goto skillcheck_1
	}
	if ($%skills.LearningRate > %learningratecheck(%lowratecycle)) then 
	{
		if (%lowratecycle >= 5) then goto LowRate_Train
		math lowratecycle add 1
		var lowrate 0
		goto skillcheck_1
	}	

echo Low Skill: %low.skill Ranks: $%low.skill.Ranks Learning Rate: $%low.skill.LearningRate/34
put #var Low.Skill %low.skill


