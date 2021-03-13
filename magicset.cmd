# Variables for quick and dirty magic trainer by Reveler
# Discord: Reveler#6969
# March 2021
# Use with magic.cmd


#  CHARACTERNAME NEEDS TO BE AS IT APPEARS EXACTLY WHEN YOU ENTER #echo $charactername (first letter capitalized)
if ("$charactername" = "XXXX") then
	{
	### Your spell to train Augmentation.  Should be a spell that only trains augmentation for most efficiency
	  put #var MAGIC.Augmentation.spell MEF 
	### For the augmentation spell you picked, this is the initial spell prep amount
	  put #var MAGIC.Augmentation.cast 8
	### For the augmentation spell you picked, this is the amount to harness
	  put #var MAGIC.Augmentation.harness 4
	### For the augmentation spell you picked, this is the amount to charge your cambrinth
	  put #var MAGIC.Augmentation.charge 4
	### Your spell to train Utility.  Should be a spell that only trains utility for most efficiency
	  put #var MAGIC.Utility.spell BS 
	### For the utility spell you picked, this is the initial spell prep amount
	  put #var MAGIC.Utility.cast 7
	### For the utility spell you picked, this is the amount to harness
	  put #var MAGIC.Utility.harness 4
	### For the utility spell you picked, this is the amount to charge your cambrinth
	  put #var MAGIC.Utility.charge 3
	### Your spell to train Warding.  Should be a spell that only trains warding for most efficiency
	  put #var MAGIC.Warding.spell IC 
	### For the warding spell you picked, this is the initial spell prep amount
	  put #var MAGIC.Warding.cast 30
	### For the warding spell you picked, this is the amount to harness
	  put #var MAGIC.Warding.harness 11
	### For the warding spell you picked, this is the amount to charge your cambrinth
	  put #var MAGIC.Warding.charge 5
	### Your spell to train Sorcery.  Caveat emptor.  Sorcery is dangerous.
	  put #var MAGIC.Sorcery.spell Bless 
	### For the sorcery spell you picked, this is the initial spell prep amount
	  put #var MAGIC.Sorcery.cast 8
	### For the sorcery spell you picked, this is the amount to harness
	  put #var MAGIC.Sorcery.harness 0
	### For the sorcery spell you picked, this is the amount to charge your cambrinth
	  put #var MAGIC.Sorcery.charge 0
	### This is your cambrinth item.  You can put adjective noun here if you have multiples of the same noun
	  put #var MAGIC.cambrinth armband

	### YES if you train using symbiosis.  NO if you do not.
	  put #var MAGIC.Utility.symbiosis YES
	  put #var MAGIC.Augmentation.symbiosis YES
	  put #var MAGIC.Warding.symbiosis NO
	  put #var MAGIC.Sorcery.symbiosis NO
	### The mindstate to stop training each specific skill  
	  put #var MAGIC.Utility.exp.stop 30
	  put #var MAGIC.Augmentation.exp.stop 30
	  put #var MAGIC.Warding.exp.stop 30
	  put #var MAGIC.Sorcery.exp.stop 20
	}
if ("$charactername" = "XXXX") then
	{
	  put #var MAGIC.Augmentation.spell EASE 
	  put #var MAGIC.Augmentation.cast 4
	  put #var MAGIC.Augmentation.harness 0
	  put #var MAGIC.Augmentation.charge 0
	  put #var MAGIC.Utility.spell EOTB 
	  put #var MAGIC.Utility.cast 5
	  put #var MAGIC.Utility.harness 0
	  put #var MAGIC.Utility.charge 0
	  put #var MAGIC.Warding.spell MAF 
	  put #var MAGIC.Warding.cast 3
	  put #var MAGIC.Warding.harness 0
	  put #var MAGIC.Warding.charge 0
	  put #var MAGIC.Sorcery.spell ATHLETICISM 
	  put #var MAGIC.Sorcery.cast 18
	  put #var MAGIC.Sorcery.harness 9
	  put #var MAGIC.Sorcery.charge 9


	  put #var MAGIC.cambrinth bracer

	  put #var MAGIC.Utility.symbiosis YES
	  put #var MAGIC.Augmentation.symbiosis YES
	  put #var MAGIC.Warding.symbiosis YES
	  put #var MAGIC.Sorcery.symbiosis NO
	  
	  put #var MAGIC.Utility.exp.stop 30
	  put #var MAGIC.Augmentation.exp.stop 30
	  put #var MAGIC.Warding.exp.stop 30
	  put #var MAGIC.Sorcery.exp.stop 30
	}

if ("$charactername" = "XXXX") then
	{
	  put #var MAGIC.Augmentation.spell BENE 
	  put #var MAGIC.Augmentation.cast 10
	  put #var MAGIC.Augmentation.harness 10
	  put #var MAGIC.Augmentation.charge 5
	  put #var MAGIC.Utility.spell DR
	  put #var MAGIC.Utility.cast 7
	  put #var MAGIC.Utility.harness 2
	  put #var MAGIC.Utility.charge 0
	  put #var MAGIC.Warding.spell PFE 
	  put #var MAGIC.Warding.cast 11
	  put #var MAGIC.Warding.harness 0
	  put #var MAGIC.Warding.charge 2
	  put #var MAGIC.Sorcery.spell ART 
	  put #var MAGIC.Sorcery.cast 20
	  put #var MAGIC.Sorcery.harness 0
	  put #var MAGIC.Sorcery.charge 0


	  put #var MAGIC.cambrinth THIGH BAG

	  put #var MAGIC.Utility.symbiosis YES
	  put #var MAGIC.Augmentation.symbiosis YES
	  put #var MAGIC.Warding.symbiosis YES
	  put #var MAGIC.Sorcery.symbiosis NO
	  
	  put #var MAGIC.Utility.exp.stop 30
	  put #var MAGIC.Augmentation.exp.stop 30
	  put #var MAGIC.Warding.exp.stop 30
	  put #var MAGIC.Sorcery.exp.stop 20
	}

if ("$charactername" = "XXXX") then
	{
	  put #var MAGIC.Augmentation.spell SKS 
	  put #var MAGIC.Augmentation.cast 10
	  put #var MAGIC.Augmentation.harness 5
	  put #var MAGIC.Augmentation.charge 5
	  put #var MAGIC.Utility.spell Blend 
	  put #var MAGIC.Utility.cast 10
	  put #var MAGIC.Utility.harness 5
	  put #var MAGIC.Utility.charge 5
	  put #var MAGIC.Warding.spell EY 
	  put #var MAGIC.Warding.cast 10
	  put #var MAGIC.Warding.harness 5
	  put #var MAGIC.Warding.charge 5
	  put #var MAGIC.Sorcery.spell WOTM 
	  put #var MAGIC.Sorcery.cast 10
	  put #var MAGIC.Sorcery.harness 3
	  put #var MAGIC.Sorcery.charge 3


	  put #var MAGIC.cambrinth cambrinth armband

	  put #var MAGIC.Utility.symbiosis YES
	  put #var MAGIC.Augmentation.symbiosis YES
	  put #var MAGIC.Warding.symbiosis YES
	  put #var MAGIC.Sorcery.symbiosis YES
	  
	  put #var MAGIC.Utility.exp.stop 30
	  put #var MAGIC.Augmentation.exp.stop 30
	  put #var MAGIC.Warding.exp.stop 30
	  put #var MAGIC.Sorcery.exp.stop 30
	}

if ("$charactername" = "XXXX") then
	{
	  put #var MAGIC.Augmentation.spell FIN
	  put #var MAGIC.Augmentation.cast 1
	  put #var MAGIC.Augmentation.harness 1
	  put #var MAGIC.Augmentation.charge 1
	  put #var MAGIC.Utility.spell NOU 
	  put #var MAGIC.Utility.cast 1
	  put #var MAGIC.Utility.harness 1
	  put #var MAGIC.Utility.charge 1
	  put #var MAGIC.Warding.spell TRC 
	  put #var MAGIC.Warding.cast 1
	  put #var MAGIC.Warding.harness 1
	  put #var MAGIC.Warding.charge 1
	  put #var MAGIC.Sorcery.spell NULL 
	  put #var MAGIC.Sorcery.cast 0
	  put #var MAGIC.Sorcery.harness 0
	  put #var MAGIC.Sorcery.charge 0


	  put #var MAGIC.cambrinth cambrinth armband

	  put #var MAGIC.Utility.symbiosis NO
	  put #var MAGIC.Augmentation.symbiosis NO
	  put #var MAGIC.Warding.symbiosis NO
	  put #var MAGIC.Sorcery.symbiosis NO
	  
	  put #var MAGIC.Utility.exp.stop 20
	  put #var MAGIC.Augmentation.exp.stop 20
	  put #var MAGIC.Warding.exp.stop 20
	  put #var MAGIC.Sorcery.exp.stop 0
	}

if ("$charactername" = "XXXX") then
	{
	  put #var MAGIC.Augmentation.spell MAPP 
	  put #var MAGIC.Augmentation.cast 6
	  put #var MAGIC.Augmentation.harness 3
	  put #var MAGIC.Augmentation.charge 3
	  put #var MAGIC.Utility.spell DR 
	  put #var MAGIC.Utility.cast 6
	  put #var MAGIC.Utility.harness 3
	  put #var MAGIC.Utility.charge 3
	  put #var MAGIC.Warding.spell PFE 
	  put #var MAGIC.Warding.cast 12
	  put #var MAGIC.Warding.harness 6
	  put #var MAGIC.Warding.charge 6
	  put #var MAGIC.Sorcery.spell MEG 
	  put #var MAGIC.Sorcery.cast 9
	  put #var MAGIC.Sorcery.harness 4
	  put #var MAGIC.Sorcery.charge 5


	  put #var MAGIC.cambrinth faeweave baldric

	  put #var MAGIC.Utility.symbiosis YES
	  put #var MAGIC.Augmentation.symbiosis YES
	  put #var MAGIC.Warding.symbiosis YES
	  put #var MAGIC.Sorcery.symbiosis YES
	  
	  put #var MAGIC.Utility.exp.stop 20
	  put #var MAGIC.Augmentation.exp.stop 20
	  put #var MAGIC.Warding.exp.stop 20
	  put #var MAGIC.Sorcery.exp.stop 20
	}
	put #var MAGIC.SET DONE
}

