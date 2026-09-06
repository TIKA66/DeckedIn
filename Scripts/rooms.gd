extends Node2D

var item_spawn_rate = null

#GENERAL ITEM VARS
var available_items: Array = ["Fountain", "Treasure Chest", "Stumble"] #TO CHANGE
var item_spawned = null

#MONSTER ROOM VARS
var available_monsters: Array = []
var number_of_monsters = null
var monster_to_spawn = null

#PLACE ITEM INTO ROOM
func place_item(spawn_rate):
	var item_roll = randf()
	print("Item roll: ", item_roll) #DEBUGGING
	if item_roll > spawn_rate:
		item_spawned = randi_range(1, available_items.size()-1) # choose which item to spawn
		Global.map[Movement.player_position]["items"].append(available_items[item_spawned]) #spawn item
		print("items in room: ", Global.map[Movement.player_position]["items"])

# SPAWN MONSTER
func place_monster():
	number_of_monsters = randi_range(1, 2) #roll how many monsters to spawn (1 or 2)
	for i in number_of_monsters: # repeat for each monster to be spawned
		monster_to_spawn = randi_range(1, available_monsters.size()-1) # choose which monster to spawn
		Global.map[Movement.player_position]["monsters"].append(available_monsters[monster_to_spawn]) # add to a list of monsters in the room
	print("monsters in room: ", Global.map[Movement.player_position]["monsters"]) #DEBUGGING

func starting():
	item_spawn_rate = 0.2
	place_item(item_spawn_rate)

func monster():
	item_spawn_rate = 0.4
	place_item(item_spawn_rate)
	place_monster()

func market():
	pass
