put #log >darkboxtracker.txt 
put #log >darkboxtracker.txt 
put #log >darkboxtracker.txt 
put #log >darkboxtracker.txt Tracking darkbox run [$date $time]:
var tickets 0
action put #log >darkboxtracker.txt You got $1 when ^As you remove your hand from the Darkbox you see a (.*) in your grasp
action evalmath tickets %tickets+$1 when ^You pick up ([0-9]*) Hollow
action put #log >darkboxtracker.txt Total Tickets: %tickets when ^You pick up ([0-9]*) Hollow Eve 
action evalmath tickets %tickets+1 when ^You pick up a Hollow
action put #log >darkboxtracker.txt Total Tickets: %tickets when ^You pick up a Hollow Eve
action put #log >darkboxtracker.txt You picked up $1 tickets when ^You pick up ([0-9]*) Hollow Eve tickets
action put #log >darkboxtracker.txt You picked up 1 ticket when ^You pick up a Hollow Eve ticket
waitforever:
pause 3600
goto waitforever