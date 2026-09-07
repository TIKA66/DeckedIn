'''
Filename: Card_Sytem.gd
Version: 1.0
Purpose: To set up the card system to connect to the overall game; 
		to initialise the starting, shuffling, selecting, processing, and ending a turn with the cards
Date: 5/09/2026
Author: Aikantika Banerjee
'''

#Imports and initialising the system
# NODE: A basic building block of a Godot game. Nodes provide different types of functionality and can be organised together within a scene tree.
extends Node
# CLASS: A blueprint for creating objects that combines related data and behaviours.
class_name CardSystem

# VARIABLE: Stores a value in memory under a named identifier. The value can be accessed & changed throughout the program.
# USER'S CARD VARIABLES - assigning variable names with accordance to the user
const HAND_SIZE: int = 5  # CONSTANT:Stores a fixed value that should not be changed while the program is running.
# ARRAY: An ordered collection of multiple values stored under one variable. Each value can be accessed using its index.
var hand: Array[Dictionary] = [] # Stores the cards that are currently in the user's hand, taken from the deck
var deck: Array[Dictionary] = [] # Stores what is the deck at the moment
var discard_pile: Array[Dictionary] = [] # Whatever was used in the hand will be transferred to here
var player_turn = false #tracks whether player turn is active or not
var available_attack: int = 0 # Stores what the available attacks the user can do with their current hand, more specifically what the weapon cards can offer
var available_movement: int = 0 # Stores what the available attacks the user can do with their current hand, more specically what the movement cards can offer
var player_health: int = 5 # Initialises what the player_health
var player_gold: int = 0 # Intialises the intial amount of gold the user has

# CARD SELECTION INPUT
var selected_card_index: int = 0
var card_confirmed: bool = false

# INFO FOR OTHER SYSTEMS - used specifically for the other nodes & scripts
#BOOLEAN: A data type that stores one of two possible values: true or false. It is commonly used to represent a state or condition.
var dragon_triggered: bool = false # A Dragon Attack is assigned here, to show the probabilities that some of the cards have of triggering the dragon, and thus ending the game
var portal_used: bool = false # Whether the portal is used, relates to the movement on the map
var cards_drawn: int = 0
var card_sprites: Array[Sprite2D] = []

# FUNCTION: A reusable block of code that performs a specific task when it is called. Functions can accept parameters and return a value.
# INITIALISE THE SYSTEM
func _ready() -> void:
	# Initialise the card_sprites array
	card_sprites = [$Dagger/Dagger, $Spear/Spear, $Sword/Sword, $Stumble/Stumble, $Explore/Explore, $Ladder/Ladder, $Boots/Boots, $Fountain/Fountain, $Portal/Portal, $Gem/Gem, $TreasureChest/TreasureChest]
	for i in range(card_sprites.size()):
		print("Sprite ", i, ": ", card_sprites[i])
	create_deck() # From the intialisation of the system to redirect to the next function of create_deck()
	shuffle_deck() # After the previous statement is completed, the system will redirect to this next function shuffle_deck()
	print("Card system ready.") # DEBUDDING STATEMENT FOR INTERNAL SYSTEM
	print("Deck size: ", deck.size()) # DEBUGGING STATEMENT FOR INTERNAL SYSTEM
	show_hand()

# CARD CREATION - sets up the strucutre to create the deck of cards
func create_card(
	card_name: String,
	card_type: String,
	attack: int,
	movement: int,
	gold: int,
	dragon: bool,
	sprite
) -> Dictionary: # DICTIONARY: A collection of key-value pairs used to store related information. Each value is accessed using its corresponding key.
		# RETURN VALUE: The value produced by a function and sent back to the part of the program that called it.
	return { # Set up the structure of the cards, including all the important components of it
		"name": card_name,
		"type": card_type,
		"attack": attack,
		"movement": movement,
		"gold": gold,
		"dragon": dragon,
		"use": false,
		"sprite": sprite
	}

