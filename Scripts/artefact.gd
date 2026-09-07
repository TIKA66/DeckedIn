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

func found_check():
	if artefact_position == $"..".player_position:
		#DISPLAY open treasure chest w artefact - change sprite
		#player_artefact = true
		artefact_position = null # remove artefact from map
	else:
		print("Artefact has not been found.")

#COME BACK TO THIS
func touch_artefact():
	artefact_use = true
