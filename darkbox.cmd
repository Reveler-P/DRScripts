#Reveler's darkbox
# start in any room in the spider - will find the darkbox for you.
# Set for healing at fang cove - adjust if you prefer a different healing method, adjust those provisions

action put #queue clear; send 1 $lastcommand when (\.\.\.wait|type ahead|^You don't seem to be able to move to do that)
#action send stow $1 when ^Your (.+) falls? to the ground\.$
var crap kelp|darkweed|flower|root|cap|sharkskin|rockweed|cobra|earcuff|powder|viper|coyote
put .darkboxtracker
 
start:
var darkroom $roomid
gosub checkhealth
send play darkbox
matchre start You fish around in the unseen depths of the Darkbox but you find nothing and remove your hand in disappointment
matchre start Before your hand is completely free of the Darkbox a hissing creature darts from the depths of the box and crushes your hand
matchre darkboxfinder Play on what instrument?
matchre darkboxfinder What type of song
matchre goclearing You cannot play the (.*) in your current physical condition\.
matchre goclearing Unfortunately\, your wounds make it impossible for you to play the Darkbox\.
matchre checkresult As you remove your hand from the Darkbox you see
matchwait
 
checkresult:
if matchre("$righthand", "%crap") then send put $righthandnoun in bin
if matchre("$lefthand", "%crap") then send put $lefthandnoun in bin
pause .25
if matchre("$righthand", "%deed") then gosub deedright
if matchre("$lefthand", "%deed") then gosub deedleft
pause .25
if matchre("$righthandnoun $lefthandnoun", "pouch") then gosub processpouch
pause .25
if $righthand != "Empty" then send stow right
if $lefthand != "Empty" then send stow left
 
pause 1
goto start
 
 
deedright:
send get my packet from my pack
send push my $righthandnoun with my packet
send put my packet in my pack
send stow my deed
return
 
deedleft:
send get my packet from my pack
send push my $lefthandnoun with my packet
send put my packet in my pack
send stow my deed
return

processpouch:
send open my pouch
send get ticket
pause .1
match droppouch There is nothing
send look in my pouch
matchwait 2
put stow right;stow left
goto start

droppouch:
put put pouch in bin
put empty left
put empty right
goto start


goclearing:
## IF YOU ARE NOT AN ESTATE HOLDER OR DO NOT WANT TO GO TO YRISA FOR HEALING, ADJUST BELOW AND IN HEALUP
pause 2
var moveroom clearing
var roomdesc [Paasvadh Forest, Clearing]
gosub move
if ($roomname != "Paasvadh Forest, Clearing") then gosub move
goto healup
 
healup:
put go path
waitforre ^Out of the corner of your eye, you spy a colorfully garbed attendant approaching you, 
pause 1
put go portal
match healup_1 usher nods at you and waves you through
match healup webbed
matchwait 5
goto error
healup_1:
pause 1
var moveroom 120
var roomdesc Clear blue water hurtles down from the waterfall, freefalling into the deeper blue of the pool to create
gosub move
if !matchre("$roomplayers", "Endalynn") then
{
var moveroom healer
var roomdesc Healer Yrisa
gosub move
put join list
waitforre You rub a portion
}
if matchre("$roomplayers", "Endalynn") then
{
put poke endalynn
waitforre ^Endalynn whispers\, \"done\" 
}
var moveroom portal
var roomdesc shimmering EXIT portal
gosub move
put go portal
pause .3
put go path
waitfor [Paasvadh Forest, Clearing]
put go brid
pause 1
var moveroom %darkroom
var roomdesc the Darkbox
gosub move
goto start
 

move:
put #goto %moveroom
match return %roomdesc
matchwait 20
if ("%roomdesc" = "the Darkbox") then goto darkboxfinder
goto move

checkhealth:
if $health < 50 then goto goclearing
return
 
darkboxfinder:
put .darkboxfinder
waitfor BOX FOUND
goto start

error:
echo ERROR WITH HEALING

return:
return

