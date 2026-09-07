extends Node2D

#display title screen
#accessability warning

#buttons ot settings/tutorial/play

var player_health: int = 5
var player_gold: int = 5
var player_position = null # Stores the players position as the room number
var player_artefact = false

func _ready() -> void:
	$Card_System._ready() # initialise card system
	$Rooms._ready()
	reset_player()
	
	print("Initialising done.") #DEBUGGING
	while player_health > 0:
		$Card_System.start_turn()
		$Movement.current_room()
		#ALLOW PLAYER TO SELECT CARD???
	print("You have the artefact and ", player_gold, " gold.")
	print("GAME OVER.") #if player health under 0 game over


#CHANGE TO ONLY IN MONSTER ROOMS????? - put into rooom > monster funciton
func _on_end_turn_pressed() -> void:
	if (player_position == $Map.map[3] and $Map.map[3]["monsters"].size() > 0 or 
		player_position == $Map.map[5] and $Map.map[5]["monsters"].size() > 0):
		player_health -= $Map.map[player_position]["monsters"]["attack"]
		print("Monster attacked.")

func reset_player():
	player_health = 5
	player_gold = 5
	player_position = $Map.map[1]["room"]
	player_artefact = false
	print("Health, gold, position, artefact status: ", player_health, player_gold, player_position, player_artefact) #DEBGUGING
