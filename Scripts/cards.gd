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
var available_attack: int = 0 # Stores what the available attacks the user can do with their current hand, more specifically what the weapon cards can offer
var available_movement: int = 0 # Stores what the available attacks the user can do with their current hand, more specically what the movement cards can offer
var player_health: int = 5 # Initialises what the player_health
var player_gold: int = 0 # Intialises the intial amount of gold the user has

# INFO FOR OTHER SYSTEMS - used specifically for the other nodes & scripts
#BOOLEAN: A data type that stores one of two possible values: true or false. It is commonly used to represent a state or condition.
var dragon_triggered: bool = false # A Dragon Attack is assigned here, to show the probabilities that some of the cards have of triggering the dragon, and thus ending the game
var portal_used: bool = false # Whether the portal is used, relates to the movement on the map
var cards_drawn: int = 0

# FUNCTION: A reusable block of code that performs a specific task when it is called. Functions can accept parameters and return a value.
# INITIALISE THE SYSTEM
func _ready() -> void:
	create_deck() # From the intialisation of the system to redirect to the next function of create_deck()
	shuffle_deck() # After the previous statement is completed, the system will redirect to this next function shuffle_deck()
	print("Card system ready.") # DEBUDDING STATEMENT FOR INTERNAL SYSTEM
	print("Deck size: ", deck.size()) # DEBUGGING STATEMENT FOR INTERNAL SYSTEM

# CARD CREATION - sets up the strucutre to create the deck of cards
func create_card(
	card_name: String,
	card_type: String,
	attack: int,
	movement: int,
	gold: int,
	dragon: bool
) -> Dictionary: # DICTIONARY: A collection of key-value pairs used to store related information. Each value is accessed using its corresponding key.
		# RETURN VALUE: The value produced by a function and sent back to the part of the program that called it.
	return { # Set up the structure of the cards, including all the important components of it
		"name": card_name,
		"type": card_type,
		"attack": attack,
		"movement": movement,
		"gold": gold,
		"dragon": dragon,
		"use": false
	}

# CREATE THE DECK - sets up each individual cards & its properties according to the card's structure as set up previously
func create_deck() -> void: # Allows easy change in terms of card's properties or to add any card for expansioning in the future
	deck.clear() # To remove the previous game's deck
	add_card_copies("Dagger", "weapon", 1, 0, 0, false, 3) # Redirect to the add_card_copies function
	add_card_copies("Spear", "weapon", 2, 0, 0, false, 2)
	add_card_copies("Sword", "weapon", 3, 0, 0, false, 1)
	add_card_copies("Stumble", "movement", 0, 1, 0, true, 2)
	add_card_copies("Explore", "movement", 0, 1, 0, false, 2)
	add_card_copies("Ladder", "movement", 0, 2, 0, false, 4)
	add_card_copies("Boots", "movement", 0, 3, 0, false, 2)
	add_card_copies("Fountain", "item", 0, 0, 0, false, 3)
	add_card_copies("Portal", "item", 0, 0, 0, false, 3)
	add_card_copies("Gem", "item", 0, 0, 5, false, 2)
	add_card_copies("Treasure Chest", "item", 0, 0, 10, true, 1)
	print("Created ", deck.size(), " cards.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# ADD COPIES OF CARD - ensures all components are written with the correct data type & then creates that manny cards to 
func add_card_copies(card_name: String, card_type: String, attack: int, movement: int, gold: int, dragon: bool, amount: int) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var card := create_card(card_name, card_type, attack, movement, gold, dragon) # Uses the create_card function to initialise the card design to then add to the deck
		deck.append(card) # Adds the card to the deck

# SHUFFLE - uses the function shuffle to change the original layout of the deck to randomising it, to ensure a seamless & fun experience for the user
func shuffle_deck() -> void:
	deck.shuffle()

# START TURN - begins the user's turn with the initial assignment of variables to reset each turn
func start_turn() -> void:
	available_attack = 0
	available_movement = 0
	dragon_triggered = false
	portal_used = false
	draw_hand()
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# DRAW HAND
func draw_hand() -> void:
	while hand.size() < HAND_SIZE: # WHILE LOOP: Repeats a block of code while a specified condition remains true.
		# CONDITIONS: A statement that is evaluated as true or false and is used to control which section of code is executed.
		# Using this, we want to check if the deck & the discard_pile is empty to break, otherwise reshuffle_discard into the deck (to ensure we never run out of card) 
		# -> then to draw_onecard into the hand
		if deck.is_empty():
			if discard_pile.is_empty():
				break
			else:
				reshuffle_discard()
		if not deck.is_empty():
			draw_one_card()
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# DRAW ONE CARD
func draw_one_card() -> void:
	if deck.is_empty():
		if discard_pile.is_empty():
			return
		reshuffle_discard()
	if deck.is_empty():
		return
	var card: Dictionary = deck.pop_back()
	card["use"] = false
	hand.append(card)
	cards_drawn += 1
	print("PASSED") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# RESHUFFLE
func reshuffle_discard() -> void:
	deck.append_array(discard_pile)
	discard_pile.clear()
	shuffle_deck()

# SELECT CARD
func select_card(card_index: int) -> bool:
	# Check that selected card exists
	if card_index < 0 or card_index >= hand.size():
		print("Invalid card selection.")
		return false
	var selected_card: Dictionary = hand[card_index]
	if selected_card["use"] == true:
		print("This card has already been used.")
		return false
	# Process card
	process_card(card_index)
	return true

# PROCESS CARD
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
	
	# DRAGON TRIGGER
	if selected_card["dragon"] == true:
		dragon_triggered = true

# PROCESS ITEM
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

# END TURN
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
