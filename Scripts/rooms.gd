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
		Map.map[$Movement.player_position]["items"] = available_items[item_spawned] #spawn item
		print("item in room: ", Map.map[$Movement.player_position]["items"]["name"]) # debugging - fetch item in room

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

func create_items_to_spawn() -> void: 
	available_items.clear() # To remove the previous game's available_items list
	available_items.append(create_item("Dagger", "weapon", 1, 0, 0, false, $Dagger/Dagger))
	available_items.append(create_item("Spear", "weapon", 2, 0, 0, false, $Spear/Dagger))
	available_items.append(create_item("Sword", "weapon", 3, 0, 0, false, $Sword/Sword))
	available_items.append(create_item("Stumble", "movement", 0, 1, 0, true, $Stumble/Stumble))
	available_items.append(create_item("Explore", "movement", 0, 1, 0, false, $Explore/Explore))
	available_items.append(create_item("Ladder", "movement", 0, 2, 0, false, $Ladder/Ladder))
	available_items.append(create_item("Boots", "movement", 0, 3, 0, false, $Boots/Boots))
	available_items.append(create_item("Fountain", "item", 0, 0, 0, false, $Fountain/Fountain))
	available_items.append(create_item("Portal", "item", 0, 0, 0, false, $Portal/Portal))
	available_items.append(create_item("Gem", "item", 0, 0, 5, false, $Gem/Gem))
	available_items.append(create_item("Treasure Chest", "item", 0, 0, 10, true, $"Treasure Chest/Treasure Chest"))
	print("Created ", available_items.size(), " items to sell.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM

# SPAWN MONSTER
func place_monster():
	monster_to_spawn = randi_range(1, $"../Monster".available_monsters.size()-1) # choose which monster to spawn from available monster list
	Map.map[$"../Movement".player_position]["monsters"] = $"../Monster".available_monsters[monster_to_spawn] #find monster in list and add it to room
	print("monster in room: ", Map.map[$"..".player_position]["monsters"]["name"]) #DEBUGGING - show monsters in current room


func starting():
	item_spawn_rate = 0.2
	place_item(item_spawn_rate)

func monster():
	item_spawn_rate = 0.4
	place_item(item_spawn_rate)
	place_monster()
#	FUNCTION ABOUT BUTTON PRESSED TO END TURN.

func market():
#	FIX THIS
	#print("Items available:")
	#for item in items_to_sell:
		#print(items_to_sell[item]["name"])
	#purchase_item(0)
	pass

func ending():
	item_spawn_rate = 0.4
	place_item(item_spawn_rate)
	$"../Artefact".win_check() #Check if artefact is held in this room

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
) -> Dictionary:
	return {
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

#ADD ALL ITEMS INTO SELL LIST
func create_items_to_sell() -> void: 
	items_to_sell.clear() # To remove the previous game's items to sell
	items_to_sell.append(create_sell_item("Sword", "weapon", 3, 0, 0, 1, false, $Dagger/Dagger))
	items_to_sell.append(create_sell_item("Boots", "movement", 0, 3, 0, 3, false, $Boots/Boots))
	items_to_sell.append(create_sell_item("Fountain", "item", 0, 0, 0, 3, false, $Fountain/Fountain))
	print("Created ", items_to_sell.size(), " items to sell.") # DEBUGGING STATEMENT FOR THE INTERNAL SYSTEM
