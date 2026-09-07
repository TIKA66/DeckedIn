extends Node2D

var item_spawn_rate = null

#GENERAL ITEM VARS
var available_items = [] #items that can be spawned
var item_spawned = null

#MONSTER ROOM VARS
var number_of_monsters = null
var monster_to_spawn = null

#MARKET VARS
var items_to_sell = [] # items that can be sold

func _ready() -> void:
	create_items_to_spawn()
	create_items_to_sell()

#PLACE ITEM INTO ROOM
func place_item(spawn_rate):
	var item_roll = randf()
	print("Item roll: ", item_roll) #DEBUGGING
	if item_roll > spawn_rate:
		item_spawned = randi_range(1, available_items.size()-1) # choose which item to spawn
		Map.map[$"..".player_position]["items"].append(available_items[item_spawned]) #spawn item
		print("item in room: ", Map.map[$"..".player_position]["items"])

#CREATE INDIVIDUAL ITEM FOR AVAILABLE_ITEMS
func create_item(
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

#ADD ALL ITEMS INTO AVAILABLE ITEMS
func create_items_to_spawn() -> void: # Allows easy change in terms of card's properties or to add any card for expansioning in the future
	available_items.clear() # To remove the previous game's available_items
	add_item_copies("Dagger", "weapon", 1, 0, 0, false, 3, $Dagger) # Redirect to the add_item_copies function
	add_item_copies("Spear", "weapon", 2, 0, 0, false, 2, $Spear)
	add_item_copies("Sword", "weapon", 3, 0, 0, false, 1, $Sword)
	add_item_copies("Stumble", "movement", 0, 1, 0, true, 2, $Stumble)
	add_item_copies("Explore", "movement", 0, 1, 0, false, 2, $Explore)
	add_item_copies("Ladder", "movement", 0, 2, 0, false, 4, $Ladder)
	add_item_copies("Boots", "movement", 0, 3, 0, false, 2, $Boots)
	add_item_copies("Fountain", "item", 0, 0, 0, false, 3, $Fountain)
	add_item_copies("Portal", "item", 0, 0, 0, false, 3, $Portal)
	add_item_copies("Gem", "item", 0, 0, 5, false, 2, $Gem)
	add_item_copies("Treasure Chest", "item", 0, 0, 10, true, 1, $"Treasure Chest")
	print("Created ", available_items.size(), " items.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# ADD ITEM COPIES - repeat item creation for specified number of times
func add_item_copies(card_name: String, card_type: String, attack: int, movement: int, gold: int, dragon: bool, amount: int, sprite) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var item := create_item(card_name, card_type, attack, movement, gold, dragon, sprite) # Uses the create_item function to initialise the item then add to available items
		available_items.append(item) # Adds the item to the available items to find

# SPAWN MONSTER
func place_monster():
	monster_to_spawn = $".".available_monsters[randi_range(1, $".".available_monsters.size()-1)] # choose which monster to spawn from available monster list
	Map.map[$"..".player_position]["monsters"].append(monster_to_spawn) # add to a list of monsters in the room
	print("monsters in room: ", Map.map[$"..".player_position]["monsters"]) #DEBUGGING - show monsters in current room

func starting():
	item_spawn_rate = 0.2
	place_item(item_spawn_rate)

func monster():
	item_spawn_rate = 0.4
	place_item(item_spawn_rate)
	place_monster()

func market():
	print("Items available:")
	print(items_to_sell)
	purchase_item(0)

func ending():
	pass

func purchase_item(item_index: int):
	var selected_item = items_to_sell[item_index]
	if $"../Card_System".player_gold >= selected_item.cost:
		$"../Card_System".hand.append(selected_item)
		$"../Card_System".player_gold -= selected_item.cost
		print("You bought an item.")
	elif $"../Card_System".player_gold < selected_item.cost:
		print("You do not have enough gold.")

func create_sell_item(
	card_name: String,
	card_type: String,
	attack: int,
	movement: int,
	gold: int,
	cost: int,
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
		"cost": cost,
		"dragon": dragon,
		"use": false,
		"sprite": sprite
	}

#ADD ALL ITEMS INTO AVAILABLE ITEMS
func create_items_to_sell() -> void: # Allows easy change in terms of card's properties or to add any card for expansioning in the future
	items_to_sell.clear() # To remove the previous game's available_items
	create_sell_item("Sword", "weapon", 3, 0, 0, 1, false, $Sword)
	create_sell_item("Boots", "movement", 0, 3, 0, 3, false, $Boots)
	create_sell_item("Fountain", "item", 0, 0, 0, 3, false,$Fountain)
	print("Created ", items_to_sell.size(), " items to sell.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM
