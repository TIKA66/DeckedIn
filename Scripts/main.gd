'''
Filename: main.gd
Version: 2.0
Purpose: To begin the game
Date: 4/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''
# NODE: A basic building block of a Godot game. Nodes provide different types of functionality and can be organised together within a scene tree.
extends Node2D

#display title screen
#accessability warning

#buttons ot settings/tutorial/play

# VARIABLE: Stores a value in memory under a named identifier. The value can be accessed & changed throughout the program.
# BOOLEAN: A data type that stores one of two possible values: true or false. It is commonly used to represent a state or condition.
var player_artefact = false
var player_escaped = false

# FUNCTION: A reusable block of code that performs a specific task when it is called. Functions can accept parameters and return a value.
# INITIALISE THE SYSTEMS - initialise game then begin turn
func _ready() -> void:
	#$Card_System._ready() # initialise card system
	$Rooms._ready()
	reset_player()
	print("Initialising done.") #DEBUGGING
	
	# IF CONDITIONAL: checks whether a condition is satisfied and executes blocks of code based on the result.
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
