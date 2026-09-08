extends Node2D

#display title screen
#accessability warning

#buttons ot settings/tutorial/play

var player_artefact = false

func _ready() -> void:
	#$Card_System._ready() # initialise card system
	$Rooms._ready()
	reset_player()
	
	print("Initialising done.") #DEBUGGING
	if $Card_System.player_health > 0:
		$Card_System.start_turn()
		$Movement.current_room()
		#ALLOW PLAYER TO SELECT CARD???
	
#	place these checks somewhere else
	#print("You have the artefact and ", $Card_System.player_gold, " gold.")
	#print("GAME OVER.") #if player health under 0 game over


#CHANGE TO ONLY IN MONSTER ROOMS????? - put into rooom > monster funciton

func reset_player():
	$Card_System.player_health = 5
	$Card_System.player_gold = 5
	$Movement.player_position = $Map.map[3]["room"]
	player_artefact = false
	print("Health, gold, position, artefact status: ", $Card_System.player_health, $Card_System.player_gold, $Movement.player_position, player_artefact) #DEBGUGING
