extends Node2D

#display title screen
#accessability warning

#buttons ot settings/tutorial/play

var player_artefact = false
var player_escaped = false

func _ready() -> void:
	#$Card_System._ready() # initialise card system
	$Rooms._ready()
	reset_player()
	print("Initialising done.") #DEBUGGING
	
	if $Card_System.player_health > 0 and player_escaped == false:
		$Card_System.start_turn()
		$Movement.current_room()
		print("stats: health, gold, position, artefact status: ", $Card_System.player_health, $Card_System.player_gold, $Movement.player_position, player_artefact) #DEBUGGING

func reset_player():
	$Card_System.player_health = 5
	$Card_System.player_gold = 5
	$Movement.player_position = $Map.map[1]["room"]
	player_artefact = false
	print("Health, gold, position, artefact status: ", $Card_System.player_health, $Card_System.player_gold, $Movement.player_position, player_artefact) #DEBGUGING
