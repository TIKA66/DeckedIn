'''
Filename: movement.gd
Version: 1.0
Purpose: To handle the movemement of the player and the artefact.
Date: 6/9/2026
Author: Elliot Slota & Tika Banerjee
'''

extends Node2D

#NULL - a variable that points to a non-existent object, in this case to be initialised later
var player_position = null
var selected_room = null # Stores the room the player wishes to move to
var movement_cost: int = 0 # stores the cost to move to a selected room
var adjacent_rooms = null
var room_nodes: Array[Area2D] = []
var selected_room_node: Area2D = null
var selecting_room: bool = false

#func _ready() -> void:
	#current_room()
	#print(Map.map)
	#print("Player position: ", Map.map[player_position]["type"], " room")
	#start_movement()
	#select_room(3, 1)
	#select_room(5, 1)

# START MOVEMENT - test whether the player has movement points, if not, do not allow them to move
func start_movement() -> void:
	$Market.hide()
	$Monster.hide()
	$Ending.hide()
	$Selection.hide()
	$Starting.show()
	if $Card_System.available_movement <= 0:
		print("You have no movement cards.")
		return
	selecting_room = true
	display_adjacent_rooms()

# DISPLAY ADJACENT ROOMS - show adjacent rooms and allow the player to select them
func display_adjacent_rooms() -> void:
	adjacent_rooms = Map.map[player_position]["adjacent_rooms"]
	print("Adjacent rooms:")
	for room in adjacent_rooms:
		print("  Room: ", room)
		print("  Movement Cost: ", Map.map[room]["movement_cost"])
	# Connect the clickable room nodes
	connect_room_clicks()

# CONNECT ROOM CLICKS - connect each room's mouse input to the movement system
func connect_room_clicks() -> void:
	var rooms = [
		$Starting,
		$Market,
		$Monster,
		$Ending
	]
	for room in rooms:
		if not room.input_event.is_connected(_on_room_clicked):
			room.input_event.connect(_on_room_clicked)

# ROOM CLICKED - select the room clicked by the player
# ROOM CLICKED - select the room clicked by the player
func _on_room_clicked(viewport: Node, event: InputEvent, shape_idx: int, room: Area2D) -> void:
	if not selecting_room:
		return
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	selected_room_node = room
	print("Room clicked: ", room.name)
	show_room_selection(room)
	var room_position = room.get_meta("room_position")
	var room_cost = Map.map[room_position]["movement_cost"]
	select_room(room_position, room_cost)

# SHOW ROOM SELECTION - move the selection sprite onto the selected room
func show_room_selection(room: Area2D) -> void:
	$Selection.global_position = room.global_position
	$Selection.visible = true
	$Selection/Template.visible = true
	$Selection/NoTemplate.visible = false
	print("Selection displayed on: ", room.name)

# SELECT ROOM - test whether player is able to move to the selected room and whether they have enough movement points
func select_room(room_position: int, room_cost: int) -> bool:
	selected_room = room_position
	movement_cost = room_cost
	# Check whether selected room is adjacent to player
	if selected_room not in adjacent_rooms:
		print("You cannot move to this room.")
		return false
	# Test whether the player has enough movement points
	if $Card_System.available_movement < movement_cost:
		print("You do not have enough movement points.")
		return false
	move_player()
	return true

#REVIEW - do we need this? - the player is only handed valid movememnt options
#func is_connected_room(room_position: int) -> bool:
	# This will later check the player's connected rooms.
	#return true

# MOVE PLAYER - move the player to the selected room and reset adjacent rooms
func move_player() -> void:
	$Card_System.available_movement -= movement_cost
	player_position = selected_room
	adjacent_rooms = Map.map[player_position]["adjacent_rooms"] #Set new adjacent rooms based on new position
	print("Player moved to room: ", player_position) # DEBUGGING
	display_room() # Show the new room. Room type is revealed only after entering.
	place_artefact() # Reset artefact position to the new adjacent rooms

# DISPLAY ROOM - display the current room
func display_room() -> void:
	print("Room type revealed.")
	print("Displaying room: ", Map.map[player_position]["type"], " room") #pull room name from dictionary
	#if Map.map[player_position]["items"] == true: #if an item exists in roomm, display item
		#print("Displaying item: ", Map.map[player_position]["items"])
	#if Map.map[player_position]["monsters"] == true: #if a monster exists in roomm, display monster
		#print("Displaying item: ", Map.map[player_position]["monsters"])

# SET ARTEFACT- set artefact position to a random room of the player's adjacent rooms
func place_artefact() -> void:
	$Artefact.random_artefact_room = randi_range(0, adjacent_rooms.size())
	print("artefact position chosen ", $Artefact.random_artefact_room, "nd spot out of adjacent rooms: ", adjacent_rooms) #DEBUGGING
	$Artefact.artefact_position = adjacent_rooms[$Artefact.random_artefact_room]
	print("artefact position: ", $Artefact.artefact_position) #DEBUGGING
#	reroll if artefact sets to the same spot as player
	if $Artefact.artefact_position == player_position:
		print("Artefact position invalid, rerolling artefact.") #DEBUGGING
		$Artefact.artefact_position = randi_range(1, adjacent_rooms.size())
		print("artefact position: ", $Artefact.artefact_position) #DEBUGGING
	print("Artefact initialised.") #DEBUGGING STATEMENT

#CURRENT ROOM - activities to complete when initialising a room
func current_room() -> void:
	display_room()
	display_adjacent_rooms()
	$Artefact.found_check() #check whether artefact is in room with player
	match Map.map[player_position]["type"]: #determine which type of room to start displaying
		"starting":
			$Rooms.starting()
		"nothing":
			pass #nothing happens in this room, only load adjacent paths
		"monster":
			$Rooms.monster()
		"market":
			pass
		"ending":
			$Rooms.ending()
