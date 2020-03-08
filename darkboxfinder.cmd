var destroom 110
var movedelay .25
action goto error when ^AUTOMAPPER MOVEMENT FAILED
action goto error when MOVE FAILED

 
start:
send #goto %destroom
match cont YOU HAVE ARRIVED
matchwait 5
goto start

cont:
if matchre("$roomobjs", "Darkbox") then goto end
math destroom sub 1
echo ### ROOM $roomid ####
pause %movedelay
goto start

error:
put go arch;nw
pause 1
goto start
 
end:
put #script resume darkbox
pause .5
echo ### DARKBOX FOUND IN ROOM $roomid ###
put #echo >Log DARKBOX FOUND IN ROOM $roomid
put #parse BOX FOUND


