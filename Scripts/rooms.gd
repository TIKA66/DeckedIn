extends Node2D

var item_spawn_rate = null

#GENERAL ITEM VARS
var available_items: Array = ["Fountain", "Treasure Chest", "Stumble"] #TO CHANGE
var item_spawned = null

#MONSTER ROOM VARS
var available_monsters: Array = ["fish", "trout", "pike"] #temporary monsters
var number_of_monsters = null
var monster_to_spawn = null

#MARKET VARS
var items_to_sell: Array = Map.map[6]["items_to_sell"]

#PLACE ITEM INTO ROOM
func place_item(spawn_rate):
	var item_roll = randf()
	print("Item roll: ", item_roll) #DEBUGGING
	if item_roll > spawn_rate:
		item_spawned = randi_range(1, available_items.size()-1) # choose which item to spawn
		Map.map[$"..".player_position]["items"].append(available_items[item_spawned]) #spawn item
		print("items in room: ", Map.map[$"..".player_position]["items"])

# SPAWN MONSTER
func place_monster():
	number_of_monsters = randi_range(1, 2) #roll how many monsters to spawn (1 or 2)
	for i in number_of_monsters: # repeat for each monster to be spawned
		monster_to_spawn = available_monsters[randi_range(1, available_monsters.size()-1)] # choose which monster to spawn from available monster list
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
	elif $"../Card_System".player_gold < selected_item.cost:
		print("You do not have enough gold.")
