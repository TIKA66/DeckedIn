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
var movement_cost: int = 0 # Stores the cost to move to a selected room
var adjacent_rooms = null # Stores a list of rooms directly connected to the player's current room
#VARIABLE - stores the Area2D node representing the currently selected room option
var selected_room_node: Area2D = null
#BOOLEAN - stores whether the player is currently choosing a room to move to
var selecting_room: bool = false
#ARRAY - stores the room number secretly assigned to each selection sprite
var selection_rooms: Array = []
#ARRAY - stores the four selection Area2D nodes used as visual movement options
var selection_nodes: Array[Area2D] = []

# READY - sets up the code to activate essentially
func _ready() -> void:
	# Store all selection nodes in an array
	selection_nodes = [
		$Selection1,
		$Selection2,
		$Selection3,
		$Selection4
	]
	# Connect each selection's mouse input to the movement system
	for i in range(selection_nodes.size()):
		selection_nodes[i].input_event.connect(_on_selection_clicked.bind(i))
	# Hide all selection sprites until movement begins
	hide_selections()

# START MOVEMENT - test whether the player has movement points, if not, do not allow them to move
func start_movement() -> void:
	print("START MOVEMENT CALLED")
	# Hide all selection sprites before creating new movement options
	hide_selections()
	if $Card_System.available_movement <= 0:
		print("You have no movement cards.")
		return
	selecting_room = true
	display_adjacent_rooms()


# DISPLAY ADJACENT ROOMS - show the correct number of selection sprites
func display_adjacent_rooms() -> void:
	adjacent_rooms = Map.map[player_position]["adjacent_rooms"]
	print("Adjacent rooms: ", adjacent_rooms)
	for room in adjacent_rooms:
		print("  Room: ", room)
		print("  Movement Cost: ", Map.map[room]["movement_cost"])
	# Store all available selection sprites in an array
	selection_nodes = [$Selection1, $Selection2, $Selection3, $Selection4]
	# DUPLICATE - creates a separate copy of the adjacent rooms list
	# This prevents the original Map data from being changed when the list is randomised
	selection_rooms = adjacent_rooms.duplicate()
	# SHUFFLE - randomly rearranges the rooms so the player does not know
	# which selection sprite represents which adjacent room
	selection_rooms.shuffle()
	# LOOP - repeats for every selection sprite
	for i in range(selection_nodes.size()):
		# CONDITION - checks whether there is an adjacent room available for this selection
		if i < selection_rooms.size():
			selection_nodes[i].show()
			print("Selection ", i + 1, " → hidden room ", selection_rooms[i])
		else:
			# If there are fewer adjacent rooms than selection sprites,
			# hide the unused selection sprites
			selection_nodes[i].hide()

# HIDE SELECTIONS - hide all selection sprites, for the purpose of efficiency and organisation
func hide_selections() -> void:
	$Selection1.hide()
	$Selection2.hide()
	$Selection3.hide()
	$Selection4.hide()

# SELECTION CLICKED - determine which hidden room the player selected
func _on_selection_clicked(viewport: Node, event: InputEvent, shape_idx: int, selection_index: int) -> void:
	print("========== CLICK ==========")
	print("MOUSE CLICK DETECTED")
	print("Selecting room: ", selecting_room)
	print("Event: ", event)
	print("Selection index: ", selection_index)

	if not selecting_room:
		print("STOPPED: selecting_room is FALSE")
		return

	if not event is InputEventMouseButton:
		print("STOPPED: event is not a mouse button")
		return

	if not event.pressed:
		print("STOPPED: mouse button was released")
		return

	if event.button_index != MOUSE_BUTTON_LEFT:
		print("STOPPED: not left mouse button")
		return

	print("ALL CLICK CHECKS PASSED")
	# ARRAY INDEX - uses the clicked selection number to find
	# which room was randomly assigned to that selection
	selected_room = selection_rooms[selection_index]
	# DICTIONARY LOOKUP - retrieves the movement cost of the selected room from Map
	movement_cost = Map.map[selected_room]["movement_cost"]
	# Stores the visual selection that the player clicked
	selected_room_node = selection_nodes[selection_index]
	print("Selection ", selection_index + 1, " clicked.")
	print("Hidden room selected: ", selected_room)
	print("Movement cost: ", movement_cost)
	select_room(selected_room, movement_cost)

