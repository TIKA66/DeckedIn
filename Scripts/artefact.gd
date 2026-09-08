'''
Filename: artefact.gd
Version: 1.0
Purpose: To handle the artefact:
		checking whether the artefact has been found, checking whether the player has won.
Date: 5/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''
# CLASS: A blueprint for creating objects that combines related data and behaviours.
extends Node2D

#ARTEFACT VARIABLES - assigning variables linked to the artefact
var artefact_position = null # NULL: a value that references a nonexistent object/adress.
var available_artefact_position = null
var random_artefact_room = null
var artefact_value: int = 10 
var artefact_use: bool = false

# FUNCTION: A reusable block of code that performs a specific task when it is called. Functions can accept parameters and return a value.
#FOUND CHECK - check whether the artefact is in the room with the player
func found_check():
	# IF CONDITIONAL: checks whether a condition is satisfied and executes blocks of code based on the result.
	if artefact_position == $"..".player_position: #if artefact position and player's position are the same, update to have artefact
		$Artefact.texture = preload("res://Resources/artefact_open.png") #set artefact texture to the open sprite
		artefact_position = null # remove artefact from map
		$"../..".player_artefact = true
	else:
		print("Artefact has not been found.") #else artefact has not been found

#COME BACK TO THIS
func touch_artefact():
	artefact_use = true

func win_check():
	if $"../..".player_artefact == true: #check whether the player has the artefact in the ending room
		$"../..".player_escaped = true
		print($"../..".player_artefact, " Gold: ", $"../../Card_System".player_gold)
	else:
		print("Player does not have artefact.")
