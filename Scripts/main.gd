'''
Filename: main.gd
Version: 2.0
Purpose: To begin the game
Date: 4/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''

extends Node2D

#display title screen
#accessability warning

#buttons ot settings/tutorial/play

var player_artefact = false
var player_escaped = false

# INITIALISE THE SYSTEMS - initialise game then begin turn
func _ready() -> void:
	#$Card_System._ready() # initialise card system
	$Rooms._ready()
	reset_player()
	print("Initialising done.") #DEBUGGING
	
	if $Card_System.player_health > 0 and player_escaped == false:
		$Card_System.start_turn()
		$Movement.current_room()
		print("stats: health, gold, position, artefact status: ", $Card_System.player_health, $Card_System.player_gold, $Movement.player_position, player_artefact) #DEBUGGING to show initial stats

# RESET PLAYER - set all player stats back to original states.
func reset_player():
	$Card_System.player_health = 5
	$Card_System.player_gold = 5
	$Movement.player_position = $Map.map[1]["room"]
	player_artefact = false
