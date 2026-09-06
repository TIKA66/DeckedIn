'''
Filename: movement.gd
Version: 1.0
Purpose: To handle the movemement of the player and the artefact.
Date: 6/9/2026
Author: Elliot Slota
'''

extends Node2D

#GLOBAL - a variable that can be accessed from any script, held in the global.gd script
var player_position = Global.map[3]["room"] # Stores the players position as the room number
#NULL - a variable that points to a non-existent object, in this case to be initialised later
var selected_room = null # Stores the room the player wishes to move to
var movement_cost: int = 0 # stores the cost to move to a selected room
var adjacent_rooms: Array = Global.map[player_position]["adjacent_rooms"]

# DEBUGGING for function testing
func _ready() -> void:
	current_room()
	#print(Global.map)
	#print("Player position: ", Global.map[player_position]["type"], " room")
	#start_movement()
	#select_room(3, 1)
	#select_room(5, 1)

# START MOVEMENT - test whether the player has movement points, if not, do not allow them to move
func start_movement() -> void:
	if Cards.available_movement <= 0:
		print("You have no movement cards.")
		return
	display_adjacent_rooms()

# DISPLAY ADJACENT ROOMS - show adjacent rooms
func display_adjacent_rooms() -> void:
	print("Adjacent rooms:")
	for room in adjacent_rooms:
		print("  Room: ", room)
		print("  Movement Cost: ", Global.map[room]["movement_cost"])

# SELECT ROOM - test whether player is able to move to the selected room and whether they have enough movement points to move
func select_room(room_position: int, room_cost: int) -> bool:
	selected_room = room_position
	movement_cost = room_cost
#	Check whether selected room is adjacent to player
	if selected_room not in adjacent_rooms:
		print("You cannot move to this room.")
		return false
#	Test whether the player has enough movement points
	if Cards.available_movement < movement_cost:
		print("You do not have enough movement points.")
		return false
	move_player()
	return true

#REVIEW - do we need this? - the player is only handed valid movememnt options
#func is_connected_room(room_position: int) -> bool:
	## This will later check the player's connected rooms.
	#return true

# MOVE PLAYER - move the player to the selected room and reset adjacent rooms
func move_player() -> void:
	Cards.available_movement -= movement_cost
	player_position = selected_room
	adjacent_rooms = Global.map[player_position]["adjacent_rooms"] #Set new adjacent rooms based on new position
	print("Player moved to room: ", player_position) # DEBUGGING
	display_room() # Show the new room. Room type is revealed only after entering.
	set_artefact() # Reset artefact position to the new adjacent rooms

# DISPLAY ROOM - display the current room
func display_room() -> void:
	print("Room type revealed.")
	print("Displaying room: ", Global.map[player_position]["type"], " room") #pull room name from dictionary

# SET ARTEFACT- set artefact position to a random room of the player's adjacent rooms
func set_artefact() -> void:
	Artefact.random_artefact_room = randi_range(0, adjacent_rooms.size())
	print("artefact position chosen ", Artefact.random_artefact_room, "nd spot out of adjacent rooms: ", adjacent_rooms) #DEBUGGING
	Artefact.artefact_position = adjacent_rooms[Artefact.random_artefact_room]
	print("artefact position: ", Artefact.artefact_position) #DEBUGGING
#	reroll if artefact sets to the same spot as player
	if Artefact.artefact_position == player_position:
		print("Artefact position invalid, rerolling artefact.") #DEBUGGING
		Artefact.artefact_position = randi_range(1, adjacent_rooms.size())
		print("artefact position: ", Artefact.artefact_position) #DEBUGGING
	print("Artefact initialised.") #DEBUGGING STATEMENT

#CURRENT ROOM - activities to complete when initialising a room
func current_room() -> void:
	display_room()
	display_adjacent_rooms()
	Artefact.found_check()
	match Global.map[player_position]["type"]: #determine which type of room to start displaying
		"starting":
			Rooms.starting()
		"nothing":
			pass #nothing happens in this room, only load adjacent paths
		"monster":
			Rooms.monster()
		"market":
			pass
		"ending":
			pass
