'''
Filename: movement.gd
Version: 1.0
Purpose: To set up and manage the movement system of this game 
Date: 5/09/2026
Author: Aikantika Banerjee
'''

#Imports and initialising the system
# NODE: A basic building block of a Godot game. Nodes provide different types of functionality and can be organised together within a scene tree.
extends Node
# CLASS: A blueprint for creating objects that combines related data and behaviours.
class_name Movement

# VARIABLE: Stores a value in memory under a named identifier. The value can be accessed & changed throughout the program.
# USER'S MOVEMENT VARIABLES - setting up the 
var player_position: int = 0
var available_movement: int = 0
var selected_room: int = -1
var movement_cost: int = 0

func start_movement() -> void:
	if available_movement <= 0:
		print("You have no movement cards.")
		return
	display_adjacent_rooms()

func display_adjacent_rooms() -> void:
	print("Adjacent rooms:")
	var adjacent_rooms: Array = []
	for room in adjacent_rooms:
		print("Room: ", room["position"])
		print("Movement Cost: ", room["movement_cost"])


func select_room(room_position: int, room_cost: int) -> bool:
	selected_room = room_position
	movement_cost = room_cost
	if not is_connected_room(selected_room):
		print("You cannot move to this room.")
		return false
	if available_movement < movement_cost:
		print("You do not have enough movement points.")
		return false
	move_player()
	return true

func is_connected_room(room_position: int) -> bool:
	# This will later check the player's connected rooms.
	return true

func move_player() -> void:
	available_movement -= movement_cost
	player_position = selected_room
	print("Player moved to room: ", player_position)
	# Room type is revealed only after entering.
	display_room()
	# Artefact system will be connected later.
	initialise_artefact()

func display_room() -> void:
	print("Room type revealed.")
	print("Displaying room: ", player_position)

func initialise_artefact() -> void:
	print("Artefact initialised.")