# CREATE THE DECK - sets up each individual cards & its properties according to the card's structure as set up previously
func create_deck() -> void: # Allows easy change in terms of card's properties or to add any card for expansioning in the future
	deck.clear() # To remove the previous game's deck
	add_card_copies("Dagger", "weapon", 1, 0, 0, false, 3, $Dagger/Dagger) # Redirect to the add_card_copies function
	add_card_copies("Spear", "weapon", 2, 0, 0, false, 2, $Spear/Spear)
	add_card_copies("Sword", "weapon", 3, 0, 0, false, 1, $Sword/Sword)
	add_card_copies("Stumble", "movement", 0, 1, 0, true, 2, $Stumble/Stumble)
	add_card_copies("Explore", "movement", 0, 1, 0, false, 2, $Explore/Explore)
	add_card_copies("Ladder", "movement", 0, 2, 0, false, 4, $Ladder/Ladder)
	add_card_copies("Boots", "movement", 0, 3, 0, false, 2, $Boots/Boots)
	add_card_copies("Fountain", "item", 0, 0, 0, false, 3, $Fountain/Fountain)
	add_card_copies("Portal", "item", 0, 0, 0, false, 3, $Portal/Portal)
	add_card_copies("Gem", "item", 0, 0, 5, false, 2, $Gem/Gem)
	add_card_copies("Treasure Chest", "item", 0, 0, 10, true, 1, $TreasureChest/TreasureChest)
	print("Created ", deck.size(), " cards.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# ADD COPIES OF CARD - ensures all components are written with the correct data type & then creates that manny cards to 
func add_card_copies(card_name: String, card_type: String, attack: int, movement: int, gold: int, dragon: bool, amount: int, sprite) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var card := create_card(card_name, card_type, attack, movement, gold, dragon, sprite) # Uses the create_card function to initialise the card design to then add to the deck
		deck.append(card) # Adds the card to the deck

# SHUFFLE - uses the function shuffle to change the original layout of the deck to randomising it, to ensure a seamless & fun experience for the user
func shuffle_deck() -> void:
	deck.shuffle()

# START TURN - begins the user's turn with the initial assignment of variables to reset each turn
func start_turn() -> void:
	player_turn = true
	available_attack = 0
	available_movement = 0
	dragon_triggered = false
	portal_used = false
	draw_hand()
	selected_card_index = 0
	card_confirmed = false
	update_card_selection()
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# CARD INPUT - allows the player to move between cards and select them
func _input(event: InputEvent) -> void:
	if not player_turn:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		# Move selection left
		if event.keycode == KEY_LEFT:
			selected_card_index -= 1
			if selected_card_index < 0:
				selected_card_index = hand.size() - 1
			update_card_selection()
		# Move selection right
		elif event.keycode == KEY_RIGHT:
			selected_card_index += 1

			if selected_card_index >= hand.size():
				selected_card_index = 0
			update_card_selection()
		# Select or confirm card
		elif event.keycode == KEY_SPACE:
			if not card_confirmed:
				select_card_for_confirmation()
			else:
				confirm_card_selection()

# INPUT PROCESS #1 - press space bar for the first confirmation
func select_card_for_confirmation() -> void:
	if hand.is_empty():
		return
	var selected_card: Dictionary = hand[selected_card_index]
	if selected_card["use"] == true:
		print("This card has already been used.")
		return
	card_confirmed = true
	print("Selected: ", selected_card["name"])
	print("Press SPACE again to confirm.")

# INPUT PROCESS #2 - pr
func confirm_card_selection() -> void:
	if hand.is_empty():
		return
	print("Card confirmed.")
	select_card(selected_card_index)
	card_confirmed = false
	# Reset selection to the first remaining card
	selected_card_index = 0
	show_hand()
	update_card_selection()

# INPUT PROCESS #3 -
func update_card_selection() -> void:
	for i in range(hand.size()):
		var card_sprite: Sprite2D = hand[i]["sprite"]
		if i == selected_card_index:
			card_sprite.scale = Vector2(1.2, 1.2)
		else:
			card_sprite.scale = Vector2(1, 1)

# DRAW HAND
func draw_hand() -> void:
	while hand.size() < HAND_SIZE: # WHILE LOOP: Repeats a block of code while a specified condition remains true.
		# CONDITIONS: A statement that is evaluated as true or false and is used to control which section of code is executed.
		# Using this, we want to check if the deck & the discard_pile is empty to break, otherwise reshuffle_discard into the deck (to ensure we never run out of card) 
		# -> then to draw_onecard into the hand
		if deck.is_empty(): # Ensures the deck is never empty and will always contain some cards --> foolproof at every step
			if discard_pile.is_empty():
				break
			else:
				reshuffle_discard() # Redirect to the reshuffle-discard function, to reuse the code consistently w/o having to create blocks of similar code and organisation
		if not deck.is_empty(): # Creates the hand for the user
			draw_one_card()
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# DRAW ONE CARD - rather than dealing with the entire hand, it simply draws one card -> essential for other systems, e.g. movement, weaponry, etc
func draw_one_card() -> void:
	if deck.is_empty(): # Ensures the deck is never empty and will always contain some cards --> foolproof at every step
		if discard_pile.is_empty():
			return
		reshuffle_discard()
	if deck.is_empty():
		return
	var card: Dictionary = deck.pop_back()
	card["use"] = false # Reset the use of the card
	hand.append(card)
	cards_drawn += 1
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# SHOW HAND - visually, show all the cards in the hand
func show_hand() -> void:
	for sprite in card_sprites:
		sprite.visible = false

	for i in range(hand.size()):
		var card_sprite: Sprite2D = hand[i]["sprite"]
		card_sprite.visible = true
		card_sprite.position = Vector2(200 + (i * 150), 500)

# RESHUFFLE
func reshuffle_discard() -> void:
	deck.append_array(discard_pile)
	discard_pile.clear()
	shuffle_deck()
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# SELECT CARD - for the turn, the user is able to select a card
func select_card(card_index: int) -> bool:
	# Check that selected card exists
	if card_index < 0 or card_index >= hand.size():
		print("Invalid card selection.")
		return false
	var selected_card: Dictionary = hand[card_index]
	# Checks whether the selected card has been used
	if selected_card["use"] == true: # Debugging
		print("This card has already been used.")
		return false
	# Process card
	process_card(card_index) # Redirects to the next section
	return true

# PROCESS CARD - system actually reads the card that has been selected
func process_card(card_index: int) -> void:
	if card_index < 0 or card_index >= hand.size():
		return
	var selected_card: Dictionary = hand[card_index]
	if selected_card["type"] == "weapon":
		available_attack += selected_card["attack"]
	elif selected_card["type"] == "movement":
		available_movement += selected_card["movement"]
	elif selected_card["type"] == "item":
		process_item(selected_card)
	selected_card["use"] = true
	hand.remove_at(card_index)
	discard_pile.append(selected_card)
	# DRAGON TRIGGER - returns to the system that the game has ended in another script
	if selected_card["dragon"] == true:
		dragon_triggered = true
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# PROCESS ITEM - for the specifc item cards, processing the card to then update GUI as following
func process_item(card: Dictionary) -> void:
	match card["name"]:
		"Fountain":
			player_health += 1
			if player_health > 5:
				player_health = 5
		"Portal":
			portal_used = true
		"Gem":
			player_gold += 5
			# Gem allows one additional card to be drawn
			draw_one_card()
		"Treasure Chest":
			player_gold += 10

# END TURN - resetting the variables to its orginal state
func end_turn() -> void:
	# Reset card use values
	for card in hand:
		card["use"] = false
	# Move remaining cards into discard pile
	discard_pile.append_array(hand)
	hand.clear()
	# Reset temporary card values
	available_attack = 0
	available_movement = 0
	card_confirmed = false
	selected_card_index = 0
	print(deck) # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM
	print(available_movement) # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM
	print(available_attack) # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# FOLLOWING FUNCTIONS ARE FOCUSED TOWARDS OTHER SYSTEM AND SCRIPTS, TO ENSURE ORGANISATION, MAINTAINANCE & EFFICIENCY

# GET CARD
func get_card(card_index: int) -> Dictionary:
	if card_index < 0 or card_index >= hand.size():
		return {}
	return hand[card_index]

# GET HAND
func get_hand() -> Array[Dictionary]:
	return hand

# CHECK FOR MOVEMENT
func has_movement() -> bool:
	return available_movement > 0

# CHECK FOR ATTACK
func has_attack() -> bool:
	return available_attack > 0

# RESET CARD FLAGS
func reset_card_flags() -> void:
	dragon_triggered = false
	portal_used = false
	cards_drawn = 0