# SELECT ROOM - test whether the player is able to move to the selected room
# and whether they have enough movement points to move
func select_room(room_position: int, room_cost: int) -> bool:
	selected_room = room_position
	movement_cost = room_cost
	# CONDITION - checks whether the selected room is connected to the player's current room
	if selected_room not in adjacent_rooms:
		print("You cannot move to this room.")
		return false
	# CONDITION - checks whether the player has enough movement points
	if $Card_System.available_movement < movement_cost:
		print("You do not have enough movement points.")
		return false
	move_player()
	return true

# HIDE ROOM BACKGROUNDS - hide all room backgrounds before displaying the current room
func hide_room_backgrounds() -> void:
	$Starting.hide()
	$Market.hide()
	$Monster.hide()
	$Ending.hide()

# MOVE PLAYER - move the player to the selected room and reset adjacent rooms
func move_player() -> void:
	# SUBTRACTION - removes the movement cost from the player's available movement
	$Card_System.available_movement -= movement_cost
	# UPDATE - changes the player's current position to the selected room
	player_position = selected_room
	# DICTIONARY LOOKUP - gets the rooms connected to the player's new position
	adjacent_rooms = Map.map[player_position]["adjacent_rooms"]
	print("Player moved to room: ", player_position)
	# The player is no longer choosing a room
	selecting_room = false
	# Hide the selection options after the player has chosen a room
	hide_selections()
	# Display the new room after entering it
	display_room()
	# Reset the artefact position based on the player's new adjacent rooms
	place_artefact()
	$Card_System.new_hand()

# DISPLAY ROOM - display the current room after the player enters it
func display_room() -> void:
	print("Room type revealed.")
	print("Displaying room: ", Map.map[player_position]["type"], " room")
	# Hide all previous room backgrounds before displaying the new room
	hide_room_backgrounds()
	# MATCH - checks the room type and displays the corresponding room background
	match Map.map[player_position]["type"]:
		"starting":
			print("Showing STARTING")
			$Starting.show()
		"nothing":
			print("Room is NOTHING - no background being shown")
		"monster":
			print("Showing MONSTER")
			$Monster.show()
		"market":
			print("Showing MARKET")
			$Market.show()
		"ending":
			print("Showing ENDING")
			$Ending.show()

# SET ARTEFACT - set artefact position to a random room of the player's adjacent rooms
func place_artefact() -> void:
	if adjacent_rooms.is_empty():
		return
	# RANDOM NUMBER - chooses a random index from the list of adjacent rooms
	$Artefact.random_artefact_room = randi_range(0, adjacent_rooms.size() - 1)
	print(
		"Artefact position chosen ",
		$Artefact.random_artefact_room,
		" spot out of adjacent rooms: ",
		adjacent_rooms
	)
	# ARRAY INDEX - uses the random number to select a room from adjacent_rooms
	$Artefact.artefact_position = adjacent_rooms[$Artefact.random_artefact_room]
	print("Artefact position: ", $Artefact.artefact_position)
	# CONDITION - checks whether the artefact was placed in the player's current room
	if $Artefact.artefact_position == player_position:
		print("Artefact position invalid, rerolling artefact.")
		# RANDOM NUMBER - chooses another valid adjacent room
		$Artefact.artefact_position = adjacent_rooms[
			randi_range(0, adjacent_rooms.size() - 1)
		]
		print("Artefact position: ", $Artefact.artefact_position)
	print("Artefact initialised.")


# CURRENT ROOM - activities to complete when initialising a room
func current_room() -> void:
	display_room()
	display_adjacent_rooms()
	$Artefact.found_check() # Check whether artefact is in room with player
	# MATCH - determines which room activity should be started
	match Map.map[player_position]["type"]:
		"starting":
			$Rooms.starting()
		"nothing":
			pass # Nothing happens in this room, only load adjacent paths
		"monster":
			$Rooms.monster()
		"market":
			pass
		"ending":
			$Rooms.ending()
