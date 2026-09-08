'''
Filename: artefact
Version: 1.0
Purpose: To handle artefact changes
Date: 5/9/2026
Author: Elliot Slota
'''

extends Node2D

var artefact_position = null
var available_artefact_position = null
var random_artefact_room = null
var artefact_value: int = 10
var artefact_use: bool = false

#FOUND CHECK - check whether the artefact is in the room with the player
func found_check():
	if artefact_position == $"..".player_position:
		$Artefact.texture = preload("res://Resources/artefact_open.png") #set artefact texture to the open sprite
		artefact_position = null # remove artefact from map
		$"../..".player_artefact = true
	else:
		print("Artefact has not been found.")

#COME BACK TO THIS
func touch_artefact():
	artefact_use = true

func win_check():
	if $"../..".player_artefact == true:
		print($"../..".player_artefact, " Gold: ", $"../../Card_System".player_gold)
	else:
		print("Player does not have artefact.")
